import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart'; // No alias needed for geocoding package
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as loc;
import 'package:network_info_plus/network_info_plus.dart'; // Alias 'loc' for location package
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  final loc.Location _location = loc.Location();
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// ✅ Check if location services are enabled
  Future<bool> checkLocationService() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  /// ✅ Check and request location permission
  Future<bool> checkPermissions(BuildContext context) async {
    loc.PermissionStatus permissionGranted = await _location.hasPermission();

    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }

    if (permissionGranted == loc.PermissionStatus.deniedForever) {
      if (context.mounted) {
        _showPermissionDialog(context);
      }
      return false;
    }

    return permissionGranted == loc.PermissionStatus.granted;
  }

  /// ✅ Show Cupertino dialog if location permission is permanently denied
  void _showPermissionDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Location Permission Required',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Location access is required to fetch city and state. Please enable it in settings.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                bool opened = await openAppSettings();
                if (opened) {
                  Future.delayed(const Duration(seconds: 2), () {
                    if (context.mounted) {
                      checkPermissions(context);
                    }
                  });
                }
              },
              child: Text(
                'Go to Settings',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ✅ Fetch user location (if permission is granted)
  Future<loc.LocationData?> getLocation(BuildContext context) async {
    if (!await checkLocationService()) return null;

    if (!context.mounted) return null; // ✅ Ensure context is still valid

    if (!await checkPermissions(context)) return null;

    if (!context.mounted) return null; // ✅ Double-check before using context

    try {
      return await _location.getLocation();
    } catch (e) {
      log('Error getting location: $e');
      return null;
    }
  }

  /// ✅ Get city and state based on user’s location
  Future<Map<String, String>?> getCityAndState(BuildContext context) async {
    try {
      if (!await checkLocationService()) return null;

      if (!context.mounted) return null; // ✅ Ensure context is valid

      if (!await checkPermissions(context)) return null;

      if (!context.mounted) return null; // ✅ Double-check before proceeding

      loc.LocationData locationData = await _location.getLocation();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return {
          'city': place.locality ?? 'Unknown City',
          'state': place.administrativeArea ?? 'Unknown State',
        };
      }
    } catch (e) {
      log('Error fetching city/state: $e');
    }
    return null; // Return null instead of defaulting to 'Unknown'
  }

  /// ✅ AES Encryption
  String encryptData(String data, String base64Key) {
    final keyBytes = encrypt.Key.fromBase64(base64Key);
    final iv = encrypt.IV.fromLength(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(data, iv: iv);

    return json.encode({
      'iv': base64.encode(iv.bytes),
      'value': encrypted.base64,
    });
  }

  /// ✅ AES Decryption
  String decryptData(String encryptedData, String base64Key) {
    final keyBytes = encrypt.Key.fromBase64(base64Key);
    final decryptedData = json.decode(encryptedData);
    final iv = encrypt.IV.fromBase64(decryptedData['iv']);
    final encryptedValue = decryptedData['value'];
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    return encrypter.decrypt64(encryptedValue, iv: iv);
  }

  /// ✅ Get IP Address
  Future<String> getIpAddress() async {
    final info = NetworkInfo();
    try {
      final wifiIP = await info.getWifiIP();
      return wifiIP ?? 'Unable to fetch IP';
    } catch (e) {
      log('Error fetching IP: $e');
      return 'Error';
    }
  }

  /// ✅ Get Device ID
  Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor ?? 'Not available';
      }
    } catch (e) {
      log('Error fetching device ID: $e');
    }
    return 'Error';
  }

  /// ✅ Fetch and Encrypt Device Data
  Future<Map<String, String>> getEncryptedDeviceData(
      BuildContext context) async {
    // Check location first
    Map<String, String>? locationData = await getCityAndState(context);
    if (locationData == null) {
      log('Location permission denied or unavailable');
      return {};
    }

    String ipAddress = await getIpAddress();
    String deviceId = await getDeviceId();
    String staticKey = 'D+mc1VUA4d0lRblC5SiLvCDwRdLxr6+oXEWQF9DaBVs=';

    return {
      'encryptedCity': encryptData(locationData['city']!, staticKey),
      'encryptedState': encryptData(locationData['state']!, staticKey),
      'encryptedIpAddress': encryptData(ipAddress, staticKey),
      'encryptedDeviceId': encryptData(deviceId, staticKey),
    };
  }
}
