import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/widgets/task_card.dart';

class InPorgressScreen extends StatelessWidget {
  const InPorgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      itemBuilder: (context, index) {
      //  return const TaskCard();
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
    );
  }
}
