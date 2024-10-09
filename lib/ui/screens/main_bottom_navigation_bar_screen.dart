import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screens/canceled_screen.dart';
import 'package:task_manager_project/ui/screens/completed_screen.dart';
import 'package:task_manager_project/ui/screens/progress_screen.dart';
import 'package:task_manager_project/ui/screens/new_task_screen.dart';
import 'package:task_manager_project/ui/utils/app_colors.dart';
import 'package:task_manager_project/ui/widgets/tm_appbar.dart';

class MainBottomNavbarScreen extends StatefulWidget {
  const MainBottomNavbarScreen({super.key});

  @override
  State<MainBottomNavbarScreen> createState() => _MainBottomNavbarScreenState();
}

class _MainBottomNavbarScreenState extends State<MainBottomNavbarScreen> {

  int _selectedIndex=0;

  final List<Widget> _screens= [
    const NewTaskScreen(),
    const CompletedScreen(),
    const CanceledScreen(),
    const InPorgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index){
          _selectedIndex=index;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.new_label), label:'New',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_box), label:'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.close), label:'Canceled',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_filled_outlined), label:'In Progress',
          ),
        ],
      ),
    );
  }
}


