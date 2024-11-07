import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_manager_project/data/models/network_response.dart';
import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/service/network_caller.dart';
import 'package:task_manager_project/data/utls/urls.dart';
import 'package:task_manager_project/ui/widgets/center_circular_progress_indecator.dart';
import 'package:task_manager_project/ui/widgets/snackbar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskModel,
    required this.onRefreshList,
  });

  final TaskModel taskModel;
  final VoidCallback onRefreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  String _selectedStatus = '';
  bool _changeStatusInprogress= false;
  bool _deleteTaskInprogress= false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.title ?? '',
                style: Theme.of(context).textTheme.titleMedium),
            Text(widget.taskModel.description ?? '',),
            Text('DATE: ${widget.taskModel.createdDate ?? ''}'),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTaskStatusChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: _changeStatusInprogress == false,
                      replacement: const CenteredSirculerProgressIndecator(),
                      child: IconButton(
                        onPressed: _onTapEditButton,
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _deleteTaskInprogress==false,
                      replacement: const CenteredSirculerProgressIndecator(),
                      child: IconButton(
                        onPressed: _onTapDeleteButton,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapEditButton() {
   // print(_selectedStatus);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Edit Status'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['New', 'Completed', 'In-Progress', 'Canceled'].map(
                      (e) {
                    return ListTile(
                      onTap: () {
                        _changeStatus(e);
                        Navigator.pop(context);
                      },
                      title: Text(e),
                      selected: _selectedStatus == e,
                      trailing: _selectedStatus == e ? const Icon(Icons.check) : null,
                    );
                  },
                ).toList()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future<void> _onTapDeleteButton() async {
    print("Delete button tapped. Starting process...");
    _deleteTaskInprogress = true;
    setState(() {});
    final NetworkResponse response = await NetworkColler.getRequest(
        url: Urls.deleteTask(widget.taskModel.sId!));
    if(response.isSuccess){
      widget.onRefreshList();
    }else{
      _deleteTaskInprogress = false;
      showSnackbarMessage(context, response.errorMessage);
      setState(() {});
    }
  }

  Widget _buildTaskStatusChip() {
    return Chip(
      label:  Text(
        widget.taskModel.status ?? '',
      //  widget.taskModel.status!,
        style:  const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.green),
      ),
    );
  }



  Future<void> _changeStatus(String newStatus) async {
    _changeStatusInprogress = true;
    setState(() {});
    final NetworkResponse response = await NetworkColler.getRequest(
        url: Urls.changStatus(widget.taskModel.sId!, newStatus));
    if(response.isSuccess){
      widget.onRefreshList();
    }else{
      _changeStatusInprogress = false;
      setState(() {});
      showSnackbarMessage(context, response.errorMessage);

    }
  }
}
