import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/network_response.dart';
import 'package:task_manager_project/data/service/network_caller.dart';
import 'package:task_manager_project/data/utls/urls.dart';
import 'package:task_manager_project/ui/widgets/center_circular_progress_indecator.dart';
import 'package:task_manager_project/ui/widgets/snackbar_message.dart';
import 'package:task_manager_project/ui/widgets/tm_appbar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInprogress = false;
  bool _shouldRefreshPreviousPage = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ( result){
        if(result== true){
          return;
        }
        Navigator.pop(context);
    },

      child: Scaffold(
        appBar: const TMAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 42,
                  ),
                  Text('Add New Task', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600
                  ),),
                  const SizedBox(height: 26,),
                  TextFormField(
                    validator: (String? value) {
                      if(value?.trim().isEmpty?? true){
                        return 'Enter A Title';
                      }
                      return null;
                    },
                    controller: _titleTEController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      labelText: 'Title'
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    validator: (String? value) {
                    if(value?.trim().isEmpty?? true){
                      return 'Enter A Description';
                    }
                    return null;
                  },
                    controller: _descriptionTEController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        hintText: 'Description',
                        labelText: 'Description'
                    ),
                  ),
                 const SizedBox(height: 16,),
                  Visibility(
                    visible: !_addNewTaskInprogress,
                    replacement: const CenteredSirculerProgressIndecator(),
                    child: ElevatedButton(onPressed: _onTapSubmitButton,
                        child: const Icon(Icons.arrow_circle_right_outlined)),
                  )
      
                ],
      
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton(){
      if(_formKey.currentState!.validate()){
        _addNewTask();
      }
  }


  Future<void> _addNewTask()async{
    _addNewTaskInprogress = true;
    setState(() {  });
    Map<String,dynamic> requestBody = {
      'title': _titleTEController.text.trim(),
      'description': _descriptionTEController.text.trim(),
      'status': 'New'

    };

    final NetworkResponse response = await NetworkColler.postRequest(
        url: Urls.addNewTask,body: requestBody);
    _addNewTaskInprogress = false;
    setState(() {});
    if(response.isSuccess){
      _shouldRefreshPreviousPage = true;
      clearTextFields();
      showSnackbarMessage(context, 'New Task Added');
    }else{
      showSnackbarMessage(context, response.errorMessage, true);
    }
  }

  void clearTextFields(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }
}
