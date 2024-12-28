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
    return translations[currentLanguage]?[key] ?? translations['en']?[key] ?? key;
  }

  static const Map<String, Map<String, String>> translations = {
    'en': {
      // Library Page
      'library_search_books': 'Search books',
      'library_filter_all': 'All',
      'library_filter_favorites': 'Favorites',
      'library_filter_recents': 'Recents',
      'library_no_books': 'No books found',
      'library_retry': 'Retry',
      
      // Common
      'common_all_languages': 'All Languages',
      'language_english': 'English',
      'language_french': 'French',
      'language_spanish': 'Spanish',
      'language_italian': 'Italian',
      'language_german': 'German',
      'language_japanese': 'Japanese',
      'select_reading_language': 'Select Reading Language',
      'cancel': 'Cancel',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to log out?',
      'settings': 'Settings',
      'information': 'Information',
      'version': 'Version',
      'developer': 'Developer',
      'contact_us': 'Contact Us',
      'select_language': 'Select Language',
      'dark_mode': 'Dark Mode',
      'notifications': 'Notifications',
      'app_language': 'App Language',
      'saved_words': 'Saved Words',
      'saved_words_subtitle': 'View and manage your saved words',
      'acknowledgments': 'Acknowledgments',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'icons_section': 'Icons',
      'icons_description': 'HugeIcons - Beautiful and consistent icon set\nFlatIcon - Comprehensive icon library and resources',
      'special_thanks': 'Special Thanks',
      'animations_section': 'Animations',
      'animations_description': 'Lottie Animation - "Free fox greetings Animation" by Solitudinem',
      'fonts_section': 'Fonts',
      'fonts_description': 'FascinateInline - Unique and stylish font for our branding',
      'libraries_section': 'Open Source Libraries',
      'libraries_description': 'Flutter and Dart communities for their amazing work',
      'contributors_section': 'Contributors',
      'contributors_description': 'All the developers who have contributed to this project',

      // Social Media Section
      'socials': 'Socials',
      'chat_with_friends': 'Chat with friends',
      'improve_language_skills': 'Improve your language skills',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Discover learning tips',
      'tiktok': 'TikTok',
      'fun_language_content': 'Fun language content',

      // Badges & Achievements
      'achievements': 'Achievements',
      'requirements': 'Requirements',
      'books_read_requirement': '{0} books read',
      'favorite_books_requirement': '{0} favorite books',
      'reading_streak_requirement': '{0} day reading streak',
      'badge_beginner': 'Beginner',
      'badge_intermediate': 'Intermediate',
      'badge_advanced': 'Advanced',
      'badge_expert': 'Expert',
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

      // Stats
      'stats_books_read': 'Books Read',
      'stats_day_streak': 'Day Streak',
      'books_read': 'Books Read',
      'favorite_books': 'Favorite Books',
      'reading_streak': 'Reading Streak',
      'ok': 'OK',

      // Home Page
      'home_recently_added_stories': 'Recently Added Stories',
      'home_continue_reading': 'Continue Reading',
      'home_page_progress': 'Page {0} of {1}',
      'home_error_load_books': 'Error loading books',
      'home_error_favorite': 'Error updating favorite status',
      'home_no_in_progress_books': 'You don\'t have any books in progress yet. Select a book to start reading!',

      // Dashboard
      'dashboard_study_words': 'Study Words',
      'dashboard_select_language_to_study': 'Select a language to study',

      // Navigation
      'nav_home': 'Home',
      'nav_library': 'Library',
      'nav_study': 'Study',
      'nav_dashboard': 'Dashboard',
      
      // Study Page
      'study_page_title': 'Study',
      'no_saved_words_message': 'You haven\'t saved any words yet. Start reading and tap on words to save them for studying!',
      'no_saved_words_language_message': 'You haven\'t saved any words in {0} yet. Start reading and tap on words to save them for studying!',
      'study_page_subtitle': 'Track your learning progress and review saved words',
      'study_progress': 'Study Progress',
      'total_words': 'Total Words',
      'new_words': 'New',
      'learning_words': 'Learning',
      'learned_words': 'Learned',
      'start_studying': 'Start Studying',
      'study_tips': 'Study Tips',
      'regular_practice': 'Regular Practice',
      'regular_practice_desc': 'Study for 15-20 minutes daily. Short, consistent sessions are more effective than long, irregular ones.',
      'spaced_repetition': 'Spaced Repetition',
      'spaced_repetition_desc': 'Review words at increasing intervals. This helps move information from short-term to long-term memory.',
      'context_learning': 'Context Learning',
      'context_learning_desc': 'Learn words in context through reading. This helps understand usage and remember words better.',
      
      // Flashcards
      'tap_to_see_word': 'Tap to see word',
      'tap_to_see_definition': 'Tap to see definition',
      'definition': 'Definition',
      'examples': 'Examples',
      'flashcard_difficulty_easy': 'Easy',
      'flashcard_difficulty_medium': 'Medium',
      'flashcard_difficulty_hard': 'Hard',
      'flashcard_difficulty_good': 'Good',
      'flashcard_study_session': 'Study Session',
      
      // Legal
      'privacy_policy_content': '''Privacy Policy

Last updated: December 28, 2024

1. Information We Collect
We collect information that you provide directly to us, including:
- Reading progress and preferences
- Language learning data
- Device information
- Usage statistics

2. How We Use Your Information
We use the information we collect to:
- Provide and improve our services
- Personalize your reading experience
- Track your learning progress
- Analyze app usage patterns

3. Data Storage and Security
We take reasonable measures to protect your information. Your data is stored securely and encrypted when transmitted.

4. Your Rights
You have the right to:
- Access your personal data
- Request corrections to your data
- Delete your account and associated data
- Opt out of certain data collection

5. Contact Us
If you have questions about this Privacy Policy, please contact us.''',

      'terms_of_service_content': '''Terms of Service

Last updated: December 28, 2024

1. Acceptance of Terms
By using Keyra, you agree to these Terms of Service.

2. User Account
- You are responsible for maintaining the security of your account
- You must provide accurate information
- You may not share your account with others

3. Acceptable Use
You agree not to:
- Violate any laws or regulations
- Interfere with the app's functionality
- Share inappropriate content
- Attempt to access unauthorized areas

4. Content and Copyright
- All content in the app is protected by copyright
- You may not reproduce or distribute content without permission
- User-generated content remains your property

5. Service Modifications
We may modify or discontinue services at any time.

6. Limitation of Liability
We provide the service "as is" without warranties.

7. Contact
For questions about these terms, please contact us.''',
    },
    'fr': {
      // Library Page
      'library_search_books': 'Rechercher des livres',
      'library_filter_all': 'Tous',
      'library_filter_favorites': 'Favoris',
      'library_filter_recents': 'Récents',
      'library_no_books': 'Aucun livre trouvé',
      'library_retry': 'Réessayer',
      
      // Common
      'common_all_languages': 'Toutes les langues',
      'language_english': 'Anglais',
      'language_french': 'Français',
      'language_spanish': 'Espagnol',
      'language_italian': 'Italien',
      'language_german': 'Allemand',
      'language_japanese': 'Japonais',
      'select_reading_language': 'Sélectionner la langue de lecture',
      'cancel': 'Annuler',
      'logout': 'Déconnexion',
      'logout_confirm': 'Êtes-vous sûr de vouloir vous déconnecter ?',
      'settings': 'Paramètres',
      'information': 'Information',
      'version': 'Version',
      'developer': 'Développeur',
      'contact_us': 'Contactez-nous',
      'select_language': 'Sélectionner la langue',
      'dark_mode': 'Mode sombre',
      'notifications': 'Notifications',
      'app_language': 'Langue de l\'application',
      'saved_words': 'Mots sauvegardés',
      'saved_words_subtitle': 'Voir et gérer vos mots sauvegardés',
      'acknowledgments': 'Remerciements',
      'privacy_policy': 'Politique de confidentialité',
      'terms_of_service': 'Conditions d\'utilisation',
      'icons_section': 'Icônes',
      'icons_description': 'HugeIcons - Ensemble d\'icônes beau et cohérent\nFlatIcon - Bibliothèque d\'icônes complète et ressources',
      'special_thanks': 'Remerciements Spéciaux',
      'animations_section': 'Animations',
      'animations_description': 'Lottie Animation - "Animation de salutations du renard" par Solitudinem',
      'fonts_section': 'Polices',
      'fonts_description': 'FascinateInline - Police unique et élégante pour notre image de marque',
      'libraries_section': 'Bibliothèques Open Source',
      'libraries_description': 'Les communautés Flutter et Dart pour leur travail remarquable',
      'contributors_section': 'Contributeurs',
      'contributors_description': 'Tous les développeurs qui ont contribué à ce projet',

      // Social Media Section
      'socials': 'Réseaux Sociaux',
      'chat_with_friends': 'Chattez avec des amis',
      'improve_language_skills': 'Améliorez vos compétences linguistiques',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Découvrez des conseils d\'apprentissage',
      'tiktok': 'TikTok',
      'fun_language_content': 'Contenu linguistique amusant',

      // Badges & Achievements
      'achievements': 'Réalisations',
      'requirements': 'Conditions',
      'books_read_requirement': '{0} livres lus',
      'favorite_books_requirement': '{0} livres favoris',
      'reading_streak_requirement': '{0} jours de lecture consécutifs',
      'badge_beginner': 'Débutant',
      'badge_intermediate': 'Intermédiaire',
      'badge_advanced': 'Avancé',
      'badge_expert': 'Expert',
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

      // Stats
      'stats_books_read': 'Livres lus',
      'stats_day_streak': 'Jours consécutifs',
      'books_read': 'Livres lus',
      'favorite_books': 'Livres favoris',
      'reading_streak': 'Série de lecture',
      'ok': 'OK',

      // Home Page
      'home_recently_added_stories': 'Histoires récemment ajoutées',
      'home_continue_reading': 'Continuer la lecture',
      'home_page_progress': 'Page {0} sur {1}',
      'home_error_load_books': 'Erreur lors du chargement des livres',
      'home_error_favorite': 'Erreur lors de la mise à jour du statut favori',
      'home_no_in_progress_books': 'Vous n\'avez aucun livre en cours de lecture. Sélectionnez un livre pour commencer !',

      // Dashboard
      'dashboard_study_words': 'Étudier les mots',
      'dashboard_select_language_to_study': 'Sélectionnez une langue à étudier',

      // Navigation
      'nav_home': 'Accueil',
      'nav_library': 'Bibliothèque',
      'nav_study': 'Étudier',
      'nav_dashboard': 'T. de Bord',
      
      // Study Page
      'study_page_title': 'Étudier',
      'no_saved_words_message': 'Vous n\'avez pas encore sauvegardé de mots. Commencez à lire et appuyez sur les mots pour les sauvegarder !',
      'no_saved_words_language_message': 'Vous n\'avez pas encore sauvegardé de mots en {0}. Commencez à lire et appuyez sur les mots pour les sauvegarder !',
      'study_page_subtitle': 'Suivez vos progrès d\'apprentissage et révisez les mots sauvegardés',
      'study_progress': 'Progrès d\'étude',
      'total_words': 'Mots totaux',
      'new_words': 'Nouveau',
      'learning_words': 'Apprentissage',
      'learned_words': 'Appris',
      'start_studying': 'Commencer à étudier',
      'study_tips': 'Conseils d\'étude',
      'regular_practice': 'Pratique régulière',
      'regular_practice_desc': 'Étudiez 15-20 minutes par jour. Des sessions courtes et régulières sont plus efficaces que des sessions longues et irrégulières.',
      'spaced_repetition': 'Répétition espacée',
      'spaced_repetition_desc': 'Révisez les mots à intervalles croissants. Cela aide à transférer l\'information de la mémoire à court terme vers la mémoire à long terme.',
      'context_learning': 'Apprentissage contextuel',
      'context_learning_desc': 'Apprenez les mots en contexte par la lecture. Cela aide à comprendre l\'usage et à mieux mémoriser les mots.',
      
      // Flashcards
      'tap_to_see_word': 'Toucher pour voir le mot',
      'tap_to_see_definition': 'Toucher pour voir la définition',
      'definition': 'Définition',
      'examples': 'Exemples',
      'flashcard_difficulty_easy': 'Facile',
      'flashcard_difficulty_medium': 'Moyen',
      'flashcard_difficulty_hard': 'Difficile',
      'flashcard_difficulty_good': 'Bien',
      'flashcard_study_session': 'Session d\'étude',
      
      // Legal
      'privacy_policy_content': '''Politique de Confidentialité

Dernière mise à jour : 28 décembre 2024

1. Informations Collectées
Nous collectons les informations que vous nous fournissez directement :
- Progrès et préférences de lecture
- Données d'apprentissage des langues
- Informations sur l'appareil
- Statistiques d'utilisation

2. Utilisation de vos Informations
Nous utilisons les informations collectées pour :
- Fournir et améliorer nos services
- Personnaliser votre expérience de lecture
- Suivre vos progrès d'apprentissage
- Analyser les modes d'utilisation

3. Stockage et Sécurité
Nous prenons des mesures raisonnables pour protéger vos informations. Vos données sont stockées de manière sécurisée et cryptées lors de la transmission.

4. Vos Droits
Vous avez le droit de :
- Accéder à vos données personnelles
- Demander des corrections
- Supprimer votre compte
- Refuser certaines collectes de données

5. Nous Contacter
Pour toute question sur cette politique, contactez-nous.''',

      'terms_of_service_content': '''Conditions d'Utilisation

Dernière mise à jour : 28 décembre 2024

1. Acceptation des Conditions
En utilisant Keyra, vous acceptez ces conditions d'utilisation.

2. Compte Utilisateur
- Vous êtes responsable de la sécurité de votre compte
- Vous devez fournir des informations exactes
- Vous ne pouvez pas partager votre compte

3. Utilisation Acceptable
Vous acceptez de ne pas :
- Violer les lois ou les réglementations
- Perturber le fonctionnement de l'application
- Partager du contenu inapproprié
- Tenter d'accéder à des zones non autorisées

4. Contenu et Droits d'Auteur
- Tout le contenu est protégé par droits d'auteur
- Vous ne pouvez pas reproduire ou distribuer du contenu sans autorisation
- Le contenu créé par l'utilisateur reste sa propriété

5. Modifications du Service
Nous pouvons modifier ou interrompre les services à tout moment.

6. Limitation de Responsabilité
Nous fournissons le service "tel quel" sans garanties.

7. Contact
Pour toute question sur ces conditions, contactez-nous.''',
    },
    'es': {
      // Library Page
      'library_search_books': 'Buscar libros',
      'library_filter_all': 'Todos',
      'library_filter_favorites': 'Favoritos',
      'library_filter_recents': 'Recientes',
      'library_no_books': 'No se encontraron libros',
      'library_retry': 'Reintentar',
      
      // Common
      'common_all_languages': 'Todos los idiomas',
      'language_english': 'Inglés',
      'language_french': 'Francés',
      'language_spanish': 'Español',
      'language_italian': 'Italiano',
      'language_german': 'Alemán',
      'language_japanese': 'Japonés',
      'select_reading_language': 'Seleccionar idioma de lectura',
      'cancel': 'Cancelar',
      'logout': 'Cerrar sesión',
      'logout_confirm': '¿Estás seguro de que quieres cerrar sesión?',
      'settings': 'Ajustes',
      'information': 'Información',
      'version': 'Versión',
      'developer': 'Desarrollador',
      'contact_us': 'Contáctanos',
      'select_language': 'Seleccionar idioma',
      'dark_mode': 'Modo oscuro',
      'notifications': 'Notificaciones',
      'app_language': 'Idioma de la aplicación',
      'saved_words': 'Palabras guardadas',
      'saved_words_subtitle': 'Ver y gestionar tus palabras guardadas',
      'acknowledgments': 'Agradecimientos',
      'privacy_policy': 'Política de privacidad',
      'terms_of_service': 'Términos de servicio',
      'icons_section': 'Iconos',
      'icons_description': 'HugeIcons - Conjunto de iconos hermoso y consistente\nFlatIcon - Biblioteca completa de iconos y recursos',
      'special_thanks': 'Agradecimientos Especiales',
      'animations_section': 'Animaciones',
      'animations_description': 'Lottie Animation - "Animación de saludos del zorro" por Solitudinem',
      'fonts_section': 'Fuentes',
      'fonts_description': 'FascinateInline - Fuente única y elegante para nuestra marca',
      'libraries_section': 'Bibliotecas de Código Abierto',
      'libraries_description': 'Las comunidades de Flutter y Dart por su increíble trabajo',
      'contributors_section': 'Colaboradores',
      'contributors_description': 'Todos los desarrolladores que han contribuido a este proyecto',

      // Social Media Section
      'socials': 'Redes Sociales',
      'chat_with_friends': 'Chatea con amigos',
      'improve_language_skills': 'Mejora tus habilidades lingüísticas',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Descubre consejos de aprendizaje',
      'tiktok': 'TikTok',
      'fun_language_content': 'Contenido divertido de idiomas',

      // Badges & Achievements
      'achievements': 'Logros',
      'requirements': 'Requisitos',
      'books_read_requirement': '{0} libros leídos',
      'favorite_books_requirement': '{0} libros favoritos',
      'reading_streak_requirement': '{0} días seguidos de lectura',
      'badge_beginner': 'Principiante',
      'badge_intermediate': 'Intermedio',
      'badge_advanced': 'Avanzado',
      'badge_expert': 'Experto',
      'badge_master': 'Maestro',
      'badge_explorer': 'Explorador',
      'badge_voyager': 'Viajero',
      'badge_weaver': 'Tejedor',
      'badge_navigator': 'Navigante',
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
      'badge_ultimate': 'Último',

      // Stats
      'stats_books_read': 'Libros leídos',
      'stats_day_streak': 'Días seguidos',
      'books_read': 'Libros leídos',
      'favorite_books': 'Libros favoritos',
      'reading_streak': 'Racha de lectura',
      'ok': 'OK',

      // Home Page
      'home_recently_added_stories': 'Historias añadidas recientemente',
      'home_continue_reading': 'Continuar leyendo',
      'home_page_progress': 'Página {0} de {1}',
      'home_error_load_books': 'Error al cargar los libros',
      'home_error_favorite': 'Error al actualizar el estado favorito',
      'home_no_in_progress_books': 'No tienes ningún libro en progreso todavía. ¡Selecciona un libro para empezar a leer!',

      // Dashboard
      'dashboard_study_words': 'Estudiar palabras',
      'dashboard_select_language_to_study': 'Selecciona un idioma para estudiar',

      // Navigation
      'nav_home': 'Inicio',
      'nav_library': 'Biblioteca',
      'nav_study': 'Estudiar',
      'nav_dashboard': 'Panel',
      
      // Study Page
      'study_page_title': 'Estudiar',
      'no_saved_words_message': '¡Aún no has guardado ninguna palabra. ¡Empieza a leer y toca las palabras para guardarlas!',
      'no_saved_words_language_message': '¡Aún no has guardado ninguna palabra en {0}. ¡Empieza a leer y toca las palabras para guardarlas!',
      'study_page_subtitle': 'Sigue tu progreso de aprendizaje y repasa las palabras guardadas',
      'study_progress': 'Progreso de estudio',
      'total_words': 'Palabras totales',
      'new_words': 'Nuevo',
      'learning_words': 'Aprendiendo',
      'learned_words': 'Aprendido',
      'start_studying': 'Empezar a estudiar',
      'study_tips': 'Consejos de estudio',
      'regular_practice': 'Práctica regular',
      'regular_practice_desc': 'Estudia 15-20 minutos al día. Las sesiones cortas y constantes son más efectivas que las largas e irregulares.',
      'spaced_repetition': 'Repetición espaciada',
      'spaced_repetition_desc': 'Repasa las palabras a intervalos crecientes. Esto ayuda a transferir la información de la memoria a corto plazo a la memoria a largo plazo.',
      'context_learning': 'Aprendizaje contextual',
      'context_learning_desc': 'Aprende palabras en contexto a través de la lectura. Esto ayuda a entender el uso y recordar mejor las palabras.',
      
      // Flashcards
      'tap_to_see_word': 'Toca para ver la palabra',
      'tap_to_see_definition': 'Toca para ver la definición',
      'definition': 'Definición',
      'examples': 'Ejemplos',
      'flashcard_difficulty_easy': 'Fácil',
      'flashcard_difficulty_medium': 'Medio',
      'flashcard_difficulty_hard': 'Difícil',
      'flashcard_difficulty_good': 'Bien',
      'flashcard_study_session': 'Sesión de estudio',
      
      // Legal
      'privacy_policy_content': '''Política de Privacidad

Última actualización: 28 de diciembre de 2024

1. Información que Recopilamos
Recopilamos la información que nos proporciona directamente:
- Progreso y preferencias de lectura
- Datos de aprendizaje de idiomas
- Información del dispositivo
- Estadísticas de uso

2. Cómo Usamos su Información
Utilizamos la información recopilada para:
- Proporcionar y mejorar nuestros servicios
- Personalizar su experiencia de lectura
- Seguir su progreso de aprendizaje
- Analizar patrones de uso

3. Almacenamiento y Seguridad
Tomamos medidas razonables para proteger su información. Sus datos se almacenan de forma segura y se cifran durante la transmisión.

4. Sus Derechos
Tiene derecho a:
- Acceder a sus datos personales
- Solicitar correcciones
- Eliminar su cuenta
- Optar por no participar en ciertas recopilaciones de datos

5. Contáctenos
Si tiene preguntas sobre esta política, contáctenos.''',

      'terms_of_service_content': '''Términos de Servicio

Última actualización: 28 de diciembre de 2024

1. Aceptación de Términos
Al usar Keyra, acepta estos términos de servicio.

2. Cuenta de Usuario
- Es responsable de mantener la seguridad de su cuenta
- Debe proporcionar información precisa
- No puede compartir su cuenta

3. Uso Aceptable
Acepta no:
- Violar leyes o regulaciones
- Interferir con la funcionalidad
- Compartir contenido inapropiado
- Intentar acceder a áreas no autorizadas

4. Contenido y Derechos de Autor
- Todo el contenido está protegido por derechos de autor
- No puede reproducir contenido sin permiso
- El contenido generado por usuarios sigue siendo su propiedad

5. Modificaciones del Servicio
Podemos modificar o descontinuar servicios en cualquier momento.

6. Limitación de Responsabilidad
Proporcionamos el servicio "tal cual" sin garantías.

7. Contacto
Para preguntas sobre estos términos, contáctenos.''',
    },
    'it': {
      // Library Page
      'library_search_books': 'Cerca libri',
      'library_filter_all': 'Tutti',
      'library_filter_favorites': 'Preferiti',
      'library_filter_recents': 'Recenti',
      'library_no_books': 'Nessun libro trovato',
      'library_retry': 'Riprova',
      
      // Common
      'common_all_languages': 'Tutte le lingue',
      'language_english': 'Inglese',
      'language_french': 'Francese',
      'language_spanish': 'Spagnolo',
      'language_italian': 'Italiano',
      'language_german': 'Tedesco',
      'language_japanese': 'Giapponese',
      'select_reading_language': 'Seleziona lingua di lettura',
      'cancel': 'Annulla',
      'logout': 'Esci',
      'logout_confirm': 'Sei sicuro di voler uscire?',
      'settings': 'Impostazioni',
      'information': 'Informazioni',
      'version': 'Versione',
      'developer': 'Sviluppatore',
      'contact_us': 'Contattaci',
      'select_language': 'Seleziona lingua',
      'dark_mode': 'Modalità scura',
      'notifications': 'Notifiche',
      'app_language': 'Lingua dell\'app',
      'saved_words': 'Parole salvate',
      'saved_words_subtitle': 'Visualizza e gestisci le tue parole salvate',
      'acknowledgments': 'Riconoscimenti',
      'privacy_policy': 'Informativa sulla privacy',
      'terms_of_service': 'Termini di servizio',
      'icons_section': 'Icone',
      'icons_description': 'HugeIcons - Set di icone bello e coerente\nFlatIcon - Libreria completa di icone e risorse',
      'special_thanks': 'Ringraziamenti Speciali',
      'animations_section': 'Animazioni',
      'animations_description': 'Lottie Animation - "Animazione saluti della volpe" di Solitudinem',
      'fonts_section': 'Font',
      'fonts_description': 'FascinateInline - Font unico ed elegante per il nostro marchio',
      'libraries_section': 'Librerie Open Source',
      'libraries_description': 'Le comunità Flutter e Dart per il loro straordinario lavoro',
      'contributors_section': 'Contributori',
      'contributors_description': 'Tutti gli sviluppatori che hanno contribuito a questo progetto',

      // Social Media Section
      'socials': 'Social',
      'chat_with_friends': 'Chatta con gli amici',
      'improve_language_skills': 'Migliora le tue competenze linguistiche',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Scopri consigli per l\'apprendimento',
      'tiktok': 'TikTok',
      'fun_language_content': 'Contenuti linguistici divertenti',

      // Badges & Achievements
      'achievements': 'Risultati',
      'requirements': 'Requisiti',
      'books_read_requirement': '{0} libri letti',
      'favorite_books_requirement': '{0} libri preferiti',
      'reading_streak_requirement': '{0} giorni consecutivi di lettura',
      'badge_beginner': 'Principiante',
      'badge_intermediate': 'Intermedio',
      'badge_advanced': 'Avanzato',
      'badge_expert': 'Esperto',
      'badge_master': 'Maestro',
      'badge_explorer': 'Esploratore',
      'badge_voyager': 'Viaggiatore',
      'badge_weaver': 'Tessitore',
      'badge_navigator': 'Navigatore',
      'badge_pioneer': 'Pioniere',
      'badge_royalty': 'Reale',
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
      'badge_ultimate': 'Ultimo',

      // Stats
      'stats_books_read': 'Libri letti',
      'stats_day_streak': 'Giorni consecutivi',
      'books_read': 'Libri letti',
      'favorite_books': 'Libri preferiti',
      'reading_streak': 'Serie di lettura',
      'ok': 'OK',

      // Home Page
      'home_recently_added_stories': 'Storie aggiunte di recente',
      'home_continue_reading': 'Continua a leggere',
      'home_page_progress': 'Pagina {0} di {1}',
      'home_error_load_books': 'Errore nel caricamento dei libri',
      'home_error_favorite': 'Errore durante l\'aggiornamento dello stato preferito',
      'home_no_in_progress_books': 'Non hai ancora libri in corso. Seleziona un libro per iniziare a leggere!',

      // Dashboard
      'dashboard_study_words': 'Studia parole',
      'dashboard_select_language_to_study': 'Seleziona una lingua da studiare',

      // Navigation
      'nav_home': 'Home',
      'nav_library': 'Libreria',
      'nav_study': 'Studiare',
      'nav_dashboard': 'Dashboard',
      
      // Study Page
      'study_page_title': 'Studiare',
      'no_saved_words_message': 'Non hai ancora salvato nessuna parola. Inizia a leggere e tocca le parole per salvarle!',
      'no_saved_words_language_message': 'Non hai ancora salvato nessuna parola in {0}. Inizia a leggere e tocca le parole per salvarle!',
      'study_page_subtitle': 'Monitora i tuoi progressi di apprendimento e rivedi le parole salvate',
      'study_progress': 'Progresso dello studio',
      'total_words': 'Parole totali',
      'new_words': 'Nuovo',
      'learning_words': 'Imparando',
      'learned_words': 'Imparato',
      'start_studying': 'Inizia a studiare',
      'study_tips': 'Suggerimenti di studio',
      'regular_practice': 'Pratica regolare',
      'regular_practice_desc': 'Studia per 15-20 minuti al giorno. Le sessioni brevi e costanti sono più efficaci di quelle lunghe e irregolari.',
      'spaced_repetition': 'Ripetizione spaziata',
      'spaced_repetition_desc': 'Rivedi le parole a intervalli crescenti. Questo aiuta a trasferire le informazioni dalla memoria a breve termine a quella a lungo termine.',
      'context_learning': 'Apprendimento contestuale',
      'context_learning_desc': 'Impara le parole nel contesto attraverso la lettura. Questo aiuta a capire l\'uso e ricordare meglio le parole.',
      
      // Flashcards
      'tap_to_see_word': 'Tocca per vedere la parola',
      'tap_to_see_definition': 'Tocca per vedere la definizione',
      'definition': 'Definizione',
      'examples': 'Esempi',
      'flashcard_difficulty_easy': 'Facile',
      'flashcard_difficulty_medium': 'Medio',
      'flashcard_difficulty_hard': 'Difficile',
      'flashcard_difficulty_good': 'Bene',
      'flashcard_study_session': 'Sessione di studio',
      
      // Legal
      'privacy_policy_content': '''Informativa sulla Privacy

Ultimo aggiornamento: 28 dicembre 2024

1. Informazioni che Raccogliamo
Raccogliamo le informazioni che ci fornisci direttamente:
- Progressi e preferenze di lettura
- Dati di apprendimento delle lingue
- Informazioni sul dispositivo
- Statistiche di utilizzo

2. Come Utilizziamo le tue Informazioni
Utilizziamo le informazioni raccolte per:
- Fornire e migliorare i nostri servizi
- Personalizzare la tua esperienza di lettura
- Monitorare i tuoi progressi
- Analizzare i modelli di utilizzo

3. Archiviazione e Sicurezza
Adottiamo misure ragionevoli per proteggere le tue informazioni. I tuoi dati sono archiviati in modo sicuro e crittografati durante la trasmissione.

4. I tuoi Diritti
Hai il diritto di:
- Accedere ai tuoi dati personali
- Richiedere correzioni
- Eliminare il tuo account
- Rifiutare determinate raccolte di dati

5. Contattaci
Per domande su questa politica, contattaci.''',

      'terms_of_service_content': '''Termini di Servizio

Ultimo aggiornamento: 28 dicembre 2024

1. Accettazione dei Termini
Utilizzando Keyra, accetti questi termini di servizio.

2. Account Utente
- Sei responsabile della sicurezza del tuo account
- Devi fornire informazioni accurate
- Non puoi condividere il tuo account

3. Uso Accettabile
Accetti di non:
- Violare leggi o regolamenti
- Interferire con la funzionalità
- Condividere contenuti inappropriati
- Tentare di accedere ad aree non autorizzate

4. Contenuti e Copyright
- Tutti i contenuti sono protetti da copyright
- Non puoi riprodurre contenuti senza permesso
- I contenuti generati dagli utenti rimangono di loro proprietà

5. Modifiche al Servizio
Possiamo modificare o interrompere i servizi in qualsiasi momento.

6. Limitazione di Responsabilità
Forniamo il servizio "così com'è" senza garanzie.

7. Contatto
Per domande su questi termini, contattaci.''',
    },
    'de': {
      // Library Page
      'library_search_books': 'Bücher suchen',
      'library_filter_all': 'Alle',
      'library_filter_favorites': 'Favoriten',
      'library_filter_recents': 'Kürzlich',
      'library_no_books': 'Keine Bücher gefunden',
      'library_retry': 'Wiederholen',
      
      // Common
      'common_all_languages': 'Alle Sprachen',
      'language_english': 'Englisch',
      'language_french': 'Französisch',
      'language_spanish': 'Spanisch',
      'language_italian': 'Italienisch',
      'language_german': 'Deutsch',
      'language_japanese': 'Japanisch',
      'select_reading_language': 'Leseprache auswählen',
      'cancel': 'Abbrechen',
      'logout': 'Abmelden',
      'logout_confirm': 'Sind Sie sicher, dass Sie sich abmelden möchten?',
      'settings': 'Einstellungen',
      'information': 'Information',
      'version': 'Version',
      'developer': 'Entwickler',
      'contact_us': 'Kontakt',
      'select_language': 'Sprache auswählen',
      'dark_mode': 'Dunkelmodus',
      'notifications': 'Benachrichtigungen',
      'app_language': 'App-Sprache',
      'saved_words': 'Gespeicherte Wörter',
      'saved_words_subtitle': 'Gespeicherte Wörter anzeigen und verwalten',
      'acknowledgments': 'Danksagungen',
      'privacy_policy': 'Datenschutzerklärung',
      'terms_of_service': 'Nutzungsbedingungen',
      'icons_section': 'Icons',
      'icons_description': 'HugeIcons - Schönes und konsistentes Icon-Set\nFlatIcon - Umfassende Icon-Bibliothek und Ressourcen',
      'special_thanks': 'Besonderer Dank',
      'animations_section': 'Animationen',
      'animations_description': 'Lottie Animation - "Fuchs-Grüße Animation" von Solitudinem',
      'fonts_section': 'Schriftarten',
      'fonts_description': 'FascinateInline - Einzigartige und stilvolle Schriftart für unser Branding',
      'libraries_section': 'Open-Source-Bibliotheken',
      'libraries_description': 'Die Flutter- und Dart-Communities für ihre großartige Arbeit',
      'contributors_section': 'Mitwirkende',
      'contributors_description': 'Alle Entwickler, die zu diesem Projekt beigetragen haben',

      // Social Media Section
      'socials': 'Soziale Medien',
      'chat_with_friends': 'Chatte mit Freunden',
      'improve_language_skills': 'Verbessere deine Sprachkenntnisse',
      'instagram': 'Instagram',
      'discover_learning_tips': 'Entdecke Lerntipps',
      'tiktok': 'TikTok',
      'fun_language_content': 'Unterhaltsame Sprachinhalte',

      // Badges & Achievements
      'achievements': 'Erfolge',
      'requirements': 'Anforderungen',
      'books_read_requirement': '{0} Bücher gelesen',
      'favorite_books_requirement': '{0} Lieblingsbücher',
      'reading_streak_requirement': '{0} Tage Lesefolge',
      'badge_beginner': 'Anfänger',
      'badge_intermediate': 'Fortgeschritten',
      'badge_advanced': 'Erweitert',
      'badge_expert': 'Experte',
      'badge_master': 'Meister',
      'badge_explorer': 'Entdecker',
      'badge_voyager': 'Reisender',
      'badge_weaver': 'Weber',
      'badge_navigator': 'Navigator',
      'badge_pioneer': 'Pionier',
      'badge_royalty': 'Königshaus',
      'badge_baron': 'Baron',
      'badge_legend': 'Legende',
      'badge_wizard': 'Zauberer',
      'badge_epic': 'Episch',
      'badge_titan': 'Titan',
      'badge_sovereign': 'Souverän',
      'badge_virtuoso': 'Virtuose',
      'badge_luminary': 'Leuchtturm',
      'badge_beacon': 'Leuchtturm',
      'badge_radiant': 'Strahlend',
      'badge_lighthouse': 'Leuchtturm',
      'badge_infinite': 'Unendlich',
      'badge_renaissance': 'Renaissance',
      'badge_ultimate': 'Ultimativ',

      // Stats
      'stats_books_read': 'Gelesene Bücher',
      'stats_day_streak': 'Tage in Folge',
      'books_read': 'Gelesene Bücher',
      'favorite_books': 'Lieblingsbücher',
      'reading_streak': 'Lesefolge',
      'ok': 'OK',

      // Home Page
      'home_recently_added_stories': 'Kürzlich hinzugefügte Geschichten',
      'home_continue_reading': 'Weiterlesen',
      'home_page_progress': 'Seite {0} von {1}',
      'home_error_load_books': 'Fehler beim Laden der Bücher',
      'home_error_favorite': 'Fehler beim Aktualisieren des Favoritenstatus',
      'home_no_in_progress_books': 'Du hast noch keine Bücher in Bearbeitung. Wähle ein Buch aus, um mit dem Lesen zu beginnen!',

      // Dashboard
      'dashboard_study_words': 'Wörter lernen',
      'dashboard_select_language_to_study': 'Wähle eine Sprache zum Lernen',

      // Navigation
      'nav_home': 'Start',
      'nav_library': 'Bibliothek',
      'nav_study': 'Lernen',
      'nav_dashboard': 'Dashboard',
      
      // Study Page
      'study_page_title': 'Lernen',
      'no_saved_words_message': 'Du hast noch keine Wörter gespeichert. Fang an zu lesen und tippe auf Wörter, um sie zum Lernen zu speichern!',
      'no_saved_words_language_message': 'Du hast noch keine Wörter auf {0} gespeichert. Fang an zu lesen und tippe auf Wörter, um sie zum Lernen zu speichern!',
      'study_page_subtitle': 'Verfolge deinen Lernfortschritt und wiederhole gespeicherte Wörter',
      'study_progress': 'Lernfortschritt',
      'total_words': 'Wörter insgesamt',
      'new_words': 'Neu',
      'learning_words': 'Lernend',
      'learned_words': 'Gelernt',
      'start_studying': 'Anfangen zu lernen',
      'study_tips': 'Lerntipps',
      'regular_practice': 'Regelmäßiges Üben',
      'regular_practice_desc': 'Lerne täglich 15-20 Minuten. Kurze, regelmäßige Einheiten sind effektiver als lange, unregelmäßige.',
      'spaced_repetition': 'Wiederholung mit Abständen',
      'spaced_repetition_desc': 'Wiederhole Wörter in zunehmenden Abständen. Dies hilft, Informationen vom Kurz- ins Langzeitgedächtnis zu übertragen.',
      'context_learning': 'Kontextbezogenes Lernen',
      'context_learning_desc': 'Lerne Wörter im Kontext durch Lesen. Dies hilft, die Verwendung zu verstehen und sich Wörter besser zu merken.',
      
      // Flashcards
      'tap_to_see_word': 'Tippen Sie, um das Wort zu sehen',
      'tap_to_see_definition': 'Tippen Sie, um die Definition zu sehen',
      'definition': 'Definition',
      'examples': 'Beispiele',
      'flashcard_difficulty_easy': 'Einfach',
      'flashcard_difficulty_medium': 'Mittel',
      'flashcard_difficulty_hard': 'Schwer',
      'flashcard_difficulty_good': 'Gut',
      'flashcard_study_session': 'Lernsitzung',
      
      // Legal
      'privacy_policy_content': '''Datenschutzerklärung

Zuletzt aktualisiert: 28. Dezember 2024

1. Informationen, die wir sammeln
Wir sammeln Informationen, die Sie uns direkt zur Verfügung stellen:
- Lesefortschritt und Präferenzen
- Sprachlern-Daten
- Geräteinformationen
- Nutzungsstatistiken

2. Wie wir Ihre Informationen verwenden
Wir nutzen die gesammelten Informationen für:
- Bereitstellung und Verbesserung unserer Dienste
- Personalisierung Ihrer Leseerfahrung
- Verfolgung Ihres Lernfortschritts
- Analyse von Nutzungsmustern

3. Datenspeicherung und Sicherheit
Wir ergreifen angemessene Maßnahmen zum Schutz Ihrer Informationen. Ihre Daten werden sicher gespeichert und bei der Übertragung verschlüsselt.

4. Ihre Rechte
Sie haben das Recht:
- Auf Ihre persönlichen Daten zuzugreifen
- Korrekturen anzufordern
- Ihr Konto zu löschen
- Bestimmte Datenerfassungen abzulehnen

5. Kontakt
Bei Fragen zu dieser Politik kontaktieren Sie uns bitte.''',

      'terms_of_service_content': '''Nutzungsbedingungen

Zuletzt aktualisiert: 28. Dezember 2024

1. Annahme der Bedingungen
Durch die Nutzung von Keyra stimmen Sie diesen Nutzungsbedingungen zu.

2. Benutzerkonto
- Sie sind für die Sicherheit Ihres Kontos verantwortlich
- Sie müssen genaue Informationen angeben
- Sie dürfen Ihr Konto nicht teilen

3. Akzeptable Nutzung
Sie stimmen zu, nicht:
- Gesetze zu verletzen
- Die Funktionalität zu stören
- Unangemessene Inhalte zu teilen
- Unbefugten Zugriff zu versuchen

4. Inhalt und Urheberrecht
- Alle Inhalte sind urheberrechtlich geschützt
- Keine Reproduktion ohne Erlaubnis
- Nutzergenerierte Inhalte bleiben Ihr Eigentum

5. Änderungen am Dienst
Wir können Dienste jederzeit ändern oder einstellen.

6. Haftungsbeschränkung
Wir stellen den Dienst "wie besehen" ohne Garantien bereit.

7. Kontakt
Bei Fragen zu diesen Bedingungen kontaktieren Sie uns.''',
    },
    'ja': {
      // Library Page
      'library_search_books': '本を検索',
      'library_filter_all': 'すべて',
      'library_filter_favorites': 'お気に入り',
      'library_filter_recents': '最近',
      'library_no_books': '本が見つかりません',
      'library_retry': '再試行',
      
      // Common
      'common_all_languages': '全ての言語',
      'language_english': '英語',
      'language_french': 'フランス語',
      'language_spanish': 'スペイン語',
      'language_italian': 'イタリア語',
      'language_german': 'ドイツ語',
      'language_japanese': '日本語',
      'select_reading_language': '読書言語を選択',
      'cancel': 'キャンセル',
      'logout': 'ログアウト',
      'logout_confirm': 'ログアウトしてもよろしいですか？',
      'settings': '設定',
      'information': '情報',
      'version': 'バージョン',
      'developer': '開発者',
      'contact_us': 'お問い合わせ',
      'select_language': '言語を選択',
      'dark_mode': 'ダークモード',
      'notifications': '通知',
      'app_language': 'アプリの言語',
      'saved_words': '保存した単語',
      'saved_words_subtitle': '保存した単語を表示・管理',
      'acknowledgments': '謝辞',
      'privacy_policy': 'プライバシーポリシー',
      'terms_of_service': '利用規約',
      'icons_section': 'アイコン',
      'icons_description': 'HugeIcons - 美しく一貫性のあるアイコンセット\nFlatIcon - 包括的なアイコンライブラリとリソース',
      'special_thanks': '特別な感謝',
      'animations_section': 'アニメーション',
      'animations_description': 'Lottie Animation - Solitudinem による「キツネの挨拶アニメーション」',
      'fonts_section': 'フォント',
      'fonts_description': 'FascinateInline - ブランディングのためのユニークでスタイリッシュなフォント',
      'libraries_section': 'オープンソースライブラリ',
      'libraries_description': 'FlutterとDartコミュニティの素晴らしい仕事に感謝',
      'contributors_section': '貢献者',
      'contributors_description': 'このプロジェクトに貢献したすべての開発者',

      // Social Media Section
      'socials': 'ソーシャル',
      'chat_with_friends': '友達とチャット',
      'improve_language_skills': '語学力を向上させる',
      'instagram': 'Instagram',
      'discover_learning_tips': '学習のヒントを見つける',
      'tiktok': 'TikTok',
      'fun_language_content': '楽しい言語コンテンツ',

      // Badges & Achievements
      'achievements': '実績',
      'requirements': '要件',
      'books_read_requirement': '本を{0}冊読む',
      'favorite_books_requirement': 'お気に入りの本{0}冊',
      'reading_streak_requirement': '{0}日連続で読書',
      'badge_beginner': '初心者',
      'badge_intermediate': '中級者',
      'badge_advanced': '上級者',
      'badge_expert': 'エキスパート',
      'badge_master': 'マスター',
      'badge_explorer': '探検家',
      'badge_voyager': '航海者',
      'badge_weaver': '織り手',
      'badge_navigator': '案内人',
      'badge_pioneer': 'パイオニア',
      'badge_royalty': '王室',
      'badge_baron': '男爵',
      'badge_legend': '伝説',
      'badge_wizard': '魔法使い',
      'badge_epic': 'エピック',
      'badge_titan': 'タイタン',
      'badge_sovereign': '主権者',
      'badge_virtuoso': 'ヴィルトゥオーソ',
      'badge_luminary': 'ルミナリー',
      'badge_beacon': 'ビーコン',
      'badge_radiant': '放射性',
      'badge_lighthouse': '灯台',
      'badge_infinite': '無限',
      'badge_renaissance': 'ルネッサンス',
      'badge_ultimate': 'アルティメット',

      // Stats
      'stats_books_read': '読んだ本',
      'stats_day_streak': '連続日数',
      'books_read': '読んだ本',
      'favorite_books': 'お気に入りの本',
      'reading_streak': '読書の連続日数',
      'ok': 'OK',

      // Home Page
      'home_recently_added_stories': '最近追加されたストーリー',
      'home_continue_reading': '読み続ける',
      'home_page_progress': 'ページ {0} / {1}',
      'home_error_load_books': '本の読み込みエラー',
      'home_error_favorite': 'お気に入りの更新エラー',
      'home_no_in_progress_books': '進行中の本がまだありません。本を選択して読書を始めましょう！',

      // Dashboard
      'dashboard_study_words': '単語を学習',
      'dashboard_select_language_to_study': '学習する言語を選択',

      // Navigation
      'nav_home': 'ホーム',
      'nav_library': 'ライブラリ',
      'nav_study': '学習',
      'nav_dashboard': 'ダッシュボード',
      
      // Study Page
      'study_page_title': '学習',
      'no_saved_words_message': 'まだ単語を保存していません。読書を始めて、単語をタップして保存しましょう！',
      'no_saved_words_language_message': 'まだ{0}の単語を保存していません。読書を始めて、単語をタップして保存しましょう！',
      'study_page_subtitle': '学習の進捗状況を確認し、保存した単語を復習する',
      'study_progress': '学習の進捗',
      'total_words': '総単語数',
      'new_words': '新規',
      'learning_words': '学習中',
      'learned_words': '習得済み',
      'start_studying': '学習を始める',
      'study_tips': '学習のヒント',
      'regular_practice': '定期的な練習',
      'regular_practice_desc': '毎日15-20分勉強しましょう。短く定期的なセッションの方が、長く不規則なセッションより効果的です。',
      'spaced_repetition': '間隔をあけた復習',
      'spaced_repetition_desc': '徐々に間隔を広げながら単語を復習します。これにより、短期記憶から長期記憶への転送を促進します。',
      'context_learning': '文脈での学習',
      'context_learning_desc': '読書を通じて文脈の中で単語を学びます。これにより、使い方を理解し、より良く記憶することができます。',
      
      // Flashcards
      'tap_to_see_word': '単語を見るためにタップ',
      'tap_to_see_definition': '定義を見るためにタップ',
      'definition': '定義',
      'examples': '例文',
      'flashcard_difficulty_easy': '簡単',
      'flashcard_difficulty_medium': '普通',
      'flashcard_difficulty_hard': '難しい',
      'flashcard_difficulty_good': '良い',
      'flashcard_study_session': '学習セッション',
      
      // Legal
      'privacy_policy_content': '''プライバシーポリシー

最終更新日：2024年12月28日

1. 収集する情報
以下の情報を直接収集します：
- 読書の進捗と設定
- 言語学習データ
- デバイス情報
- 利用統計

2. 情報の使用方法
収集した情報は以下の目的で使用します：
- サービスの提供と改善
- 読書体験のカスタマイズ
- 学習進捗の追跡
- 利用パターンの分析

3. データの保管とセキュリティ
お客様の情報を保護するための適切な措置を講じています。データは安全に保管され、送信時は暗号化されます。

4. お客様の権利
以下の権利があります：
- 個人データへのアクセス
- データの訂正要求
- アカウントの削除
- 特定のデータ収集の拒否

5. お問い合わせ
このポリシーに関するご質問は、お問い合わせください。''',

      'terms_of_service_content': '''利用規約

最終更新日：2024年12月28日

1. 規約の同意
Keyraを使用することで、この利用規約に同意したことになります。

2. ユーザーアカウント
- アカウントのセキュリティ維持は利用者の責任です
- 正確な情報を提供する必要があります
- アカウントの共有は禁止されています

3. 適切な使用
以下の行為は禁止されています：
- 法令違反
- アプリの機能妨害
- 不適切なコンテンツの共有
- 許可されていない領域へのアクセス試行

4. コンテンツと著作権
- すべてのコンテンツは著作権で保護されています
- 許可なく複製することはできません
- ユーザー生成コンテンツの権利はユーザーに帰属します

5. サービスの変更
サービスは予告なく変更または中止される場合があります。

6. 責任の制限
サービスは「現状のまま」提供され、保証はありません。

7. お問い合わせ
この規約に関するご質問は、お問い合わせください。''',
    },
  };
}
