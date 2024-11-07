import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/controllers/auth_controller.dart';
import 'package:task_manager_project/ui/screens/login_screen.dart';
import 'package:task_manager_project/ui/screens/main_bottom_navigation_bar_screen.dart';
import 'package:task_manager_project/ui/widgets/screen_background.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  void moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)).then(
      (value) async {
        await AuthController.getAccessToken();
       // await AuthController.getUserData();
        if (AuthController.isLoggedIn()) {
          await AuthController.getUserData();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainBottomNavbarScreen(),
              ),
              (route) => false);
        }else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
                  (route) => false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
      child: Center(
          child: SvgPicture.asset('assets/images/logo.svg')
      ),
      ),
    );
  }
}
