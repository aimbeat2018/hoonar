import 'dart:convert';
import 'dart:core';

import 'package:hoonar/main.dart';
import 'package:hoonar/model/success_models/signup_success_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'key_res.dart';

class SessionManager {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  SharedPreferences? sharedPreferences;
  static String userId = 'userId';
  static String accessToken = 'accessToken';
  static String userEmail = 'userEmail';
  static String userPassword = 'userPassword';
  static String rememberMe = 'rememberMe';

  Future initPref() async {
    sharedPreferences = await _pref;
  }

  void saveBoolean(String key, bool value) async {
    if (sharedPreferences != null) sharedPreferences?.setBool(key, value);
  }

  bool? getBool(String key) {
    return sharedPreferences == null || sharedPreferences!.getBool(key) == null
        ? false
        : sharedPreferences!.getBool(key);
  }

  bool? getIsDarkMode(String key, bool value) {
    return sharedPreferences == null || sharedPreferences!.getBool(key) == null
        ? value
        : sharedPreferences!.getBool(key);
  }

  String? giveString(String key) {
    return sharedPreferences?.getString(key);
  }

  void cleanString(String key) {
    if (sharedPreferences != null) sharedPreferences!.remove(key);
  }

  void saveString(String key, String? value) async {
    if (sharedPreferences != null) sharedPreferences!.setString(key, value!);
  }

  String? getString(String key) {
    return sharedPreferences == null ||
            sharedPreferences!.getString(key) == null
        ? ''
        : sharedPreferences!.getString(key);
  }

  void saveUser(String value) {
    if (sharedPreferences != null) {
      sharedPreferences!.setString(KeyRes.user, value);
    }
    saveBoolean(KeyRes.login, true);
    int userIdInt = getUser()?.data?.userId ?? -1;
    // userId = userIdInt.toString();
    // accessToken = getUser()?.data?.token ?? '';
    saveString(SessionManager.userId, userIdInt.toString());
    saveString(SessionManager.accessToken, getUser()?.data?.token ?? '');
  }

  SignupSuccessModel? getUser() {
    if (sharedPreferences != null) {
      String? strUser = sharedPreferences!.getString(KeyRes.user);
      if (strUser != null && strUser.isNotEmpty) {
        return SignupSuccessModel.fromJson(jsonDecode(strUser));
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  // void saveSetting(String value) {
  //   if (sharedPreferences != null)
  //     sharedPreferences?.setString(KeyRes.setting, value);
  // }
  //
  // Setting? getSetting() {
  //   if (sharedPreferences != null) {
  //     String? value = sharedPreferences?.getString(KeyRes.setting);
  //     if (value != null && value.isNotEmpty) {
  //       return Setting.fromJson(jsonDecode(value));
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  // }
  //
  // void saveFavouriteMusic(String id) {
  //   List<dynamic> fav = getFavouriteMusic();
  //   // ignore: unnecessary_null_comparison
  //   if (fav != null) {
  //     if (fav.contains(id)) {
  //       fav.remove(id);
  //     } else {
  //       fav.add(id);
  //     }
  //   } else {
  //     fav = [];
  //     fav.add(id);
  //   }
  //   if (sharedPreferences != null) {
  //     sharedPreferences!.setString(KeyRes.favouriteMusic, json.encode(fav));
  //   }
  // }
  //
  // List<String> getFavouriteMusic() {
  //   if (sharedPreferences != null) {
  //     String? userString = sharedPreferences!.getString(KeyRes.favouriteMusic);
  //     if (userString != null && userString.isNotEmpty) {
  //       List<dynamic> dummy = json.decode(userString);
  //       return dummy.map((item) => item as String).toList();
  //     }
  //   }
  //   return [];
  // }

  Future<void> clean() async {
    var value1 = sharedPreferences!.getString(userEmail) ?? '';
    var value2 = sharedPreferences!.getString(userPassword) ?? '';
    var value3 = sharedPreferences!.getBool(rememberMe) ?? false;

    await sharedPreferences!.clear();

    await sharedPreferences!.setString(userEmail, value1);
    await sharedPreferences!.setString(userPassword, value2);
    sessionManager.saveBoolean(SessionManager.rememberMe, value3);
  }
}
