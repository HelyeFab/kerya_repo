import 'package:flutter/widgets.dart';

class UiTranslations {
  static UiTranslations of(BuildContext context) {
    return UiTranslations();
  }

  static const Map<String, Map<String, String>> translations = {
    'en': {
      // Legal Documents
      'privacy_policy_content': '''Last updated: December 19, 2024

Welcome to Keyra's Privacy Policy. This document outlines how we collect, use, and protect your personal information.

1. Information We Collect

We collect information that you provide directly to us, including:
• Account information (email, name)
• Learning preferences
• Study progress and statistics
• Saved words and flashcards

2. How We Use Your Information

We use the collected information to:
• Personalize your learning experience
• Track your progress
• Improve our services
• Provide customer support

3. Data Security

We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

4. Data Sharing

We do not sell your personal information to third parties. We may share your information only in the following circumstances:
• With your consent
• To comply with legal obligations
• To protect our rights and safety

5. Your Rights

You have the right to:
• Access your personal information
• Correct inaccurate data
• Request deletion of your data
• Opt-out of certain data collection

6. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

7. Contact Us

If you have any questions about this Privacy Policy, please contact us at:
support@keyra.app

8. Children's Privacy

Our service is not intended for children under 13. We do not knowingly collect personal information from children under 13.''',

      'terms_of_service_content': '''Last updated: December 19, 2024

Welcome to Keyra! These Terms of Service ("Terms") govern your use of our application and services.

1. Acceptance of Terms

By accessing or using Keyra, you agree to be bound by these Terms. If you do not agree to these Terms, do not use our services.

2. Changes to Terms

We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the new Terms on this page.

3. User Accounts

• You are responsible for maintaining the confidentiality of your account
• You must provide accurate and complete information
• You are responsible for all activities under your account
• You must notify us immediately of any unauthorized use

4. Intellectual Property Rights

• All content in Keyra is owned by us or our licensors
• You may not copy, modify, or distribute our content without permission
• Your user-generated content remains your property

5. Acceptable Use

You agree not to:
• Violate any laws or regulations
• Impersonate others
• Share inappropriate content
• Attempt to access restricted areas
• Interfere with the service's operation

6. Premium Features

• Some features may require payment
• Subscriptions auto-renew unless cancelled
• Refunds are subject to our refund policy
• Prices may change with notice

7. Termination

We may terminate or suspend your account if you violate these Terms.

8. Disclaimer of Warranties

The service is provided "as is" without warranties of any kind.

9. Limitation of Liability

We are not liable for any indirect, incidental, or consequential damages.''',

      // Profile Screen
      'profile': 'Profile',
      'view saved definitions': 'View your saved word definitions',
      'saved words subtitle': 'View your saved word definitions',
      'settings': 'Settings',
      'dark mode': 'Dark Mode',
      'notifications': 'Notifications',
      'app language': 'App Language',
      'select language': 'Select Language',
      'about': 'About',
      'version': 'Version',
      'acknowledgments': 'Acknowledgments',
      'special_thanks': 'Special Thanks',
      'icons_section': 'Icons',
      'icons_description': 'HugeIcons - Beautiful and consistent icon set',
      'animations_section': 'Animations',
      'animations_description': 'Lottie Animation - "Free fox greetings Animation" by Solitudinem',
      'fonts_section': 'Fonts',
      'fonts_description': 'FascinateInline - Unique and stylish font for our branding',
      'libraries_section': 'Open Source Libraries',
      'libraries_description': 'Flutter and Dart communities for their amazing work',
      'contributors_section': 'Contributors',
      'contributors_description': 'All the developers who have contributed to this project',
      'privacy policy': 'Privacy Policy',
      'terms of service': 'Terms of Service',
      'developer': 'Developer',
      'contact us': 'Contact Us',
      'information': 'Information',
      'versione': 'Version',
      'ringraziamenti': 'Acknowledgments',

      // Dashboard Screen
      'track reading progress': 'Track Reading Progress',
      'books read': 'Books Read',
      'favorite books': 'Favorite Books',
      'reading streak': 'Reading Streak',
      'saved words': 'Saved Words',
      'study progress': 'Study Progress',
      'new': 'New',
      'learning': 'Learning',
      'learned': 'Learned',
      'total words': 'Total Words',
      'no_saved_words_message': 'You haven\'t saved any words yet. Add some words to your library to start studying!',
      'no_saved_words_language_message': 'You haven\'t saved any words for this language yet. Add some words to start studying!',
      'dashboard_study_words': 'Study Words',
      'dashboard_select_language_to_study': 'Select a language to study:',

      // Library Screen
      'search books': 'Search your books...',
      'all': 'All',
      'favorites': 'Favorites',
      'recents': 'Recents',

      // Home Screen
      'recently added': 'Recently Added Stories',
      'continue reading': 'Continue Reading',
      'page of': 'Page 1 of 3',
      'home': 'Home',
      'library': 'Library',
      'create': 'Create',
      'dashboard': 'Dashboard',
      'home_recently_added_stories': 'Recently Added Stories',
      'home_continue_reading': 'Continue Reading',
      'home_page_progress': 'Page {0} of {1}',
      'nav_home': 'Home',
      'nav_library': 'Library',
      'nav_create': 'Create',
      'nav_dashboard': 'Dashboard',
      'ok': 'OK',
      // Language names
      'language_english': 'English',
      'language_french': 'French',
      'language_spanish': 'Spanish',
      'language_german': 'German',
      'language_italian': 'Italian',
      'language_japanese': 'Japanese',
      'no_words_for_language': 'No words to study for {language}',
      // Badge System
      'achievements': 'Achievements',
      'badge_reading_title': 'Your Reading Badge',
      'badge_reading_subtitle': 'Keep reading to earn new badges!',
      'badge_earned': 'Badge Earned!',
      'badge_beginner': 'Beginner',
      'badge_intermediate': 'Intermediate',
      'badge_advanced': 'Advanced',
      'badge_master': 'Master',
      'badge_explorer': 'Explorer',
      'badge_voyager': 'Voyager',
      'badge_weaver': 'Weaver',
      'badge_navigator': 'Navigator',
      'badge_pioneer': 'Pioneer',
      'badge_royalty': 'Royalty',
      'badge_baron': 'Baron',
      'badge_legend': 'Legend',
      'badge_wizard': 'Wizard',
      'badge_epic': 'Epic',
      'badge_titan': 'Titan',
      'badge_sovereign': 'Sovereign',
      'badge_virtuoso': 'Virtuoso',
      'badge_luminary': 'Luminary',
      'badge_beacon': 'Beacon',
      'badge_radiant': 'Radiant',
      'badge_lighthouse': 'Lighthouse',
      'badge_infinite': 'Infinite',
      'badge_renaissance': 'Renaissance',
      'badge_ultimate': 'Ultimate',
      'requirements': 'Requirements',
      'books read requirement': '{0} books read',
      'favorite books requirement': '{0} favorite books',
      'reading streak requirement': '{0} day streak',
      'badge_description': 'You have earned a new badge for reading {amount} words!',
      'badge_unlocked': 'Badge Unlocked!',
      'badge_unlocked_description': 'You have unlocked a new badge for reading {amount} words!',
      'common_close': 'Close',
      'common_all_languages': 'All Languages',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'badge_level_up_message': 'Congratulations! You\'ve reached a new level!',
      'badge_progress_title': 'Badge Progress',
      'badge_progress_subtitle': 'Keep reading to unlock more badges!',
      // Flashcard Screen
      'flashcard_study_session': 'Study Session',
      'tap_to_see_definition': 'Tap to see definition',
      'tap_to_see_word': 'Tap to see word',
      'definition': 'Definition',
      'examples': 'Examples',
      'flashcard_difficulty_hard': 'Hard',
      'flashcard_difficulty_good': 'Good',
      'flashcard_difficulty_easy': 'Easy',
      // Study Words Page
      'delete_word_title': 'Delete Word?',
      'delete_word_confirm': 'Are you sure you want to delete "{0}" from your saved words?',
      'error_deleting_word': 'Error deleting word: {0}',
      'common_definition': 'Definition',
      'common_examples': 'Examples',
      'common_show_all_languages': 'Show all languages',
      'common_error': 'Error: {0}',
      'common_cancel': 'Cancel',
      'common_delete': 'Delete',
    },
    'fr': {
      // Legal Documents
      'privacy_policy_content': '''Dernière mise à jour : 19 décembre 2024

Bienvenue dans la Politique de confidentialité de Keyra. Ce document décrit comment nous collectons, utilisons et protégeons vos informations personnelles.

1. Informations que nous collectons

Nous collectons les informations que vous nous fournissez directement, notamment :
• Informations de compte (email, nom)
• Préférences d'apprentissage
• Progrès et statistiques d'étude
• Mots sauvegardés et cartes mémoire

2. Comment nous utilisons vos informations

Nous utilisons les informations collectées pour :
• Personnaliser votre expérience d'apprentissage
• Suivre vos progrès
• Améliorer nos services
• Fournir un support client

3. Sécurité des données

Nous mettons en œuvre des mesures de sécurité appropriées pour protéger vos informations personnelles contre l'accès non autorisé, la modification, la divulgation ou la destruction.

4. Partage des données

Nous ne vendons pas vos informations personnelles à des tiers. Nous pouvons partager vos informations uniquement dans les circonstances suivantes :
• Avec votre consentement
• Pour respecter les obligations légales
• Pour protéger nos droits et notre sécurité

5. Vos droits

Vous avez le droit de :
• Accéder à vos informations personnelles
• Corriger les données inexactes
• Demander la suppression de vos données
• Refuser certaines collectes de données

6. Modifications de cette politique

Nous pouvons mettre à jour cette Politique de confidentialité de temps en temps. Nous vous informerons de tout changement en publiant la nouvelle Politique de confidentialité sur cette page.

7. Nous contacter

Si vous avez des questions sur cette Politique de confidentialité, veuillez nous contacter à :
support@keyra.app

8. Confidentialité des enfants

Notre service n'est pas destiné aux enfants de moins de 13 ans. Nous ne collectons pas sciemment d'informations personnelles d'enfants de moins de 13 ans.''',

      'terms_of_service_content': '''Dernière mise à jour : 19 décembre 2024

Bienvenue sur Keyra ! Ces Conditions d'utilisation ("Conditions") régissent votre utilisation de notre application et de nos services.

1. Acceptation des conditions

En accédant ou en utilisant Keyra, vous acceptez d'être lié par ces Conditions. Si vous n'acceptez pas ces Conditions, n'utilisez pas nos services.

2. Modifications des conditions

Nous nous réservons le droit de modifier ces Conditions à tout moment. Nous vous informerons de tout changement en publiant les nouvelles Conditions sur cette page.

3. Comptes utilisateurs

• Vous êtes responsable de la confidentialité de votre compte
• Vous devez fournir des informations exactes et complètes
• Vous êtes responsable de toutes les activités sous votre compte
• Vous devez nous informer immédiatement de toute utilisation non autorisée

4. Droits de propriété intellectuelle

• Tout le contenu de Keyra appartient à nous ou à nos concédants
• Vous ne pouvez pas copier, modifier ou distribuer notre contenu sans permission
• Votre contenu généré par l'utilisateur reste votre propriété

5. Utilisation acceptable

Vous acceptez de ne pas :
• Violer les lois ou règlements
• Impersonner d'autres personnes
• Partager du contenu inapproprié
• Tenter d'accéder à des zones restreintes
• Interférer avec le fonctionnement du service

6. Fonctionnalités premium

• Certaines fonctionnalités peuvent nécessiter un paiement
• Les abonnements se renouvellent automatiquement sauf annulation
• Les remboursements sont soumis à notre politique de remboursement
• Les prix peuvent changer avec préavis

7. Résiliation

Nous pouvons résilier ou suspendre votre compte si vous violez ces Conditions.

8. Exclusion de garanties

Le service est fourni "tel quel" sans garanties d'aucune sorte.

9. Limitation de responsabilité

Nous ne sommes pas responsables des dommages indirects, accessoires ou consécutifs.''',

      // Profile Screen
      'profile': 'Profil',
      'view saved definitions': 'Voir vos définitions de mots enregistrées',
      'saved words subtitle': 'Voir vos définitions de mots enregistrées',
      'settings': 'Paramètres',
      'dark mode': 'Mode sombre',
      'notifications': 'Notifications',
      'app language': 'Langue de l\'application',
      'select language': 'Sélectionner la langue',
      'about': 'À propos',
      'version': 'Version',
      'acknowledgments': 'Remerciements',
      'special_thanks': 'Remerciements spéciaux',
      'icons_section': 'Icônes',
      'icons_description': 'HugeIcons - Ensemble d\'icônes beau et cohérent',
      'animations_section': 'Animations',
      'animations_description': 'Animation Lottie - "Animation gratuite de salutations de renard" par Solitudinem',
      'fonts_section': 'Polices',
      'fonts_description': 'FascinateInline - Police unique et élégante pour notre image de marque',
      'libraries_section': 'Bibliothèques Open Source',
      'libraries_description': 'Communautés Flutter et Dart pour leur travail remarquable',
      'contributors_section': 'Contributeurs',
      'contributors_description': 'Tous les développeurs qui ont contribué à ce projet',
      'privacy policy': 'Politique de confidentialité',
      'terms of service': 'Conditions d\'utilisation',
      'developer': 'Développeur',
      'contact us': 'Contactez-nous',
      'information': 'Informations',
      'versione': 'Version',
      'ringraziamenti': 'Remerciements',

      // Dashboard Screen
      'track reading progress': 'Suivi de la lecture',
      'books read': 'Livres lus',
      'favorite books': 'Livres favoris',
      'reading streak': 'Série de lecture',
      'saved words': 'Mots enregistrés',
      'study progress': 'Progrès d\'étude',
      'new': 'Nouveau',
      'learning': 'En apprentissage',
      'learned': 'Appris',
      'total words': 'Total des mots',
      'no_saved_words_message': 'Vous n\'avez pas encore enregistré de mots. Ajoutez des mots à votre bibliothèque pour commencer à étudier !',
      'no_saved_words_language_message': 'Vous n\'avez pas encore enregistré de mots pour cette langue. Ajoutez des mots pour commencer à étudier !',
      'dashboard_study_words': 'Étudier les mots',
      'dashboard_select_language_to_study': 'Sélectionnez une langue à étudier :',

      // Library Screen
      'search books': 'Recherchez vos livres...',
      'all': 'Tous',
      'favorites': 'Favoris',
      'recents': 'Récents',

      // Home Screen
      'recently added': 'Histoires récemment ajoutées',
      'continue reading': 'Continuer la lecture',
      'page of': 'Page 1 sur 3',
      'home': 'Accueil',
      'library': 'Bibliothèque',
      'create': 'Créer',
      'dashboard': 'Tableau de bord',
      'home_recently_added_stories': 'Histoires récemment ajoutées',
      'home_continue_reading': 'Continuer la lecture',
      'home_page_progress': 'Page {0} sur {1}',
      'nav_home': 'Accueil',
      'nav_library': 'Bibliothèque',
      'nav_create': 'Créer',
      'nav_dashboard': 'T. de Bord',
      'ok': 'OK',
      // Language names
      'language_english': 'Anglais',
      'language_french': 'Français',
      'language_spanish': 'Espagnol',
      'language_german': 'Allemand',
      'language_italian': 'Italien',
      'language_japanese': 'Japonais',
      'no_words_for_language': 'Aucun mot à étudier pour {language}',
      // Badge System
      'achievements': 'Réalisations',
      'badge_progress_title': 'Votre badge de lecture',
      'badge_progress_subtitle': 'Continuez à lire pour gagner de nouveaux badges !',
      'badge_earned': 'Badge gagné !',
      'badge_beginner': 'Débutant',
      'badge_intermediate': 'Intermédiaire',
      'badge_advanced': 'Avancé',
      'badge_master': 'Maître',
      'badge_explorer': 'Explorateur',
      'badge_voyager': 'Voyageur',
      'badge_weaver': 'Tisseur',
      'badge_navigator': 'Navigateur',
      'badge_pioneer': 'Pionnier',
      'badge_royalty': 'Royauté',
      'badge_baron': 'Baron',
      'badge_legend': 'Légende',
      'badge_wizard': 'Sorcier',
      'badge_epic': 'Épique',
      'badge_titan': 'Titan',
      'badge_sovereign': 'Souverain',
      'badge_virtuoso': 'Virtuose',
      'badge_luminary': 'Luminaire',
      'badge_beacon': 'Phare',
      'badge_radiant': 'Radiant',
      'badge_lighthouse': 'Phare',
      'badge_infinite': 'Infini',
      'badge_renaissance': 'Renaissance',
      'badge_ultimate': 'Ultime',
      'requirements': 'Prérequis',
      'books read requirement': '{0} livres lus',
      'favorite books requirement': '{0} livres favoris',
      'reading streak requirement': '{0} jours de lecture consécutifs',
      'badge_description': 'Vous avez gagné un nouveau badge pour avoir lu {amount} mots !',
      'badge_unlocked': 'Badge débloqué !',
      'badge_unlocked_description': 'Vous avez débloqué un nouveau badge pour avoir lu {amount} mots !',
      'common_close': 'Fermer',
      'common_all_languages': 'Toutes les langues',
      'logout': 'Déconnexion',
      'logout_confirm': 'Êtes-vous sûr de vouloir vous déconnecter ?',
      'cancel': 'Annuler',
      // Flashcard Screen
      'flashcard_study_session': 'Session d\'étude',
      'tap_to_see_definition': 'Touchez pour voir la définition',
      'tap_to_see_word': 'Touchez pour voir le mot',
      'definition': 'Définition',
      'examples': 'Exemples',
      'flashcard_difficulty_hard': 'Difficile',
      'flashcard_difficulty_good': 'Bien',
      'flashcard_difficulty_easy': 'Facile',
      // Study Words Page
      'delete_word_title': 'Supprimer le mot ?',
      'delete_word_confirm': 'Êtes-vous sûr de vouloir supprimer "{0}" de vos mots enregistrés ?',
      'error_deleting_word': 'Erreur lors de la suppression du mot : {0}',
      'common_definition': 'Définition',
      'common_examples': 'Exemples',
      'common_show_all_languages': 'Afficher toutes les langues',
      'common_error': 'Erreur : {0}',
      'common_cancel': 'Annuler',
      'common_delete': 'Supprimer',
    },
    'es': {
      // Legal Documents
      'privacy_policy_content': '''Última actualización: 19 de diciembre de 2024

Bienvenido a la Política de Privacidad de Keyra. Este documento describe cómo recopilamos, usamos y protegemos su información personal.

1. Información que recopilamos

Recopilamos la información que nos proporciona directamente, incluyendo:
• Información de cuenta (correo electrónico, nombre)
• Preferencias de aprendizaje
• Progreso y estadísticas de estudio
• Palabras guardadas y tarjetas de memoria

2. Cómo usamos su información

Utilizamos la información recopilada para:
• Personalizar su experiencia de aprendizaje
• Realizar un seguimiento de su progreso
• Mejorar nuestros servicios
• Proporcionar atención al cliente

3. Seguridad de datos

Implementamos medidas de seguridad apropiadas para proteger su información personal contra acceso no autorizado, alteración, divulgación o destrucción.

4. Compartir datos

No vendemos su información personal a terceros. Podemos compartir su información solo en las siguientes circunstancias:
• Con su consentimiento
• Para cumplir con obligaciones legales
• Para proteger nuestros derechos y seguridad

5. Sus derechos

Tiene derecho a:
• Acceder a su información personal
• Corregir datos inexactos
• Solicitar la eliminación de sus datos
• Optar por no participar en ciertas recopilaciones de datos

6. Cambios en esta política

Podemos actualizar esta Política de Privacidad de vez en cuando. Le notificaremos cualquier cambio publicando la nueva Política de Privacidad en esta página.

7. Contáctenos

Si tiene preguntas sobre esta Política de Privacidad, contáctenos en:
support@keyra.app

8. Privacidad de los niños

Nuestro servicio no está destinado a niños menores de 13 años. No recopilamos conscientemente información personal de niños menores de 13 años.''',

      'terms_of_service_content': '''Última actualización: 19 de diciembre de 2024

¡Bienvenido a Keyra! Estos Términos de Servicio ("Términos") rigen su uso de nuestra aplicación y servicios.

1. Aceptación de los términos

Al acceder o usar Keyra, acepta estar sujeto a estos Términos. Si no está de acuerdo con estos Términos, no use nuestros servicios.

2. Cambios en los términos

Nos reservamos el derecho de modificar estos Términos en cualquier momento. Le notificaremos cualquier cambio publicando los nuevos Términos en esta página.

3. Cuentas de usuario

• Usted es responsable de mantener la confidencialidad de su cuenta
• Debe proporcionar información precisa y completa
• Es responsable de todas las actividades bajo su cuenta
• Debe notificarnos inmediatamente de cualquier uso no autorizado

4. Derechos de propiedad intelectual

• Todo el contenido en Keyra es propiedad nuestra o de nuestros licenciantes
• No puede copiar, modificar o distribuir nuestro contenido sin permiso
• Su contenido generado por el usuario sigue siendo su propiedad

5. Uso aceptable

Acepta no:
• Violar leyes o regulaciones
• Suplantar a otros
• Compartir contenido inapropiado
• Intentar acceder a áreas restringidas
• Interferir con la operación del servicio

6. Funciones premium

• Algunas funciones pueden requerir pago
• Las suscripciones se renuevan automáticamente a menos que se cancelen
• Los reembolsos están sujetos a nuestra política de reembolso
• Los precios pueden cambiar con previo aviso

7. Terminación

Podemos terminar o suspender su cuenta si viola estos Términos.

8. Descargo de garantías

El servicio se proporciona "tal cual" sin garantías de ningún tipo.

9. Limitación de responsabilidad

No somos responsables de daños indirectos, incidentales o consecuentes.''',

      // Profile Screen
      'profile': 'Perfil',
      'view saved definitions': 'Ver tus definiciones de palabras guardadas',
      'saved words subtitle': 'Ver tus definiciones de palabras guardadas',
      'settings': 'Configuración',
      'dark mode': 'Modo oscuro',
      'notifications': 'Notificaciones',
      'app language': 'Idioma de la aplicación',
      'select language': 'Seleccionar idioma',
      'about': 'Acerca de',
      'version': 'Versión',
      'acknowledgments': 'Agradecimientos',
      'special_thanks': 'Agradecimientos especiales',
      'icons_section': 'Iconos',
      'icons_description': 'HugeIcons - Conjunto de iconos hermoso y consistente',
      'animations_section': 'Animaciones',
      'animations_description': 'Animación Lottie - "Animación gratuita de saludos de zorro" por Solitudinem',
      'fonts_section': 'Fuentes',
      'fonts_description': 'FascinateInline - Fuente única y elegante para nuestra marca',
      'libraries_section': 'Bibliotecas de código abierto',
      'libraries_description': 'Comunidades Flutter y Dart por su increíble trabajo',
      'contributors_section': 'Colaboradores',
      'contributors_description': 'Todos los desarrolladores que han contribuido a este proyecto',
      'privacy policy': 'Política de privacidad',
      'terms of service': 'Términos de servicio',
      'developer': 'Desarrollador',
      'contact us': 'Contáctenos',
      'information': 'Información',
      'versione': 'Versión',
      'ringraziamenti': 'Agradecimientos',

      // Dashboard Screen
      'track reading progress': 'Seguimiento de lectura',
      'books read': 'Libros leídos',
      'favorite books': 'Libros favoritos',
      'reading streak': 'Racha de lectura',
      'saved words': 'Palabras guardadas',
      'study progress': 'Progreso de estudio',
      'new': 'Nuevas',
      'learning': 'Aprendiendo',
      'learned': 'Aprendidas',
      'total words': 'Total de palabras',
      'no_saved_words_message': 'Aún no has guardado ninguna palabra. ¡Agrega algunas palabras a tu biblioteca para empezar a estudiar!',
      'no_saved_words_language_message': 'Aún no has guardado palabras para este idioma. ¡Agrega algunas palabras para empezar a estudiar!',
      'dashboard_study_words': 'Estudiar palabras',
      'dashboard_select_language_to_study': 'Selecciona un idioma para estudiar:',

      // Library Screen
      'search books': 'Busca tus libros...',
      'all': 'Todos',
      'favorites': 'Favoritos',
      'recents': 'Recientes',

      // Home Screen
      'recently added': 'Historias añadidas recientemente',
      'continue reading': 'Continuar leyendo',
      'page of': 'Página 1 de 3',
      'home': 'Inicio',
      'library': 'Biblioteca',
      'create': 'Crear',
      'dashboard': 'Panel de control',
      'home_recently_added_stories': 'Historias añadidas recientemente',
      'home_continue_reading': 'Continuar leyendo',
      'home_page_progress': 'Página {0} de {1}',
      'nav_home': 'Inicio',
      'nav_library': 'Biblioteca',
      'nav_create': 'Crear',
      'nav_dashboard': 'Panel',
      'ok': 'Aceptar',
      // Language names
      'language_english': 'Inglés',
      'language_french': 'Francés',
      'language_spanish': 'Español',
      'language_german': 'Alemán',
      'language_italian': 'Italiano',
      'language_japanese': 'Japonés',
      'no_words_for_language': 'No hay palabras para estudiar en {language}',
      // Badge System
      'achievements': 'Logros',
      'badge_progress_title': 'Tu insignia de lectura',
      'badge_progress_subtitle': 'Sigue leyendo para ganar nuevas insignias!',
      'badge_earned': 'Insignia ganada!',
      'badge_beginner': 'Principiante',
      'badge_intermediate': 'Intermedio',
      'badge_advanced': 'Avanzado',
      'badge_master': 'Maestro',
      'badge_explorer': 'Explorador',
      'badge_voyager': 'Viajero',
      'badge_weaver': 'Tejedor',
      'badge_navigator': 'Navegante',
      'badge_pioneer': 'Pionero',
      'badge_royalty': 'Realeza',
      'badge_baron': 'Barón',
      'badge_legend': 'Leyenda',
      'badge_wizard': 'Mago',
      'badge_epic': 'Épico',
      'badge_titan': 'Titán',
      'badge_sovereign': 'Soberano',
      'badge_virtuoso': 'Virtuoso',
      'badge_luminary': 'Luminario',
      'badge_beacon': 'Faro',
      'badge_radiant': 'Radiante',
      'badge_lighthouse': 'Faro',
      'badge_infinite': 'Infinito',
      'badge_renaissance': 'Renacimiento',
      'badge_ultimate': 'Definitivo',
      'requirements': 'Requisitos',
      'books read requirement': '{0} libros leídos',
      'favorite books requirement': '{0} libros favoritos',
      'reading streak requirement': '{0} días consecutivos',
      'badge_description': 'Has ganado una nueva insignia por leer {amount} palabras!',
      'badge_unlocked': 'Insignia desbloqueada!',
      'badge_unlocked_description': 'Has desbloqueado una nueva insignia por leer {amount} palabras!',
      'common_close': 'Cerrar',
      'common_all_languages': 'Todos los idiomas',
      'logout': 'Cerrar sesión',
      'logout_confirm': '¿Estás seguro de que quieres cerrar sesión?',
      'cancel': 'Cancelar',
      // Flashcard Screen
      'flashcard_study_session': 'Sesión de estudio',
      'tap_to_see_definition': 'Toca para ver la definición',
      'tap_to_see_word': 'Toca para ver la palabra',
      'definition': 'Definición',
      'examples': 'Ejemplos',
      'flashcard_difficulty_hard': 'Difícil',
      'flashcard_difficulty_good': 'Bien',
      'flashcard_difficulty_easy': 'Fácil',
      // Study Words Page
      'delete_word_title': '¿Eliminar palabra?',
      'delete_word_confirm': '¿Estás seguro de que quieres eliminar "{0}" de tus palabras guardadas?',
      'error_deleting_word': 'Error al eliminar la palabra: {0}',
      'common_definition': 'Definición',
      'common_examples': 'Ejemplos',
      'common_show_all_languages': 'Mostrar todos los idiomas',
      'common_error': 'Error: {0}',
      'common_cancel': 'Cancelar',
      'common_delete': 'Eliminar',
    },
    'it': {
      // Legal Documents
      'privacy_policy_content': '''Ultimo aggiornamento: 19 dicembre 2024

Benvenuto all'Informativa sulla Privacy di Keyra. Questo documento descrive come raccogliamo, utilizziamo e proteggiamo le tue informazioni personali.

1. Informazioni che raccogliamo

Raccogliamo le informazioni che ci fornisci direttamente, incluso:
• Informazioni dell'account (email, nome)
• Preferenze di apprendimento
• Progressi e statistiche di studio
• Parole salvate e flashcard

2. Come utilizziamo le tue informazioni

Utilizziamo le informazioni raccolte per:
• Personalizzare la tua esperienza di apprendimento
• Tracciare i tuoi progressi
• Migliorare i nostri servizi
• Fornire supporto clienti

3. Sicurezza dei dati

Implementiamo misure di sicurezza appropriate per proteggere le tue informazioni personali contro accessi non autorizzati, alterazioni, divulgazioni o distruzioni.

4. Condivisione dei dati

Non vendiamo le tue informazioni personali a terzi. Possiamo condividere le tue informazioni solo nelle seguenti circostanze:
• Con il tuo consenso
• Per rispettare obblighi legali
• Per proteggere i nostri diritti e la sicurezza

5. I tuoi diritti

Hai il diritto di:
• Accedere alle tue informazioni personali
• Correggere dati inaccurati
• Richiedere la cancellazione dei tuoi dati
• Rifiutare determinate raccolte di dati

6. Modifiche a questa politica

Potremmo aggiornare questa Informativa sulla Privacy di tanto in tanto. Ti informeremo di eventuali modifiche pubblicando la nuova Informativa sulla Privacy su questa pagina.

7. Contattaci

Se hai domande su questa Informativa sulla Privacy, contattaci a:
support@keyra.app

8. Privacy dei minori

Il nostro servizio non è destinato a minori di 13 anni. Non raccogliamo consapevolmente informazioni personali da minori di 13 anni.''',

      'terms_of_service_content': '''Ultimo aggiornamento: 19 dicembre 2024

Benvenuto su Keyra! Questi Termini di Servizio ("Termini") regolano l'utilizzo della nostra applicazione e dei nostri servizi.

1. Accettazione dei termini

Accedendo o utilizzando Keyra, accetti di essere vincolato da questi Termini. Se non accetti questi Termini, non utilizzare i nostri servizi.

2. Modifiche ai termini

Ci riserviamo il diritto di modificare questi Termini in qualsiasi momento. Ti informeremo di eventuali modifiche pubblicando i nuovi Termini su questa pagina.

3. Account utente

• Sei responsabile del mantenimento della riservatezza del tuo account
• Devi fornire informazioni accurate e complete
• Sei responsabile di tutte le attività sotto il tuo account
• Devi informarci immediatamente di qualsiasi uso non autorizzato

4. Diritti di proprietà intellettuale

• Tutti i contenuti in Keyra sono di nostra proprietà o dei nostri licenziatari
• Non puoi copiare, modificare o distribuire i nostri contenuti senza permesso
• I tuoi contenuti generati dall'utente rimangono di tua proprietà

5. Uso accettabile

Accetti di non:
• Violare leggi o regolamenti
• Impersonare altri
• Condividere contenuti inappropriati
• Tentare di accedere ad aree ristrette
• Interferire con il funzionamento del servizio

6. Funzionalità premium

• Alcune funzionalità potrebbero richiedere un pagamento
• Gli abbonamenti si rinnovano automaticamente se non cancellati
• I rimborsi sono soggetti alla nostra politica di rimborso
• I prezzi possono cambiare con preavviso

7. Terminazione

Possiamo terminare o sospendere il tuo account se violi questi Termini.

8. Esclusione di garanzie

Il servizio è fornito "così com'è" senza garanzie di alcun tipo.

9. Limitazione di responsabilità

Non siamo responsabili per danni indiretti, incidentali o consequenziali.''',

      // Profile Screen
      'profile': 'Profilo',
      'view saved definitions': 'Visualizza le tue definizioni di parole salvate',
      'saved words subtitle': 'Visualizza le tue definizioni di parole salvate',
      'settings': 'Impostazioni',
      'dark mode': 'Modalità scura',
      'notifications': 'Notifiche',
      'app language': 'Lingua dell\'app',
      'select language': 'Seleziona lingua',
      'about': 'Informazioni',
      'version': 'Versione',
      'acknowledgments': 'Riconoscimenti',
      'special_thanks': 'Ringraziamenti speciali',
      'icons_section': 'Icone',
      'icons_description': 'HugeIcons - Set di icone bello e coerente',
      'animations_section': 'Animazioni',
      'animations_description': 'Animazione Lottie - "Animazione gratuita di saluti della volpe" di Solitudinem',
      'fonts_section': 'Font',
      'fonts_description': 'FascinateInline - Font unico ed elegante per il nostro marchio',
      'libraries_section': 'Librerie Open Source',
      'libraries_description': 'Comunità Flutter e Dart per il loro incredibile lavoro',
      'contributors_section': 'Contributori',
      'contributors_description': 'Tutti gli sviluppatori che hanno contribuito a questo progetto',
      'privacy policy': 'Informativa sulla privacy',
      'terms of service': 'Termini di servizio',
      'developer': 'Sviluppatore',
      'contact us': 'Contattaci',
      'information': 'Informazioni',
      'versione': 'Versione',
      'ringraziamenti': 'Ringraziamenti',

      // Dashboard Screen
      'track reading progress': 'Monitora i tuoi progressi di lettura',
      'books read': 'Libri letti',
      'favorite books': 'Libri preferiti',
      'reading streak': 'Serie di lettura',
      'saved words': 'Parole salvate',
      'study progress': 'Progresso dello studio',
      'new': 'Nuovi',
      'learning': 'In apprendimento',
      'learned': 'Imparati',
      'total words': 'Totale parole',
      'no_saved_words_message': 'Non hai ancora salvato nessuna parola. Aggiungi alcune parole alla tua libreria per iniziare a studiare!',
      'no_saved_words_language_message': 'Non hai ancora salvato parole per questa lingua. Aggiungi alcune parole per iniziare a studiare!',
      'dashboard_study_words': 'Studia parole',
      'dashboard_select_language_to_study': 'Seleziona una lingua da studiare:',

      // Library Screen
      'search books': 'Cerca i tuoi libri...',
      'all': 'Tutti',
      'favorites': 'Preferiti',
      'recents': 'Recenti',

      // Home Screen
      'recently added': 'Storie aggiunte di recente',
      'continue reading': 'Continua a leggere',
      'page of': 'Pagina 1 di 3',
      'home': 'Home',
      'library': 'Libreria',
      'create': 'Crea',
      'dashboard': 'Dashboard',
      'home_recently_added_stories': 'Storie aggiunte di recente',
      'home_continue_reading': 'Continua a leggere',
      'home_page_progress': 'Pagina {0} di {1}',
      'nav_home': 'Home',
      'nav_library': 'Libreria',
      'nav_create': 'Crea',
      'nav_dashboard': 'Dashboard',
      'ok': 'OK',
      // Language names
      'language_english': 'Inglese',
      'language_french': 'Francese',
      'language_spanish': 'Spagnolo',
      'language_german': 'Tedesco',
      'language_italian': 'Italiano',
      'language_japanese': 'Giapponese',
      'no_words_for_language': 'Nessuna parola da studiare per {language}',
      // Badge System
      'achievements': 'Risultati',
      'badge_progress_title': 'La tua medaglia di lettura',
      'badge_progress_subtitle': 'Continua a leggere per guadagnare nuove medaglie!',
      'badge_earned': 'Medaglia guadagnata!',
      'badge_beginner': 'Principiante',
      'badge_intermediate': 'Intermedio',
      'badge_advanced': 'Avanzato',
      'badge_master': 'Maestro',
      'badge_explorer': 'Esploratore',
      'badge_voyager': 'Viaggiatore',
      'badge_weaver': 'Tessitore',
      'badge_navigator': 'Navigatore',
      'badge_pioneer': 'Pioniere',
      'badge_royalty': 'Regalità',
      'badge_baron': 'Barone',
      'badge_legend': 'Leggenda',
      'badge_wizard': 'Mago',
      'badge_epic': 'Epico',
      'badge_titan': 'Titano',
      'badge_sovereign': 'Sovrano',
      'badge_virtuoso': 'Virtuoso',
      'badge_luminary': 'Luminare',
      'badge_beacon': 'Faro',
      'badge_radiant': 'Radiante',
      'badge_lighthouse': 'Faro',
      'badge_infinite': 'Infinito',
      'badge_renaissance': 'Rinascimento',
      'badge_ultimate': 'Definitivo',
      'requirements': 'Requisiti',
      'books read requirement': '{0} libri letti',
      'favorite books requirement': '{0} libri preferiti',
      'reading streak requirement': '{0} giorni consecutivi',
      'badge_description': 'Hai guadagnato una nuova medaglia per aver letto {amount} parole!',
      'badge_unlocked': 'Medaglia sbloccata!',
      'badge_unlocked_description': 'Hai sbloccato una nuova medaglia per aver letto {amount} parole!',
      'common_close': 'Chiudi',
      'common_all_languages': 'Tutte le lingue',
      'logout': 'Disconnetti',
      'logout_confirm': 'Sei sicuro di voler uscire?',
      'cancel': 'Annulla',
      // Flashcard Screen
      'flashcard_study_session': 'Sessione di studio',
      'tap_to_see_definition': 'Tocca per vedere la definizione',
      'tap_to_see_word': 'Tocca per vedere la parola',
      'definition': 'Definizione',
      'examples': 'Esempi',
      'flashcard_difficulty_hard': 'Difficile',
      'flashcard_difficulty_good': 'Buono',
      'flashcard_difficulty_easy': 'Facile',
      // Study Words Page
      'delete_word_title': 'Eliminare la parola?',
      'delete_word_confirm': 'Sei sicuro di voler eliminare "{0}" dalle tue parole salvate?',
      'error_deleting_word': 'Errore durante l\'eliminazione della parola: {0}',
      'common_definition': 'Definizione',
      'common_examples': 'Esempi',
      'common_show_all_languages': 'Mostra tutte le lingue',
      'common_error': 'Errore: {0}',
      'common_cancel': 'Annulla',
      'common_delete': 'Elimina',
    },
    'de': {
      // Legal Documents
      'privacy_policy_content': '''Zuletzt aktualisiert: 19. Dezember 2024

Willkommen zur Datenschutzerklärung von Keyra. Dieses Dokument beschreibt, wie wir Ihre persönlichen Informationen sammeln, verwenden und schützen.

1. Informationen, die wir sammeln

Wir sammeln Informationen, die Sie uns direkt zur Verfügung stellen, einschließlich:
• Kontoinformationen (E-Mail, Name)
• Lernpräferenzen
• Lernfortschritt und Statistiken
• Gespeicherte Wörter und Karteikarten

2. Wie wir Ihre Informationen verwenden

Wir verwenden die gesammelten Informationen für:
• Personalisierung Ihrer Lernerfahrung
• Verfolgung Ihres Fortschritts
• Verbesserung unserer Dienste
• Bereitstellung von Kundenservice

3. Datensicherheit

Wir implementieren angemessene Sicherheitsmaßnahmen zum Schutz Ihrer persönlichen Informationen vor unbefugtem Zugriff, Änderung, Offenlegung oder Zerstörung.

4. Datenweitergabe

Wir verkaufen Ihre persönlichen Informationen nicht an Dritte. Wir teilen Ihre Informationen nur unter folgenden Umständen:
• Mit Ihrer Einwilligung
• Zur Erfüllung gesetzlicher Verpflichtungen
• Zum Schutz unserer Rechte und Sicherheit

5. Ihre Rechte

Sie haben das Recht:
• Auf Zugriff zu Ihren persönlichen Informationen
• Auf Korrektur ungenauer Daten
• Auf Löschung Ihrer Daten
• Bestimmte Datenerfassungen abzulehnen

6. Änderungen dieser Richtlinie

Wir können diese Datenschutzerklärung von Zeit zu Zeit aktualisieren. Wir werden Sie über Änderungen informieren, indem wir die neue Datenschutzerklärung auf dieser Seite veröffentlichen.

7. Kontakt

Bei Fragen zu dieser Datenschutzerklärung kontaktieren Sie uns bitte unter:
support@keyra.app

8. Datenschutz für Kinder

Unser Service ist nicht für Kinder unter 13 Jahren bestimmt. Wir sammeln wissentlich keine persönlichen Informationen von Kindern unter 13 Jahren.''',

      'terms_of_service_content': '''Zuletzt aktualisiert: 19. Dezember 2024

Willkommen bei Keyra! Diese Nutzungsbedingungen ("Bedingungen") regeln Ihre Nutzung unserer Anwendung und Dienste.

1. Annahme der Bedingungen

Durch den Zugriff auf oder die Nutzung von Keyra stimmen Sie diesen Bedingungen zu. Wenn Sie diesen Bedingungen nicht zustimmen, nutzen Sie unsere Dienste nicht.

2. Änderungen der Bedingungen

Wir behalten uns das Recht vor, diese Bedingungen jederzeit zu ändern. Wir werden Sie über Änderungen informieren, indem wir die neuen Bedingungen auf dieser Seite veröffentlichen.

3. Benutzerkonten

• Sie sind für die Vertraulichkeit Ihres Kontos verantwortlich
• Sie müssen genaue und vollständige Informationen bereitstellen
• Sie sind für alle Aktivitäten unter Ihrem Konto verantwortlich
• Sie müssen uns sofort über unbefugte Nutzung informieren

4. Geistige Eigentumsrechte

• Alle Inhalte in Keyra gehören uns oder unseren Lizenzgebern
• Sie dürfen unsere Inhalte nicht ohne Erlaubnis kopieren, ändern oder verteilen
• Ihre nutzergenerierten Inhalte bleiben Ihr Eigentum

5. Zulässige Nutzung

Sie stimmen zu, nicht:
• Gesetze oder Vorschriften zu verletzen
• Sich als andere auszugeben
• Unangemessene Inhalte zu teilen
• Zu versuchen, auf eingeschränkte Bereiche zuzugreifen
• Den Betrieb des Dienstes zu stören

6. Premium-Funktionen

• Einige Funktionen können kostenpflichtig sein
• Abonnements verlängern sich automatisch, wenn sie nicht gekündigt werden
• Erstattungen unterliegen unserer Erstattungsrichtlinie
• Preise können sich mit Ankündigung ändern

7. Kündigung

Wir können Ihr Konto kündigen oder sperren, wenn Sie gegen diese Bedingungen verstoßen.

8. Gewährleistungsausschluss

Der Dienst wird "wie besehen" ohne jegliche Garantien bereitgestellt.

9. Haftungsbeschränkung

Wir haften nicht für indirekte, zufällige oder Folgeschäden.''',

      // Profile Screen
      'profile': 'Profil',
      'view saved definitions': 'Gespeicherte Wortdefinitionen anzeigen',
      'saved words subtitle': 'Gespeicherte Wortdefinitionen anzeigen',
      'settings': 'Einstellungen',
      'dark mode': 'Dunkelmodus',
      'notifications': 'Benachrichtigungen',
      'app language': 'App-Sprache',
      'select language': 'Sprache auswählen',
      'about': 'Über',
      'version': 'Version',
      'acknowledgments': 'Danksagungen',
      'special_thanks': 'Besonderer Dank',
      'icons_section': 'Icons',
      'icons_description': 'HugeIcons - Schönes und konsistentes Icon-Set',
      'animations_section': 'Animationen',
      'animations_description': 'Lottie Animation - "Kostenlose Fuchs-Grüße Animation" von Solitudinem',
      'fonts_section': 'Schriftarten',
      'fonts_description': 'FascinateInline - Einzigartige und stilvolle Schriftart für unser Branding',
      'libraries_section': 'Open-Source-Bibliotheken',
      'libraries_description': 'Flutter- und Dart-Communities für ihre großartige Arbeit',
      'contributors_section': 'Mitwirkende',
      'contributors_description': 'Alle Entwickler, die zu diesem Projekt beigetragen haben',
      'privacy policy': 'Datenschutzerklärung',
      'terms of service': 'Nutzungsbedingungen',
      'developer': 'Entwickler',
      'contact us': 'Kontaktiere uns',
      'information': 'Informationen',
      'versione': 'Version',
      'ringraziamenti': 'Danksagungen',

      // Dashboard Screen
      'track reading progress': 'Verfolgen Sie Ihren Lesefortschritt',
      'books read': 'Gelesene Bücher',
      'favorite books': 'Lieblingsbücher',
      'reading streak': 'Lese-Serie',
      'saved words': 'Gespeicherte Wörter',
      'study progress': 'Lernfortschritt',
      'new': 'Neu',
      'learning': 'Lernen',
      'learned': 'Gelernt',
      'total words': 'Gesamtanzahl Wörter',
      'no_saved_words_message': 'Sie haben noch keine Wörter gespeichert. Fügen Sie Ihrer Bibliothek einige Wörter hinzu, um mit dem Lernen zu beginnen!',
      'no_saved_words_language_message': 'Sie haben noch keine Wörter für diese Sprache gespeichert. Fügen Sie einige Wörter hinzu, um mit dem Lernen zu beginnen!',
      'dashboard_study_words': 'Wörter lernen',
      'dashboard_select_language_to_study': 'Wählen Sie eine Sprache zum Lernen:',

      // Library Screen
      'search books': 'Durchsuchen Sie Ihre Bücher...',
      'all': 'Alle',
      'favorites': 'Favoriten',
      'recents': 'Kürzlich',

      // Home Screen
      'recently added': 'Kürzlich hinzugefügte Geschichten',
      'continue reading': 'Weiterlesen',
      'page of': 'Seite 1 von 3',
      'home': 'Startseite',
      'library': 'Bibliothek',
      'create': 'Erstellen',
      'dashboard': 'Dashboard',
      'home_recently_added_stories': 'Kürzlich hinzugefügte Geschichten',
      'home_continue_reading': 'Weiterlesen',
      'home_page_progress': 'Seite {0} von {1}',
      'nav_home': 'Start',
      'nav_library': 'Bibliothek',
      'nav_create': 'Erstellen',
      'nav_dashboard': 'Dashboard',
      'ok': 'OK',
      // Language names
      'language_english': 'Englisch',
      'language_french': 'Französisch',
      'language_spanish': 'Spanisch',
      'language_german': 'Deutsch',
      'language_italian': 'Italienisch',
      'language_japanese': 'Japanisch',
      'no_words_for_language': 'Keine Wörter zum Lernen für {language}',
      // Badge System
      'achievements': 'Erfolge',
      'badge_progress_title': 'Ihr Leseabzeichen',
      'badge_progress_subtitle': 'Lesen Sie weiter, um neue Abzeichen zu verdienen!',
      'badge_earned': 'Abzeichen verdient!',
      'badge_beginner': 'Anfänger',
      'badge_intermediate': 'Fortgeschritten',
      'badge_advanced': 'Experte',
      'badge_master': 'Meister',
      'badge_explorer': 'Entdecker',
      'badge_voyager': 'Reisender',
      'badge_weaver': 'Weber',
      'badge_navigator': 'Navigator',
      'badge_pioneer': 'Pionier',
      'badge_royalty': 'Königtum',
      'badge_baron': 'Baron',
      'badge_legend': 'Legende',
      'badge_wizard': 'Zauberer',
      'badge_epic': 'Episch',
      'badge_titan': 'Titan',
      'badge_sovereign': 'Souverän',
      'badge_virtuoso': 'Virtuose',
      'badge_luminary': 'Leuchte',
      'badge_beacon': 'Leuchtfeuer',
      'badge_radiant': 'Strahlend',
      'badge_lighthouse': 'Leuchtturm',
      'badge_infinite': 'Unendlich',
      'badge_renaissance': 'Renaissance',
      'badge_ultimate': 'Ultimate',
      'requirements': 'Anforderungen',
      'books read requirement': '{0} Bücher gelesen',
      'favorite books requirement': '{0} Lieblingsbücher',
      'reading streak requirement': '{0} Tage in Folge',
      'badge_description': 'Sie haben ein neues Abzeichen für das Lesen von {amount} Wörtern verdient!',
      'badge_unlocked': 'Abzeichen freigeschaltet!',
      'badge_unlocked_description': 'Sie haben ein neues Abzeichen für das Lesen von {amount} Wörtern freigeschaltet!',
      'common_close': 'Schließen',
      'common_all_languages': 'Alle Sprachen',
      'logout': 'Abmelden',
      'logout_confirm': 'Sind Sie sicher, dass Sie sich abmelden möchten?',
      'cancel': 'Abbrechen',
      // Flashcard Screen
      'flashcard_study_session': 'Lernsitzung',
      'tap_to_see_definition': 'Tippen Sie, um die Definition zu sehen',
      'tap_to_see_word': 'Tippen Sie, um das Wort zu sehen',
      'definition': 'Definition',
      'examples': 'Beispiele',
      'flashcard_difficulty_hard': 'Schwer',
      'flashcard_difficulty_good': 'Gut',
      'flashcard_difficulty_easy': 'Einfach',
      // Study Words Page
      'delete_word_title': 'Wort löschen?',
      'delete_word_confirm': 'Sind Sie sicher, dass Sie "{0}" aus Ihren gespeicherten Wörtern löschen möchten?',
      'error_deleting_word': 'Fehler beim Löschen des Wortes: {0}',
      'common_definition': 'Definition',
      'common_examples': 'Beispiele',
      'common_show_all_languages': 'Alle Sprachen anzeigen',
      'common_error': 'Fehler: {0}',
      'common_cancel': 'Abbrechen',
      'common_delete': 'Löschen',
    },
    'ja': {
      // Legal Documents
      'privacy_policy_content': '''最終更新日：2024年12月19日

Keyraのプライバシーポリシーへようこそ。本文書では、お客様の個人情報の収集、使用、保護方法について説明します。

1. 収集する情報

当社は、お客様から直接提供される以下の情報を収集します：
• アカウント情報（メール、名前）
• 学習設定
• 学習進捗と統計
• 保存された単語とフラッシュカード

2. 情報の使用方法

収集した情報は以下の目的で使用します：
• 学習体験のパーソナライズ
• 進捗の追跡
• サービスの改善
• カスタマーサポートの提供

3. データセキュリティ

お客様の個人情報を不正アクセス、改ざん、開示、破壊から保護するため、適切なセキュリティ対策を実施しています。

4. データの共有

当社は、お客様の個人情報を第三者に販売することはありません。以下の場合にのみ、情報を共有することがあります：
• お客様の同意がある場合
• 法的義務を遵守するため
• 当社の権利と安全を保護するため

5. お客様の権利

お客様には以下の権利があります：
• 個人情報へのアクセス
• 不正確なデータの訂正
• データの削除要請
• 特定のデータ収集のオプトアウト

6. 本ポリシーの変更

当社は、このプライバシーポリシーを随時更新することがあります。変更がある場合は、新しいプライバシーポリシーをこのページに掲載してお知らせします。

7. お問い合わせ

本プライバシーポリシーに関するご質問は、以下までお問い合わせください：
support@keyra.app

8. 子どものプライバシー

当社のサービスは13歳未満の子ども向けではありません。当社は、13歳未満の子どもの個人情報を故意に収集することはありません。''',

      'terms_of_service_content': '''最終更新日：2024年12月19日

Keyraへようこそ！本利用規約（以下「本規約」）は、当社のアプリケーションおよびサービスの利用を規定します。

1. 規約の承諾

Keyraにアクセスまたは使用することにより、お客様は本規約に同意したものとみなされます。本規約に同意されない場合は、当社のサービスを使用しないでください。

2. 規約の変更

当社は、本規約をいつでも変更する権利を有します。変更がある場合は、新しい規約をこのページに掲載してお知らせします。

3. ユーザーアカウント

• アカウントの機密性保持はお客様の責任です
• 正確かつ完全な情報を提供する必要があります
• アカウント下のすべての活動に責任を負います
• 不正使用を発見した場合は直ちに通知する必要があります

4. 知的財産権

• Keyraのすべてのコンテンツは当社またはライセンサーの所有物です
• 許可なくコンテンツをコピー、変更、配布することはできません
• ユーザー生成コンテンツの所有権はお客様に帰属します

5. 許容される使用

以下の行為を行わないことに同意します：
• 法律または規制に違反すること
• 他者になりすますこと
• 不適切なコンテンツを共有すること
• 制限区域へのアクセスを試みること
• サービスの運営を妨害すること

6. プレミアム機能

• 一部の機能は有料となる場合があります
• サブスクリプションは解約しない限り自動更新されます
• 返金は返金ポリシーに従います
• 価格は通知をもって変更される場合があります

7. 解約

本規約に違反した場合、アカウントを解約または停止することがあります。

8. 保証の否認

サービスは「現状のまま」提供され、いかなる種類の保証もありません。

9. 責任の制限

当社は、間接的、付随的、または結果的な損害について責任を負いません。''',

      // Profile Screen
      'profile': 'プロフィール',
      'view saved definitions': '保存した単語の定義を表示',
      'saved words subtitle': '保存した単語の定義を表示',
      'settings': '設定',
      'dark mode': 'ダークモード',
      'notifications': '通知',
      'app language': 'アプリの言語',
      'select language': '言語を選択',
      'about': 'について',
      'version': 'バージョン',
      'acknowledgments': '謝辞',
      'special_thanks': '特別な感謝',
      'icons_section': 'アイコン',
      'icons_description': 'HugeIcons - 美しく一貫性のあるアイコンセット',
      'animations_section': 'アニメーション',
      'animations_description': 'Lottieアニメーション - Solitudinemによる"無料のキツネの挨拶アニメーション"',
      'fonts_section': 'フォント',
      'fonts_description': 'FascinateInline - ブランディングのためのユニークでスタイリッシュなフォント',
      'libraries_section': 'オープンソースライブラリ',
      'libraries_description': 'FlutterとDartコミュニティの素晴らしい仕事に感謝',
      'contributors_section': '貢献者',
      'contributors_description': 'このプロジェクトに貢献したすべての開発者',
      'privacy policy': 'プライバシーポリシー',
      'terms of service': '利用規約',
      'developer': '開発者',
      'contact us': 'お問い合わせ',
      'information': '情報',
      'versione': 'バージョン',
      'ringraziamenti': '謝辞',

      // Dashboard Screen
      'track reading progress': '読書の進捗を追跡',
      'books read': '読んだ本',
      'favorite books': 'お気に入りの本',
      'reading streak': '読書の連続日数',
      'saved words': '保存された単語',
      'study progress': '学習の進捗',
      'new': '新しい',
      'learning': '学習中',
      'learned': '学習済み',
      'total words': '単語の合計',
      'no_saved_words_message': 'まだ単語を保存していません。学習を始めるには、ライブラリに単語を追加してください！',
      'no_saved_words_language_message': 'この言語の単語をまだ保存していません。学習を始めるには、単語を追加してください！',
      'dashboard_study_words': '単語を学習',
      'dashboard_select_language_to_study': '学習する言語を選択：',

      // Library Screen
      'search books': '本を検索...',
      'all': 'すべて',
      'favorites': 'お気に入り',
      'recents': '最近',

      // Home Screen
      'recently added': '最近追加されたストーリー',
      'continue reading': '読み続ける',
      'page of': '3ページ中の1ページ',
      'home': 'ホーム',
      'library': 'ライブラリ',
      'create': '作成',
      'dashboard': 'ダッシュボード',
      'home_recently_added_stories': '最近追加されたストーリー',
      'home_continue_reading': '読み続ける',
      'home_page_progress': '{1}ページ中の{0}ページ',
      'nav_home': 'ホーム',
      'nav_library': 'ライブラリ',
      'nav_create': '作成',
      'nav_dashboard': 'ダッシュボード',
      'ok': 'OK',
      // Language names
      'language_english': '英語',
      'language_french': 'フランス語',
      'language_spanish': 'スペイン語',
      'language_german': 'ドイツ語',
      'language_italian': 'イタリア語',
      'language_japanese': '日本語',
      'no_words_for_language': '{language}の学習する単語がありません',
      // Badge System
      'achievements': '実績',
      'badge_progress_title': 'あなたの読書バッジ',
      'badge_progress_subtitle': '読書を続けて新しいバッジを獲得しよう！',
      'badge_earned': 'バッジ獲得！',
      'badge_beginner': '初心者',
      'badge_intermediate': '中級者',
      'badge_advanced': '上級者',
      'badge_master': 'マスター',
      'badge_explorer': '探検家',
      'badge_voyager': '航海者',
      'badge_weaver': '織り手',
      'badge_navigator': 'ナビゲーター',
      'badge_pioneer': '開拓者',
      'badge_royalty': '王族',
      'badge_baron': '男爵',
      'badge_legend': '伝説',
      'badge_wizard': '魔法使い',
      'badge_epic': '叙事詩',
      'badge_titan': 'タイタン',
      'badge_sovereign': '主権者',
      'badge_virtuoso': '達人',
      'badge_luminary': '輝く者',
      'badge_beacon': '標識',
      'badge_radiant': '光輝く',
      'badge_lighthouse': '灯台',
      'badge_infinite': '無限',
      'badge_renaissance': 'ルネサンス',
      'badge_ultimate': 'アルティメット',
      'requirements': '必要条件',
      'books read requirement': '読んだ本：{0}冊',
      'favorite books requirement': 'お気に入りの本：{0}冊',
      'reading streak requirement': '連続読書：{0}日',
      'badge_description': 'あなたは{amount}語を読んで新しいバッジを獲得しました！',
      'badge_unlocked': 'バッジ解除！',
      'badge_unlocked_description': 'あなたは{amount}語を読んで新しいバッジを解除しました！',
      'common_close': '閉じる',
      'common_all_languages': '全ての言語',
      'logout': 'ログアウト',
      'logout_confirm': 'ログアウトしてもよろしいですか？',
      'cancel': 'キャンセル',
      // Flashcard Screen
      'flashcard_study_session': '学習セッション',
      'tap_to_see_definition': 'タップして定義を表示',
      'tap_to_see_word': 'タップして単語を表示',
      'definition': '定義',
      'examples': '例文',
      'flashcard_difficulty_hard': '難しい',
      'flashcard_difficulty_good': '良い',
      'flashcard_difficulty_easy': '簡単',
      // Study Words Page
      'delete_word_title': '単語を削除しますか？',
      'delete_word_confirm': '"{0}"を保存した単語から削除してもよろしいですか？',
      'error_deleting_word': '単語の削除中にエラーが発生しました：{0}',
      'common_definition': '定義',
      'common_examples': '例文',
      'common_show_all_languages': 'すべての言語を表示',
      'common_error': 'エラー：{0}',
      'common_cancel': 'キャンセル',
      'common_delete': '削除',
    },
  };

  String get appName => 'Keyra';
  String get library => 'Library';
  String get dashboard => 'Dashboard';
  // Add more getters for other translations
}
