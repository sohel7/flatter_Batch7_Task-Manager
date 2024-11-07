import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:task_manager_project/data/models/network_response.dart';
import 'package:task_manager_project/data/models/task_list_model.dart';
import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/models/task_status_count_model.dart';
import 'package:task_manager_project/data/models/task_status_model.dart';
import 'package:task_manager_project/data/service/network_caller.dart';
import 'package:task_manager_project/data/utls/urls.dart';
import 'package:task_manager_project/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_project/ui/widgets/center_circular_progress_indecator.dart';
import 'package:task_manager_project/ui/widgets/snackbar_message.dart';
import 'package:task_manager_project/ui/widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskListInprogress = false;
  bool _getTaskStatusCountListInprogress = false;


  List<TaskModel> _newTaskList =[];
  List<TaskStatusModel> _taskStatusCountList =[];

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          _getNewTaskList();
          _getTaskStatusCount();
        },
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: Visibility(
                visible: !_getNewTaskListInprogress,
                replacement: const CenteredSirculerProgressIndecator(),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                     return  TaskCard(
                       taskModel: _newTaskList[index],
                       onRefreshList: (){
                         _getNewTaskList();
                       },
                     );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddFAB,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return  Padding(
      padding: EdgeInsets.all(8.0),
      child: Visibility(
        visible: _getTaskStatusCountListInprogress==true,
        replacement: const CenteredSirculerProgressIndecator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _getTaskSummaryCardList(),
          ),
        ),
      ),
    );
  }

  List<TaskSummaryCard> _getTaskSummaryCardList(){
    List<TaskSummaryCard> taskSummaryCardList = [];
    for (TaskStatusModel t in _taskStatusCountList){
      taskSummaryCardList.add(TaskSummaryCard(title: t.sId!, count: t.sum ?? 0));
    }
    return taskSummaryCardList;
  }


  Future<void> _onTapAddFAB() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
    if(shouldRefresh == true){
    _getNewTaskList();
    }
  }

  // For getting new task list
  Future<void> _getNewTaskList() async {
    _newTaskList.clear();
    _getNewTaskListInprogress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkColler.getRequest(url: Urls.newTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _newTaskList = taskListModel.taskList ?? [];
    }else{
      showSnackbarMessage(context, response.errorMessage,true);
    }
    _getNewTaskListInprogress = false;
    setState(() {});
  }


  // For getting  task status count
  Future<void> _getTaskStatusCount() async {
    _taskStatusCountList.clear();
    _getTaskStatusCountListInprogress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkColler.getRequest(url: Urls.taskStatusCount);
    if(response.isSuccess){
      final TaskStatusCountModel taskStatusCountModel =
      TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList= taskStatusCountModel.taskStatusCountList ?? [];
    }else{
      showSnackbarMessage(context, response.errorMessage,true);
    }
    _getTaskStatusCountListInprogress = false;
    setState(() {});
  }

}

class TaskSummaryCard extends StatelessWidget {
  const TaskSummaryCard({
    super.key,
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: SizedBox(
        width: 110,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$count', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: 4,
              ),
              FittedBox(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
