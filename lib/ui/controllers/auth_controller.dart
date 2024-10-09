import 'package:shared_preferences/shared_preferences.dart';

class AuthController{

 static  const String _accessTokenKey = 'access-token';

  // Global Variable
 static String? accessToken;

  //Set
  static Future<void> saveAccessToken(String token) async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.setString(_accessTokenKey, token);
   accessToken = token;
  }


  // Get
  static Future<String?> getAccessToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   String? token = sharedPreferences.getString(_accessTokenKey);
    accessToken = token;
    return token;
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


