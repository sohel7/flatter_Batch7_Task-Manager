import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_manager_project/data/modules/network_response.dart';
import 'package:task_manager_project/data/service/network_caller.dart';
import 'package:task_manager_project/data/utls/urls.dart';
import 'package:task_manager_project/ui/widgets/center_circular_progress_indecator.dart';
import 'package:task_manager_project/ui/widgets/screen_background.dart';
import 'package:task_manager_project/ui/widgets/snackbar_message.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: buildSignUpForm(),
              ),
            ),
          ),
        ));
  }

  // Widget buildSignupForm() {
  //   return Form(
  //     key: _formKey,
  //     child: buildSignUpForm(),
  //   );
  // }

  Widget buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 80,
          ),
          Text('Join With Us',
              style: Theme.of(context).textTheme.titleLarge),
          TextFormField(
            controller: _firstNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                hintText: 'First Name', labelText: 'First Name'),
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return 'Enter Valied First Name';
              }
            },
          ),
          TextFormField(
            controller: _lastNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                hintText: 'Last Name', labelText: 'Last Name'),
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return 'Enter Valied Last Name';
              }
            },
          ),
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                hintText: 'Email', labelText: 'Email'),
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return 'Enter Valied Email';
              }
            },
          ),
          TextFormField(
            controller: _mobileTEController,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                hintText: 'Mobile', labelText: 'Mobile'),
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return 'Enter Valied Mobile';
              }
            },
          ),
          TextFormField(
            controller: _passwordTEController,
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
            ),
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return 'Enter Valied Password';
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: _inProgress == false,
            replacement: const CenteredSirculerProgressIndecator(),
            child: ElevatedButton(
              onPressed: _onTapNextButton,
              child: const Icon(Icons.arrow_circle_right_outlined,color: Colors.white,),
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Have an Account ?",
                style: TextStyle(color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.green.shade400,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // For Next Button
  void _onTapNextButton(){
    if(_formKey.currentState!.validate()== false){
      return;
    }
    _signUp();
  }

//
  Future<void> _signUp() async{
    _inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody= {
      "email":_emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      "password":_passwordTEController.text,
      "photo":""
    };

    NetworkResponse response = await NetworkColler.postRequest(
       url: Urls.registration,
      body: requestBody,
    );
    _inProgress = false;
    setState(() {});
    if(response.isSuccess){
    showSnackbarMessage(context, 'New User Created');
    }else{
      showSnackbarMessage(context, response.errorMessage, true);
    }
  }


// Dispose Data
  @override
  void dispose() {
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

