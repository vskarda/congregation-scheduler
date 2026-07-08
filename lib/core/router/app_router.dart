import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/attendance_screen.dart';
import '../../features/auth/awaiting_screen.dart';
import '../../features/auth/complete_profile_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/events/events_screen.dart';
import '../../features/home/app_shell.dart';
import '../../features/info_board/info_board_screen.dart';
import '../../features/lmm_schedule/lmm_screen.dart';
import '../../features/public_witnessing/pw_screen.dart';
import '../../features/publishers/admin_publishers_screen.dart';
import '../../features/publishers/profile_screen.dart';
import '../../features/publishers/publisher_detail_screen.dart';
import '../../features/reports/admin_reports_screen.dart';
import '../../features/reports/report_screen.dart';
import '../../features/s1_report/s1_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/setup/setup_mode_screen.dart';
import '../../features/setup/setup_screen.dart';
import '../../features/territories/territories_screen.dart';
import '../../features/weekend_schedule/weekend_screen.dart';
import '../data/publishers_repository.dart';
import '../firebase/firebase_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(firebaseReadyProvider, (_, _) => refresh.value++);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(myPublisherProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    refreshListenable: refresh,
    initialLocation: '/',
    redirect: (context, state) {
      final loc = state.uri.path;
      final onSetup = loc.startsWith('/setup');

      if (!ref.read(firebaseReadyProvider)) {
        return onSetup ? null : '/setup';
      }

      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return null;
      final user = auth.value;
      final onAuthScreens =
          loc == '/login' || loc.startsWith('/register') || onSetup;
      if (user == null) {
        return onAuthScreens ? null : '/login';
      }

      final publisherAsync = ref.read(myPublisherProvider);
      if (publisherAsync.isLoading) return null;
      final publisher = publisherAsync.value;
      if (publisher == null) {
        // Signed in but the publisher doc is missing (interrupted
        // registration) — let the user finish it.
        return loc == '/complete-profile' ? null : '/complete-profile';
      }
      if (!publisher.verified) {
        return loc == '/awaiting' ? null : '/awaiting';
      }
      if (onAuthScreens || loc == '/awaiting' || loc == '/complete-profile') {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/setup', builder: (_, _) => const SetupScreen()),
      GoRoute(path: '/setup/mode', builder: (_, _) => const SetupModeScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (_, state) => RegisterScreen(
          isNewCongregation: state.uri.queryParameters['mode'] == 'new',
        ),
      ),
      GoRoute(path: '/awaiting', builder: (_, _) => const AwaitingScreen()),
      GoRoute(
          path: '/complete-profile',
          builder: (_, _) => const CompleteProfileScreen()),
      GoRoute(
        path: '/admin/publishers/:id',
        builder: (_, state) =>
            PublisherDetailScreen(publisherId: state.pathParameters['id']!),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const InfoBoardScreen()),
          GoRoute(path: '/events', builder: (_, _) => const EventsScreen()),
          GoRoute(path: '/lmm', builder: (_, _) => const LmmScreen()),
          GoRoute(path: '/weekend', builder: (_, _) => const WeekendScreen()),
          GoRoute(path: '/pw', builder: (_, _) => const PwScreen()),
          GoRoute(
              path: '/territories',
              builder: (_, _) => const TerritoriesScreen()),
          GoRoute(path: '/report', builder: (_, _) => const ReportScreen()),
          GoRoute(
              path: '/attendance',
              builder: (_, _) => const AttendanceScreen()),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          GoRoute(
              path: '/admin/publishers',
              builder: (_, _) => const AdminPublishersScreen()),
          GoRoute(
              path: '/admin/reports',
              builder: (_, _) => const AdminReportsScreen()),
          GoRoute(path: '/admin/s1', builder: (_, _) => const S1Screen()),
          GoRoute(
              path: '/admin/settings',
              builder: (_, _) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
