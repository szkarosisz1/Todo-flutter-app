import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';
import '../services/api_service.dart';
import '../widgets/todo_tile.dart';
import '../widgets/daily_goal.dart';
import '../widgets/achievement_card.dart';

import '../providers/provider.dart';
import '../providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    todos = await ApiService.fetchTodos();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<AppProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: themeProvider.currentGradient),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// =========================
                /// TOP BAR
                /// =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My Tasks",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      children: [
                        /// BACKGROUND PICKER
                        IconButton(
                          icon: const Icon(
                            Icons.color_lens,
                            color: Colors.white,
                          ),

                          onPressed: () {
                            showModalBottomSheet(
                              context: context,

                              builder: (_) {
                                return Container(
                                  padding: const EdgeInsets.all(10),

                                  child: Wrap(
                                    children: List.generate(
                                      themeProvider.backgrounds.length,
                                      (i) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: themeProvider
                                                .backgrounds[i]
                                                .first,
                                          ),

                                          title: Text("Background ${i + 1}"),

                                          onTap: () {
                                            themeProvider.changeBackground(i);

                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        /// DARK / LIGHT MODE
                        IconButton(
                          icon: Icon(
                            themeProvider.isDark
                                ? Icons.light_mode
                                : Icons.dark_mode,

                            color: Colors.white,
                          ),

                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// =========================
                /// DAILY GOAL
                /// =========================
                DailyGoal(
                  completed: stats.completedToday,
                  goal: stats.dailyGoal,
                ),

                const SizedBox(height: 20),

                /// =========================
                /// ADD TODO
                /// =========================
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,

                        style: const TextStyle(color: Colors.white),

                        decoration: InputDecoration(
                          hintText: "Add new task...",

                          hintStyle: const TextStyle(color: Colors.white70),

                          filled: true,

                          fillColor: Colors.white.withOpacity(0.15),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () async {
                        if (controller.text.trim().isEmpty) {
                          return;
                        }

                        await ApiService.addTodo(controller.text.trim());

                        controller.clear();

                        load();
                      },

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),

                        backgroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// =========================
                /// ACHIEVEMENTS TITLE
                /// =========================
                const Text(
                  "Achievements",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// =========================
                /// ACHIEVEMENT LIST
                /// =========================
                SizedBox(
                  height: 180,

                  child: ListView.builder(
                    itemCount: stats.achievements.length,

                    itemBuilder: (_, i) {
                      return AchievementCard(
                        achievement: stats.achievements[i],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// =========================
                /// TODO LIST
                /// =========================
                Expanded(
                  child: todos.isEmpty
                      ? const Center(
                          child: Text(
                            "No tasks yet",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: todos.length,

                          itemBuilder: (_, i) {
                            final t = todos[i];

                            return TodoTile(
                              todo: t,

                              onToggle: () async {
                                await ApiService.toggleTodo(t);

                                /// ACHIEVEMENT PROGRESS
                                if (!t.completed) {
                                  stats.completeTask();
                                }

                                load();
                              },

                              onDelete: () async {
                                await ApiService.deleteTodo(t.id);

                                load();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
