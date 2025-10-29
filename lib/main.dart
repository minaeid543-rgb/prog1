import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Day',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blueAccent,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  final List<String> _tasks = [];
  int _completed = 0;

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _tasks.add(task);
      });
      _taskController.clear();
    }
  }

  void _toggleComplete(int index) {
    setState(() {
      if (_tasks[index].startsWith("✅ ")) {
        _tasks[index] = _tasks[index].substring(2);
        _completed--;
      } else {
        _tasks[index] = "✅ ${_tasks[index]}";
        _completed++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, MMM d').format(DateTime.now());
    double progress = _tasks.isEmpty ? 0 : _completed / _tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Good Morning, Ali',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(Icons.search, color: Colors.black87),
          SizedBox(width: 10),
          Icon(Icons.person, color: Colors.black87),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'My Day Progress',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blueAccent,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 25),
            const Text(
              'Tasks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final isDone = _tasks[index].startsWith("✅ ");
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(
                                isDone
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isDone
                                    ? Colors.green
                                    : Colors.grey.shade400,
                              ),
                              onPressed: () => _toggleComplete(index),
                            ),
                            title: Text(
                              _tasks[index],
                              style: TextStyle(
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  if (_tasks[index].startsWith("✅ ")) {
                                    _completed--;
                                  }
                                  _tasks.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Add Task'),
              content: TextField(
                controller: _taskController,
                decoration:
                    const InputDecoration(hintText: 'Enter your task here'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addTask(_taskController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
