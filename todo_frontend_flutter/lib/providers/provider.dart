import 'package:flutter/material.dart';
import '../models/achievement.dart';

class AppProvider extends ChangeNotifier {
  /// =========================
  /// DAILY GOAL
  /// =========================

  int completedToday = 0;

  final int dailyGoal = 5;

  double get progress {
    return completedToday / dailyGoal;
  }

  bool get isGoalCompleted {
    return completedToday >= dailyGoal;
  }

  /// =========================
  /// ACHIEVEMENTS
  /// =========================

  final List<Achievement> achievements = [
    Achievement(title: "First Step", icon: "🎯", required: 1),
    Achievement(title: "Getting Started", icon: "🔥", required: 5),
    Achievement(title: "Productivity Master", icon: "🏆", required: 10),
  ];

  /// =========================
  /// COMPLETE TASK
  /// =========================

  void completeTask() {
    completedToday++;

    _checkAchievements();

    notifyListeners();
  }

  /// =========================
  /// RESET DAILY PROGRESS
  /// =========================

  void resetDailyProgress() {
    completedToday = 0;

    for (var achievement in achievements) {
      achievement.unlocked = false;
    }

    notifyListeners();
  }

  /// =========================
  /// CHECK ACHIEVEMENTS
  /// =========================

  void _checkAchievements() {
    for (var achievement in achievements) {
      if (completedToday >= achievement.required) {
        achievement.unlocked = true;
      }
    }
  }
}
