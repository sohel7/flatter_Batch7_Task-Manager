import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_project/ui/controllers/auth_controller.dart';
import 'package:task_manager_project/ui/widgets/tm_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  XFile? _selectedImage;

  bool _updateProfileInProgress =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUserData();
  }


  void _setUserData (){
    _emailTEController.text = AuthController.userData?.email ?? '';
   _firstNameTEController.text= AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _phoneTEController.text = AuthController.userData?.mobile ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(
        isProfileScreenOption: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 48,),
                Text('Udate Profile',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 48,
                ),
                _buildPhotoPicker(),
                const SizedBox(
                  height: 48,
                ),
                TextFormField(
                  enabled: false,
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: _firstNameTEController,
                  decoration: const InputDecoration(
                    hintText: 'First Name',
                  ),
                ),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
                  ),
                ),
                TextFormField(
                  controller: _phoneTEController,
                  decoration: const InputDecoration(
                    hintText: 'Phone',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()){

                      }
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined)),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _updateProfile()async{

  }


  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: (){
        _pickImage();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child:const Text(
                'Photo', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8,),
             Text(_getSelectedPhotoTitle()),
          ],
        ),
      ),
    );
  }


  String _getSelectedPhotoTitle(){
    if(_selectedImage!=null){
      return _selectedImage!.name;
    }
    return 'Select Photo';
  }

  Future<void>_pickImage()async{
    ImagePicker imagePicker = ImagePicker();
   XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
   if(pickedImage!=null){

   }else{
     _selectedImage = pickedImage;
     setState(() {});
    }
  }
}
