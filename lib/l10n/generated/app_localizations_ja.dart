// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '会衆スケジューラー';

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonDelete => '削除';

  @override
  String get commonEdit => '編集';

  @override
  String get commonAdd => '追加';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonBack => '戻る';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonLoading => '読み込み中…';

  @override
  String get commonError => '問題が発生しました';

  @override
  String commonErrorDetail(String message) {
    return '問題が発生しました: $message';
  }

  @override
  String get commonFieldRequired => 'この項目は必須です';

  @override
  String get commonConfirmDeleteTitle => '削除しますか？';

  @override
  String get commonConfirmDeleteBody => 'この操作は取り消せません。';

  @override
  String get commonToday => '今日';

  @override
  String get commonAll => 'すべて';

  @override
  String get commonNone => 'なし';

  @override
  String get commonYes => 'はい';

  @override
  String get commonNo => 'いいえ';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSearch => '検索';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => '言語';

  @override
  String get setupTitle => '会衆に接続する';

  @override
  String get setupIntro =>
      'このアプリは会衆独自のデータベースに直接接続します。管理者から受け取った設定を貼り付けるか、招待のQRコードをスキャンしてください。';

  @override
  String get setupConfigLabel => 'Firebaseの設定（JSON）';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'QRコードをスキャン';

  @override
  String get setupPickQrImage => 'QRコードの写真を選ぶ';

  @override
  String get setupQrNotFoundInImage => 'その画像にQRコードが見つかりませんでした。';

  @override
  String get setupConnect => '接続';

  @override
  String get setupInvalidJson =>
      '有効な設定JSONではありません。少なくとも apiKey、projectId、appId が必要です。';

  @override
  String setupConnectionFailed(String message) {
    return 'この設定では接続できませんでした: $message';
  }

  @override
  String get setupModeTitle => 'どのように始めますか？';

  @override
  String get setupModeJoin => '自分の会衆に参加する';

  @override
  String get setupModeJoinSubtitle => '管理者から招待されています。登録後、管理者があなたのアカウントを確認します。';

  @override
  String get setupModeNew => '新しい会衆をセットアップする';

  @override
  String get setupModeNewSubtitle => '新しく作成したFirebaseプロジェクトの最初の管理者です。';

  @override
  String get setupCongregationExists =>
      'この会衆はすでにセットアップされています。代わりに「自分の会衆に参加する」を選んでください。';

  @override
  String get setupDatabaseNotReady => '会衆のデータベースはまだ起動中です。少し待ってからもう一度お試しください。';

  @override
  String get setupReconfigure => '設定を変更';

  @override
  String get setupRestartRequired => '設定を保存しました。適用するにはアプリを閉じてもう一度開いてください。';

  @override
  String get setupGuideLinkIntro => '設定がありませんか？　会衆独自の無料データベースを作成しましょう:';

  @override
  String get setupGuideLinkButton => '新しい会衆をセットアップする方法';

  @override
  String get setupGuideTitle => '新しい会衆をセットアップする';

  @override
  String get setupGuideIntro =>
      'このアプリはセルフホスト型です。会衆のデータは、ほかの誰もアクセスできない、あなた自身の無料のGoogle Firebaseプロジェクトに保存されます。セットアップには約15分かかり、プログラミングは不要です。必要なのはGoogleアカウントだけです。このスマホかパソコンで以下の手順を行ってください。';

  @override
  String get setupGuideOpenConsole => 'Firebaseコンソールを開く';

  @override
  String get setupGuideStep1Title => 'Firebaseプロジェクトを作成する';

  @override
  String get setupGuideStep1Body1 =>
      'console.firebase.google.com を開き、Googleアカウントでログインして「Get started by setting up a Firebase project」をタップします。';

  @override
  String get setupGuideStep1Body2 =>
      'プロジェクトに名前を付け（例:「congregation-mytown」）、規約に同意して続行します。Google Analyticsを勧められたら無効にします（不要です）。無料のSparkプランのままにします。このアプリは料金が発生しないように設計されています。';

  @override
  String get setupGuideStep2Title => 'メールでのログインを有効にする';

  @override
  String get setupGuideStep2Body1 => '左のメニューで Security → Authentication を選びます。';

  @override
  String get setupGuideStep2Body2 => '「Get started」をタップします。';

  @override
  String get setupGuideStep2Body3 =>
      '「Sign-in method」タブで Email/Password を選びます。';

  @override
  String get setupGuideStep2Body4 =>
      '最初のスイッチを有効にし（「Email link」はオフのまま）、Save をタップします。';

  @override
  String get setupGuideStep3Title => 'Firestoreデータベースを作成する';

  @override
  String get setupGuideStep3Body1 =>
      '左のメニューで Databases & Storage → Firestore を選びます。';

  @override
  String get setupGuideStep3Body2 => '「Create database」をタップします。';

  @override
  String get setupGuideStep3Body3 => 'Standard エディションを選びます。';

  @override
  String get setupGuideStep3Body4 =>
      '近い場所を選びます（例: 日本なら asia-northeast1）。あとで変更できません。';

  @override
  String get setupGuideStep3Body5 => '本番モードで開始し…';

  @override
  String get setupGuideStep3Body6 => '…Create をタップします。';

  @override
  String get setupGuideStep4Title => 'セキュリティルールをインストールする';

  @override
  String get setupGuideStep4Body1 =>
      'ルールは、どのデータを誰が読み書きできるかを決めます（例: 確認済みの伝道者だけが予定を見られる）。Firestoreデータベースで Rules タブを開き、「Edit rules」をタップします。';

  @override
  String get setupGuideStep4Body2 => 'エディター内のすべてを削除し、コピーしたルールを貼り付けます。';

  @override
  String get setupGuideStep4Body3 => 'Publish をタップします。';

  @override
  String get setupGuideStep4Note => '新しいアプリ版で更新されたルールが提供されるたびに、この手順を繰り返してください。';

  @override
  String get setupGuideStep5Title => 'アプリの設定を取得する';

  @override
  String get setupGuideStep5Body1 =>
      '「Project Overview」の横の歯車アイコン（左上）をタップし、Project settings を選びます。';

  @override
  String get setupGuideStep5Body2 =>
      'General タブで「Your apps」までスクロールし、ウェブアイコン </> をタップします。';

  @override
  String get setupGuideStep5Body3 =>
      'ニックネーム（例:「congregation-app」）を入力し、ホスティングはオフのままにして「Register app」をタップします。';

  @override
  String get setupGuideStep5Body4 =>
      '「const firebaseConfig = …」というコードブロックが表示されます。波かっこの中の設定を、波かっこも含めて選択してコピーします。';

  @override
  String get setupGuideStep5Note =>
      'この設定は秘密ではありません。プロジェクトを識別するだけです。データは手順4のセキュリティルールで保護されます。';

  @override
  String get setupGuideRulesTitle => 'セキュリティルール（firestore.rules）';

  @override
  String get setupGuideRulesCopy => 'ルールをコピー';

  @override
  String get setupGuideRulesCopied => 'ルールをクリップボードにコピーしました。';

  @override
  String get setupGuideRulesView => 'ルールのテキストを表示';

  @override
  String get setupGuideRulesLoadError => 'ルールのテキストを読み込めませんでした。';

  @override
  String get setupGuideFinish =>
      '完了です！　戻って、コピーした設定を貼り付け、接続をタップします。その後「新しい会衆をセットアップする」を選び、最初の管理者として登録します。';

  @override
  String get setupGuideBackToConnect => '接続画面に戻る';

  @override
  String get languageSystem => 'システムの言語';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageFrench => 'Français';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageJapanese => '日本語';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String themeTooltip(String mode) {
    return 'テーマ: $mode';
  }

  @override
  String get profileCompleteTitle => 'プロフィールを完成させる';

  @override
  String get profileCompleteBody =>
      'アカウントはありますが、プロフィールがありません。登録を完了するために氏名を入力してください。';

  @override
  String get authSignIn => 'ログイン';

  @override
  String get authSignOut => 'ログアウト';

  @override
  String get authRegister => 'アカウントを作成';

  @override
  String get authEmail => 'メールアドレス';

  @override
  String get authPassword => 'パスワード';

  @override
  String get authPasswordConfirm => 'パスワードの確認';

  @override
  String get authPasswordsDontMatch => 'パスワードが一致しません';

  @override
  String get authForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get authResetSent => 'パスワード再設定のメールを送信しました。';

  @override
  String get authEnterEmailForReset =>
      '先にメールアドレスを入力し、「パスワードをお忘れですか？」をタップすると再設定リンクが届きます。';

  @override
  String get authNoAccountYet => 'アカウントがありませんか？　作成する';

  @override
  String get authHaveAccount => 'すでにアカウントがありますか？　ログイン';

  @override
  String get authErrorInvalidCredentials => 'メールアドレスまたはパスワードが違います。';

  @override
  String get authErrorEmailInUse => 'このメールアドレスのアカウントはすでに存在します。';

  @override
  String get authErrorWeakPassword => 'パスワードが弱すぎます（6文字以上）。';

  @override
  String authErrorGeneric(String message) {
    return 'ログインに失敗しました: $message';
  }

  @override
  String get authFirstName => '名';

  @override
  String get authLastName => '姓';

  @override
  String get authCongregationName => '会衆名';

  @override
  String get awaitingTitle => '確認待ち';

  @override
  String get awaitingBody => 'アカウントが作成されました。会衆情報を見られるようになる前に、会衆の管理者による確認が必要です。';

  @override
  String get deleteAccountAction => 'アカウントを削除';

  @override
  String get deleteAccountWarning =>
      'これによりアカウントと個人プロフィール（氏名、連絡先、ログイン情報）が完全に削除されます。取り消せません。提出済みの報告は会衆に保存されたまま残ります。';

  @override
  String get deleteAccountPasswordLabel => '確認のためパスワードを入力';

  @override
  String get deleteAccountConfirm => 'アカウントを削除';

  @override
  String get deleteAccountSoleAdminTitle => 'あなたが唯一の管理者です';

  @override
  String get deleteAccountSoleAdminBody =>
      'あなたは会衆で唯一のフル管理者です。先にほかのメンバーにフル管理者権限を与えてください。そうしないと、アカウントを削除すると会衆に管理者がいなくなり、アクセスを復元できなくなります。';

  @override
  String get changePasswordAction => 'パスワードを変更';

  @override
  String get changePasswordCurrentLabel => '現在のパスワード';

  @override
  String get changePasswordNewLabel => '新しいパスワード';

  @override
  String get changePasswordConfirmLabel => '新しいパスワードを確認';

  @override
  String get changePasswordConfirm => 'パスワードを更新';

  @override
  String get changePasswordSuccess => 'パスワードを更新しました。';

  @override
  String get navInfoBoard => '掲示板';

  @override
  String get navEvents => '行事';

  @override
  String get navLmm => '週日の集会';

  @override
  String get navWeekend => '週末の集会';

  @override
  String get navPublicWitnessing => '公の証し';

  @override
  String get navFieldServiceMeetings => '野外奉仕の集まり';

  @override
  String get navTerritories => '区域';

  @override
  String get navMinistryGroups => '奉仕グループ';

  @override
  String get navReport => '野外奉仕報告';

  @override
  String get navAttendance => '出席';

  @override
  String get navProfile => 'マイプロフィール';

  @override
  String get navAdmin => '管理';

  @override
  String get navPublishersAdmin => '伝道者';

  @override
  String get navReportsAdmin => '報告の概要';

  @override
  String get navS1 => 'S-1報告';

  @override
  String get navTalks => '公開講演の主題';

  @override
  String get navSettings => '会衆の設定';

  @override
  String get navStatistics => '統計';

  @override
  String get navHelp => 'ヘルプ';

  @override
  String get helpPublisherSection => '伝道者へのヒント';

  @override
  String get helpAdminSection => '管理者向け';

  @override
  String get helpCalendarTitle => 'カレンダーに追加';

  @override
  String get helpCalendarBody =>
      'モバイルアプリでは、行事や自分の割り当てにカレンダーのアイコンが表示されます。タップすると、その項目を端末のカレンダーに追加できます。';

  @override
  String get helpRemindersTitle => '割り当てのリマインダー';

  @override
  String get helpRemindersBody =>
      '行事画面で「今後の自分の割り当て」の横のベルのアイコンをタップすると、各割り当ての前に通知を受け取れます。どれくらい前に受け取るかを選べます。（モバイルアプリのみ。）';

  @override
  String get helpHighlightTitle => '自分をひと目で見つける';

  @override
  String get helpHighlightBody => '集会の予定では自分の氏名が強調表示されるので、自分の割り当てをすぐに見つけられます。';

  @override
  String get helpTerritoryMapTitle => '区域の地図を開く';

  @override
  String get helpTerritoryMapBody =>
      '区域の横の地図アイコンをタップすると、その地図が開きます。灰色のアイコンは、その区域にまだ地図リンクが追加されていないことを表します。';

  @override
  String get helpAdminToggleTitle => '伝道者としてアプリを見る';

  @override
  String get helpAdminToggleBody =>
      '上部バーの鉛筆アイコンをタップすると、すべての管理ツールが一時的に隠れ、伝道者と同じようにアプリが見えます。もう一度タップするとツールが戻ります。';

  @override
  String get helpPdfExportTitle => '予定を印刷または共有する';

  @override
  String get helpPdfExportBody =>
      '週日の集会と週末の集会の画面では、予定の編集者は上部バーのPDFアイコンから、その月の予定を印刷や共有用にエクスポートできます。';

  @override
  String get helpGoogleMyMapsTitle => 'Google マイマップで区域の地図を作る';

  @override
  String get helpGoogleMyMapsBody =>
      '区域の地図をGoogle マイマップで作成し、各区域の共有リンクを地図リンクの欄に貼り付けます。手順を追ったガイドがGitHubにあります。';

  @override
  String get helpOpenGuide => 'ガイドを開く';

  @override
  String get helpDataDelayTitle => '変更が表示されるまで少し時間がかかることがあります';

  @override
  String get helpDataDelayBody =>
      'アプリで行った変更（例: 伝道者での編集）は、表示されるまで最大1分ほどかかることがあります。（例えば、S-21のインポートで今の奉仕年度の奉仕時間がすぐに表示されないことがあります。）';

  @override
  String get helpPwApplyTitle => '公の証しに志願する';

  @override
  String get helpPwApplyBody =>
      '公の証しを開き、時間帯を見つけて手のアイコンをタップすると志願できます。もう一度タップすると取り消せます。アイコンが見当たらない場合は、管理者に自分の記録の「公の証し」の資格を有効にしてもらってください。';

  @override
  String get helpPwAssignTitle => '伝道者を公の証しに割り当てる';

  @override
  String get helpPwAssignBody =>
      '伝道者 → 伝道者を開く → 資格 で、各志願者の「公の証し」の資格を有効にします。その後、公の証しで時間帯を開いて「割り当て済み」をタップすると、志願した伝道者が「志願済み」バッジ付きでリストの上部に固定表示されます。毎週のカートや展示台には繰り返しの時間帯を使ってください。';

  @override
  String get helpS21Title => 'S-21の記録をインポートする';

  @override
  String get helpS21Body =>
      '伝道者の会衆伝道者記録（S-21）をPDFからインポートできます。伝道者 → 伝道者 → S-21 を開いてファイルを選びます。PDFのテキスト層だけが読み取られるため、スキャンされた書式や画像化された書式はインポートできないことがあります。';

  @override
  String get helpS99Title => '公開講演の主題をインポートする（S-99）';

  @override
  String get helpS99Body =>
      '公開講演の主題で「PDFから主題を更新」を選び、公式のS-99書式のPDFを選びます。それらの講演番号を参照している今後の週末の集会は自動的に更新されます。';

  @override
  String get adminToggleHide => '管理オプションを隠す';

  @override
  String get adminToggleShow => '管理オプションを表示';

  @override
  String get profilePhone => '電話番号';

  @override
  String get profileAddress => '住所';

  @override
  String get profileBirthDate => '生年月日';

  @override
  String get profileBaptismDate => 'バプテスマの日付';

  @override
  String get profileGender => '性別';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => '男性';

  @override
  String get genderFemale => '女性';

  @override
  String get profileHope => '希望';

  @override
  String get hopeOtherSheep => 'ほかの羊';

  @override
  String get hopeAnointed => '油そそがれた者';

  @override
  String get profileStatus => '奉仕の状況';

  @override
  String get statusNone => '-';

  @override
  String get statusPublisher => '伝道者';

  @override
  String get statusAuxPioneer => '補助開拓者';

  @override
  String get statusRegPioneer => '正規開拓者';

  @override
  String get statusSpecialPioneer => '特別開拓者';

  @override
  String get statusFieldMissionary => '宣教者';

  @override
  String get profileAppointment => '任命';

  @override
  String get appointmentMinisterialServant => '奉仕の僕';

  @override
  String get appointmentElder => '長老';

  @override
  String get profileEmergency => '緊急連絡メモ';

  @override
  String get profileEmergencyHint => '緊急時の連絡先';

  @override
  String get profileSaved => '保存しました';

  @override
  String get profileRecord => '伝道者記録';

  @override
  String get profileAwayTitle => '不在期間';

  @override
  String get profileAwayEmpty => '不在期間はありません';

  @override
  String get profileAwayAdd => '不在期間を追加';

  @override
  String profileAwayRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String serviceYear(int year) {
    return '$year奉仕年度';
  }

  @override
  String get recordTotalHours => '合計時間';

  @override
  String get recordAverageHours => '月平均';

  @override
  String get reportMonth => '月';

  @override
  String get reportParticipated => '宣教に参加した';

  @override
  String get reportStudies => '聖書研究';

  @override
  String get reportHours => '時間';

  @override
  String get reportCredit => '認定時間';

  @override
  String get reportComments => 'コメント';

  @override
  String get s21Export => 'S-21をエクスポート（PDF）';

  @override
  String get schedulePdfExport => '月間予定（PDF）';

  @override
  String get lmmScheduleTitle => '週日の集会の予定';

  @override
  String get s21Title => '会衆伝道者記録カード';

  @override
  String get s21Name => '氏名:';

  @override
  String get s21DateOfBirth => '生年月日:';

  @override
  String get s21DateOfBaptism => 'バプテスマの日付:';

  @override
  String get s21HoursHeader => '時間（開拓者または宣教者の場合）';

  @override
  String get s21Remarks => '備考';

  @override
  String get s21Total => '合計';

  @override
  String get s21FormCode => 'S-21-J 11/23';

  @override
  String s21Credit(int hours) {
    return '認定: $hours';
  }

  @override
  String get s21Import => 'S-21をインポート（PDF）';

  @override
  String get s21ImportNew => 'S-21から伝道者をインポート';

  @override
  String get s21ImportTitle => 'S-21をインポート';

  @override
  String get s21ImportPickFile => 'PDFファイルを選ぶ';

  @override
  String get s21ImportHint =>
      'S-21伝道者記録カード（PDF）を選びます。カードの値が伝道者のプロフィール項目と月ごとの報告を置き換えます。';

  @override
  String get s21ImportNoData => 'このファイルにS-21のデータが見つかりませんでした。';

  @override
  String s21ImportMonths(int count) {
    return '$count件の月ごとの報告が見つかりました';
  }

  @override
  String s21ImportNameKept(String name) {
    return 'アプリの氏名を保持します: $name';
  }

  @override
  String s21ImportCardName(String name) {
    return 'カードの氏名: $name';
  }

  @override
  String s21ImportDuplicateName(String name) {
    return '「$name」という伝道者はすでに存在します。';
  }

  @override
  String get s21ImportUseExisting => '既存の記録にインポート';

  @override
  String get s21ImportReplaceTitle => '既存の記録を置き換えますか？';

  @override
  String get s21ImportReplaceBody =>
      '伝道者のプロフィール項目と、インポートする奉仕年度の月ごとの報告が、このS-21の値で置き換えられます。取り消せません。';

  @override
  String get s21ImportSave => 'インポート';

  @override
  String get s21ImportDone => 'S-21をインポートしました。';

  @override
  String get s21ImportAssignYear => 'この表の奉仕年度';

  @override
  String get pubAdminInvite => '招待';

  @override
  String get pubAdminInviteTitle => '会衆に招待';

  @override
  String get pubAdminInviteBody =>
      '新しいメンバーはアプリでこのQRコードをスキャンして登録し、その後、下に未確認として表示されます。確認するとアクセスが与えられます。';

  @override
  String get pubAdminAddRecord => '伝道者記録を追加';

  @override
  String get pubAdminAddRecordHint => 'アプリを使わないメンバーの記録です。報告は管理者が入力できます。';

  @override
  String get pubAdminVerified => '確認済み';

  @override
  String get pubAdminUnverifiedBadge => '確認待ち';

  @override
  String get pubAdminNoAccountBadge => 'アプリのアカウントなし';

  @override
  String get pubAdminTabProfile => 'プロフィール';

  @override
  String get pubAdminTabRoles => '権限';

  @override
  String get pubAdminTabAssign => '割り当て';

  @override
  String get pubAdminTabRecord => '記録';

  @override
  String get pubAdminDeleteConfirm => 'この伝道者と個人データを削除しますか？　報告は保存されたまま残ります。';

  @override
  String get pubAdminDeleteMovedHint =>
      'アプリのアカウントがある場合、削除してもログインは残り、再びログインできてしまいます。転出した人を保管するには、代わりに「転出として記録」を使ってください。';

  @override
  String get pubAdminMarkMoved => '転出として記録';

  @override
  String get pubAdminRestoreMoved => '転出から復元';

  @override
  String get pubAdminMovedBadge => '転出';

  @override
  String get pubAdminShowMoved => '転出を表示';

  @override
  String get pubFilterPioneers => '開拓者';

  @override
  String get pubFilterHasRights => '権限あり';

  @override
  String get pubFilterAnyGroup => 'すべてのグループ';

  @override
  String get pubFilterClear => 'クリア';

  @override
  String get pubAdminMoveConfirmTitle => '転出として記録しますか？';

  @override
  String get pubAdminMoveConfirmBody =>
      '記録と報告の履歴は保持されますが、伝道者は保管されます。アクセスが取り消され、予定や報告リストに表示されなくなります。あとで復元できます。';

  @override
  String get pubAdminSelfVerifiedWarningTitle => '自分の確認済み状態をオフにしますか？';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      '自分のアカウントから確認済みを外そうとしています。すぐに会衆のデータへのアクセスを失い、ほかのフル管理者だけが復元できます。本当に続けますか？';

  @override
  String get pubAdminSelfFullAdminWarningTitle => '自分のフル管理者権限を外しますか？';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      '自分のアカウントからフル管理者の役割を外そうとしています。あなたが唯一の管理者の場合、あなたを含め誰もこれを取り消せません。本当に続けますか？';

  @override
  String get pubAdminSelfWarningConfirm => '自分のアクセスを外す';

  @override
  String get pubConnectBanner =>
      'このアカウントは確認待ちです。管理者がこの人の伝道者記録をすでに作成している場合は、両者を結び付けてください。記録の履歴がこのアカウントに移り、重複した記録は消えます。';

  @override
  String get pubConnectAction => '既存の記録に結び付ける';

  @override
  String get pubConnectNeedsFullAdmin =>
      '記録を結び付けられるのはフル管理者だけです（移行はすべてのセクションのデータに影響します）。';

  @override
  String get pubConnectPickTitle => '既存の記録に結び付ける';

  @override
  String pubConnectPickHint(String name) {
    return '$name の記録を選んでください。';
  }

  @override
  String get pubConnectNoRecords => '結び付けられる、アプリのアカウントのない伝道者記録がありません。';

  @override
  String get pubConnectConfirmTitle => '結び付けて統合しますか？';

  @override
  String pubConnectConfirmBody(String record, String account) {
    return '「$record」のすべての履歴（報告、区域、予定の割り当て）が「$account」のアカウントに移ります。アカウントは確認済みになり、重複した記録は完全に削除されます。取り消せません。';
  }

  @override
  String get pubConnectProgressTitle => '記録を結び付けています…';

  @override
  String get pubConnectProgressBody => '履歴の移行中はアプリを閉じないでください。';

  @override
  String pubConnectFailed(String section) {
    return '結び付けが $section で失敗しました。完了した手順は保持されます。再試行は安全で、止まった所から続きます。';
  }

  @override
  String get pubConnectSuccess => '記録を結び付けました。履歴はこのアカウントのものになりました。';

  @override
  String get roleFullAdmin => 'フル管理者';

  @override
  String get roleRecordAttendance => '出席を記録';

  @override
  String get weekNoSchedule => 'この週の予定はまだありません。';

  @override
  String get weekCreateEmpty => '空の週を作成';

  @override
  String get weekImportEpub => '.epubからインポート';

  @override
  String get weekCheckCdn => 'オンラインで確認';

  @override
  String get weekDelete => 'この週を削除';

  @override
  String get lmmSongs => '歌';

  @override
  String get sectionOpening => '開会';

  @override
  String get sectionTreasures => '神の言葉の宝';

  @override
  String get sectionMinistry => '野外奉仕に励む';

  @override
  String get sectionLiving => 'クリスチャンとして生活する';

  @override
  String get sectionClosing => '結び';

  @override
  String get partChairman => '司会者';

  @override
  String get partOpeningPrayer => '開会の祈り';

  @override
  String get partClosingPrayer => '結びの祈り';

  @override
  String get partGems => '宝石を探し出す';

  @override
  String get partBibleReading => '聖書朗読';

  @override
  String get partCbs => '会衆の聖書研究';

  @override
  String get partCbsReader => '朗読者';

  @override
  String get partAssistant => '相手';

  @override
  String partMinutes(int min) {
    return '$min分';
  }

  @override
  String get lmmClassMain => '本会場';

  @override
  String lmmClassN(int index) {
    return '第$indexクラス';
  }

  @override
  String get partEdit => 'パートを編集';

  @override
  String get partTitle => '主題';

  @override
  String get partDescription => '説明';

  @override
  String get partDuration => '時間（分）';

  @override
  String get partAdd => 'パートを追加';

  @override
  String get partDeleteConfirm => 'このパートを削除しますか？';

  @override
  String get supportAttendants => '案内係';

  @override
  String get supportMicrophones => 'マイク';

  @override
  String get supportAudioVideo => '音響・映像';

  @override
  String get customAssignmentAdd => 'カスタムの割り当てを追加';

  @override
  String get customLabel => 'ラベル';

  @override
  String get customAssignmentPermanent => '常設（毎週）';

  @override
  String get customAssignmentRemovePermanentTitle => '常設の割り当てを削除';

  @override
  String customAssignmentRemovePermanentBody(String label) {
    return '「$label」を毎週から削除しますか？';
  }

  @override
  String get pickerQualified => '資格あり';

  @override
  String get pickerAll => 'すべて';

  @override
  String get pickerFreeText => 'テキスト';

  @override
  String pickerLastAssigned(String date) {
    return '前回: $date';
  }

  @override
  String get pickerNever => '割り当てなし';

  @override
  String get pickerApplied => '志願済み';

  @override
  String pickerAwayWarning(String range) {
    return '不在 $range';
  }

  @override
  String get importTitle => '集会ワークブックをインポート';

  @override
  String get importNoWeeks => 'このファイルに使用できる週が見つかりませんでした。';

  @override
  String get importWeekExists => 'すでに存在します — 予定は更新され、割り当ては保持されます';

  @override
  String importSave(int count) {
    return '$count週をインポート';
  }

  @override
  String get importDone => 'インポートしました。';

  @override
  String get importCdnNothing => 'オンラインで利用できるワークブックの号はまだありません。';

  @override
  String get weekendTalkTitle => '公開講演';

  @override
  String get weekendSpeaker => '話し手';

  @override
  String get weekendChairmanLabel => '司会者';

  @override
  String get weekendWtReader => 'ものみの塔の朗読者';

  @override
  String get customFieldAdd => '予定の項目を追加';

  @override
  String get pickerFromCatalog => 'リストから';

  @override
  String get talksUpdateFromPdf => 'PDFから主題を更新';

  @override
  String get talksPickPdf => 'S-99のPDFを選ぶ';

  @override
  String get talksParseError =>
      'このファイルから講演の主題を読み取れませんでした。公式のS-99書式のPDFを使ってください。';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return '$total件の講演が見つかりました: 新規$added、変更$changed、削除$removed';
  }

  @override
  String get talksImportSave => '主題を保存';

  @override
  String talksImportDone(int count) {
    return '主題を保存しました。今後の集会$count件を更新しました。';
  }

  @override
  String talksLastDelivered(String date) {
    return '前回の話: $date';
  }

  @override
  String get talksNeverDelivered => 'まだ話されていません';

  @override
  String get talksScheduled => '予定済み';

  @override
  String get talksNew => '新規';

  @override
  String get talksChanged => '変更';

  @override
  String get talksRemoved => '削除';

  @override
  String get talksSearchHint => '講演を検索…';

  @override
  String get talksEmpty => '講演の主題がまだありません。S-99のPDFからインポートしてください。';

  @override
  String get talksOpenCatalog => '講演の主題を管理';

  @override
  String get talksEditTitle => '主題を編集';

  @override
  String get songLabel => '歌';

  @override
  String get songsSearchHint => '歌を検索…';

  @override
  String get songsEmpty => '歌のリストがまだありません。公式サイトから更新してください。';

  @override
  String get songsUpdateFromWeb => '公式サイトから歌のリストを更新';

  @override
  String songsUpdateDone(int count) {
    return '歌のリストを更新しました: $count曲。';
  }

  @override
  String get songsCdnNothing => '歌のリストはまだオンラインで利用できません。';

  @override
  String get songsStatusEmpty => '歌のリストはまだインポートされていません。';

  @override
  String songsStatusLoaded(int count, String date) {
    return '$count曲 · 更新 $date';
  }

  @override
  String get settingsSongsSection => '歌のリスト';

  @override
  String get settingsSongsDescription =>
      '集会の歌の題をjw.orgからダウンロードすると、週末と週日の予定で選べるようになります。';

  @override
  String get pwNoSlots => '今週は公の証しがありません。';

  @override
  String get pwAddSlot => '時間帯を追加';

  @override
  String get pwEditSlot => '時間帯を編集';

  @override
  String get pwLocation => '場所';

  @override
  String get pwTimeFrom => '開始';

  @override
  String get pwTimeTo => '終了';

  @override
  String get pwRecurringRules => '繰り返しの時間帯';

  @override
  String get pwRecurringAdd => '繰り返しの時間帯を追加';

  @override
  String get pwWeekday => '曜日';

  @override
  String get pwValidFrom => '有効期間の開始';

  @override
  String get pwValidUntil => '有効期間の終了（任意）';

  @override
  String get pwAssignees => '割り当て済み';

  @override
  String get pwDate => '日付';

  @override
  String get pwApply => 'この時間帯に志願';

  @override
  String get pwWithdraw => '志願を取り消す';

  @override
  String pwApplicants(int count) {
    return '$count人が志願';
  }

  @override
  String get fsmNoMeetings => '今週は野外奉仕の集まりがありません。';

  @override
  String get fsmAddMeeting => '集まりを追加';

  @override
  String get fsmEditMeeting => '集まりを編集';

  @override
  String get fsmDate => '日付';

  @override
  String get fsmTime => '時刻';

  @override
  String get fsmLocation => '場所';

  @override
  String get fsmNote => 'メモ';

  @override
  String get fsmConductor => '司会者';

  @override
  String get fsmRecurringRules => '繰り返しの集まり';

  @override
  String get fsmRecurringAdd => '繰り返しの集まりを追加';

  @override
  String get fsmWeekday => '曜日';

  @override
  String get fsmValidFrom => '有効期間の開始';

  @override
  String get fsmValidUntil => '有効期間の終了（任意）';

  @override
  String get fsmRecurringDeleteConfirm =>
      'この繰り返しの集まりを削除しますか？　今後の集まりも削除されます。取り消せません。';

  @override
  String get fsmRemoveAllFutureAction => '今後の集まりをすべて削除';

  @override
  String get fsmRemoveAllFutureWarning =>
      '今後の集まりをすべて削除すると、今後の1回限りと繰り返しの集まりがすべて削除され、取り消せません。';

  @override
  String get fsmRemoveAllFutureTitle => '今後の集まりをすべて削除しますか？';

  @override
  String get fsmRemoveAllFutureBody =>
      'これにより、今後の1回限りと繰り返しの野外奉仕の集まりがすべて削除され、繰り返しの集まりのルールもすべて削除されて再生成されなくなります。過去の集まりは保持されます。取り消せません。';

  @override
  String get fsmRemoveAllFutureConfirm => 'すべて削除';

  @override
  String get eventsUpcoming => '今後の行事';

  @override
  String get eventsNone => '今後の行事はありません。';

  @override
  String get eventAdd => '行事を追加';

  @override
  String get eventEdit => '行事を編集';

  @override
  String get eventTitle => 'タイトル';

  @override
  String get eventType => '種類';

  @override
  String get eventTypeConvention => '地域大会';

  @override
  String get eventTypeAssembly => '巡回大会';

  @override
  String get eventTypeMemorial => '記念式';

  @override
  String get eventTypeCoVisit => '巡回監督の訪問';

  @override
  String get eventTypeOther => 'その他';

  @override
  String get eventDateFrom => '開始';

  @override
  String get eventDateTo => '終了（任意）';

  @override
  String get eventLocation => '場所';

  @override
  String get eventNotes => 'メモ';

  @override
  String get eventAddToCalendar => 'カレンダーに追加';

  @override
  String get myAssignments => '今後の自分の割り当て';

  @override
  String get myAssignmentsNone => '今後の割り当てはありません。';

  @override
  String get remindersTitle => '割り当てのリマインダー';

  @override
  String get remindersDescription =>
      '今後の各割り当ての前に、この端末で通知を受け取れます。アプリを閉じている間の変更は、次にアプリを開いたときに反映されます。';

  @override
  String get remindersEnable => 'リマインダーを有効にする';

  @override
  String get remindersAdd => 'リマインダーを追加';

  @override
  String get reminderUnitMinutes => '分前';

  @override
  String get reminderUnitHours => '時間前';

  @override
  String get reminderUnitDays => '日前';

  @override
  String get remindersPermissionDenied =>
      'このアプリの通知が許可されていません。リマインダーを使うにはシステム設定で有効にしてください。';

  @override
  String get remindersChannelName => '割り当てのリマインダー';

  @override
  String get remindersChannelDescription => '会衆の割り当ての前の通知';

  @override
  String get roleAssistant => '相手';

  @override
  String get rolePw => '公の証し';

  @override
  String get roleFsm => '野外奉仕の集まり';

  @override
  String get reportSubmit => '報告を送信';

  @override
  String reportSubmittedAt(String date) {
    return '$date に送信';
  }

  @override
  String get reportSaved => '報告を保存しました。';

  @override
  String get reportMissing => '未送信';

  @override
  String reportEnterFor(String name) {
    return '報告を入力 — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return '報告済み: $reported / $total';
  }

  @override
  String get attAdd => '出席を記録';

  @override
  String get attInPerson => '会場';

  @override
  String get attOnline => 'オンライン';

  @override
  String get attTotal => '合計';

  @override
  String get attMeetingLmm => '週日の集会';

  @override
  String get attMeetingWeekend => '週末の集会';

  @override
  String get attOverview => '月平均';

  @override
  String get attHistory => '過去の集会';

  @override
  String get attNotFilled => '未記録';

  @override
  String get attMismatch => '数字が合いません。';

  @override
  String attRecordedOf(int filled, int expected) {
    return '$filled/$expected 記録済み';
  }

  @override
  String get attSaved => '出席を記録しました。';

  @override
  String get statMembershipTitle => '伝道者';

  @override
  String get statTotalMembers => 'すべての伝道者';

  @override
  String get statPioneers => '開拓者';

  @override
  String get statAgeTitle => '年齢の分布';

  @override
  String get statAgeAverage => '平均年齢';

  @override
  String statAgeKnownDetail(int known, int total) {
    return '既知の生年月日 $total 件中 $known 件に基づく';
  }

  @override
  String get statAgeUnder18 => '18歳未満';

  @override
  String get statAgeUnknown => '不明';

  @override
  String get statAttendanceTitle => '集会の出席';

  @override
  String get statAvg3Months => '3か月平均';

  @override
  String get statAvg12Months => '12か月平均';

  @override
  String get statFieldServiceTitle => '野外奉仕';

  @override
  String statServiceYear(String year) {
    return '$year奉仕年度';
  }

  @override
  String get statReportsSubmitted => '送信された報告';

  @override
  String get statParticipated => '宣教に参加した人';

  @override
  String get statPioneerHours => '開拓者の時間';

  @override
  String get statPublisherHours => '伝道者の時間';

  @override
  String get statUsageTitle => 'アプリの利用状況';

  @override
  String get statWithAccount => 'アプリのアカウントあり';

  @override
  String get statSelfReported => '本人が送信した報告（先月）';

  @override
  String get statAwaiting => '確認待ち';

  @override
  String get statFullAdmins => 'フル管理者';

  @override
  String get statSectionAdmins => 'セクション管理者';

  @override
  String get statNoData => 'まだデータがありません';

  @override
  String get terrMine => '自分の区域';

  @override
  String get terrNoMine => '割り当てられている区域はありません。';

  @override
  String get terrAll => 'すべての区域';

  @override
  String terrAssignedOn(String date) {
    return '$date に割り当て';
  }

  @override
  String get terrReturn => '返却';

  @override
  String get terrReturnTitle => '区域を返却';

  @override
  String get terrReturnNotes => 'メモ（任意）';

  @override
  String get terrMap => '地図';

  @override
  String get terrAdd => '区域を追加';

  @override
  String get terrEdit => '区域を編集';

  @override
  String get terrName => '名前';

  @override
  String get terrNameDuplicate => 'この名前の区域はすでに存在します。';

  @override
  String get terrMapUrl => '地図リンク（例: Google マイマップ）';

  @override
  String get terrNotes => 'メモ';

  @override
  String get terrAssignTo => '割り当て先…';

  @override
  String terrHolder(String name, String date) {
    return '$name — $date から';
  }

  @override
  String get terrFree => '未割り当て';

  @override
  String get terrStats => '統計';

  @override
  String get terrStatsTotal => '合計';

  @override
  String get terrStatsAssigned => '現在割り当て済み';

  @override
  String get terrStatsFinished => '期間内に完了';

  @override
  String get terrRemoveAssignment => '割り当てを解除';

  @override
  String get terrImportTitle => '区域をインポート';

  @override
  String get terrImportPasteHint =>
      'ExcelやGoogleスプレッドシートから行を貼り付けます。列: 名前、地図リンク、メモ — 名前だけが必須です。';

  @override
  String get terrImportPreview => 'プレビュー';

  @override
  String get terrImportPickFile => 'CSVファイルを選ぶ';

  @override
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  ) {
    return '$total行: 新規$newCount、既存$duplicates、無効$invalid';
  }

  @override
  String get terrImportUpdateExisting => '既存の区域をスキップせず、（名前で照合して）更新する';

  @override
  String get terrImportBadgeNew => '新規';

  @override
  String get terrImportBadgeSkip => 'スキップ';

  @override
  String get terrImportBadgeUpdate => '更新';

  @override
  String get terrImportBadgeInvalid => '名前がありません';

  @override
  String get terrImportBadgeDupRow => '重複行';

  @override
  String terrImportLine(int line) {
    return '$line行目';
  }

  @override
  String terrImportSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の区域をインポート',
    );
    return '$_temp0';
  }

  @override
  String terrImportDone(int created, int updated) {
    return '新規$created件をインポート、$updated件を更新しました。';
  }

  @override
  String get terrImportEmpty => '入力に行が見つかりませんでした。';

  @override
  String get terrDeleteConfirm => 'この区域を削除しますか？　取り消せません。';

  @override
  String get terrSortByTerritory => '区域';

  @override
  String get terrSortByPublisher => '伝道者';

  @override
  String get terrSortByDate => '割り当て日';

  @override
  String get terrHistoryOngoing => '現在';

  @override
  String get terrHistoryEmpty => '割り当ての履歴はまだありません。';

  @override
  String get mgEmpty => '奉仕グループがまだありません。';

  @override
  String get mgAdd => 'グループを追加';

  @override
  String get mgEdit => 'グループを編集';

  @override
  String get mgName => '名前';

  @override
  String mgMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count人のメンバー',
      zero: 'メンバーなし',
    );
    return '$_temp0';
  }

  @override
  String get mgNoMembers => 'このグループにはまだメンバーがいません。';

  @override
  String get mgOverseer => 'グループ監督';

  @override
  String get mgAssistant => 'グループの補佐';

  @override
  String get mgMakeOverseer => 'グループ監督に設定';

  @override
  String get mgMakeAssistant => '補佐に設定';

  @override
  String get mgClearRole => '監督/補佐の指定を解除';

  @override
  String get mgAddMember => 'メンバーを追加…';

  @override
  String get mgNoUnassigned => '全員がすでにグループに属しています。';

  @override
  String get mgRemoveMember => 'グループから外す';

  @override
  String get mgDeleteConfirm => 'このグループを削除しますか？　メンバーはグループなしになります。';

  @override
  String get mgGroup => '奉仕グループ';

  @override
  String get mgNoGroup => 'グループなし';

  @override
  String get infoEmpty => '現在お知らせはありません。';

  @override
  String get infoAddText => 'テキストを追加';

  @override
  String get infoAddFile => 'ファイルをアップロード（PDF/画像）';

  @override
  String get infoAddLink => 'リンクを追加';

  @override
  String get infoTitle => 'タイトル';

  @override
  String get infoBody => 'テキスト';

  @override
  String get infoUrl => 'リンク（URL）';

  @override
  String get infoShowFrom => '表示開始（任意）';

  @override
  String get infoShowUntil => '表示終了（任意）';

  @override
  String get infoFileTooLarge => 'ファイルが大きすぎます（最大10 MB）。代わりにリンクとして共有してください。';

  @override
  String get infoHidden => '現在非表示（表示期間外）';

  @override
  String get infoDownloading => 'ファイルを読み込み中…';

  @override
  String get infoEditItem => '項目を編集';

  @override
  String get s1Active => '活発な伝道者（過去6か月に少なくとも1回報告した人）';

  @override
  String get s1AvgMid => '週日の集会の平均出席者数';

  @override
  String get s1AvgWeekend => '週末の集会の平均出席者数';

  @override
  String get s1Publishers => '伝道者';

  @override
  String get s1AuxPioneers => '補助開拓者';

  @override
  String get s1RegPioneers => '正規開拓者';

  @override
  String get s1Count => '報告数';

  @override
  String get s1Studies => '聖書研究';

  @override
  String get s1Hours => '時間（合計）';

  @override
  String get s1Note => '補助開拓者、正規開拓者、特別開拓者は伝道者のグループには数えません。特別開拓者はどのグループにも含めません。';

  @override
  String get settingsName => '会衆名';

  @override
  String get settingsLmmMeeting => '週日の集会（曜日と時刻）';

  @override
  String get settingsLmmClassCount => '週日の集会のクラス数';

  @override
  String get settingsWeekendMeeting => '週末の集会（曜日と時刻）';

  @override
  String get settingsBackupSection => 'バックアップと復元';

  @override
  String get settingsBackupDescription =>
      '会衆のデータの完全なコピーをダウンロードするか、バックアップファイルから復元します。誤った削除や不正な編集からの回復に使います。';

  @override
  String get settingsExportData => 'すべてのデータをエクスポート';

  @override
  String get settingsImportData => 'バックアップから復元…';

  @override
  String backupExportSuccess(int count) {
    return 'バックアップをダウンロードしました（$count件）。';
  }

  @override
  String get backupImportTitle => 'バックアップから復元';

  @override
  String get backupImportPick => 'バックアップファイルを選ぶ…';

  @override
  String get backupImportEmpty => '内容をプレビューするにはバックアップファイルを選んでください。';

  @override
  String get backupImportContents => '内容';

  @override
  String backupImportFrom(String name, String date) {
    return '$name のバックアップ · $date';
  }

  @override
  String get backupImportWarning =>
      '復元すると、このバックアップ内のバージョンと同じIDを持つ現在の記録が上書きされます。バックアップ後に追加された記録は保持されます。取り消せません。';

  @override
  String get backupImportConfirm => 'このバックアップを復元';

  @override
  String backupImportSuccess(int count) {
    return '$count件を復元しました。';
  }

  @override
  String backupImportPartial(int count, String collections) {
    return '$count件を復元しました。復元できませんでした: $collections。';
  }

  @override
  String get backupInvalidFile => 'このファイルは有効な会衆のバックアップではありません。';

  @override
  String get qSupportSection => '集会の補助など';

  @override
  String get qChairman => '司会者（週日）';

  @override
  String get qPrayer => '祈り';

  @override
  String get qTreasures => '神の言葉の宝';

  @override
  String get qGems => '宝石を探し出す';

  @override
  String get qBibleReading => '聖書朗読';

  @override
  String get qFieldMinistry => '生徒の割り当て（宣教）';

  @override
  String get qLiving => 'クリスチャンとして生活する';

  @override
  String get qCbsConductor => '会衆の聖書研究の司会者';

  @override
  String get qCbsReader => '会衆の聖書研究の朗読者';

  @override
  String get qPublicTalk => '公開講演';

  @override
  String get qWeekendChairman => '司会者（週末）';

  @override
  String get qWtReader => 'ものみの塔の朗読者';

  @override
  String get qAttendant => '案内係';

  @override
  String get qMicrophone => 'マイク';

  @override
  String get qAudioVideo => '音響・映像';

  @override
  String get qPublicWitnessing => '公の証し';

  @override
  String get qMinistryMeetingConductor => '野外奉仕の集まりの司会者';
}
