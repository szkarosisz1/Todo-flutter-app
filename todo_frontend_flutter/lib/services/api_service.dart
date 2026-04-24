import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  static const baseUrl = "http://localhost:3000/todos";

  static Future<List<Todo>> fetchTodos() async {
    final res = await http.get(Uri.parse(baseUrl));
    final data = json.decode(res.body) as List;
    return data.map((e) => Todo.fromJson(e)).toList();
  }

  static Future<void> addTodo(String title) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"title": title}),
    );
  }

  static Future<void> toggleTodo(Todo todo) async {
    await http.put(
      Uri.parse("$baseUrl/${todo.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"completed": !todo.completed}),
    );
  }

  static Future<void> deleteTodo(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}
