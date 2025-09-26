import 'package:flutter/material.dart';

class Task {
  String title;
  bool isCompleted;

  Task({
    required this.title,
    this.isCompleted = false,
  });

  void toggle() {
    isCompleted = !isCompleted;
  }

  @override
  String toString() {
    return 'Task{title: $title, isCompleted: $isCompleted}';
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ToDo List Pemula",
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget{
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen>{
  Widget _buildStatItem(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();
  void addTask() {
    String newTaskTitle = taskController.text.trim();

    if (newTaskTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Task tidak boleh kosong!'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    bool isDuplicate = tasks.any((task) =>
    task.title.toLowerCase() == newTaskTitle.toLowerCase());

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Task "$newTaskTitle" sudah ada!')),
            ],
          ),
          backgroundColor: Colors.pink,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (newTaskTitle.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Task terlalu panjang! Maksimal 100 karakter.')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      Task newTask = Task(title: newTaskTitle);
      tasks.add(newTask);
    });
    taskController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Task "$newTaskTitle" berhasil ditambahkan!')),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    print('Task ditambahkan: $newTaskTitle');
  }
  void removeTask(int index) async {
    Task taskToDelete = tasks[index];
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.pink[50],
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Konfirmasi Hapus', style: TextStyle(fontWeight: FontWeight.bold ),),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Apakah kamu yakin ingin menghapus task ini?'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${taskToDelete.title}"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        tasks.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Task "${taskToDelete.title}" dihapus')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      print('Task dihapus: ${taskToDelete.title}');
    }
  }
  void toggleTask(int index) {
    setState(() {
      tasks[index].toggle();
    });

    Task task = tasks[index];
    String message = task.isCompleted
        ? 'Selamat! Task "${task.title}" selesai! 🎉'
        : 'Task "${task.title}" ditandai belum selesai';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              task.isCompleted ? Icons.celebration : Icons.undo,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: task.isCompleted ? Colors.green : Colors.blue,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    print('Task ${task.isCompleted ? "completed" : "uncompleted"}: ${task.title}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My To-Do List", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink, width: 1,),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: taskController,
                    textCapitalization: TextCapitalization.sentences, // Auto capitalize
                    maxLength: 100, // Limit input length
                    decoration: InputDecoration(
                      hintText: 'Ketik task baru di sini...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(Icons.edit),
                      counterText: '', // Hide character counter
                      helperText: 'Maksimal 100 karakter', // Helper text
                    ),
                    onSubmitted: (value) => addTask(), // Enter key also adds task
                  ),
                  const SizedBox(height: 12,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:() {
                        addTask();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text(
                            'Add Task',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),

            if (tasks.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink[50]!, Colors.pink[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Statistik Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Total', tasks.length, Icons.list, Colors.pink),
                        _buildStatItem(
                            'Selesai',
                            tasks.where((task) => task.isCompleted).length,
                            Icons.check_circle,
                            Colors.green
                        ),
                        _buildStatItem(
                            'Belum',
                            tasks.where((task) => !task.isCompleted).length,
                            Icons.pending,
                            Colors.orange
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Text(
              tasks.isEmpty
                  ? "Belum ada task. Yuk tambah yang pertama!"
                  : "Kamu punya ${tasks.length} task${tasks.length > 1 ? 's' :" "}",
                  style: TextStyle(
                    fontSize: 16,
                    color: tasks.isEmpty ? Colors.grey[600] : Colors.pink[700],
                    fontWeight: FontWeight.w500,
                  )
            ),
            SizedBox(height: 20),
            Expanded(child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink[300]!, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: tasks.isEmpty
              ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada task',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan task pertamamu di atas!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
                  :
              ListView.builder(
                physics: BouncingScrollPhysics(),  
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Task task = tasks[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: task.isCompleted ? Colors.green[50] : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: task.isCompleted
                            ? Border.all(color: Colors.green[200]!, width: 2)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Opacity(
                        opacity: task.isCompleted ? 0.7 : 1.0,
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: task.isCompleted ? Colors.green[100] : Colors.pink[100],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: task.isCompleted
                                  ? Icon(Icons.check, color: Colors.green[700])
                                  : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.pink[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: task.isCompleted ? Colors.grey[600] : Colors.black87,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            task.isCompleted ? 'Selesai ✅' : 'Belum selesai',
                            style: TextStyle(
                              fontSize: 12,
                              color: task.isCompleted ? Colors.green[600] : Colors.grey[600],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  task.isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: task.isCompleted ? Colors.green[600] : Colors.grey[400],
                                ),
                                onPressed: () => toggleTask(index),
                                tooltip: task.isCompleted
                                    ? 'Mark as incomplete'
                                    : 'Mark as complete',
                              ),
                              // Delete button
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                                onPressed: () => removeTask(index),
                                tooltip: 'Hapus task',
                              ),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          onTap: () => toggleTask(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ))
          ],
        ),

      ),
    );
  }
}