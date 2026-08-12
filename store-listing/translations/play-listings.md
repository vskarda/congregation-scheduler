# Google Play store listing — all languages

Source of truth for the localized Play Store listing. `scripts/build_store_listings.py`
parses this file, checks Play's character limits, and emits
`play-listing-translations.csv` next to it.

Locales match the ten languages the app's own UI ships (`lib/l10n/app_*.arb`), so the
store never advertises a language the app can't actually speak. Titles reuse each
locale's own `appTitle` string, except where that exceeded Play's 30-character title
limit (noted inline).

Play limits: title 30, short description 80, full description 4000.

Structure below is machine-read — keep the `### LOCALE / ### TITLE / ### SHORT / ### FULL`
markers exactly as they are.

---

### LOCALE: en-US
### TITLE
Congregation Scheduler
### SHORT
Self-hosted scheduling for Jehovah's Witnesses congregations. Your own Firebase.
### FULL
Congregation Scheduler is a self-hosted scheduling and management app for Jehovah's Witnesses congregations. Unlike typical apps, it doesn't send your congregation's data to any company's server: each congregation runs its own free Firebase project, and the app connects directly to it. Nobody but your own administrators - not even the app's developer - can see your data.

Independently developed. Not affiliated with, endorsed by, or produced by the Watch Tower Bible and Tract Society or any official Jehovah's Witnesses entity.

WHAT IT DOES

- Information board: texts, PDF/image documents, links, with visibility windows
- Events and a personal "my upcoming assignments" overview
- Midweek meeting schedule, with direct .epub workbook import and a qualification-aware assignment picker that favors whoever was assigned longest ago
- Weekend meeting schedule: talk, speaker, chairman, Watchtower reader, and custom fields
- Public witnessing schedule with recurring time slots
- Territories: assignment, return with notes, map links, and statistics
- Ministry reports: self-service and admin paper entry, publisher records by service year, and an automatic monthly (S-1) summary
- Meeting attendance tracking, in-person and online, with monthly averages
- Publisher management: identity verification, granular per-section admin roles, assignment qualifications, and emergency contact notes
- Interface in Czech, English, French, German, Italian, Japanese, Polish, Portuguese, Spanish, and Turkish

HOW SET-UP WORKS

An administrator creates a free Firebase project (about 15 minutes, no programming required - full instructions are included) and installs the app's security rules, which decide exactly who can see and edit what. Every other publisher is invited by scanning a QR code; new members start out unverified until an administrator confirms their identity.

WHY SELF-HOSTED

Congregation records include personal details - names, contact info, ministry activity - that deserve real privacy. By keeping every congregation's data inside a Firebase project that only that congregation's own administrators control, Congregation Scheduler avoids a shared central database becoming the target of a single breach, and keeps you in charge of your own data at all times.

The app is free, contains no ads, and does not collect analytics or tracking data of any kind.

---

### LOCALE: cs-CZ
### TITLE
Sborový plánovač
### SHORT
Plánování pro sbory svědků Jehovových. Data ve vlastním projektu Firebase.
### FULL
Sborový plánovač je aplikace pro plánování a správu sboru svědků Jehovových, kterou si každý sbor hostuje sám. Na rozdíl od běžných aplikací neposílá data vašeho sboru na server žádné firmy: každý sbor provozuje vlastní bezplatný projekt Firebase a aplikace se připojuje přímo k němu. Vaše údaje nevidí nikdo kromě vašich vlastních správců - ani vývojář aplikace.

Vyvinuto nezávisle. Není spojeno se společností Watch Tower Bible and Tract Society ani s žádným oficiálním subjektem svědků Jehovových, není jimi podporováno ani vydáváno.

CO APLIKACE UMÍ

- Informační deska: texty, dokumenty PDF a obrázky, odkazy, s obdobím viditelnosti
- Události a osobní přehled nadcházejících úkolů
- Program shromáždění v týdnu s přímým importem sešitu ve formátu .epub a výběrem úkolů podle kvalifikace, který upřednostní toho, kdo měl úkol nejdéle
- Program víkendového shromáždění: přednáška, řečník, předsedající, čtenář Strážné věže a vlastní pole
- Program veřejného svědectví s opakujícími se časovými úseky
- Obvody: přidělení, vrácení s poznámkami, odkazy na mapy a statistiky
- Zprávy o službě: vlastní zadání i papírové zadání správcem, záznamy zvěstovatelů podle služebního roku a automatický měsíční souhrn (S-1)
- Sledování návštěvnosti shromáždění, osobně i online, s měsíčními průměry
- Správa zvěstovatelů: ověření totožnosti, podrobná oprávnění správce podle sekcí, kvalifikace pro úkoly a poznámky o nouzovém kontaktu
- Rozhraní v angličtině, češtině, francouzštině, italštině, japonštině, němčině, polštině, portugalštině, španělštině a turečtině

JAK PROBÍHÁ NASTAVENÍ

Správce vytvoří bezplatný projekt Firebase (asi 15 minut, bez programování - součástí je podrobný návod) a nainstaluje bezpečnostní pravidla aplikace, která přesně určují, kdo co uvidí a může upravovat. Každý další zvěstovatel je pozván naskenováním QR kódu; noví členové zůstávají neověření, dokud správce nepotvrdí jejich totožnost.

PROČ VLASTNÍ HOSTING

Sborové záznamy obsahují osobní údaje - jména, kontakty, činnost ve službě - které si zaslouží skutečné soukromí. Tím, že data každého sboru zůstávají v projektu Firebase, který ovládají jen správci daného sboru, Sborový plánovač předchází tomu, aby se sdílená centrální databáze stala cílem jediného úniku dat, a vy máte své údaje trvale pod kontrolou.

Aplikace je zdarma, neobsahuje reklamy a neshromažďuje žádná analytická ani sledovací data.

---

### LOCALE: de-DE
### TITLE
Versammlungsplaner
### SHORT
Selbst gehostete Planung für Versammlungen von Jehovas Zeugen. Eigenes Firebase.
### FULL
Versammlungsplaner ist eine selbst gehostete App zur Planung und Verwaltung für Versammlungen von Jehovas Zeugen. Anders als übliche Apps sendet sie die Daten eurer Versammlung an keinen Firmenserver: Jede Versammlung betreibt ihr eigenes kostenloses Firebase-Projekt, und die App verbindet sich direkt damit. Niemand außer euren eigenen Administratoren - nicht einmal der Entwickler der App - kann eure Daten sehen.

Unabhängig entwickelt. Nicht verbunden mit, unterstützt von oder herausgegeben von der Watch Tower Bible and Tract Society oder einer offiziellen Organisation von Jehovas Zeugen.

WAS DIE APP BIETET

- Anschlagbrett: Texte, PDF- und Bilddokumente, Links, mit Anzeigezeitraum
- Veranstaltungen und eine persönliche Übersicht der anstehenden Aufgaben
- Programm der Zusammenkunft unter der Woche, mit direktem Import des Arbeitshefts (.epub) und einer Aufgabenauswahl, die Qualifikationen berücksichtigt und denjenigen bevorzugt, dessen Einsatz am längsten zurückliegt
- Programm der Zusammenkunft am Wochenende: Vortrag, Redner, Vorsitz, Wachtturm-Leser und eigene Felder
- Programm für öffentliches Zeugnisgeben mit wiederkehrenden Zeitfenstern
- Gebiete: Zuteilung, Rückgabe mit Notizen, Kartenlinks und Statistiken
- Predigtdienstberichte: Selbsteingabe und Papiereingabe durch Administratoren, Verkündigerkarten nach Dienstjahr und eine automatische Monatsübersicht (S-1)
- Erfassung der Anwesenheit bei Zusammenkünften, vor Ort und online, mit Monatsdurchschnitten
- Verkündigerverwaltung: Identitätsprüfung, fein abgestufte Administratorrechte je Bereich, Qualifikationen für Aufgaben und Notfallkontakt-Notizen
- Oberfläche auf Deutsch, Englisch, Französisch, Italienisch, Japanisch, Polnisch, Portugiesisch, Spanisch, Tschechisch und Türkisch

SO FUNKTIONIERT DIE EINRICHTUNG

Ein Administrator erstellt ein kostenloses Firebase-Projekt (etwa 15 Minuten, keine Programmierkenntnisse nötig - eine vollständige Anleitung ist enthalten) und installiert die Sicherheitsregeln der App, die genau festlegen, wer was sehen und bearbeiten darf. Alle weiteren Verkündiger werden durch das Scannen eines QR-Codes eingeladen; neue Mitglieder bleiben unbestätigt, bis ein Administrator ihre Identität bestätigt.

WARUM SELBST GEHOSTET

Versammlungsunterlagen enthalten persönliche Angaben - Namen, Kontaktdaten, Predigtdiensttätigkeit -, die echten Schutz verdienen. Dadurch, dass die Daten jeder Versammlung in einem Firebase-Projekt bleiben, das nur die Administratoren dieser Versammlung kontrollieren, verhindert Versammlungsplaner, dass eine gemeinsame zentrale Datenbank zum Ziel eines einzigen Datenlecks wird, und ihr behaltet jederzeit die Kontrolle über eure eigenen Daten.

Die App ist kostenlos, enthält keine Werbung und erhebt keinerlei Analyse- oder Trackingdaten.

---

### LOCALE: es-ES
### TITLE
Programador de la congregación
### SHORT
Programación para congregaciones de los testigos de Jehová. Tu propio Firebase.
### FULL
Programador de la congregación es una aplicación autoalojada de programación y administración para congregaciones de los testigos de Jehová. A diferencia de las aplicaciones habituales, no envía los datos de tu congregación al servidor de ninguna empresa: cada congregación mantiene su propio proyecto gratuito de Firebase y la aplicación se conecta directamente a él. Nadie más que los administradores de tu propia congregación - ni siquiera el desarrollador de la aplicación - puede ver tus datos.

Desarrollada de forma independiente. No está afiliada, respaldada ni producida por la Watch Tower Bible and Tract Society ni por ninguna entidad oficial de los testigos de Jehová.

QUÉ HACE

- Tablón de anuncios: textos, documentos PDF e imágenes, enlaces, con periodos de visibilidad
- Eventos y un resumen personal de tus próximas asignaciones
- Programa de la reunión de entre semana, con importación directa del cuaderno de trabajo en .epub y un selector de asignaciones que tiene en cuenta las capacitaciones y da preferencia a quien hace más tiempo que no participa
- Programa de la reunión del fin de semana: discurso, orador, presidente, lector de La Atalaya y campos personalizados
- Programa de predicación pública con turnos periódicos
- Territorios: asignación, devolución con notas, enlaces a mapas y estadísticas
- Informes de predicación: entrada propia y entrada en papel por el administrador, registros de publicadores por año de servicio y un resumen mensual (S-1) automático
- Registro de asistencia a las reuniones, presencial y en línea, con promedios mensuales
- Administración de publicadores: verificación de identidad, permisos de administrador detallados por sección, capacitaciones para asignaciones y notas de contacto de emergencia
- Interfaz en alemán, checo, español, francés, inglés, italiano, japonés, polaco, portugués y turco

CÓMO SE CONFIGURA

Un administrador crea un proyecto gratuito de Firebase (unos 15 minutos, sin necesidad de programar; se incluyen instrucciones completas) e instala las reglas de seguridad de la aplicación, que deciden exactamente quién puede ver y editar cada cosa. Los demás publicadores se invitan escaneando un código QR; los miembros nuevos permanecen sin verificar hasta que un administrador confirma su identidad.

POR QUÉ AUTOALOJADA

Los registros de una congregación incluyen datos personales - nombres, información de contacto, actividad en la predicación - que merecen privacidad real. Al mantener los datos de cada congregación dentro de un proyecto de Firebase que solo controlan los administradores de esa congregación, Programador de la congregación evita que una base de datos central compartida se convierta en el objetivo de una única filtración, y te deja siempre al mando de tus propios datos.

La aplicación es gratuita, no contiene anuncios y no recopila datos analíticos ni de seguimiento de ningún tipo.

---

### LOCALE: fr-FR
### TITLE
Planificateur de l'assemblée
### SHORT
Planification pour assemblées de Témoins de Jéhovah. Votre propre Firebase.
### FULL
Planificateur de l'assemblée est une application auto-hébergée de planification et de gestion pour les assemblées de Témoins de Jéhovah. Contrairement aux applications habituelles, elle n'envoie les données de votre assemblée sur le serveur d'aucune entreprise : chaque assemblée gère son propre projet Firebase gratuit, et l'application s'y connecte directement. Personne d'autre que vos propres administrateurs - pas même le développeur de l'application - ne peut voir vos données.

Développée de façon indépendante. Non affiliée à la Watch Tower Bible and Tract Society ni à aucune entité officielle des Témoins de Jéhovah, et ni approuvée ni produite par elles.

CE QU'ELLE FAIT

- Tableau d'affichage : textes, documents PDF et images, liens, avec périodes de visibilité
- Événements et un aperçu personnel de vos prochaines attributions
- Programme de la réunion de semaine, avec import direct du cahier d'activités au format .epub et un sélecteur d'attributions qui tient compte des qualifications et privilégie celui dont l'attribution remonte au plus loin
- Programme de la réunion de week-end : discours, orateur, président, lecteur de La Tour de Garde et champs personnalisés
- Programme de témoignage public avec créneaux récurrents
- Territoires : attribution, restitution avec notes, liens vers les cartes et statistiques
- Rapports d'activité : saisie personnelle et saisie papier par l'administrateur, fiches de proclamateurs par année de service et récapitulatif mensuel (S-1) automatique
- Suivi de l'assistance aux réunions, en présentiel et en ligne, avec moyennes mensuelles
- Gestion des proclamateurs : vérification d'identité, droits d'administration détaillés par section, qualifications pour les attributions et notes de contact d'urgence
- Interface en allemand, anglais, espagnol, français, italien, japonais, polonais, portugais, tchèque et turc

COMMENT SE PASSE L'INSTALLATION

Un administrateur crée un projet Firebase gratuit (environ 15 minutes, sans programmation - des instructions complètes sont fournies) et installe les règles de sécurité de l'application, qui déterminent précisément qui peut voir et modifier quoi. Tous les autres proclamateurs sont invités en scannant un code QR ; les nouveaux membres restent non vérifiés jusqu'à ce qu'un administrateur confirme leur identité.

POURQUOI L'AUTO-HÉBERGEMENT

Les registres d'une assemblée contiennent des informations personnelles - noms, coordonnées, activité de prédication - qui méritent une vraie confidentialité. En gardant les données de chaque assemblée dans un projet Firebase que seuls les administrateurs de cette assemblée contrôlent, Planificateur de l'assemblée évite qu'une base de données centrale partagée devienne la cible d'une seule fuite, et vous laisse maître de vos données à tout moment.

L'application est gratuite, ne contient aucune publicité et ne collecte aucune donnée d'analyse ou de suivi.

---

### LOCALE: it-IT
### TITLE
Pianificatore di congregazione
### SHORT
Pianificazione per congregazioni dei Testimoni di Geova. Il tuo Firebase.
### FULL
Pianificatore della congregazione è un'app self-hosted di pianificazione e gestione per le congregazioni dei Testimoni di Geova. A differenza delle app tradizionali, non invia i dati della tua congregazione al server di nessuna azienda: ogni congregazione gestisce un proprio progetto Firebase gratuito e l'app vi si collega direttamente. Nessuno al di fuori dei tuoi amministratori - nemmeno lo sviluppatore dell'app - può vedere i tuoi dati.

Sviluppata in modo indipendente. Non affiliata, approvata o prodotta dalla Watch Tower Bible and Tract Society né da alcun ente ufficiale dei Testimoni di Geova.

COSA FA

- Bacheca: testi, documenti PDF e immagini, link, con periodi di visibilità
- Eventi e un riepilogo personale dei tuoi prossimi incarichi
- Programma dell'adunanza infrasettimanale, con importazione diretta del quaderno in formato .epub e una selezione degli incarichi che tiene conto delle qualifiche e privilegia chi ha ricevuto un incarico da più tempo
- Programma dell'adunanza del fine settimana: discorso, oratore, presidente, lettore della Torre di Guardia e campi personalizzati
- Programma della testimonianza pubblica con turni ricorrenti
- Territori: assegnazione, restituzione con note, link alle mappe e statistiche
- Rapporti del servizio: inserimento personale e cartaceo da parte dell'amministratore, registri dei proclamatori per anno di servizio e riepilogo mensile (S-1) automatico
- Registrazione delle presenze alle adunanze, in sede e online, con medie mensili
- Gestione dei proclamatori: verifica dell'identità, permessi di amministrazione dettagliati per sezione, qualifiche per gli incarichi e note per i contatti di emergenza
- Interfaccia in ceco, francese, giapponese, inglese, italiano, polacco, portoghese, spagnolo, tedesco e turco

COME FUNZIONA LA CONFIGURAZIONE

Un amministratore crea un progetto Firebase gratuito (circa 15 minuti, senza programmare - sono incluse istruzioni complete) e installa le regole di sicurezza dell'app, che stabiliscono esattamente chi può vedere e modificare cosa. Tutti gli altri proclamatori vengono invitati scansionando un codice QR; i nuovi membri restano non verificati finché un amministratore non ne conferma l'identità.

PERCHÉ SELF-HOSTED

I registri di congregazione contengono dati personali - nomi, recapiti, attività di servizio - che meritano una privacy reale. Mantenendo i dati di ogni congregazione dentro un progetto Firebase controllato solo dagli amministratori di quella congregazione, Pianificatore della congregazione evita che un database centrale condiviso diventi il bersaglio di una singola violazione, e ti lascia sempre il controllo dei tuoi dati.

L'app è gratuita, non contiene pubblicità e non raccoglie dati analitici o di tracciamento di alcun tipo.

---

### LOCALE: ja-JP
### TITLE
会衆スケジューラー
### SHORT
エホバの証人の会衆向けスケジュール管理。自分専用のFirebaseで運用します。
### FULL
会衆スケジューラーは、エホバの証人の会衆のためのセルフホスト型のスケジュール管理・運営アプリです。一般的なアプリとは異なり、会衆のデータをどこかの企業のサーバーに送ることはありません。各会衆が自分たちの無料のFirebaseプロジェクトを運用し、アプリはそこへ直接接続します。あなたのデータを見られるのは自分の会衆の管理者だけで、アプリの開発者でさえ見ることはできません。

独立して開発されたアプリです。ものみの塔聖書冊子協会（Watch Tower Bible and Tract Society）およびエホバの証人の公式な団体とは関係がなく、その承認や発行を受けたものでもありません。

主な機能

- 掲示板：テキスト、PDF・画像の文書、リンク（表示期間の設定つき）
- 行事の管理と、自分の今後の割り当てをまとめて見られる個人用の一覧
- 週日の集会のスケジュール。.epub形式のワークブックを直接取り込み、資格を考慮したうえで、割り当てから最も長く時間が経っている人を優先して提案します
- 週末の集会のスケジュール：話、話し手、司会者、ものみの塔の朗読者、および任意の項目
- 公の証しのスケジュール（繰り返しの時間枠に対応）
- 区域：割り当て、メモつきの返却、地図へのリンク、統計
- 野外奉仕報告：本人による入力と管理者による用紙からの入力、奉仕年度ごとの伝道者記録、毎月のS-1集計の自動作成
- 集会の出席記録（会場・オンラインの両方）と月ごとの平均
- 伝道者の管理：本人確認、区分ごとの細かい管理者権限、割り当ての資格、緊急連絡先のメモ
- 対応言語：日本語、英語、イタリア語、スペイン語、チェコ語、ドイツ語、トルコ語、フランス語、ポルトガル語、ポーランド語

設定の流れ

管理者が無料のFirebaseプロジェクトを作成し（所要約15分、プログラミングは不要で、詳しい手順書が付属しています）、アプリのセキュリティルールを導入します。このルールが、誰が何を見て編集できるかを厳密に決めます。ほかの伝道者はQRコードを読み取って招待され、新しいメンバーは管理者が本人であることを確認するまで未承認のままです。

セルフホストである理由

会衆の記録には、氏名、連絡先、奉仕の活動といった個人情報が含まれており、本当の意味での保護が必要です。各会衆のデータを、その会衆の管理者だけが管理するFirebaseプロジェクトの中に置くことで、会衆スケジューラーは共有された中央データベースが一度の情報漏えいの標的になることを避け、あなたが常に自分のデータを管理できるようにします。

このアプリは無料で、広告はなく、分析や追跡のためのデータも一切収集しません。

---

### LOCALE: pl-PL
### TITLE
Harmonogram zboru
### SHORT
Harmonogram dla zborów Świadków Jehowy. Własny projekt Firebase.
### FULL
Harmonogram zboru to samodzielnie hostowana aplikacja do planowania i zarządzania dla zborów Świadków Jehowy. W odróżnieniu od typowych aplikacji nie wysyła danych twojego zboru na serwer żadnej firmy: każdy zbór prowadzi własny bezpłatny projekt Firebase, a aplikacja łączy się z nim bezpośrednio. Nikt poza administratorami twojego zboru - nawet twórca aplikacji - nie widzi waszych danych.

Stworzona niezależnie. Nie jest powiązana z Watch Tower Bible and Tract Society ani z żadnym oficjalnym podmiotem Świadków Jehowy, nie jest przez nie wspierana ani wydawana.

CO POTRAFI

- Tablica ogłoszeń: teksty, dokumenty PDF i obrazy, odnośniki, z okresem wyświetlania
- Wydarzenia oraz osobisty przegląd nadchodzących zadań
- Program zebrania w tygodniu, z bezpośrednim importem podręcznika w formacie .epub i doborem zadań uwzględniającym uprawnienia, który proponuje osobę najdłużej nieprzydzieloną
- Program zebrania weekendowego: wykład, mówca, przewodniczący, lektor Strażnicy i pola własne
- Program świadczenia publicznego z powtarzającymi się przedziałami czasu
- Tereny: przydział, zwrot z notatkami, odnośniki do map i statystyki
- Sprawozdania ze służby: wpis własny i papierowy wpis administratora, kartoteki głosicieli według roku służbowego oraz automatyczne miesięczne zestawienie (S-1)
- Rejestrowanie obecności na zebraniach, na miejscu i online, ze średnimi miesięcznymi
- Zarządzanie głosicielami: weryfikacja tożsamości, szczegółowe uprawnienia administratora w poszczególnych działach, uprawnienia do zadań i notatki z kontaktem alarmowym
- Interfejs w językach: angielskim, czeskim, francuskim, hiszpańskim, japońskim, niemieckim, polskim, portugalskim, tureckim i włoskim

JAK WYGLĄDA KONFIGURACJA

Administrator tworzy bezpłatny projekt Firebase (około 15 minut, bez programowania - pełna instrukcja jest dołączona) i instaluje reguły bezpieczeństwa aplikacji, które dokładnie określają, kto co może zobaczyć i edytować. Pozostali głosiciele są zapraszani przez zeskanowanie kodu QR; nowe osoby pozostają niezweryfikowane, dopóki administrator nie potwierdzi ich tożsamości.

DLACZEGO WŁASNY HOSTING

Kartoteki zborowe zawierają dane osobowe - imiona i nazwiska, dane kontaktowe, działalność w służbie - które zasługują na realną ochronę. Dzięki temu, że dane każdego zboru pozostają w projekcie Firebase kontrolowanym wyłącznie przez administratorów tego zboru, Harmonogram zboru zapobiega sytuacji, w której wspólna centralna baza danych staje się celem jednego wycieku, i przez cały czas pozostawia dane pod twoją kontrolą.

Aplikacja jest bezpłatna, nie zawiera reklam i nie zbiera żadnych danych analitycznych ani śledzących.

---

### LOCALE: pt-BR
### TITLE
Programador da congregação
### SHORT
Programação para congregações das Testemunhas de Jeová. Seu próprio Firebase.
### FULL
Programador da congregação é um aplicativo auto-hospedado de programação e administração para congregações das Testemunhas de Jeová. Ao contrário dos aplicativos comuns, ele não envia os dados da sua congregação para o servidor de nenhuma empresa: cada congregação mantém o seu próprio projeto gratuito do Firebase, e o aplicativo se conecta diretamente a ele. Ninguém além dos administradores da sua congregação - nem mesmo o desenvolvedor do aplicativo - consegue ver os seus dados.

Desenvolvido de forma independente. Não é afiliado, endossado nem produzido pela Watch Tower Bible and Tract Society ou por qualquer entidade oficial das Testemunhas de Jeová.

O QUE ELE FAZ

- Mural de avisos: textos, documentos em PDF e imagens, links, com período de exibição
- Eventos e um resumo pessoal das suas próximas designações
- Programação da reunião do meio de semana, com importação direta da apostila em .epub e uma seleção de designações que considera as qualificações e dá preferência a quem está há mais tempo sem designação
- Programação da reunião do fim de semana: discurso, orador, presidente, leitor de A Sentinela e campos personalizados
- Programação do testemunho público com horários recorrentes
- Territórios: designação, devolução com observações, links de mapas e estatísticas
- Relatórios de serviço de campo: registro próprio e registro em papel pelo administrador, fichas de publicadores por ano de serviço e um resumo mensal (S-1) automático
- Controle de assistência às reuniões, presencial e on-line, com médias mensais
- Administração de publicadores: verificação de identidade, permissões de administrador detalhadas por seção, qualificações para designações e observações de contato de emergência
- Interface em alemão, checo, espanhol, francês, inglês, italiano, japonês, polonês, português e turco

COMO É A CONFIGURAÇÃO

Um administrador cria um projeto gratuito do Firebase (cerca de 15 minutos, sem precisar programar - instruções completas estão incluídas) e instala as regras de segurança do aplicativo, que definem exatamente quem pode ver e editar o quê. Os demais publicadores são convidados pela leitura de um código QR; novos membros ficam sem verificação até que um administrador confirme a identidade deles.

POR QUE AUTO-HOSPEDADO

Os registros de uma congregação incluem dados pessoais - nomes, contatos, atividade no serviço de campo - que merecem privacidade de verdade. Ao manter os dados de cada congregação dentro de um projeto do Firebase controlado somente pelos administradores daquela congregação, o Programador da congregação evita que um banco de dados central compartilhado se torne alvo de um único vazamento, e deixa você no controle dos seus dados o tempo todo.

O aplicativo é gratuito, não contém anúncios e não coleta dados de análise ou rastreamento de nenhum tipo.

---

### LOCALE: tr-TR
### TITLE
Cemaat Planlayıcı
### SHORT
Yehova'nın Şahitleri cemaatleri için planlama. Kendi Firebase projeniz.
### FULL
Cemaat Planlayıcı, Yehova'nın Şahitleri cemaatleri için kendi sunucunuzda barındırılan bir planlama ve yönetim uygulamasıdır. Alışılmış uygulamaların aksine, cemaatinizin verilerini hiçbir şirketin sunucusuna göndermez: her cemaat kendi ücretsiz Firebase projesini çalıştırır ve uygulama doğrudan ona bağlanır. Verilerinizi kendi yöneticileriniz dışında kimse - uygulamanın geliştiricisi bile - göremez.

Bağımsız olarak geliştirilmiştir. Watch Tower Bible and Tract Society ya da Yehova'nın Şahitlerine ait herhangi bir resmi kuruluşla bağlantılı değildir, onlar tarafından desteklenmemekte veya yayımlanmamaktadır.

NELER YAPAR

- İlan panosu: metinler, PDF ve görsel belgeler, bağlantılar, görünürlük süreleriyle birlikte
- Etkinlikler ve yaklaşan görevlerinizi tek yerde gösteren kişisel özet
- Hafta içi ibadeti programı: .epub çalışma kitabını doğrudan içe aktarma ve niteliklere göre çalışan, görevi en uzun süredir almamış kişiyi öne çıkaran görev seçici
- Hafta sonu ibadeti programı: konuşma, konuşmacı, başkan, Gözcü Kulesi okuyucusu ve özel alanlar
- Tekrarlanan zaman dilimleriyle halka açık şahitlik programı
- Sahalar: verme, notlarla birlikte iade, harita bağlantıları ve istatistikler
- Tarla hizmeti raporları: kişinin kendi girişi ve yöneticinin kâğıttan girişi, hizmet yılına göre müjdeci kayıtları ve otomatik aylık (S-1) özeti
- İbadetlere katılımın takibi, yerinde ve çevrimiçi, aylık ortalamalarla
- Müjdeci yönetimi: kimlik doğrulama, bölüm bazında ayrıntılı yönetici yetkileri, görev nitelikleri ve acil durum iletişim notları
- Arayüz dilleri: Almanca, Çekçe, Fransızca, İngilizce, İspanyolca, İtalyanca, Japonca, Lehçe, Portekizce ve Türkçe

KURULUM NASIL İŞLER

Bir yönetici ücretsiz bir Firebase projesi oluşturur (yaklaşık 15 dakika, programlama gerekmez - ayrıntılı yönerge pakete dahildir) ve kimin tam olarak neyi görüp düzenleyebileceğini belirleyen güvenlik kurallarını yükler. Diğer bütün müjdeciler bir QR kodu okutularak davet edilir; yeni üyeler, bir yönetici kimliklerini onaylayana kadar doğrulanmamış olarak kalır.

NEDEN KENDİ SUNUCUNUZDA

Cemaat kayıtları kişisel bilgiler içerir - isimler, iletişim bilgileri, hizmet faaliyeti - ve bunlar gerçek bir gizliliği hak eder. Her cemaatin verilerini yalnızca o cemaatin kendi yöneticilerinin denetlediği bir Firebase projesinin içinde tutarak Cemaat Planlayıcı, paylaşılan merkezi bir veritabanının tek bir sızıntının hedefi hâline gelmesini önler ve verilerinizin denetimini her zaman sizde bırakır.

Uygulama ücretsizdir, reklam içermez ve hiçbir türde analiz veya izleme verisi toplamaz.
