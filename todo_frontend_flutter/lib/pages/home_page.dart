import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/api_service.dart';
import '../widgets/todo_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    todos = await ApiService.fetchTodos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text("My Tasks"), centerTitle: true, elevation: 0),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Add new task...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (controller.text.isEmpty) return;
                    await ApiService.addTodo(controller.text);
                    controller.clear();
                    load();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Icon(Icons.add),
                ),
              ],
            ),

            SizedBox(height: 20),

            // lista
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (_, i) {
                  final t = todos[i];
                  return TodoTile(
                    todo: t,
                    onToggle: () async {
                      await ApiService.toggleTodo(t);
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
    );
  }
}
