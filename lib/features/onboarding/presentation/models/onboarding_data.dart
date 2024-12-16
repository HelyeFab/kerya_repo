class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  bool isFavorite;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isFavorite = false,
  });

  OnboardingData copyWith({
    String? title,
    String? description,
    String? imagePath,
    bool? isFavorite,
  }) {
    return OnboardingData(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: 'Welcome to Keyra Books',
    description: 'Discover a world of AI-generated stories tailored just for you',
    imagePath: 'assets/images/onboarding/keyra01.png',
  ),
  OnboardingData(
    title: 'Create Your Own Stories',
    description: 'Let your imagination run wild with personalized AI-powered storytelling',
    imagePath: 'assets/images/onboarding/keyra02.png',
  ),
  OnboardingData(
    title: 'Share and Explore',
    description: 'Join our community of storytellers and explore amazing tales together',
    imagePath: 'assets/images/onboarding/keyra03.png',
  ),
];
