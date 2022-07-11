import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Todo {
  bool isDone = false;
  String title;

  Todo(this.title);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _items = <Todo>[];

  var _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _addTodo(Todo todo) {
    setState(() {
      _items.add(todo);
      _todoController.text = '';
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _items.remove(todo);
    });
  }

  void _toggleTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  Widget _buildItemWidget(Todo todo) {
    return ListTile(
      onTap: () {},
      title: Text(
        todo.title,
        style: todo.isDone
            ? const TextStyle(
                decoration: TextDecoration.lineThrough,
                fontStyle: FontStyle.italic,
              )
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () => _deleteTodo(todo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Things to do'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                  ),
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () => _addTodo(Todo(_todoController.text)),
                ),
              ],
            ),
            FutureBuilder<List<Todo>>(
              future: _fetchTodoData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    "There was an error",
                    style: Theme.of(context).textTheme.headline2,
                  );
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView(
                      children: (snapshot.data)!.map((todo) => _buildItemWidget(todo))
                          .toList(),
                    ),
                  );
                } else {
                  return Text(
                    "No data",
                    style: Theme.of(context).textTheme.headline2,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Todo>> _fetchTodoData() {
    return Future.delayed(const Duration(seconds: 3), () => _items);
  }
}
