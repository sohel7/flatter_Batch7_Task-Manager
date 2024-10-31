import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/network_response.dart';
import 'package:task_manager_project/data/models/task_list_model.dart';
import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/service/network_caller.dart';
import 'package:task_manager_project/data/utls/urls.dart';
import 'package:task_manager_project/ui/widgets/center_circular_progress_indecator.dart';
import 'package:task_manager_project/ui/widgets/snackbar_message.dart';
import 'package:task_manager_project/ui/widgets/task_card.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {

  bool _getCompletedTaskInprogress = false;
  List<TaskModel> _completedTaskList=[];
  @override
  void initState() {
    _getCompleteTaskList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getCompletedTaskInprogress,
      replacement: const CenteredSirculerProgressIndecator(),
      child: RefreshIndicator(
        onRefresh: ()async{
          _getCompleteTaskList();
        },
        child: ListView.separated(
          itemCount: _completedTaskList.length,
          itemBuilder: (context, index) {
            return  TaskCard(
              taskModel: _completedTaskList[index],
              onRefreshList: _getCompleteTaskList,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 8,
            );
          },
        ),
      ),
    );
  }
  // getting Complete Task Screen
  Future<void> _getCompleteTaskList() async {
    _completedTaskList.clear();
    _getCompletedTaskInprogress= true;
    setState(() {});
    final NetworkResponse response =
    await NetworkColler.getRequest(url:Urls.completedTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _completedTaskList = taskListModel.taskList ?? [];
    }else{
      showSnackbarMessage(context, response.errorMessage,true);
    }
    _getCompletedTaskInprogress = false;
    setState(() {});
  }

}
