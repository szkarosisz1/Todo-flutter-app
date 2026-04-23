import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TodoPage());
  }
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> todos = [];
  final controller = TextEditingController();

  final baseUrl = "http://localhost:3000/todos";

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final res = await http.get(Uri.parse(baseUrl));
    final data = json.decode(res.body) as List;
    setState(() {
      todos = data.map((e) => Todo.fromJson(e)).toList();
    });
  }

  Future<void> addTodo(String title) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"title": title}),
    );
    controller.clear();
    fetchTodos();
  }

  Future<void> toggleTodo(Todo todo) async {
    await http.put(
      Uri.parse("$baseUrl/${todo.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"completed": !todo.completed}),
    );
    fetchTodos();
  }

  Future<void> deleteTodo(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-do App")),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: controller)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => addTodo(controller.text),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: todos.map((todo) {
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (_) => toggleTodo(todo),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTodo(todo.id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
