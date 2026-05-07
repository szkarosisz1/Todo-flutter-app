import 'package:flutter/material.dart';
import '../models/achievement.dart';

class StatsProvider extends ChangeNotifier {
  int completedToday = 0;

  List<Achievement> achievements = [
    Achievement(title: "First Step", icon: "🎯", required: 1),
    Achievement(title: "Getting Things Done", icon: "🔥", required: 5),
    Achievement(title: "Productivity Master", icon: "🏆", required: 10),
  ];

  final int dailyGoal = 5;

  void completeTask() {
    completedToday++;

    for (var a in achievements) {
      if (completedToday >= a.required) {
        a.unlocked = true;
      }
    }

    notifyListeners();
  }

  double get progress => completedToday / dailyGoal;

  bool get dailyGoalReached => completedToday >= dailyGoal;
}
