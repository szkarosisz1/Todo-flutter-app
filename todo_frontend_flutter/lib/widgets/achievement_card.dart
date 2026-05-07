import 'package:flutter/material.dart';
import '../models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: achievement.unlocked ? 1 : 0.4,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(achievement.icon, style: TextStyle(fontSize: 28)),

            SizedBox(width: 15),

            Expanded(
              child: Text(
                achievement.title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            Icon(
              achievement.unlocked ? Icons.lock_open : Icons.lock,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
