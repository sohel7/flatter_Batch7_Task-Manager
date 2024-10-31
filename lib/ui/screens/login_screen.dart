import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_manager_project/data/models/network_response.dart';
import 'package:task_manager_project/data/service/network_caller.dart';
import 'package:task_manager_project/data/utls/urls.dart';
import 'package:task_manager_project/ui/controllers/auth_controller.dart';
import 'package:task_manager_project/ui/screens/forgot_password_screen.dart';
import 'package:task_manager_project/ui/screens/main_bottom_navigation_bar_screen.dart';
import 'package:task_manager_project/ui/screens/sign_up_screen.dart';
import 'package:task_manager_project/ui/utils/app_colors.dart';
import 'package:task_manager_project/ui/widgets/center_circular_progress_indecator.dart';
import 'package:task_manager_project/ui/widgets/screen_background.dart';
import 'package:task_manager_project/ui/widgets/snackbar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   resizeToAvoidBottomInset: // TODO for backgroun image stack ,
      body: ScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text('Get Started With Us',
                      style: Theme.of(context).textTheme.titleLarge),
                  _buildSignInForm(),
                  const SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: _onTapForgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  _buildSignupSection(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              if(value ?.isEmpty ?? true){
                return 'Enter a Valid Email';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Email', labelText: 'Email'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              if(value ?.isEmpty ?? true){
                return 'Enter a Valid Password';
              } if(value!.length <=6){
                return 'Password must be more than Five Character';
              }
              return null;
            },
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: _inProgress == false, // or !_inProgress both are same
            replacement: const CenteredSirculerProgressIndecator(),
            child: ElevatedButton(
              onPressed: _onTapNextButton,
              child: const Icon(
                Icons.arrow_circle_right_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupSection(BuildContext context) {
    return Center(
      child: RichText(
          text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
              text: "Don't Have an Account?",
              children: [
            TextSpan(
              text: 'Sign Up',
              style: const TextStyle(color: AppColor.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignUp,
            )
          ])),
    );
  }

  void _onTapNextButton() {

    if(_formKey.currentState!.validate() == false){
      return;
    }else{
      _signIn();
    }
  }

  Future<void> _signIn() async {
    _inProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'email': _emailTEController.text.trim(),
      'password': _passwordTEController.text,
    };
    final NetworkResponse response =
        await NetworkColler.postRequest(url: Urls.login, body: requestBody);
    _inProgress = false;
    if (response.isSuccess) {
      // this line for save token
      await AuthController.saveAccessToken(response.responseData['token']);
      // then naviget to the page
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainBottomNavbarScreen()),
          (route) => false);
    } else {
      showSnackbarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onTapForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }
}
