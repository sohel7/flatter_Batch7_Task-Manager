import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_project/data/models/user_model.dart';

class AuthController{

 static  const String _accessTokenKey = 'access-token';
 static  const String _userDataKey = 'user-data';

  // Global Variable
 static String? accessToken;
 static UserModel? userData;

  //save access Token
  static Future<void> saveAccessToken(String token) async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.setString(_accessTokenKey, token);
   accessToken = token;
  }
// Save User Data
 static Future<void> saveUserData(UserModel userModel) async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.setString(
       _userDataKey, jsonEncode(userModel.toJson()));
      userData = userModel;
 }
  // Get AccessToken
  static Future<String?> getAccessToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   String? token = sharedPreferences.getString(_accessTokenKey);
    accessToken = token;
    return token;
  }

  // Get User Data
  static Future<UserModel?> getUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userEncodedData = sharedPreferences.getString(_userDataKey);
    if(userEncodedData == null){
     return null;
    }
    UserModel userModel =UserModel.fromJson(jsonDecode(userEncodedData));
    userData = userModel;
    return userModel;
  }

 // Check user is Loged in Or Not
  static bool isLoggedIn(){
    return accessToken!= null; // Null Noy
  }


  // Clear All data when Loged Out
  static Future<void> clearUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    accessToken = null;
  }

}


