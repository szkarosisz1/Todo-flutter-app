class Achievement {
  final String title;
  final String icon;
  final int required;
  bool unlocked;

  Achievement({
    required this.title,
    required this.icon,
    required this.required,
    this.unlocked = false,
  });
}
