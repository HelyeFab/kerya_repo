import 'package:flutter/widgets.dart';

class UiTranslations extends InheritedWidget {
  final String currentLanguage;

  const UiTranslations({
    super.key,
    required super.child,
    required this.currentLanguage,
  });

  static UiTranslations of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UiTranslations>()!;
  }

  @override
  bool updateShouldNotify(UiTranslations oldWidget) {
    return currentLanguage != oldWidget.currentLanguage;
  }

  String translate(String key) {
    return translations[currentLanguage]?[key] ??
        translations['en']?[key] ??
        key;
  }

  static const Map<String, Map<String, String>> translations = {
    'en': {
      // All existing English translations...

      // Legal Content
      'privacy_policy_content': '''Privacy Policy

Last updated: 2024

1. Information We Collect
We collect information that you provide directly to us, including when you create an account, save words, or interact with our services.

2. How We Use Your Information
We use the information we collect to provide and improve our services, personalize your experience, and communicate with you.

3. Information Sharing
We do not sell or share your personal information with third parties except as described in this policy.

4. Data Security
We implement appropriate security measures to protect your personal information.

5. Your Rights
You have the right to access, correct, or delete your personal information.

6. Changes to This Policy
We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.''',

      'terms_of_service_content': '''Terms of Service

Last updated: 2024

1. Acceptance of Terms
By accessing and using this app, you accept and agree to be bound by these Terms of Service.

2. User Account
You are responsible for maintaining the confidentiality of your account and password.

3. User Content
You retain ownership of any content you create or upload to the service.

4. Prohibited Activities
You agree not to engage in any activities that may interfere with or disrupt the service.

5. Termination
We reserve the right to terminate or suspend your account for violations of these terms.

6. Changes to Terms
We may modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.''',
    },
    'fr': {
      // All existing French translations...

      // Legal Content
      'privacy_policy_content': '''Politique de Confidentialité

Dernière mise à jour : 2024

1. Informations que nous collectons
Nous collectons les informations que vous nous fournissez directement, notamment lors de la création d'un compte, de la sauvegarde de mots ou de l'interaction avec nos services.

2. Utilisation de vos informations
Nous utilisons les informations collectées pour fournir et améliorer nos services, personnaliser votre expérience et communiquer avec vous.

3. Partage d'informations
Nous ne vendons ni ne partageons vos informations personnelles avec des tiers, sauf comme décrit dans cette politique.

4. Sécurité des données
Nous mettons en œuvre des mesures de sécurité appropriées pour protéger vos informations personnelles.

5. Vos droits
Vous avez le droit d'accéder à vos informations personnelles, de les corriger ou de les supprimer.

6. Modifications de cette politique
Nous pouvons mettre à jour cette politique de confidentialité de temps à autre. Nous vous informerons de tout changement en publiant la nouvelle politique sur cette page.''',

      'terms_of_service_content': '''Conditions d'utilisation

Dernière mise à jour : 2024

1. Acceptation des conditions
En accédant et en utilisant cette application, vous acceptez d'être lié par ces conditions d'utilisation.

2. Compte utilisateur
Vous êtes responsable de la confidentialité de votre compte et de votre mot de passe.

3. Contenu utilisateur
Vous conservez la propriété de tout contenu que vous créez ou téléchargez sur le service.

4. Activités interdites
Vous acceptez de ne pas vous engager dans des activités qui pourraient interférer avec ou perturber le service.

5. Résiliation
Nous nous réservons le droit de résilier ou de suspendre votre compte en cas de violation de ces conditions.

6. Modifications des conditions
Nous pouvons modifier ces conditions à tout moment. L'utilisation continue du service constitue l'acceptation des conditions modifiées.''',
    },
    'es': {
      // All existing Spanish translations...

      // Legal Content
      'privacy_policy_content': '''Política de Privacidad

Última actualización: 2024

1. Información que recopilamos
Recopilamos la información que nos proporciona directamente, incluso cuando crea una cuenta, guarda palabras o interactúa con nuestros servicios.

2. Cómo usamos su información
Usamos la información que recopilamos para proporcionar y mejorar nuestros servicios, personalizar su experiencia y comunicarnos con usted.

3. Compartir información
No vendemos ni compartimos su información personal con terceros, excepto como se describe en esta política.

4. Seguridad de datos
Implementamos medidas de seguridad apropiadas para proteger su información personal.

5. Sus derechos
Tiene derecho a acceder, corregir o eliminar su información personal.

6. Cambios a esta política
Podemos actualizar esta política de privacidad de vez en cuando. Le notificaremos cualquier cambio publicando la nueva política en esta página.''',

      'terms_of_service_content': '''Términos de Servicio

Última actualización: 2024

1. Aceptación de términos
Al acceder y usar esta aplicación, acepta y está de acuerdo en estar sujeto a estos Términos de Servicio.

2. Cuenta de usuario
Usted es responsable de mantener la confidencialidad de su cuenta y contraseña.

3. Contenido del usuario
Usted mantiene la propiedad de cualquier contenido que cree o cargue en el servicio.

4. Actividades prohibidas
Acepta no participar en actividades que puedan interferir o interrumpir el servicio.

5. Terminación
Nos reservamos el derecho de terminar o suspender su cuenta por violaciones de estos términos.

6. Cambios en los términos
Podemos modificar estos términos en cualquier momento. El uso continuado del servicio constituye la aceptación de los términos modificados.''',
    },
    'it': {
      // All existing Italian translations...

      // Legal Content
      'privacy_policy_content': '''Informativa sulla Privacy

Ultimo aggiornamento: 2024

1. Informazioni che raccogliamo
Raccogliamo le informazioni che ci fornisci direttamente, incluso quando crei un account, salvi parole o interagisci con i nostri servizi.

2. Come utilizziamo le tue informazioni
Utilizziamo le informazioni raccolte per fornire e migliorare i nostri servizi, personalizzare la tua esperienza e comunicare con te.

3. Condivisione delle informazioni
Non vendiamo né condividiamo le tue informazioni personali con terze parti, eccetto come descritto in questa informativa.

4. Sicurezza dei dati
Implementiamo misure di sicurezza appropriate per proteggere le tue informazioni personali.

5. I tuoi diritti
Hai il diritto di accedere, correggere o eliminare le tue informazioni personali.

6. Modifiche a questa informativa
Potremmo aggiornare questa informativa sulla privacy di tanto in tanto. Ti informeremo di eventuali modifiche pubblicando la nuova informativa su questa pagina.''',

      'terms_of_service_content': '''Termini di Servizio

Ultimo aggiornamento: 2024

1. Accettazione dei termini
Accedendo e utilizzando questa applicazione, accetti di essere vincolato da questi Termini di Servizio.

2. Account utente
Sei responsabile del mantenimento della riservatezza del tuo account e della password.

3. Contenuti dell'utente
Mantieni la proprietà di qualsiasi contenuto che crei o carichi sul servizio.

4. Attività proibite
Accetti di non impegnarti in attività che potrebbero interferire o interrompere il servizio.

5. Terminazione
Ci riserviamo il diritto di terminare o sospendere il tuo account per violazioni di questi termini.

6. Modifiche ai termini
Potremmo modificare questi termini in qualsiasi momento. L'uso continuato del servizio costituisce l'accettazione dei termini modificati.''',
    },
    'de': {
      // All existing German translations...

      // Legal Content
      'privacy_policy_content': '''Datenschutzerklärung

Zuletzt aktualisiert: 2024

1. Informationen, die wir sammeln
Wir sammeln Informationen, die Sie uns direkt zur Verfügung stellen, einschließlich wenn Sie ein Konto erstellen, Wörter speichern oder mit unseren Diensten interagieren.

2. Wie wir Ihre Informationen verwenden
Wir verwenden die gesammelten Informationen, um unsere Dienste bereitzustellen und zu verbessern, Ihre Erfahrung zu personalisieren und mit Ihnen zu kommunizieren.

3. Informationsaustausch
Wir verkaufen oder teilen Ihre persönlichen Informationen nicht mit Dritten, außer wie in dieser Richtlinie beschrieben.

4. Datensicherheit
Wir implementieren angemessene Sicherheitsmaßnahmen zum Schutz Ihrer persönlichen Informationen.

5. Ihre Rechte
Sie haben das Recht, auf Ihre persönlichen Informationen zuzugreifen, sie zu korrigieren oder zu löschen.

6. Änderungen dieser Richtlinie
Wir können diese Datenschutzerklärung von Zeit zu Zeit aktualisieren. Wir werden Sie über Änderungen informieren, indem wir die neue Richtlinie auf dieser Seite veröffentlichen.''',

      'terms_of_service_content': '''Nutzungsbedingungen

Zuletzt aktualisiert: 2024

1. Annahme der Bedingungen
Durch den Zugriff auf und die Nutzung dieser App akzeptieren Sie diese Nutzungsbedingungen.

2. Benutzerkonto
Sie sind für die Vertraulichkeit Ihres Kontos und Passworts verantwortlich.

3. Benutzerinhalte
Sie behalten das Eigentum an allen Inhalten, die Sie erstellen oder in den Dienst hochladen.

4. Verbotene Aktivitäten
Sie stimmen zu, keine Aktivitäten durchzuführen, die den Dienst stören oder beeinträchtigen könnten.

5. Kündigung
Wir behalten uns das Recht vor, Ihr Konto bei Verstößen gegen diese Bedingungen zu kündigen oder zu sperren.

6. Änderungen der Bedingungen
Wir können diese Bedingungen jederzeit ändern. Die weitere Nutzung des Dienstes stellt die Annahme der geänderten Bedingungen dar.''',
    },
    'ja': {
      // All existing Japanese translations...

      // Legal Content
      'privacy_policy_content': '''プライバシーポリシー

最終更新日：2024年

1. 収集する情報
アカウントの作成、単語の保存、またはサービスとの対話時に、お客様が直接提供する情報を収集します。

2. 情報の使用方法
収集した情報は、サービスの提供と改善、体験のパーソナライズ、およびお客様とのコミュニケーションに使用します。

3. 情報の共有
このポリシーに記載されている場合を除き、個人情報を第三者に販売または共有することはありません。

4. データセキュリティ
個人情報を保護するための適切なセキュリティ対策を実施しています。

5. お客様の権利
お客様は個人情報へのアクセス、訂正、削除の権利を有しています。

6. このポリシーの変更
このプライバシーポリシーは随時更新される場合があります。変更がある場合は、このページに新しいポリシーを掲載してお知らせします。''',

      'terms_of_service_content': '''利用規約

最終更新日：2024年

1. 規約の承諾
このアプリにアクセスし使用することにより、これらの利用規約に同意したものとみなされます。

2. ユーザーアカウント
アカウントとパスワードの機密性を維持する責任はお客様にあります。

3. ユーザーコンテンツ
サービスに作成またはアップロードしたコンテンツの所有権はお客様に帰属します。

4. 禁止事項
サービスを妨害または中断する可能性のある活動に従事しないことに同意するものとします。

5. 利用停止
利用規約違反があった場合、アカウントを終了または停止する権利を留保します。

6. 規約の変更
利用規約は随時変更される場合があります。サービスの継続的な使用は、変更された規約の承諾を意味します。''',
    },
  };
}
