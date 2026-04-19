import 'package:flutter/material.dart';
import '../../../../features/tasks/presentation/pages/tasks_view.dart';
import '../../../../features/timer/presentation/pages/timer_page.dart';
import '../../../../features/subjects/presentation/pages/add_subject_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../../features/tasks/presentation/pages/add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _SubjectsView(),
    const TasksView(), // <<< Tasks View added here
    const TimerPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Study Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _getFloatingActionButton(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            activeIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  FloatingActionButton? _getFloatingActionButton(BuildContext context) {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSubjectPage(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      );
    } else if (_selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskPage(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_task),
      );
    }
    return null;
  }
}

class _SubjectsView extends StatelessWidget {
  const _SubjectsView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 4, // Dummy subjects count
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16.0),
          color: Colors.blueAccent.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.blueAccent.withOpacity(0.2)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: const Icon(Icons.menu_book, color: Colors.blueAccent),
            ),
            title: Text(
              'Subject ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('3 Tasks Pending • 5h Studied'),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                // TODO: Delete Subject
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delete clicked!')),
                );
              },
            ),
            onTap: () {
              // Navigate to Subject Details / Tasks list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Open subject details...')),
              );
            },
          ),
        );
      },
    );
  }
}
