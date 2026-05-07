import 'package:flutter/material.dart';

class DailyGoal extends StatelessWidget {
  final int completed;
  final int goal;

  const DailyGoal({required this.completed, required this.goal});

  @override
  Widget build(BuildContext context) {
    double progress = completed / goal;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Goal",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),

          SizedBox(height: 10),

          LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
          ),

          SizedBox(height: 10),

          Text(
            "$completed / $goal tasks completed",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
