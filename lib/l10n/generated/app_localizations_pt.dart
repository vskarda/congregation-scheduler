// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Programador da congregação';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonAdd => 'Adicionar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonLoading => 'Carregando…';

  @override
  String get commonError => 'Algo deu errado';

  @override
  String commonErrorDetail(String message) {
    return 'Algo deu errado: $message';
  }

  @override
  String get commonFieldRequired => 'Este campo é obrigatório';

  @override
  String get commonConfirmDeleteTitle => 'Excluir?';

  @override
  String get commonConfirmDeleteBody => 'Isso não pode ser desfeito.';

  @override
  String get commonToday => 'Hoje';

  @override
  String get commonAll => 'Todos';

  @override
  String get commonNone => 'Nenhum';

  @override
  String get commonYes => 'Sim';

  @override
  String get commonNo => 'Não';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSearch => 'Pesquisar';

  @override
  String get commonNotAssigned => '—';

  @override
  String get commonLanguage => 'Idioma';

  @override
  String get setupTitle => 'Conecte-se à sua congregação';

  @override
  String get setupIntro =>
      'Este aplicativo se conecta diretamente ao banco de dados da sua congregação. Cole a configuração que você recebeu do seu administrador ou escaneie o QR code do convite.';

  @override
  String get setupConfigLabel => 'Configuração do Firebase (JSON)';

  @override
  String get setupConfigHint => 'apiKey, authDomain, projectId, …';

  @override
  String get setupScanQr => 'Escanear QR code';

  @override
  String get setupPickQrImage => 'Escolher foto do QR code';

  @override
  String get setupQrNotFoundInImage =>
      'Nenhum QR code foi encontrado nessa imagem.';

  @override
  String get setupConnect => 'Conectar';

  @override
  String get setupInvalidJson =>
      'Esta configuração JSON não é válida. Ela precisa conter pelo menos apiKey, projectId e appId.';

  @override
  String setupConnectionFailed(String message) {
    return 'Não foi possível conectar com esta configuração: $message';
  }

  @override
  String get setupModeTitle => 'Como você quer começar?';

  @override
  String get setupModeJoin => 'Entrar na minha congregação';

  @override
  String get setupModeJoinSubtitle =>
      'Um administrador convidou você. Depois do registro, ele vai verificar sua conta.';

  @override
  String get setupModeNew => 'Configurar uma nova congregação';

  @override
  String get setupModeNewSubtitle =>
      'Você é o primeiro administrador de um projeto do Firebase recém-criado.';

  @override
  String get setupCongregationExists =>
      'Esta congregação já está configurada. Escolha «Entrar na minha congregação».';

  @override
  String get setupDatabaseNotReady =>
      'O banco de dados da congregação ainda está iniciando. Aguarde um momento e tente novamente.';

  @override
  String get setupReconfigure => 'Alterar configuração';

  @override
  String get setupRestartRequired =>
      'Configuração salva. Feche e reabra o aplicativo para aplicá-la.';

  @override
  String get setupGuideLinkIntro =>
      'Não tem uma configuração? Crie o banco de dados gratuito da sua congregação:';

  @override
  String get setupGuideLinkButton => 'Como configurar uma nova congregação';

  @override
  String get setupGuideTitle => 'Configurar uma nova congregação';

  @override
  String get setupGuideIntro =>
      'Este aplicativo é auto-hospedado: os dados da sua congregação ficam no seu próprio projeto gratuito do Google Firebase, ao qual ninguém mais tem acesso. A configuração leva cerca de 15 minutos e não exige programação: você só precisa de uma conta do Google. Siga os passos abaixo neste celular ou em um computador.';

  @override
  String get setupGuideOpenConsole => 'Abrir o console do Firebase';

  @override
  String get setupGuideStep1Title => 'Criar um projeto do Firebase';

  @override
  String get setupGuideStep1Body1 =>
      'Abra console.firebase.google.com, faça login com sua conta do Google e toque em «Get started by setting up a Firebase project».';

  @override
  String get setupGuideStep1Body2 =>
      'Dê um nome ao projeto, por exemplo «congregacao-minhacidade», aceite os termos e continue. Se o Google Analytics for oferecido, desative-o: não é necessário. Fique no plano gratuito Spark; o aplicativo foi projetado para nunca precisar de cobrança.';

  @override
  String get setupGuideStep2Title => 'Ativar o login por e-mail';

  @override
  String get setupGuideStep2Body1 =>
      'No menu à esquerda, escolha Security → Authentication.';

  @override
  String get setupGuideStep2Body2 => 'Toque em «Get started».';

  @override
  String get setupGuideStep2Body3 =>
      'Na aba «Sign-in method», escolha Email/Password.';

  @override
  String get setupGuideStep2Body4 =>
      'Ative o primeiro botão (deixe «Email link» desativado) e toque em Save.';

  @override
  String get setupGuideStep3Title => 'Criar o banco de dados Firestore';

  @override
  String get setupGuideStep3Body1 =>
      'No menu à esquerda, escolha Databases & Storage → Firestore.';

  @override
  String get setupGuideStep3Body2 => 'Toque em «Create database».';

  @override
  String get setupGuideStep3Body3 => 'Escolha a edição Standard.';

  @override
  String get setupGuideStep3Body4 =>
      'Escolha um local próximo de você (por exemplo, southamerica-east1 para o Brasil). Não poderá ser alterado depois.';

  @override
  String get setupGuideStep3Body5 => 'Comece no modo de produção…';

  @override
  String get setupGuideStep3Body6 => '…e toque em Create.';

  @override
  String get setupGuideStep4Title => 'Instalar as regras de segurança';

  @override
  String get setupGuideStep4Body1 =>
      'As regras determinam quem pode ler e gravar quais dados (por exemplo, só publicadores verificados veem as programações). No banco de dados Firestore, abra a aba Rules e toque em «Edit rules».';

  @override
  String get setupGuideStep4Body2 =>
      'Apague tudo o que estiver no editor e cole as regras copiadas.';

  @override
  String get setupGuideStep4Body3 => 'Toque em Publish.';

  @override
  String get setupGuideStep4Note =>
      'Repita esta etapa sempre que uma nova versão do aplicativo trouxer regras atualizadas.';

  @override
  String get setupGuideStep5Title => 'Obter a configuração do aplicativo';

  @override
  String get setupGuideStep5Body1 =>
      'Toque no ícone de engrenagem ao lado de «Project Overview» (no canto superior esquerdo) e escolha Project settings.';

  @override
  String get setupGuideStep5Body2 =>
      'Na aba General, role até «Your apps» e toque no ícone da web </>.';

  @override
  String get setupGuideStep5Body3 =>
      'Digite um apelido, por exemplo «congregation-app», deixe a hospedagem desativada e toque em «Register app».';

  @override
  String get setupGuideStep5Body4 =>
      'Um bloco de código com «const firebaseConfig = …» aparece. Selecione e copie apenas a configuração entre as chaves, incluindo as chaves.';

  @override
  String get setupGuideStep5Note =>
      'Esta configuração não é secreta: ela apenas identifica seu projeto. Os dados são protegidos pelas regras de segurança da etapa 4.';

  @override
  String get setupGuideRulesTitle => 'Regras de segurança (firestore.rules)';

  @override
  String get setupGuideRulesCopy => 'Copiar regras';

  @override
  String get setupGuideRulesCopied =>
      'Regras copiadas para a área de transferência.';

  @override
  String get setupGuideRulesView => 'Mostrar o texto das regras';

  @override
  String get setupGuideRulesLoadError =>
      'Não foi possível carregar o texto das regras.';

  @override
  String get setupGuideFinish =>
      'Pronto! Volte, cole a configuração copiada e toque em Conectar. Depois escolha «Configurar uma nova congregação» e registre-se como o primeiro administrador.';

  @override
  String get setupGuideBackToConnect => 'Voltar à tela de conexão';

  @override
  String get languageSystem => 'Idioma do sistema';

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
  String get themeDark => 'Escuro';

  @override
  String themeTooltip(String mode) {
    return 'Tema: $mode';
  }

  @override
  String get profileCompleteTitle => 'Complete seu perfil';

  @override
  String get profileCompleteBody =>
      'Sua conta existe, mas o perfil está faltando. Digite seu nome para concluir o registro.';

  @override
  String get authSignIn => 'Entrar';

  @override
  String get authSignOut => 'Sair';

  @override
  String get authRegister => 'Criar conta';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Senha';

  @override
  String get authPasswordConfirm => 'Confirmar senha';

  @override
  String get authPasswordsDontMatch => 'As senhas não coincidem';

  @override
  String get authForgotPassword => 'Esqueceu a senha?';

  @override
  String get authResetSent => 'Um e-mail para redefinir a senha foi enviado.';

  @override
  String get authEnterEmailForReset =>
      'Digite primeiro seu endereço de e-mail e depois toque em «Esqueceu a senha?» para receber um link de redefinição.';

  @override
  String get authNoAccountYet => 'Ainda não tem conta? Crie uma';

  @override
  String get authHaveAccount => 'Já tem conta? Entre';

  @override
  String get authErrorInvalidCredentials => 'E-mail ou senha incorretos.';

  @override
  String get authErrorEmailInUse => 'Já existe uma conta com este e-mail.';

  @override
  String get authErrorWeakPassword =>
      'A senha é muito fraca (pelo menos 6 caracteres).';

  @override
  String authErrorGeneric(String message) {
    return 'Falha ao entrar: $message';
  }

  @override
  String get authFirstName => 'Nome';

  @override
  String get authLastName => 'Sobrenome';

  @override
  String get authCongregationName => 'Nome da congregação';

  @override
  String get awaitingTitle => 'Aguardando verificação';

  @override
  String get awaitingBody =>
      'Sua conta foi criada. Agora um administrador da congregação precisa verificá-la antes que você possa ver as informações da congregação.';

  @override
  String get deleteAccountAction => 'Excluir minha conta';

  @override
  String get deleteAccountWarning =>
      'Isso exclui permanentemente sua conta e seu perfil pessoal (nome, dados de contato e login). Isso não pode ser desfeito. Os relatórios que você enviou continuam armazenados na congregação.';

  @override
  String get deleteAccountPasswordLabel => 'Digite sua senha para confirmar';

  @override
  String get deleteAccountConfirm => 'Excluir conta';

  @override
  String get deleteAccountSoleAdminTitle => 'Você é o único administrador';

  @override
  String get deleteAccountSoleAdminBody =>
      'Você é o único administrador completo da congregação. Conceda primeiro direitos de administrador completo a outro membro; caso contrário, excluir sua conta deixaria a congregação sem administrador e sem como restaurar o acesso.';

  @override
  String get changePasswordAction => 'Alterar senha';

  @override
  String get changePasswordCurrentLabel => 'Senha atual';

  @override
  String get changePasswordNewLabel => 'Nova senha';

  @override
  String get changePasswordConfirmLabel => 'Confirmar nova senha';

  @override
  String get changePasswordConfirm => 'Atualizar senha';

  @override
  String get changePasswordSuccess => 'Senha atualizada.';

  @override
  String get navInfoBoard => 'Mural de avisos';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navLmm => 'Reunião do meio de semana';

  @override
  String get navWeekend => 'Reunião do fim de semana';

  @override
  String get navPublicWitnessing => 'Testemunho público';

  @override
  String get navFieldServiceMeetings => 'Reuniões para o serviço de campo';

  @override
  String get navTerritories => 'Territórios';

  @override
  String get navMinistryGroups => 'Grupos de serviço de campo';

  @override
  String get navReport => 'Relatório de serviço de campo';

  @override
  String get navAttendance => 'Assistência';

  @override
  String get navProfile => 'Meu perfil';

  @override
  String get navAdmin => 'Administração';

  @override
  String get navPublishersAdmin => 'Publicadores';

  @override
  String get navReportsAdmin => 'Resumo de relatórios';

  @override
  String get navS1 => 'Relatório S-1';

  @override
  String get navTalks => 'Temas dos discursos públicos';

  @override
  String get navSettings => 'Configurações da congregação';

  @override
  String get navStatistics => 'Estatísticas';

  @override
  String get navHelp => 'Ajuda';

  @override
  String get helpPublisherSection => 'Dicas para publicadores';

  @override
  String get helpAdminSection => 'Para administradores';

  @override
  String get helpCalendarTitle => 'Adicionar ao calendário';

  @override
  String get helpCalendarBody =>
      'No aplicativo do celular, os eventos e suas designações mostram um ícone de calendário. Toque nele para adicionar o item ao calendário do seu dispositivo.';

  @override
  String get helpRemindersTitle => 'Lembretes de designações';

  @override
  String get helpRemindersBody =>
      'Na tela Eventos, toque no ícone de sino ao lado de «Minhas próximas designações» para ser avisado antes de cada designação — você escolhe com quanta antecedência. (Somente no aplicativo do celular.)';

  @override
  String get helpHighlightTitle => 'Encontre-se num relance';

  @override
  String get helpHighlightBody =>
      'Nas programações das reuniões, seu próprio nome fica destacado, para que você veja suas designações rapidamente.';

  @override
  String get helpTerritoryMapTitle => 'Abrir o mapa de um território';

  @override
  String get helpTerritoryMapBody =>
      'Toque no ícone de mapa ao lado de um território para abrir seu mapa. Um ícone cinza indica que ainda não foi adicionado um link de mapa para esse território.';

  @override
  String get helpAdminToggleTitle => 'Ver o aplicativo como publicador';

  @override
  String get helpAdminToggleBody =>
      'O ícone de lápis na barra superior oculta temporariamente todas as ferramentas de administração, para que você veja o aplicativo exatamente como os publicadores veem. Toque novamente para trazê-las de volta.';

  @override
  String get helpPdfExportTitle => 'Imprimir ou compartilhar programações';

  @override
  String get helpPdfExportBody =>
      'Nas telas Reunião do meio de semana e Reunião do fim de semana, os editores das programações têm um ícone de PDF na barra superior que exporta a programação do mês para imprimir ou compartilhar.';

  @override
  String get helpGoogleMyMapsTitle =>
      'Mapas de territórios com o Google My Maps';

  @override
  String get helpGoogleMyMapsBody =>
      'Crie os mapas dos seus territórios no Google My Maps e cole o link de compartilhamento de cada território no seu campo de link de mapa. Um guia passo a passo está disponível no GitHub.';

  @override
  String get helpOpenGuide => 'Abrir o guia';

  @override
  String get helpDataDelayTitle =>
      'As alterações podem demorar um momento para aparecer';

  @override
  String get helpDataDelayBody =>
      'As alterações feitas no aplicativo — por exemplo, edições em Publicadores — podem demorar até um minuto para ficar visíveis. (Às vezes, por exemplo, uma importação de S-21 não mostra imediatamente as horas de campo do ano de serviço atual.)';

  @override
  String get helpPwApplyTitle => 'Voluntariar-se para o testemunho público';

  @override
  String get helpPwApplyBody =>
      'Abra Testemunho público, encontre um horário e toque no ícone de mão para se voluntariar; toque novamente para se retirar. Se você não vir o ícone, peça a um administrador para ativar a habilitação «Testemunho público» no seu registro.';

  @override
  String get helpPwAssignTitle =>
      'Designar publicadores para o testemunho público';

  @override
  String get helpPwAssignBody =>
      'Ative a habilitação «Testemunho público» de cada voluntário em Publicadores → abra um publicador → Habilitações. Depois, em Testemunho público, abra um horário e toque em «Designados»: os publicadores que se voluntariaram ficam fixados no topo da lista com a etiqueta «Voluntariou-se». Use horários recorrentes para carrinhos ou balcões semanais.';

  @override
  String get helpS21Title => 'Importar registros S-21';

  @override
  String get helpS21Body =>
      'Você pode importar o Registro de Publicador de Congregação (S-21) de um publicador a partir de um PDF. Abra Publicadores → um publicador → S-21 e escolha o arquivo. Apenas a camada de texto do PDF é lida, então formulários digitalizados ou achatados podem não ser importados.';

  @override
  String get helpS99Title => 'Importar temas de discursos públicos (S-99)';

  @override
  String get helpS99Body =>
      'Em Temas dos discursos públicos, escolha «Atualizar temas a partir de PDF» e selecione um formulário S-99 oficial em PDF. As próximas reuniões do fim de semana que se referem a esses números de discurso são atualizadas automaticamente.';

  @override
  String get adminToggleHide => 'Ocultar opções de administração';

  @override
  String get adminToggleShow => 'Mostrar opções de administração';

  @override
  String get profilePhone => 'Número de telefone';

  @override
  String get profileAddress => 'Endereço';

  @override
  String get profileBirthDate => 'Data de nascimento';

  @override
  String get profileBaptismDate => 'Data de batismo';

  @override
  String get profileGender => 'Sexo';

  @override
  String get genderUnknown => '—';

  @override
  String get genderMale => 'Masculino';

  @override
  String get genderFemale => 'Feminino';

  @override
  String get profileHope => 'Esperança';

  @override
  String get hopeOtherSheep => 'Outras ovelhas';

  @override
  String get hopeAnointed => 'Ungido';

  @override
  String get profileStatus => 'Situação de serviço';

  @override
  String get statusNone => '-';

  @override
  String get statusPublisher => 'Publicador';

  @override
  String get statusAuxPioneer => 'Pioneiro auxiliar';

  @override
  String get statusRegPioneer => 'Pioneiro regular';

  @override
  String get statusSpecialPioneer => 'Pioneiro especial';

  @override
  String get statusFieldMissionary => 'Missionário em campo';

  @override
  String get profileAppointment => 'Designação';

  @override
  String get appointmentMinisterialServant => 'Servo ministerial';

  @override
  String get appointmentElder => 'Ancião';

  @override
  String get profileEmergency => 'Nota de emergência';

  @override
  String get profileEmergencyHint => 'Quem contatar em caso de emergência';

  @override
  String get profileSaved => 'Salvo';

  @override
  String get profileRecord => 'Registro de publicador';

  @override
  String get profileAwayTitle => 'Períodos de ausência';

  @override
  String get profileAwayEmpty => 'Nenhum período de ausência adicionado';

  @override
  String get profileAwayAdd => 'Adicionar período de ausência';

  @override
  String profileAwayRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String serviceYear(int year) {
    return 'Ano de serviço $year';
  }

  @override
  String get recordTotalHours => 'Total de horas';

  @override
  String get recordAverageHours => 'Média mensal';

  @override
  String get reportMonth => 'Mês';

  @override
  String get reportParticipated => 'Participou no ministério';

  @override
  String get reportStudies => 'Estudos bíblicos';

  @override
  String get reportHours => 'Horas';

  @override
  String get reportCredit => 'Horas de crédito';

  @override
  String get reportComments => 'Comentários';

  @override
  String get s21Export => 'Exportar S-21 (PDF)';

  @override
  String get schedulePdfExport => 'Resumo mensal (PDF)';

  @override
  String get lmmScheduleTitle => 'Programação da reunião do meio de semana';

  @override
  String get s21Title => 'REGISTRO DE PUBLICADOR DE CONGREGAÇÃO';

  @override
  String get s21Name => 'Nome:';

  @override
  String get s21DateOfBirth => 'Data de nascimento:';

  @override
  String get s21DateOfBaptism => 'Data de batismo:';

  @override
  String get s21HoursHeader =>
      'Horas (Se for pioneiro ou missionário em campo)';

  @override
  String get s21Remarks => 'Observações';

  @override
  String get s21Total => 'Total';

  @override
  String get s21FormCode => 'S-21-T 11/23';

  @override
  String s21Credit(int hours) {
    return 'Crédito: $hours';
  }

  @override
  String get s21Import => 'Importar S-21 (PDF)';

  @override
  String get s21ImportNew => 'Importar publicador de S-21';

  @override
  String get s21ImportTitle => 'Importar S-21';

  @override
  String get s21ImportPickFile => 'Escolher arquivo PDF';

  @override
  String get s21ImportHint =>
      'Escolha um cartão de registro de publicador S-21 (PDF). Os valores do cartão substituem os campos do perfil do publicador e os relatórios mensais.';

  @override
  String get s21ImportNoData => 'Nenhum dado S-21 encontrado neste arquivo.';

  @override
  String s21ImportMonths(int count) {
    return '$count relatórios mensais encontrados';
  }

  @override
  String s21ImportNameKept(String name) {
    return 'O nome no aplicativo é mantido: $name';
  }

  @override
  String s21ImportCardName(String name) {
    return 'Nome no cartão: $name';
  }

  @override
  String s21ImportDuplicateName(String name) {
    return 'Já existe um publicador chamado «$name».';
  }

  @override
  String get s21ImportUseExisting => 'Importar no registro existente';

  @override
  String get s21ImportReplaceTitle => 'Substituir os registros existentes?';

  @override
  String get s21ImportReplaceBody =>
      'Os campos do perfil do publicador e os relatórios mensais dos anos de serviço importados serão substituídos pelos valores deste S-21. Isso não pode ser desfeito.';

  @override
  String get s21ImportSave => 'Importar';

  @override
  String get s21ImportDone => 'S-21 importado.';

  @override
  String get s21ImportAssignYear => 'Ano de serviço desta tabela';

  @override
  String get pubAdminInvite => 'Convidar';

  @override
  String get pubAdminInviteTitle => 'Convidar para a congregação';

  @override
  String get pubAdminInviteBody =>
      'O novo membro escaneia este QR code no aplicativo, registra-se e depois aparece abaixo como não verificado. Verifique-o para conceder acesso.';

  @override
  String get pubAdminAddRecord => 'Adicionar registro de publicador';

  @override
  String get pubAdminAddRecordHint =>
      'Um registro para um membro que não vai usar o aplicativo; os relatórios podem ser inseridos pelos administradores.';

  @override
  String get pubAdminVerified => 'Verificado';

  @override
  String get pubAdminUnverifiedBadge => 'Aguardando verificação';

  @override
  String get pubAdminNoAccountBadge => 'Sem conta no aplicativo';

  @override
  String get pubAdminTabProfile => 'Perfil';

  @override
  String get pubAdminTabRoles => 'Direitos';

  @override
  String get pubAdminTabAssign => 'Designar';

  @override
  String get pubAdminTabRecord => 'Registro';

  @override
  String get pubAdminDeleteConfirm =>
      'Excluir este publicador e seus dados privados? Os relatórios dele continuam armazenados.';

  @override
  String get pubAdminDeleteMovedHint =>
      'Se ele tem conta no aplicativo, a exclusão não remove o login e ele poderia entrar novamente. Para arquivar alguém que se mudou, use «Marcar como mudado».';

  @override
  String get pubAdminMarkMoved => 'Marcar como mudado';

  @override
  String get pubAdminRestoreMoved => 'Restaurar dos mudados';

  @override
  String get pubAdminMovedBadge => 'Mudado';

  @override
  String get pubAdminShowMoved => 'Mostrar mudados';

  @override
  String get pubFilterPioneers => 'Pioneiros';

  @override
  String get pubFilterHasRights => 'Com direitos';

  @override
  String get pubFilterAnyGroup => 'Qualquer grupo';

  @override
  String get pubFilterClear => 'Limpar';

  @override
  String get pubAdminMoveConfirmTitle => 'Marcar como mudado?';

  @override
  String get pubAdminMoveConfirmBody =>
      'O registro e o histórico de relatórios são mantidos, mas o publicador é arquivado: o acesso dele é revogado e ele não aparece mais nas programações nem nas listas de relatórios. Você pode restaurá-lo depois.';

  @override
  String get pubAdminSelfVerifiedWarningTitle =>
      'Desativar seu próprio status de Verificado?';

  @override
  String get pubAdminSelfVerifiedWarningBody =>
      'Você está removendo o status Verificado da sua própria conta. Você perderá imediatamente o acesso aos dados da congregação, e só outro administrador completo poderá restaurá-lo. Tem certeza de que quer continuar?';

  @override
  String get pubAdminSelfFullAdminWarningTitle =>
      'Remover seus próprios direitos de administrador completo?';

  @override
  String get pubAdminSelfFullAdminWarningBody =>
      'Você está removendo o papel de administrador completo da sua própria conta. Se você é o único administrador, ninguém — nem você — poderá desfazer isso. Tem certeza de que quer continuar?';

  @override
  String get pubAdminSelfWarningConfirm => 'Remover meu acesso';

  @override
  String get pubConnectBanner =>
      'Esta conta está aguardando verificação. Se um administrador já criou um registro de publicador para esta pessoa, conecte os dois: o histórico do registro passa para esta conta e o registro duplicado desaparece.';

  @override
  String get pubConnectAction => 'Conectar a um registro existente';

  @override
  String get pubConnectNeedsFullAdmin =>
      'Só um administrador completo pode conectar registros (a migração afeta os dados de todas as seções).';

  @override
  String get pubConnectPickTitle => 'Conectar a um registro existente';

  @override
  String pubConnectPickHint(String name) {
    return 'Selecione o registro que pertence a $name.';
  }

  @override
  String get pubConnectNoRecords =>
      'Não há nenhum registro de publicador sem conta no aplicativo para conectar.';

  @override
  String get pubConnectConfirmTitle => 'Conectar e mesclar?';

  @override
  String pubConnectConfirmBody(String record, String account) {
    return 'Todo o histórico de «$record» — relatórios, territórios e designações das programações — será transferido para a conta de «$account». A conta passa a ser verificada e o registro duplicado é excluído permanentemente. Isso não pode ser desfeito.';
  }

  @override
  String get pubConnectProgressTitle => 'Conectando o registro…';

  @override
  String get pubConnectProgressBody =>
      'Não feche o aplicativo enquanto o histórico está sendo transferido.';

  @override
  String pubConnectFailed(String section) {
    return 'A conexão falhou em: $section. As etapas concluídas são mantidas; tentar novamente é seguro e continua de onde parou.';
  }

  @override
  String get pubConnectSuccess =>
      'Registro conectado — o histórico dele agora pertence a esta conta.';

  @override
  String get roleFullAdmin => 'Administrador completo';

  @override
  String get roleRecordAttendance => 'Registrar assistência';

  @override
  String get weekNoSchedule => 'Ainda não há programação para esta semana.';

  @override
  String get weekCreateEmpty => 'Criar semana vazia';

  @override
  String get weekImportEpub => 'Importar de .epub';

  @override
  String get weekCheckCdn => 'Verificar on-line';

  @override
  String get weekDelete => 'Excluir esta semana';

  @override
  String get lmmSongs => 'Cânticos';

  @override
  String get sectionOpening => 'Abertura';

  @override
  String get sectionTreasures => 'TESOUROS DA PALAVRA DE DEUS';

  @override
  String get sectionMinistry => 'FAÇA SEU MELHOR NO MINISTÉRIO';

  @override
  String get sectionLiving => 'NOSSA VIDA CRISTÃ';

  @override
  String get sectionClosing => 'Conclusão';

  @override
  String get partChairman => 'Presidente';

  @override
  String get partOpeningPrayer => 'Oração inicial';

  @override
  String get partClosingPrayer => 'Oração final';

  @override
  String get partGems => 'Joias espirituais';

  @override
  String get partBibleReading => 'Leitura da Bíblia';

  @override
  String get partCbs => 'Estudo bíblico de congregação';

  @override
  String get partCbsReader => 'Leitor';

  @override
  String get partAssistant => 'Ajudante';

  @override
  String partMinutes(int min) {
    return '$min min';
  }

  @override
  String get lmmClassMain => 'Salão principal';

  @override
  String lmmClassN(int index) {
    return 'Sala $index';
  }

  @override
  String get partEdit => 'Editar parte';

  @override
  String get partTitle => 'Tema';

  @override
  String get partDescription => 'Descrição';

  @override
  String get partDuration => 'Duração (min)';

  @override
  String get partAdd => 'Adicionar parte';

  @override
  String get partDeleteConfirm => 'Excluir esta parte?';

  @override
  String get supportAttendants => 'Indicadores';

  @override
  String get supportMicrophones => 'Microfones';

  @override
  String get supportAudioVideo => 'Áudio e vídeo';

  @override
  String get customAssignmentAdd => 'Adicionar designação personalizada';

  @override
  String get customLabel => 'Rótulo';

  @override
  String get customAssignmentPermanent => 'Permanente (toda semana)';

  @override
  String get customAssignmentRemovePermanentTitle =>
      'Remover designação permanente';

  @override
  String customAssignmentRemovePermanentBody(String label) {
    return 'Remover «$label» de todas as semanas?';
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
  String get pickerNever => 'Nunca designado';

  @override
  String get pickerApplied => 'Voluntariou-se';

  @override
  String pickerAwayWarning(String range) {
    return 'Ausente $range';
  }

  @override
  String get importTitle => 'Importar a Apostila da Reunião';

  @override
  String get importNoWeeks =>
      'Nenhuma semana utilizável foi encontrada neste arquivo.';

  @override
  String get importWeekExists =>
      'Já existe — a programação será atualizada, as designações mantidas';

  @override
  String importSave(int count) {
    return 'Importar $count semanas';
  }

  @override
  String get importDone => 'Importado.';

  @override
  String get importCdnNothing =>
      'Nenhuma edição da apostila está disponível on-line ainda.';

  @override
  String get weekendTalkTitle => 'Discurso público';

  @override
  String get weekendSpeaker => 'Orador';

  @override
  String get weekendChairmanLabel => 'Presidente';

  @override
  String get weekendWtReader => 'Leitor de A Sentinela';

  @override
  String get customFieldAdd => 'Adicionar campo à programação';

  @override
  String get pickerFromCatalog => 'Da lista';

  @override
  String get talksUpdateFromPdf => 'Atualizar temas a partir de PDF';

  @override
  String get talksPickPdf => 'Escolher PDF S-99';

  @override
  String get talksParseError =>
      'Não foi possível ler os temas dos discursos deste arquivo. Use um formulário S-99 oficial em PDF.';

  @override
  String talksImportSummary(int total, int added, int changed, int removed) {
    return '$total discursos encontrados: $added novos, $changed alterados, $removed removidos';
  }

  @override
  String get talksImportSave => 'Salvar temas';

  @override
  String talksImportDone(int count) {
    return 'Temas salvos. $count reuniões futuras atualizadas.';
  }

  @override
  String talksLastDelivered(String date) {
    return 'Proferido pela última vez em $date';
  }

  @override
  String get talksNeverDelivered => 'Ainda não proferido';

  @override
  String get talksScheduled => 'programado';

  @override
  String get talksNew => 'Novo';

  @override
  String get talksChanged => 'Alterado';

  @override
  String get talksRemoved => 'Removido';

  @override
  String get talksSearchHint => 'Pesquisar discursos…';

  @override
  String get talksEmpty =>
      'Ainda não há temas de discursos. Importe-os de um PDF S-99.';

  @override
  String get talksOpenCatalog => 'Gerenciar temas dos discursos';

  @override
  String get talksEditTitle => 'Editar tema';

  @override
  String get songLabel => 'Cântico';

  @override
  String get songsSearchHint => 'Pesquisar cânticos…';

  @override
  String get songsEmpty =>
      'Ainda não há lista de cânticos. Atualize-a pelo site oficial.';

  @override
  String get songsUpdateFromWeb =>
      'Atualizar a lista de cânticos pelo site oficial';

  @override
  String songsUpdateDone(int count) {
    return 'Lista de cânticos atualizada: $count cânticos.';
  }

  @override
  String get songsCdnNothing =>
      'A lista de cânticos ainda não está disponível on-line.';

  @override
  String get songsStatusEmpty =>
      'Ainda não foi importada nenhuma lista de cânticos.';

  @override
  String songsStatusLoaded(int count, String date) {
    return '$count cânticos · atualizado $date';
  }

  @override
  String get settingsSongsSection => 'Lista de cânticos';

  @override
  String get settingsSongsDescription =>
      'Baixe os títulos dos cânticos das reuniões do jw.org para poder escolhê-los nas programações do fim de semana e do meio de semana.';

  @override
  String get pwNoSlots => 'Nenhum testemunho público esta semana.';

  @override
  String get pwAddSlot => 'Adicionar horário';

  @override
  String get pwEditSlot => 'Editar horário';

  @override
  String get pwLocation => 'Local';

  @override
  String get pwTimeFrom => 'Das';

  @override
  String get pwTimeTo => 'Às';

  @override
  String get pwRecurringRules => 'Horários recorrentes';

  @override
  String get pwRecurringAdd => 'Adicionar horário recorrente';

  @override
  String get pwWeekday => 'Dia da semana';

  @override
  String get pwValidFrom => 'Válido a partir de';

  @override
  String get pwValidUntil => 'Válido até (opcional)';

  @override
  String get pwAssignees => 'Designados';

  @override
  String get pwDate => 'Data';

  @override
  String get pwApply => 'Voluntariar-me para este horário';

  @override
  String get pwWithdraw => 'Retirar meu voluntariado';

  @override
  String pwApplicants(int count) {
    return '$count se voluntariaram';
  }

  @override
  String get fsmNoMeetings =>
      'Nenhuma reunião para o serviço de campo esta semana.';

  @override
  String get fsmAddMeeting => 'Adicionar reunião';

  @override
  String get fsmEditMeeting => 'Editar reunião';

  @override
  String get fsmDate => 'Data';

  @override
  String get fsmTime => 'Horário';

  @override
  String get fsmLocation => 'Local';

  @override
  String get fsmNote => 'Nota';

  @override
  String get fsmConductor => 'Dirigente';

  @override
  String get fsmRecurringRules => 'Reuniões recorrentes';

  @override
  String get fsmRecurringAdd => 'Adicionar reunião recorrente';

  @override
  String get fsmWeekday => 'Dia da semana';

  @override
  String get fsmValidFrom => 'Válido a partir de';

  @override
  String get fsmValidUntil => 'Válido até (opcional)';

  @override
  String get fsmRecurringDeleteConfirm =>
      'Excluir esta reunião recorrente? As reuniões futuras dela também serão removidas. Isso não pode ser desfeito.';

  @override
  String get fsmRemoveAllFutureAction => 'Remover todas as reuniões futuras';

  @override
  String get fsmRemoveAllFutureWarning =>
      'Remover todas as reuniões futuras exclui cada reunião futura, única ou recorrente, e não pode ser desfeito.';

  @override
  String get fsmRemoveAllFutureTitle => 'Remover todas as reuniões futuras?';

  @override
  String get fsmRemoveAllFutureBody =>
      'Isso exclui cada reunião futura para o serviço de campo, única ou recorrente, e remove todas as regras de reuniões recorrentes para que nenhuma seja gerada de novo. As reuniões passadas são mantidas. Isso não pode ser desfeito.';

  @override
  String get fsmRemoveAllFutureConfirm => 'Remover todas';

  @override
  String get eventsUpcoming => 'Próximos eventos';

  @override
  String get eventsNone => 'Nenhum evento futuro.';

  @override
  String get eventAdd => 'Adicionar evento';

  @override
  String get eventEdit => 'Editar evento';

  @override
  String get eventTitle => 'Título';

  @override
  String get eventType => 'Tipo';

  @override
  String get eventTypeConvention => 'Congresso regional';

  @override
  String get eventTypeAssembly => 'Assembleia de circuito';

  @override
  String get eventTypeMemorial => 'Comemoração';

  @override
  String get eventTypeCoVisit => 'Visita do superintendente de circuito';

  @override
  String get eventTypeOther => 'Outro';

  @override
  String get eventDateFrom => 'De';

  @override
  String get eventDateTo => 'Até (opcional)';

  @override
  String get eventLocation => 'Local';

  @override
  String get eventNotes => 'Notas';

  @override
  String get eventAddToCalendar => 'Adicionar ao calendário';

  @override
  String get myAssignments => 'Minhas próximas designações';

  @override
  String get myAssignmentsNone => 'Nenhuma designação futura.';

  @override
  String get remindersTitle => 'Lembretes de designações';

  @override
  String get remindersDescription =>
      'Receba um aviso neste dispositivo antes de cada uma das suas próximas designações. As alterações feitas com o aplicativo fechado são captadas na próxima vez que você o abrir.';

  @override
  String get remindersEnable => 'Ativar lembretes';

  @override
  String get remindersAdd => 'Adicionar lembrete';

  @override
  String get reminderUnitMinutes => 'minutos antes';

  @override
  String get reminderUnitHours => 'horas antes';

  @override
  String get reminderUnitDays => 'dias antes';

  @override
  String get remindersPermissionDenied =>
      'As notificações não são permitidas para este aplicativo. Ative-as nas configurações do sistema para usar os lembretes.';

  @override
  String get remindersChannelName => 'Lembretes de designações';

  @override
  String get remindersChannelDescription =>
      'Avisos antes das suas designações na congregação';

  @override
  String get roleAssistant => 'Ajudante';

  @override
  String get rolePw => 'Testemunho público';

  @override
  String get roleFsm => 'Reunião para o serviço de campo';

  @override
  String get reportSubmit => 'Enviar relatório';

  @override
  String reportSubmittedAt(String date) {
    return 'Enviado em $date';
  }

  @override
  String get reportSaved => 'Relatório salvo.';

  @override
  String get reportMissing => 'Não enviado';

  @override
  String reportEnterFor(String name) {
    return 'Inserir relatório — $name';
  }

  @override
  String reportSummaryReported(int reported, int total) {
    return 'Relataram: $reported / $total';
  }

  @override
  String get attAdd => 'Registrar assistência';

  @override
  String get attInPerson => 'Presencial';

  @override
  String get attOnline => 'On-line';

  @override
  String get attTotal => 'Total';

  @override
  String get attMeetingLmm => 'Reunião do meio de semana';

  @override
  String get attMeetingWeekend => 'Reunião do fim de semana';

  @override
  String get attOverview => 'Médias mensais';

  @override
  String get attHistory => 'Reuniões anteriores';

  @override
  String get attNotFilled => 'Não registrado';

  @override
  String get attMismatch => 'Os números não batem.';

  @override
  String attRecordedOf(int filled, int expected) {
    return '$filled/$expected registrados';
  }

  @override
  String get attSaved => 'Assistência registrada.';

  @override
  String get statMembershipTitle => 'Publicadores';

  @override
  String get statTotalMembers => 'Todos os publicadores';

  @override
  String get statPioneers => 'Pioneiros';

  @override
  String get statAgeTitle => 'Distribuição por idade';

  @override
  String get statAgeAverage => 'Idade média';

  @override
  String statAgeKnownDetail(int known, int total) {
    return 'Baseado em $known de $total datas de nascimento conhecidas';
  }

  @override
  String get statAgeUnder18 => 'Menores de 18';

  @override
  String get statAgeUnknown => 'Desconhecida';

  @override
  String get statAttendanceTitle => 'Assistência às reuniões';

  @override
  String get statAvg3Months => 'Média de 3 meses';

  @override
  String get statAvg12Months => 'Média de 12 meses';

  @override
  String get statFieldServiceTitle => 'Serviço de campo';

  @override
  String statServiceYear(String year) {
    return 'Ano de serviço $year';
  }

  @override
  String get statReportsSubmitted => 'Relatórios enviados';

  @override
  String get statParticipated => 'Participaram no ministério';

  @override
  String get statPioneerHours => 'Horas dos pioneiros';

  @override
  String get statPublisherHours => 'Horas dos publicadores';

  @override
  String get statUsageTitle => 'Uso do aplicativo';

  @override
  String get statWithAccount => 'Com conta no aplicativo';

  @override
  String get statSelfReported =>
      'Relatórios enviados pelos próprios publicadores (mês passado)';

  @override
  String get statAwaiting => 'Aguardando verificação';

  @override
  String get statFullAdmins => 'Administradores completos';

  @override
  String get statSectionAdmins => 'Administradores de seção';

  @override
  String get statNoData => 'Ainda não há dados';

  @override
  String get terrMine => 'Meus territórios';

  @override
  String get terrNoMine => 'Nenhum território designado a você.';

  @override
  String get terrAll => 'Todos os territórios';

  @override
  String terrAssignedOn(String date) {
    return 'Designado em $date';
  }

  @override
  String get terrReturn => 'Devolver';

  @override
  String get terrReturnTitle => 'Devolver território';

  @override
  String get terrReturnNotes => 'Notas (opcional)';

  @override
  String get terrMap => 'Mapa';

  @override
  String get terrAdd => 'Adicionar território';

  @override
  String get terrEdit => 'Editar território';

  @override
  String get terrName => 'Nome';

  @override
  String get terrNameDuplicate => 'Já existe um território com este nome.';

  @override
  String get terrMapUrl => 'Link do mapa (por exemplo, Google My Maps)';

  @override
  String get terrNotes => 'Notas';

  @override
  String get terrAssignTo => 'Designar a…';

  @override
  String terrHolder(String name, String date) {
    return '$name — desde $date';
  }

  @override
  String get terrFree => 'Não designado';

  @override
  String get terrStats => 'Estatísticas';

  @override
  String get terrStatsTotal => 'Total';

  @override
  String get terrStatsAssigned => 'Designados no momento';

  @override
  String get terrStatsFinished => 'Concluídos no período';

  @override
  String get terrRemoveAssignment => 'Remover designação';

  @override
  String get terrImportTitle => 'Importar territórios';

  @override
  String get terrImportPasteHint =>
      'Cole linhas do Excel ou do Google Planilhas. Colunas: nome, link do mapa, notas — só o nome é obrigatório.';

  @override
  String get terrImportPreview => 'Prévia';

  @override
  String get terrImportPickFile => 'Escolher arquivo CSV';

  @override
  String terrImportSummary(
    int total,
    int newCount,
    int duplicates,
    int invalid,
  ) {
    return '$total linhas: $newCount novas, $duplicates existentes, $invalid inválidas';
  }

  @override
  String get terrImportUpdateExisting =>
      'Atualizar os territórios existentes (correspondência por nome) em vez de ignorá-los';

  @override
  String get terrImportBadgeNew => 'Novo';

  @override
  String get terrImportBadgeSkip => 'Ignorar';

  @override
  String get terrImportBadgeUpdate => 'Atualizar';

  @override
  String get terrImportBadgeInvalid => 'Nome faltando';

  @override
  String get terrImportBadgeDupRow => 'Linha duplicada';

  @override
  String terrImportLine(int line) {
    return 'Linha $line';
  }

  @override
  String terrImportSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importar $count territórios',
      one: 'Importar 1 território',
    );
    return '$_temp0';
  }

  @override
  String terrImportDone(int created, int updated) {
    return '$created novos importados, $updated atualizados.';
  }

  @override
  String get terrImportEmpty => 'Nenhuma linha encontrada na entrada.';

  @override
  String get terrDeleteConfirm =>
      'Excluir este território? Isso não pode ser desfeito.';

  @override
  String get terrSortByTerritory => 'Território';

  @override
  String get terrSortByPublisher => 'Publicador';

  @override
  String get terrSortByDate => 'Data de designação';

  @override
  String get terrHistoryOngoing => 'Atual';

  @override
  String get terrHistoryEmpty => 'Ainda não há histórico de designações.';

  @override
  String get mgEmpty => 'Ainda não há grupos de serviço de campo.';

  @override
  String get mgAdd => 'Adicionar grupo';

  @override
  String get mgEdit => 'Editar grupo';

  @override
  String get mgName => 'Nome';

  @override
  String mgMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros',
      one: '1 membro',
      zero: 'Nenhum membro',
    );
    return '$_temp0';
  }

  @override
  String get mgNoMembers => 'Ainda não há membros neste grupo.';

  @override
  String get mgOverseer => 'Superintendente de grupo';

  @override
  String get mgAssistant => 'Ajudante de grupo';

  @override
  String get mgMakeOverseer => 'Definir como superintendente de grupo';

  @override
  String get mgMakeAssistant => 'Definir como ajudante';

  @override
  String get mgClearRole => 'Remover a designação de superintendente/ajudante';

  @override
  String get mgAddMember => 'Adicionar membro…';

  @override
  String get mgNoUnassigned => 'Todos já estão em um grupo.';

  @override
  String get mgRemoveMember => 'Remover do grupo';

  @override
  String get mgDeleteConfirm =>
      'Excluir este grupo? Os membros dele ficarão sem grupo.';

  @override
  String get mgGroup => 'Grupo de serviço de campo';

  @override
  String get mgNoGroup => 'Sem grupo';

  @override
  String get infoEmpty => 'Nenhuma informação no momento.';

  @override
  String get infoAddText => 'Adicionar texto';

  @override
  String get infoAddFile => 'Enviar arquivo (PDF/imagem)';

  @override
  String get infoTitle => 'Título';

  @override
  String get infoBody => 'Texto';

  @override
  String get infoUrl => 'Link (URL)';

  @override
  String get infoShowFrom => 'Mostrar a partir de (opcional)';

  @override
  String get infoShowUntil => 'Mostrar até (opcional)';

  @override
  String get infoFileTooLarge =>
      'O arquivo é grande demais (máx. 10 MB). Compartilhe como um link.';

  @override
  String get infoHidden =>
      'Oculto no momento (fora do seu período de visibilidade)';

  @override
  String get infoDownloading => 'Carregando arquivo…';

  @override
  String get infoEditItem => 'Editar item';

  @override
  String get s1Active =>
      'Publicadores ativos (que relataram pelo menos uma vez nos últimos 6 meses)';

  @override
  String get s1AvgMid => 'Média da assistência da reunião do meio de semana';

  @override
  String get s1AvgWeekend => 'Média da assistência da reunião do fim de semana';

  @override
  String get s1Publishers => 'Publicadores';

  @override
  String get s1AuxPioneers => 'Pioneiros auxiliares';

  @override
  String get s1RegPioneers => 'Pioneiros regulares';

  @override
  String get s1Count => 'Quantos relataram';

  @override
  String get s1Studies => 'Estudos bíblicos';

  @override
  String get s1Hours => 'Horas (total)';

  @override
  String get s1Note =>
      'Os pioneiros auxiliares, regulares e especiais não são contados no grupo dos Publicadores; os pioneiros especiais não são incluídos em nenhum grupo.';

  @override
  String get settingsName => 'Nome da congregação';

  @override
  String get settingsLmmMeeting => 'Reunião do meio de semana (dia e horário)';

  @override
  String get settingsLmmClassCount => 'Salas da reunião do meio de semana';

  @override
  String get settingsWeekendMeeting =>
      'Reunião do fim de semana (dia e horário)';

  @override
  String get settingsBackupSection => 'Backup e restauração';

  @override
  String get settingsBackupDescription =>
      'Baixe uma cópia completa dos dados da sua congregação ou restaure-os de um arquivo de backup. Use isso para se recuperar de uma exclusão acidental ou de uma edição errada.';

  @override
  String get settingsExportData => 'Exportar todos os dados';

  @override
  String get settingsImportData => 'Restaurar de backup…';

  @override
  String backupExportSuccess(int count) {
    return 'Backup baixado ($count registros).';
  }

  @override
  String get backupImportTitle => 'Restaurar de backup';

  @override
  String get backupImportPick => 'Escolher arquivo de backup…';

  @override
  String get backupImportEmpty =>
      'Escolha um arquivo de backup para pré-visualizar o conteúdo.';

  @override
  String get backupImportContents => 'Conteúdo';

  @override
  String backupImportFrom(String name, String date) {
    return 'Backup de $name · $date';
  }

  @override
  String get backupImportWarning =>
      'A restauração sobrescreve os registros atuais que compartilham um ID com as versões deste backup. Os registros adicionados depois do backup são mantidos. Isso não pode ser desfeito.';

  @override
  String get backupImportConfirm => 'Restaurar este backup';

  @override
  String backupImportSuccess(int count) {
    return '$count registros restaurados.';
  }

  @override
  String backupImportPartial(int count, String collections) {
    return '$count registros restaurados. Não foi possível restaurar: $collections.';
  }

  @override
  String get backupInvalidFile =>
      'Este arquivo não é um backup de congregação válido.';

  @override
  String get qSupportSection => 'Apoio à reunião e outros';

  @override
  String get qChairman => 'Presidente (meio de semana)';

  @override
  String get qPrayer => 'Oração';

  @override
  String get qTreasures => 'Tesouros da Palavra de Deus';

  @override
  String get qGems => 'Joias espirituais';

  @override
  String get qBibleReading => 'Leitura da Bíblia';

  @override
  String get qFieldMinistry => 'Designações de estudante (ministério)';

  @override
  String get qLiving => 'Nossa vida cristã';

  @override
  String get qCbsConductor => 'Dirigente do Estudo bíblico de congregação';

  @override
  String get qCbsReader => 'Leitor do Estudo bíblico de congregação';

  @override
  String get qPublicTalk => 'Discurso público';

  @override
  String get qWeekendChairman => 'Presidente (fim de semana)';

  @override
  String get qWtReader => 'Leitor de A Sentinela';

  @override
  String get qAttendant => 'Indicador';

  @override
  String get qMicrophone => 'Microfones';

  @override
  String get qAudioVideo => 'Áudio e vídeo';

  @override
  String get qPublicWitnessing => 'Testemunho público';

  @override
  String get qMinistryMeetingConductor =>
      'Dirigente da reunião para o serviço de campo';
}
