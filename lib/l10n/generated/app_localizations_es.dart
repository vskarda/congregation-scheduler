// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Programador de la congregación';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonAdd => 'Añadir';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonLoading => 'Cargando…';

  @override
  String get commonError => 'Algo salió mal';

  @override
  String commonErrorDetail(String message) {
    return 'Algo salió mal: $message';
  }

  @override
  String get commonFieldRequired => 'Este campo es obligatorio';

  @override
  String get commonConfirmDeleteTitle => '¿Eliminar?';

  @override
  String get commonConfirmDeleteBody => 'Esto no se puede deshacer.';

  @override
  String get commonToday => 'Hoy';

  @override
  String get commonAll => 'Todos';

  @override
  String get commonNone => 'Ninguno';

  @override
  String get commonYes => 'Sí';

  @override
  String get commonNo => 'No';

  @override
  String get commonOk => 'Aceptar';

  @override
  String get commonSearch => 'Buscar';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Idioma';

  @override
  String get setupTitle => 'Conéctate a tu congregación';

  @override
  String get setupIntro =>
      'Esta aplicación se conecta directamente a la base de datos propia de tu congregación. Pega la configuración que recibiste de tu administrador o escanea el código QR de la invitación.';

  @override
  String get setupConfigLabel => 'Configuración de Firebase (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'Escanear código QR';

  @override
  String get setupPickQrImage => 'Elegir foto del código QR';

  @override
  String get setupQrNotFoundInImage =>
      'No se encontró ningún código QR en esa imagen.';

  @override
  String get setupConnect => 'Conectar';

  @override
  String get setupInvalidJson =>
      'Esta configuración JSON no es válida. Debe contener al menos apiKey, projectId y appId.';

  @override
  String setupConnectionFailed(String message) {
    return 'No se pudo conectar con esta configuración: $message';
  }

  @override
  String get setupModeTitle => '¿Cómo quieres empezar?';

  @override
  String get setupModeJoin => 'Unirme a mi congregación';

  @override
  String get setupModeJoinSubtitle =>
      'Un administrador te invitó. Después del registro verificará tu cuenta.';

  @override
  String get setupModeNew => 'Configurar una nueva congregación';

  @override
  String get setupModeNewSubtitle =>
      'Eres el primer administrador de un proyecto de Firebase recién creado.';

  @override
  String get setupCongregationExists =>
      'Esta congregación ya está configurada. Elige «Unirme a mi congregación» en su lugar.';

  @override
  String get setupDatabaseNotReady =>
      'La base de datos de la congregación aún se está iniciando. Espera un momento e inténtalo de nuevo.';

  @override
  String get setupReconfigure => 'Cambiar configuración';

  @override
  String get setupRestartRequired =>
      'Configuración guardada. Cierra y vuelve a abrir la aplicación para aplicarla.';

  @override
  String get setupGuideLinkIntro =>
      '¿No tienes una configuración? Crea la base de datos gratuita de tu propia congregación:';

  @override
  String get setupGuideLinkButton => 'Cómo configurar una nueva congregación';

  @override
  String get setupGuideTitle => 'Configurar una nueva congregación';

  @override
  String get setupGuideIntro =>
      'Esta aplicación es autoalojada: los datos de tu congregación se guardan en tu propio proyecto gratuito de Google Firebase, al que nadie más puede acceder. Configurarlo lleva unos 15 minutos y no requiere programación: solo necesitas una cuenta de Google. Sigue los pasos siguientes en este teléfono o en una computadora.';

  @override
  String get setupGuideOpenConsole => 'Abrir la consola de Firebase';

  @override
  String get setupGuideStep1Title => 'Crear un proyecto de Firebase';

  @override
  String get setupGuideStep1Body1 =>
      'Abre console.firebase.google.com, inicia sesión con tu cuenta de Google y toca «Get started by setting up a Firebase project».';

  @override
  String get setupGuideStep1Body2 =>
      'Ponle nombre al proyecto, por ejemplo «congregacion-miciudad», acepta los términos y continúa. Si se ofrece Google Analytics, desactívalo: no es necesario. Quédate en el plan gratuito Spark; la aplicación está diseñada para no necesitar nunca facturación.';

  @override
  String get setupGuideStep2Title =>
      'Activar el inicio de sesión por correo electrónico';

  @override
  String get setupGuideStep2Body1 =>
      'En el menú de la izquierda elige Security → Authentication.';

  @override
  String get setupGuideStep2Body2 => 'Toca «Get started».';

  @override
  String get setupGuideStep2Body3 =>
      'En la pestaña «Sign-in method» elige Email/Password.';

  @override
  String get setupGuideStep2Body4 =>
      'Activa el primer interruptor (deja «Email link» desactivado) y toca Save.';

  @override
  String get setupGuideStep3Title => 'Crear la base de datos Firestore';

  @override
  String get setupGuideStep3Body1 =>
      'En el menú de la izquierda elige Databases & Storage → Firestore.';

  @override
  String get setupGuideStep3Body2 => 'Toca «Create database».';

  @override
  String get setupGuideStep3Body3 => 'Elige la edición Standard.';

  @override
  String get setupGuideStep3Body4 =>
      'Elige una ubicación cercana (por ejemplo europe-west3 para Europa Central). No se puede cambiar después.';

  @override
  String get setupGuideStep3Body5 => 'Empieza en modo de producción…';

  @override
  String get setupGuideStep3Body6 => '…y toca Create.';

  @override
  String get setupGuideStep4Title => 'Instalar las reglas de seguridad';

  @override
  String get setupGuideStep4Body1 =>
      'Las reglas deciden quién puede leer y escribir cada dato (por ejemplo, que solo los publicadores verificados vean los programas). En la base de datos Firestore abre la pestaña Rules y toca «Edit rules».';

  @override
  String get setupGuideStep4Body2 =>
      'Borra todo lo que haya en el editor y pega las reglas copiadas.';

  @override
  String get setupGuideStep4Body3 => 'Toca Publish.';

  @override
  String get setupGuideStep4Note =>
      'Repite este paso cada vez que una nueva versión de la aplicación traiga reglas actualizadas.';

  @override
  String get setupGuideStep5Title =>
      'Obtener la configuración de la aplicación';

  @override
  String get setupGuideStep5Body1 =>
      'Toca el icono de engranaje junto a «Project Overview» (arriba a la izquierda) y elige Project settings.';

  @override
  String get setupGuideStep5Body2 =>
      'En la pestaña General baja hasta «Your apps» y toca el icono web </>.';

  @override
  String get setupGuideStep5Body3 =>
      'Escribe un apodo, por ejemplo «congregation-app», deja el hosting desactivado y toca «Register app».';

  @override
  String get setupGuideStep5Body4 =>
      'Aparecerá un bloque de código con «const firebaseConfig = …». Selecciona y copia solo la configuración que está entre las llaves, incluidas las llaves.';

  @override
  String get setupGuideStep5Note =>
      'Esta configuración no es secreta: solo identifica tu proyecto. Los datos están protegidos por las reglas de seguridad del paso 4.';

  @override
  String get setupGuideRulesTitle => 'Reglas de seguridad (firestore.rules)';

  @override
  String get setupGuideRulesCopy => 'Copiar reglas';

  @override
  String get setupGuideRulesCopied => 'Reglas copiadas al portapapeles.';

  @override
  String get setupGuideRulesView => 'Mostrar el texto de las reglas';

  @override
  String get setupGuideRulesLoadError =>
      'No se pudo cargar el texto de las reglas.';

  @override
  String get setupGuideFinish =>
      '¡Listo! Vuelve atrás, pega la configuración copiada y toca Conectar. Luego elige «Configurar una nueva congregación» y regístrate como el primer administrador.';

  @override
  String get setupGuideBackToConnect => 'Volver a la pantalla de conexión';

  @override
  String get languageSystem => 'Idioma del sistema';

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
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String themeTooltip(String mode) {
    return 'Tema: $mode';
  }

  @override
  String get profileCompleteTitle => 'Completa tu perfil';

  @override
  String get profileCompleteBody =>
      'Tu cuenta existe, pero falta el perfil. Escribe tu nombre para terminar el registro.';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authSignOut => 'Cerrar sesión';

  @override
  String get authRegister => 'Crear cuenta';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authPasswordConfirm => 'Confirmar contraseña';

  @override
  String get authPasswordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authResetSent =>
      'Se ha enviado un correo para restablecer la contraseña.';

  @override
  String get authEnterEmailForReset =>
      'Primero escribe tu dirección de correo electrónico y luego toca «¿Olvidaste tu contraseña?» para recibir un enlace de restablecimiento.';

  @override
  String get authNoAccountYet => '¿Aún no tienes cuenta? Crea una';

  @override
  String get authHaveAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get authErrorInvalidCredentials =>
      'Correo electrónico o contraseña incorrectos.';

  @override
  String get authErrorEmailInUse =>
      'Ya existe una cuenta con este correo electrónico.';

  @override
  String get authErrorWeakPassword =>
      'La contraseña es demasiado débil (al menos 6 caracteres).';

  @override
  String authErrorGeneric(String message) {
    return 'Error al iniciar sesión: $message';
  }

  @override
  String get authFirstName => 'Nombre';

  @override
  String get authLastName => 'Apellido';

  @override
  String get authCongregationName => 'Nombre de la congregación';

  @override
  String get awaitingTitle => 'Esperando verificación';

  @override
  String get awaitingBody =>
      'Se creó tu cuenta. Ahora un administrador de la congregación debe verificarla antes de que puedas ver la información de la congregación.';

  @override
  String get deleteAccountAction => 'Eliminar mi cuenta';

  @override
  String get deleteAccountWarning =>
      'Esto elimina de forma permanente tu cuenta y tu perfil personal (nombre, datos de contacto e inicio de sesión). Esto no se puede deshacer. Los informes que has enviado permanecen guardados en la congregación.';

  @override
  String get deleteAccountPasswordLabel =>
      'Escribe tu contraseña para confirmar';

  @override
  String get deleteAccountConfirm => 'Eliminar cuenta';

  @override
  String get deleteAccountSoleAdminTitle => 'Eres el único administrador';

  @override
  String get deleteAccountSoleAdminBody =>
      'Eres el único administrador completo de la congregación. Primero concede derechos de administrador completo a otro miembro; de lo contrario, eliminar tu cuenta dejaría a la congregación sin administrador y sin forma de restaurar el acceso.';

  @override
  String get changePasswordAction => 'Cambiar contraseña';

  @override
  String get changePasswordCurrentLabel => 'Contraseña actual';

  @override
  String get changePasswordNewLabel => 'Nueva contraseña';

  @override
  String get changePasswordConfirmLabel => 'Confirmar nueva contraseña';

  @override
  String get changePasswordConfirm => 'Actualizar contraseña';

  @override
  String get changePasswordSuccess => 'Contraseña actualizada.';

  @override
  String get navInfoBoard => 'Tablón de anuncios';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navLmm => 'Reunión de entre semana';

  @override
  String get navWeekend => 'Reunión del fin de semana';

  @override
  String get navPublicWitnessing => 'Predicación pública';

  @override
  String get navFieldServiceMeetings => 'Reuniones para predicar';

  @override
  String get navTerritories => 'Territorios';

  @override
  String get navMinistryGroups => 'Grupos de predicación';

  @override
  String get navReport => 'Informe de predicación';

  @override
  String get navAttendance => 'Asistencia';

  @override
  String get navProfile => 'Mi perfil';

  @override
  String get navAdmin => 'Administración';

  @override
  String get navPublishersAdmin => 'Publicadores';

  @override
  String get navReportsAdmin => 'Resumen de informes';

  @override
  String get navS1 => 'Informe S-1';

  @override
  String get navTalks => 'Temas de los discursos públicos';

  @override
  String get navSettings => 'Configuración de la congregación';

  @override
  String get navStatistics => 'Estadísticas';

  @override
  String get navHelp => 'Ayuda';

  @override
  String get helpPublisherSection => 'Consejos para publicadores';

  @override
  String get helpAdminSection => 'Para administradores';

  @override
  String get helpCalendarTitle => 'Añadir al calendario';

  @override
  String get helpCalendarBody =>
      'En la aplicación móvil, los eventos y tus asignaciones muestran un icono de calendario. Tócalo para añadir el elemento al calendario de tu dispositivo.';

  @override
  String get helpRemindersTitle => 'Recordatorios de asignaciones';

  @override
  String get helpRemindersBody =>
      'En la pantalla Eventos, toca el icono de campana junto a «Mis próximas asignaciones» para recibir un aviso antes de cada asignación; tú eliges con cuánta antelación. (Solo en la aplicación móvil.)';

  @override
  String get helpHighlightTitle => 'Encuéntrate de un vistazo';

  @override
  String get helpHighlightBody =>
      'En los programas de las reuniones tu propio nombre aparece resaltado, para que localices tus asignaciones rápidamente.';

  @override
  String get helpTerritoryMapTitle => 'Abrir el mapa de un territorio';

  @override
  String get helpTerritoryMapBody =>
      'Toca el icono de mapa junto a un territorio para abrir su mapa. Un icono gris indica que aún no se ha añadido un enlace de mapa para ese territorio.';

  @override
  String get helpAdminToggleTitle => 'Ver la aplicación como publicador';

  @override
  String get helpAdminToggleBody =>
      'El icono de lápiz de la barra superior oculta temporalmente todas las herramientas de administración, para que veas la aplicación tal como la ven los publicadores. Tócalo de nuevo para recuperarlas.';

  @override
  String get helpPdfExportTitle => 'Imprimir o compartir programas';

  @override
  String get helpPdfExportBody =>
      'En las pantallas Reunión de entre semana y Reunión del fin de semana, los editores del programa tienen un icono de PDF en la barra superior que exporta el programa del mes para imprimirlo o compartirlo.';

  @override
  String get helpGoogleMyMapsTitle => 'Mapas de territorio con Google My Maps';

  @override
  String get helpGoogleMyMapsBody =>
      'Crea los mapas de tus territorios en Google My Maps y pega el enlace para compartir de cada territorio en su campo de enlace de mapa. Hay una guía paso a paso disponible en GitHub.';

  @override
  String get helpOpenGuide => 'Abrir la guía';

  @override
  String get helpDataDelayTitle =>
      'Los cambios pueden tardar un momento en aparecer';

  @override
  String get helpDataDelayBody =>
      'Los cambios hechos en la aplicación —por ejemplo, ediciones en Publicadores— pueden tardar hasta un minuto en verse. (A veces, por ejemplo, una importación de S-21 no muestra de inmediato las horas de predicación del año de servicio en curso.)';

  @override
  String get helpPwApplyTitle => 'Ofrecerte para la predicación pública';

  @override
  String get helpPwApplyBody =>
      'Abre Predicación pública, busca un turno y toca el icono de mano para ofrecerte; tócalo de nuevo para retirarte. Si no ves el icono, pide a un administrador que active la habilitación «Predicación pública» en tu registro.';

  @override
  String get helpPwAssignTitle =>
      'Asignar publicadores a la predicación pública';

  @override
  String get helpPwAssignBody =>
      'Activa la habilitación «Predicación pública» de cada voluntario en Publicadores → abre un publicador → Habilitaciones. Luego, en Predicación pública, abre un turno y toca «Asignados»: los publicadores que se ofrecieron aparecen fijados arriba con la etiqueta «Se ofreció». Usa turnos recurrentes para carritos o exhibidores semanales.';

  @override
  String get helpS21Title => 'Importar registros S-21';

  @override
  String get helpS21Body =>
      'Puedes importar el Registro de Publicador de la Congregación (S-21) de un publicador desde un PDF. Abre Publicadores → un publicador → S-21 y elige el archivo. Solo se lee la capa de texto del PDF, así que los formularios escaneados o aplanados quizás no se importen.';

  @override
  String get helpS99Title => 'Importar temas de discursos públicos (S-99)';

  @override
  String get helpS99Body =>
      'En Temas de los discursos públicos, elige «Actualizar temas desde PDF» y selecciona un formulario S-99 oficial en PDF. Las próximas reuniones del fin de semana que usen esos números de discurso se actualizan automáticamente.';

  @override
  String get adminToggleHide => 'Ocultar opciones de administración';

  @override
  String get adminToggleShow => 'Mostrar opciones de administración';

  @override
  String get profilePhone => 'Número de teléfono';

  @override
  String get profileAddress => 'Dirección';

  @override
  String get profileBirthDate => 'Fecha de nacimiento';

  @override
  String get profileBaptismDate => 'Fecha de bautismo';

  @override
  String get profileGender => 'Sexo';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Hombre';

  @override
  String get genderFemale => 'Mujer';

  @override
  String get profileHope => 'Esperanza';

  @override
  String get hopeOtherSheep => 'Otras ovejas';

  @override
  String get hopeAnointed => 'Ungido';

  @override
  String get profileStatus => 'Situación de servicio';

  @override
  String get statusNone => '-';

  @override
  String get statusPublisher => 'Publicador';

  @override
  String get statusAuxPioneer => 'Precursor auxiliar';

  @override
  String get statusRegPioneer => 'Precursor regular';

  @override
  String get statusSpecialPioneer => 'Precursor especial';

  @override
  String get statusFieldMissionary => 'Misionero que sirve en el campo';

  @override
  String get profileAppointment => 'Nombramiento';

  @override
  String get appointmentMinisterialServant => 'Siervo ministerial';

  @override
  String get appointmentElder => 'Anciano';

  @override
  String get profileEmergency => 'Nota de emergencia';

  @override
  String get profileEmergencyHint => 'A quién contactar en caso de emergencia';

  @override
  String get profileSaved => 'Guardado';

  @override
  String get profileRecord => 'Registro de publicador';

  @override
  String serviceYear(int year) {
    return 'Año de servicio $year';
  }

  @override
  String get recordTotalHours => 'Total de horas';

  @override
  String get recordAverageHours => 'Promedio mensual';

  @override
  String get reportMonth => 'Mes';

  @override
  String get reportParticipated => 'Participación en el ministerio';

  @override
  String get reportStudies => 'Cursos bíblicos';

  @override
  String get reportHours => 'Horas';

  @override
  String get reportCredit => 'Horas de crédito';

  @override
  String get reportComments => 'Comentarios';

  @override
  String get s21Export => 'Exportar S-21 (PDF)';

  @override
  String get schedulePdfExport => 'Resumen mensual (PDF)';

  @override
  String get lmmScheduleTitle => 'Programa para la reunión de entre semana';

  @override
  String get s21Title => 'REGISTRO DE PUBLICADOR DE LA CONGREGACIÓN';

  @override
  String get s21Name => 'Nombre:';

  @override
  String get s21DateOfBirth => 'Fecha de nacimiento:';

  @override
  String get s21DateOfBaptism => 'Fecha de bautismo:';

  @override
  String get s21HoursHeader =>
      'Horas (Si es precursor o misionero que sirve en el campo)';

  @override
  String get s21Remarks => 'Notas';

  @override
  String get s21Total => 'Total';

  @override
  String get s21FormCode => 'S-21-S 11/23';

  @override
  String s21Credit(int hours) {
    return 'Crédito: $hours';
  }

  @override
  String get s21Import => 'Importar S-21 (PDF)';

  @override
  String get s21ImportNew => 'Importar publicador desde S-21';

  @override
  String get s21ImportTitle => 'Importar S-21';

  @override
  String get s21ImportPickFile => 'Elegir archivo PDF';

  @override
  String get s21ImportHint =>
      'Elige una tarjeta de registro de publicador S-21 (PDF). Los valores de la tarjeta reemplazan los campos del perfil del publicador y los informes mensuales.';

  @override
  String get s21ImportNoData => 'No se encontraron datos S-21 en este archivo.';

  @override
  String s21ImportMonths(int count) {
    return '$count informes mensuales encontrados';
  }

  @override
  String s21ImportNameKept(String name) {
    return 'Se conserva el nombre de la aplicación: $name';
  }

  @override
  String s21ImportCardName(String name) {
    return 'Nombre en la tarjeta: $name';
  }

  @override
  String s21ImportDuplicateName(String name) {
    return 'Ya existe un publicador llamado «$name».';
  }

  @override
  String get s21ImportUseExisting => 'Importar en el registro existente';

  @override
  String get s21ImportReplaceTitle => '¿Reemplazar los registros existentes?';

  @override
  String get s21ImportReplaceBody =>
      'Los campos del perfil del publicador y los informes mensuales de los años de servicio importados se reemplazarán con los valores de este S-21. Esto no se puede deshacer.';

  @override
  String get s21ImportSave => 'Importar';

  @override
  String get s21ImportDone => 'S-21 importado.';

  @override
  String get s21ImportAssignYear => 'Año de servicio de esta tabla';

  @override
  String get pubAdminInvite => 'Invitar';

  @override
  String get pubAdminInviteTitle => 'Invitar a la congregación';

  @override
  String get pubAdminInviteBody =>
      'El nuevo miembro escanea este código QR en la aplicación, se registra y luego aparece abajo como no verificado. Verifícalo para concederle acceso.';

  @override
  String get pubAdminAddRecord => 'Añadir registro de publicador';

  @override
  String get pubAdminAddRecordHint =>
      'Un registro para un miembro que no usará la aplicación; los administradores pueden introducir sus informes.';

  @override
  String get pubAdminVerified => 'Verificado';

  @override
  String get pubAdminUnverifiedBadge => 'Esperando verificación';

  @override
  String get pubAdminNoAccountBadge => 'Sin cuenta en la aplicación';

  @override
  String get pubAdminTabProfile => 'Perfil';

  @override
  String get pubAdminTabRoles => 'Derechos';

  @override
  String get pubAdminTabAssign => 'Asignar';

  @override
  String get pubAdminTabRecord => 'Registro';

  @override
  String get pubAdminDeleteConfirm =>
      '¿Eliminar este publicador y sus datos privados? Sus informes permanecen guardados.';

  @override
  String get pubAdminDeleteMovedHint =>
      'Si tiene una cuenta en la aplicación, eliminarlo no borra su inicio de sesión y podría volver a entrar. Para archivar a alguien que se mudó, usa «Marcar como mudado» en su lugar.';

  @override
  String get pubAdminMarkMoved => 'Marcar como mudado';

  @override
  String get pubAdminRestoreMoved => 'Restaurar de mudados';

  @override
  String get pubAdminMovedBadge => 'Mudado';

  @override
  String get pubAdminShowMoved => 'Mostrar mudados';

  @override
  String get pubFilterPioneers => 'Precursores';

  @override
  String get pubFilterHasRights => 'Con derechos';

  @override
  String get pubFilterAnyGroup => 'Cualquier grupo';

  @override
  String get pubFilterClear => 'Borrar';

  @override
  String get pubAdminMoveConfirmTitle => '¿Marcar como mudado?';

  @override
  String get pubAdminMoveConfirmBody =>
      'El registro y el historial de informes se conservan, pero el publicador se archiva: se le revoca el acceso y ya no aparece en los programas ni en las listas de informes. Puedes restaurarlo más adelante.';

  @override
  String get pubAdminSelfVerifiedWarningTitle =>
      '¿Desactivar tu propia condición de Verificado?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'Estás quitando el estado Verificado de tu propia cuenta. Perderás de inmediato el acceso a los datos de la congregación, y solo otro administrador completo podrá restaurarlo. ¿Seguro que quieres continuar?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      '¿Quitar tus propios derechos de administrador completo?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'Estás quitando el rol de administrador completo de tu propia cuenta. Si eres el único administrador, nadie —ni siquiera tú— podrá deshacer esto. ¿Seguro que quieres continuar?';

  @override
  String get pubAdminSelfWarningConfirm => 'Quitar mi acceso';

  @override
  String get pubConnectBanner =>
      'Esta cuenta está esperando verificación. Si un administrador ya creó un registro de publicador para esta persona, conéctalos: el historial del registro pasa a esta cuenta y el registro duplicado desaparece.';

  @override
  String get pubConnectAction => 'Conectar con un registro existente';

  @override
  String get pubConnectNeedsFullAdmin =>
      'Solo un administrador completo puede conectar registros (la migración afecta a los datos de todas las secciones).';

  @override
  String get pubConnectPickTitle => 'Conectar con un registro existente';

  @override
  String pubConnectPickHint(String name) {
    return 'Selecciona el registro que pertenece a $name.';
  }

  @override
  String get pubConnectNoRecords =>
      'No hay ningún registro de publicador sin cuenta en la aplicación para conectar.';

  @override
  String get pubConnectConfirmTitle => '¿Conectar y combinar?';

  @override
  String pubConnectConfirmBody(String record, String account) {
    return 'Todo el historial de «$record» —informes, territorios y asignaciones de los programas— se trasladará a la cuenta de «$account». La cuenta pasa a estar verificada y el registro duplicado se elimina de forma permanente. Esto no se puede deshacer.';
  }

  @override
  String get pubConnectProgressTitle => 'Conectando el registro…';

  @override
  String get pubConnectProgressBody =>
      'No cierres la aplicación mientras se traslada el historial.';

  @override
  String pubConnectFailed(String section) {
    return 'La conexión falló en: $section. Los pasos completados se conservan; reintentar es seguro y continúa donde se detuvo.';
  }

  @override
  String get pubConnectSuccess =>
      'Registro conectado: su historial ahora pertenece a esta cuenta.';

  @override
  String get roleFullAdmin => 'Administrador completo';

  @override
  String get roleRecordAttendance => 'Registrar asistencia';

  @override
  String get weekNoSchedule => 'Todavía no hay programa para esta semana.';

  @override
  String get weekCreateEmpty => 'Crear semana vacía';

  @override
  String get weekImportEpub => 'Importar desde .epub';

  @override
  String get weekCheckCdn => 'Buscar en línea';

  @override
  String get weekDelete => 'Eliminar esta semana';

  @override
  String get lmmSongs => 'Canciones';

  @override
  String get sectionOpening => 'Apertura';

  @override
  String get sectionTreasures => 'TESOROS DE LA BIBLIA';

  @override
  String get sectionMinistry => 'SEAMOS MEJORES MAESTROS';

  @override
  String get sectionLiving => 'NUESTRA VIDA CRISTIANA';

  @override
  String get sectionClosing => 'Conclusión';

  @override
  String get partChairman => 'Presidente';

  @override
  String get partOpeningPrayer => 'Oración de apertura';

  @override
  String get partClosingPrayer => 'Oración de conclusión';

  @override
  String get partGems => 'Busquemos perlas escondidas';

  @override
  String get partBibleReading => 'Lectura de la Biblia';

  @override
  String get partCbs => 'Estudio bíblico de la congregación';

  @override
  String get partCbsReader => 'Lector';

  @override
  String get partAssistant => 'Ayudante';

  @override
  String partMinutes(int min) {
    return '$min min.';
  }

  @override
  String get lmmClassMain => 'Auditorio principal';

  @override
  String lmmClassN(int index) {
    return 'Sala $index';
  }

  @override
  String get partEdit => 'Editar parte';

  @override
  String get partTitle => 'Título';

  @override
  String get partDescription => 'Descripción';

  @override
  String get partDuration => 'Duración (min.)';

  @override
  String get partAdd => 'Añadir parte';

  @override
  String get partDeleteConfirm => '¿Eliminar esta parte?';

  @override
  String get supportAttendants => 'Acomodadores';

  @override
  String get supportMicrophones => 'Micrófonos';

  @override
  String get supportAudioVideo => 'Audio y video';

  @override
  String get customAssignmentAdd => 'Añadir asignación personalizada';

  @override
  String get customLabel => 'Etiqueta';

  @override
  String get customAssignmentPermanent => 'Permanente (todas las semanas)';

  @override
  String get customAssignmentRemovePermanentTitle =>
      'Quitar asignación permanente';

  @override
  String customAssignmentRemovePermanentBody(String label) {
    return '¿Quitar «$label» de todas las semanas?';
  }

  @override
  String get pickerQualified => 'Habilitados';

  @override
  String get pickerAll => 'Todos';

  @override
  String get pickerFreeText => 'Texto';

  @override
  String pickerLastAssigned(String date) {
    return 'Última vez: $date';
  }

  @override
  String get pickerNever => 'Nunca asignado';

  @override
  String get pickerApplied => 'Se ofreció';

  @override
  String get importTitle => 'Importar la Guía de actividades';

  @override
  String get importNoWeeks =>
      'No se encontraron semanas utilizables en este archivo.';

  @override
  String get importWeekExists =>
      'Ya existe: se actualizará el programa y se conservarán las asignaciones';

  @override
  String importSave(int count) {
    return 'Importar $count semanas';
  }

  @override
  String get importDone => 'Importado.';

  @override
  String get importCdnNothing =>
      'Todavía no hay ninguna edición de la Guía de actividades disponible en línea.';

  @override
  String get weekendTalkTitle => 'Discurso público';

  @override
  String get weekendSpeaker => 'Orador';

  @override
  String get weekendChairmanLabel => 'Presidente';

  @override
  String get weekendWtReader => 'Lector de La Atalaya';

  @override
  String get customFieldAdd => 'Añadir campo del programa';

  @override
  String get pickerFromCatalog => 'De la lista';

  @override
  String get talksUpdateFromPdf => 'Actualizar temas desde PDF';

  @override
  String get talksPickPdf => 'Elegir PDF S-99';

  @override
  String get talksParseError =>
      'No se pudieron leer los temas de los discursos de este archivo. Usa un formulario S-99 oficial en PDF.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return '$total discursos encontrados: $added nuevos, $changed cambiados, $removed eliminados';
  }

  @override
  String get talksImportSave => 'Guardar temas';

  @override
  String talksImportDone(int count) {
    return 'Temas guardados. Se actualizaron $count reuniones próximas.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Pronunciado por última vez el $date';
  }

  @override
  String get talksNeverDelivered => 'Todavía no se ha pronunciado';

  @override
  String get talksScheduled => 'programado';

  @override
  String get talksNew => 'Nuevo';

  @override
  String get talksChanged => 'Cambiado';

  @override
  String get talksRemoved => 'Eliminado';

  @override
  String get talksSearchHint => 'Buscar discursos…';

  @override
  String get talksEmpty =>
      'Todavía no hay temas de discursos. Impórtalos desde un PDF S-99.';

  @override
  String get talksOpenCatalog => 'Gestionar temas de los discursos';

  @override
  String get talksEditTitle => 'Editar tema';

  @override
  String get songLabel => 'Canción';

  @override
  String get songsSearchHint => 'Buscar canciones…';

  @override
  String get songsEmpty =>
      'Todavía no hay lista de canciones. Actualízala desde el sitio web oficial.';

  @override
  String get songsUpdateFromWeb =>
      'Actualizar la lista de canciones desde el sitio web oficial';

  @override
  String songsUpdateDone(int count) {
    return 'Lista de canciones actualizada: $count canciones.';
  }

  @override
  String get songsCdnNothing =>
      'La lista de canciones todavía no está disponible en línea.';

  @override
  String get songsStatusEmpty =>
      'Todavía no se ha importado ninguna lista de canciones.';

  @override
  String songsStatusLoaded(int count, String date) {
    return '$count canciones · actualizado $date';
  }

  @override
  String get settingsSongsSection => 'Lista de canciones';

  @override
  String get settingsSongsDescription =>
      'Descarga los títulos de las canciones de las reuniones desde jw.org para poder elegirlos en los programas del fin de semana y de entre semana.';

  @override
  String get pwNoSlots => 'No hay predicación pública esta semana.';

  @override
  String get pwAddSlot => 'Añadir turno';

  @override
  String get pwEditSlot => 'Editar turno';

  @override
  String get pwLocation => 'Lugar';

  @override
  String get pwTimeFrom => 'Desde';

  @override
  String get pwTimeTo => 'Hasta';

  @override
  String get pwRecurringRules => 'Turnos recurrentes';

  @override
  String get pwRecurringAdd => 'Añadir turno recurrente';

  @override
  String get pwWeekday => 'Día de la semana';

  @override
  String get pwValidFrom => 'Válido desde';

  @override
  String get pwValidUntil => 'Válido hasta (opcional)';

  @override
  String get pwAssignees => 'Asignados';

  @override
  String get pwDate => 'Fecha';

  @override
  String get pwApply => 'Ofrecerme para este turno';

  @override
  String get pwWithdraw => 'Retirar mi ofrecimiento';

  @override
  String pwApplicants(int count) {
    return '$count se ofrecieron';
  }

  @override
  String get fsmNoMeetings => 'No hay reuniones para predicar esta semana.';

  @override
  String get fsmAddMeeting => 'Añadir reunión';

  @override
  String get fsmEditMeeting => 'Editar reunión';

  @override
  String get fsmDate => 'Fecha';

  @override
  String get fsmTime => 'Hora';

  @override
  String get fsmLocation => 'Lugar';

  @override
  String get fsmNote => 'Nota';

  @override
  String get fsmConductor => 'Conductor';

  @override
  String get fsmRecurringRules => 'Reuniones recurrentes';

  @override
  String get fsmRecurringAdd => 'Añadir reunión recurrente';

  @override
  String get fsmWeekday => 'Día de la semana';

  @override
  String get fsmValidFrom => 'Válido desde';

  @override
  String get fsmValidUntil => 'Válido hasta (opcional)';

  @override
  String get fsmRecurringDeleteConfirm =>
      '¿Eliminar esta reunión recurrente? También se eliminarán sus reuniones futuras. Esto no se puede deshacer.';

  @override
  String get fsmRemoveAllFutureAction => 'Eliminar todas las reuniones futuras';

  @override
  String get fsmRemoveAllFutureWarning =>
      'Eliminar todas las reuniones futuras borra cada reunión próxima, única o recurrente, y no se puede deshacer.';

  @override
  String get fsmRemoveAllFutureTitle =>
      '¿Eliminar todas las reuniones futuras?';

  @override
  String get fsmRemoveAllFutureBody =>
      'Esto elimina cada reunión próxima para predicar, única o recurrente, y quita todas las reglas de reuniones recurrentes para que ninguna se vuelva a generar. Las reuniones pasadas se conservan. Esto no se puede deshacer.';

  @override
  String get fsmRemoveAllFutureConfirm => 'Eliminar todas';

  @override
  String get eventsUpcoming => 'Próximos eventos';

  @override
  String get eventsNone => 'No hay eventos próximos.';

  @override
  String get eventAdd => 'Añadir evento';

  @override
  String get eventEdit => 'Editar evento';

  @override
  String get eventTitle => 'Título';

  @override
  String get eventType => 'Tipo';

  @override
  String get eventTypeConvention => 'Asamblea regional';

  @override
  String get eventTypeAssembly => 'Asamblea de circuito';

  @override
  String get eventTypeMemorial => 'Conmemoración';

  @override
  String get eventTypeCoVisit => 'Visita del superintendente de circuito';

  @override
  String get eventTypeOther => 'Otro';

  @override
  String get eventDateFrom => 'Desde';

  @override
  String get eventDateTo => 'Hasta (opcional)';

  @override
  String get eventLocation => 'Lugar';

  @override
  String get eventNotes => 'Notas';

  @override
  String get eventAddToCalendar => 'Añadir al calendario';

  @override
  String get myAssignments => 'Mis próximas asignaciones';

  @override
  String get myAssignmentsNone => 'No tienes asignaciones próximas.';

  @override
  String get remindersTitle => 'Recordatorios de asignaciones';

  @override
  String get remindersDescription =>
      'Recibe un aviso en este dispositivo antes de cada una de tus próximas asignaciones. Los cambios hechos con la aplicación cerrada se recogen la próxima vez que la abres.';

  @override
  String get remindersEnable => 'Activar recordatorios';

  @override
  String get remindersAdd => 'Añadir recordatorio';

  @override
  String get reminderUnitMinutes => 'minutos antes';

  @override
  String get reminderUnitHours => 'horas antes';

  @override
  String get reminderUnitDays => 'días antes';

  @override
  String get remindersPermissionDenied =>
      'Las notificaciones no están permitidas para esta aplicación. Actívalas en los ajustes del sistema para usar los recordatorios.';

  @override
  String get remindersChannelName => 'Recordatorios de asignaciones';

  @override
  String get remindersChannelDescription =>
      'Avisos antes de tus asignaciones de la congregación';

  @override
  String get roleAssistant => 'Ayudante';

  @override
  String get rolePw => 'Predicación pública';

  @override
  String get roleFsm => 'Reunión para predicar';

  @override
  String get reportSubmit => 'Enviar informe';

  @override
  String reportSubmittedAt(String date) {
    return 'Enviado el $date';
  }

  @override
  String get reportSaved => 'Informe guardado.';

  @override
  String get reportMissing => 'No enviado';

  @override
  String reportEnterFor(String name) {
    return 'Introducir informe — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Informaron: $reported / $total';
  }

  @override
  String get attAdd => 'Registrar asistencia';

  @override
  String get attInPerson => 'Presencial';

  @override
  String get attOnline => 'En línea';

  @override
  String get attTotal => 'Total';

  @override
  String get attMeetingLmm => 'Reunión de entre semana';

  @override
  String get attMeetingWeekend => 'Reunión del fin de semana';

  @override
  String get attOverview => 'Promedios mensuales';

  @override
  String get attHistory => 'Reuniones anteriores';

  @override
  String get attNotFilled => 'No registrado';

  @override
  String get attMismatch => 'Los números no cuadran.';

  @override
  String attRecordedOf(int filled, int expected) {
    return '$filled/$expected registrados';
  }

  @override
  String get attSaved => 'Asistencia guardada.';

  @override
  String get statMembershipTitle => 'Publicadores';

  @override
  String get statTotalMembers => 'Todos los publicadores';

  @override
  String get statPioneers => 'Precursores';

  @override
  String get statAgeTitle => 'Distribución por edad';

  @override
  String get statAgeAverage => 'Edad promedio';

  @override
  String statAgeKnownDetail(int known, int total) {
    return 'Basado en $known de $total fechas de nacimiento conocidas';
  }

  @override
  String get statAgeUnder18 => 'Menores de 18';

  @override
  String get statAgeUnknown => 'Desconocida';

  @override
  String get statAttendanceTitle => 'Asistencia a las reuniones';

  @override
  String get statAvg3Months => 'Prom. 3 meses';

  @override
  String get statAvg12Months => 'Prom. 12 meses';

  @override
  String get statFieldServiceTitle => 'Predicación';

  @override
  String statServiceYear(String year) {
    return 'Año de servicio $year';
  }

  @override
  String get statReportsSubmitted => 'Informes enviados';

  @override
  String get statParticipated => 'Participaron en el ministerio';

  @override
  String get statPioneerHours => 'Horas de precursor';

  @override
  String get statPublisherHours => 'Horas de publicador';

  @override
  String get statUsageTitle => 'Uso de la aplicación';

  @override
  String get statWithAccount => 'Con cuenta en la aplicación';

  @override
  String get statSelfReported =>
      'Informes enviados por el propio publicador (mes pasado)';

  @override
  String get statAwaiting => 'Esperando verificación';

  @override
  String get statFullAdmins => 'Administradores completos';

  @override
  String get statSectionAdmins => 'Administradores de sección';

  @override
  String get statNoData => 'Todavía no hay datos';

  @override
  String get terrMine => 'Mis territorios';

  @override
  String get terrNoMine => 'No tienes territorios asignados.';

  @override
  String get terrAll => 'Todos los territorios';

  @override
  String terrAssignedOn(String date) {
    return 'Asignado el $date';
  }

  @override
  String get terrReturn => 'Devolver';

  @override
  String get terrReturnTitle => 'Devolver territorio';

  @override
  String get terrReturnNotes => 'Notas (opcional)';

  @override
  String get terrMap => 'Mapa';

  @override
  String get terrAdd => 'Añadir territorio';

  @override
  String get terrEdit => 'Editar territorio';

  @override
  String get terrName => 'Nombre';

  @override
  String get terrNumber => 'Número';

  @override
  String get terrMapUrl => 'Enlace de mapa (por ejemplo, Google My Maps)';

  @override
  String get terrNotes => 'Notas';

  @override
  String get terrAssignTo => 'Asignar a…';

  @override
  String terrHolder(String name, String date) {
    return '$name — desde $date';
  }

  @override
  String get terrFree => 'Sin asignar';

  @override
  String get terrStats => 'Estadísticas';

  @override
  String get terrStatsTotal => 'Total';

  @override
  String get terrStatsAssigned => 'Asignados actualmente';

  @override
  String get terrStatsFinished => 'Terminados en el periodo';

  @override
  String get terrRemoveAssignment => 'Quitar asignación';

  @override
  String get terrImportTitle => 'Importar territorios';

  @override
  String get terrImportPasteHint =>
      'Pega filas de Excel o Google Sheets. Columnas: nombre, número, enlace de mapa, notas; solo el nombre es obligatorio.';

  @override
  String get terrImportPreview => 'Vista previa';

  @override
  String get terrImportPickFile => 'Elegir archivo CSV';

  @override
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  ) {
    return '$total filas: $newCount nuevas, $duplicates existentes, $invalid no válidas';
  }

  @override
  String get terrImportUpdateExisting =>
      'Actualizar los territorios existentes (coincidencia por número) en lugar de omitirlos';

  @override
  String get terrImportBadgeNew => 'Nuevo';

  @override
  String get terrImportBadgeSkip => 'Omitir';

  @override
  String get terrImportBadgeUpdate => 'Actualizar';

  @override
  String get terrImportBadgeInvalid => 'Falta el nombre';

  @override
  String get terrImportBadgeDupRow => 'Fila duplicada';

  @override
  String terrImportLine(int line) {
    return 'Línea $line';
  }

  @override
  String terrImportSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importar $count territorios',
      one: 'Importar 1 territorio',
    );
    return '$_temp0';
  }

  @override
  String terrImportDone(int created, int updated) {
    return 'Se importaron $created nuevos y se actualizaron $updated.';
  }

  @override
  String get terrImportEmpty => 'No se encontraron filas en la entrada.';

  @override
  String get terrDeleteConfirm =>
      '¿Eliminar este territorio? Esto no se puede deshacer.';

  @override
  String get terrSortByTerritory => 'Territorio';

  @override
  String get terrSortByPublisher => 'Publicador';

  @override
  String get terrSortByDate => 'Fecha de asignación';

  @override
  String get terrHistoryOngoing => 'Actual';

  @override
  String get terrHistoryEmpty => 'Todavía no hay historial de asignaciones.';

  @override
  String get mgEmpty => 'Todavía no hay grupos de predicación.';

  @override
  String get mgAdd => 'Añadir grupo';

  @override
  String get mgEdit => 'Editar grupo';

  @override
  String get mgName => 'Nombre';

  @override
  String mgMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
      zero: 'Sin miembros',
    );
    return '$_temp0';
  }

  @override
  String get mgNoMembers => 'Todavía no hay miembros en este grupo.';

  @override
  String get mgOverseer => 'Superintendente de grupo';

  @override
  String get mgAssistant => 'Auxiliar de grupo';

  @override
  String get mgMakeOverseer => 'Designar como superintendente de grupo';

  @override
  String get mgMakeAssistant => 'Designar como auxiliar';

  @override
  String get mgClearRole => 'Quitar la designación de superintendente/auxiliar';

  @override
  String get mgAddMember => 'Añadir miembro…';

  @override
  String get mgNoUnassigned => 'Todos ya están en un grupo.';

  @override
  String get mgRemoveMember => 'Quitar del grupo';

  @override
  String get mgDeleteConfirm =>
      '¿Eliminar este grupo? Sus miembros quedarán sin grupo.';

  @override
  String get mgGroup => 'Grupo de predicación';

  @override
  String get mgNoGroup => 'Sin grupo';

  @override
  String get infoEmpty => 'No hay información en este momento.';

  @override
  String get infoAddText => 'Añadir texto';

  @override
  String get infoAddFile => 'Subir archivo (PDF/imagen)';

  @override
  String get infoAddLink => 'Añadir enlace';

  @override
  String get infoTitle => 'Título';

  @override
  String get infoBody => 'Texto';

  @override
  String get infoUrl => 'Enlace (URL)';

  @override
  String get infoShowFrom => 'Mostrar desde (opcional)';

  @override
  String get infoShowUntil => 'Mostrar hasta (opcional)';

  @override
  String get infoFileTooLarge =>
      'El archivo es demasiado grande (máx. 10 MB). Compártelo como enlace en su lugar.';

  @override
  String get infoHidden =>
      'Oculto actualmente (fuera de su periodo de visibilidad)';

  @override
  String get infoDownloading => 'Cargando archivo…';

  @override
  String get infoEditItem => 'Editar elemento';

  @override
  String get s1Active =>
      'Publicadores activos (que informaron al menos una vez en los últimos 6 meses)';

  @override
  String get s1AvgMid =>
      'Promedio de asistencia a las reuniones de entre semana';

  @override
  String get s1AvgWeekend =>
      'Promedio de asistencia a las reuniones del fin de semana';

  @override
  String get s1Publishers => 'Publicadores';

  @override
  String get s1AuxPioneers => 'Precursores auxiliares';

  @override
  String get s1RegPioneers => 'Precursores regulares';

  @override
  String get s1Count => 'Cuántos informaron';

  @override
  String get s1Studies => 'Cursos bíblicos';

  @override
  String get s1Hours => 'Horas (total)';

  @override
  String get s1Note =>
      'Los precursores auxiliares, regulares y especiales no se cuentan en el grupo de Publicadores; los precursores especiales no se incluyen en ningún grupo.';

  @override
  String get settingsName => 'Nombre de la congregación';

  @override
  String get settingsLmmMeeting => 'Reunión de entre semana (día y hora)';

  @override
  String get settingsLmmClassCount => 'Salas de la reunión de entre semana';

  @override
  String get settingsWeekendMeeting => 'Reunión del fin de semana (día y hora)';

  @override
  String get settingsBackupSection => 'Copia de seguridad y restauración';

  @override
  String get settingsBackupDescription =>
      'Descarga una copia completa de los datos de tu congregación o restáuralos desde un archivo de copia de seguridad. Úsalo para recuperarte de una eliminación accidental o una edición incorrecta.';

  @override
  String get settingsExportData => 'Exportar todos los datos';

  @override
  String get settingsImportData => 'Restaurar desde copia de seguridad…';

  @override
  String backupExportSuccess(int count) {
    return 'Copia de seguridad descargada ($count registros).';
  }

  @override
  String get backupImportTitle => 'Restaurar desde copia de seguridad';

  @override
  String get backupImportPick => 'Elegir archivo de copia de seguridad…';

  @override
  String get backupImportEmpty =>
      'Elige un archivo de copia de seguridad para ver su contenido.';

  @override
  String get backupImportContents => 'Contenido';

  @override
  String backupImportFrom(String name, String date) {
    return 'Copia de seguridad de $name · $date';
  }

  @override
  String get backupImportWarning =>
      'Restaurar sobrescribe los registros actuales que compartan un ID con las versiones de esta copia de seguridad. Los registros añadidos después de la copia se conservan. Esto no se puede deshacer.';

  @override
  String get backupImportConfirm => 'Restaurar esta copia de seguridad';

  @override
  String backupImportSuccess(int count) {
    return 'Se restauraron $count registros.';
  }

  @override
  String backupImportPartial(int count, String collections) {
    return 'Se restauraron $count registros. No se pudieron restaurar: $collections.';
  }

  @override
  String get backupInvalidFile =>
      'Este archivo no es una copia de seguridad de congregación válida.';

  @override
  String get qSupportSection => 'Apoyo a la reunión y otros';

  @override
  String get qChairman => 'Presidente (entre semana)';

  @override
  String get qPrayer => 'Oración';

  @override
  String get qTreasures => 'Tesoros de la Biblia';

  @override
  String get qGems => 'Busquemos perlas escondidas';

  @override
  String get qBibleReading => 'Lectura de la Biblia';

  @override
  String get qFieldMinistry => 'Asignaciones de estudiante (predicación)';

  @override
  String get qLiving => 'Nuestra vida cristiana';

  @override
  String get qCbsConductor =>
      'Conductor del Estudio bíblico de la congregación';

  @override
  String get qCbsReader => 'Lector del Estudio bíblico de la congregación';

  @override
  String get qPublicTalk => 'Discurso público';

  @override
  String get qWeekendChairman => 'Presidente (fin de semana)';

  @override
  String get qWtReader => 'Lector de La Atalaya';

  @override
  String get qAttendant => 'Acomodador';

  @override
  String get qMicrophone => 'Micrófonos';

  @override
  String get qAudioVideo => 'Audio y video';

  @override
  String get qPublicWitnessing => 'Predicación pública';

  @override
  String get qMinistryMeetingConductor =>
      'Conductor de la reunión para predicar';
}
