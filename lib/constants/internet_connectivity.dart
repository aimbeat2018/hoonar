import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class CheckInternet {
  static final Connectivity _connectivity = Connectivity();

  static String _connectionStatus = 'Unknown';

  static Future<String> initConnectivity() async {
    List<ConnectivityResult> result = [ConnectivityResult.none];
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      //print(e.toString());
    }

    return updateConnectionStatus(result);
  }

  static Future<String> updateConnectionStatus(
      List<ConnectivityResult> connectivityResult) async {
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      return "";
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      return "";
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return "";
      // Ethernet connection available.
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return "";
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      return "";
      // Bluetooth connection available.
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      return "";
      // Connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      _connectionStatus = ConnectivityResult.none.toString();
      return _connectionStatus;
    }

    return "";
    /*switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
      // break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        return _connectionStatus;
      // break;
    }*/
  }
}
