import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geocoding/geocoding.dart'; // No alias needed for geocoding package
import 'package:location/location.dart' as loc;
import 'package:network_info_plus/network_info_plus.dart'; // Alias 'loc' for location package

class LocationService {
  final loc.Location _location = loc.Location(); // Use alias 'loc' here
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<bool> checkLocationService() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  Future<bool> checkPermissions() async {
    loc.PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }
    return permissionGranted == loc.PermissionStatus.granted;
  }

  Future<loc.LocationData?> getLocation() async {
    if (await checkLocationService() && await checkPermissions()) {
      return await _location.getLocation();
    }
    return null;
  }

  Future<Map<String, String>> getCityAndState() async {
    try {
      if (await checkLocationService() && await checkPermissions()) {
        loc.LocationData locationData = await _location.getLocation();

        // Get placemarks from latitude and longitude
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          return {
            'city': place.locality ?? 'Unknown City',
            'state': place.administrativeArea ?? 'Unknown State',
          };
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return {'city': 'Unknown', 'state': 'Unknown'};
  }

  String encryptData(String data, String base64Key) {
    // Decode the base64 key into bytes
    final keyBytes = encrypt.Key.fromBase64(base64Key);

    // Generate a random initialization vector (IV) of length 16
    final iv = encrypt.IV.fromLength(16);

    // Initialize AES encrypter in CBC mode with PKCS7 padding
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    // Encrypt the data
    final encrypted = encrypter.encrypt(data, iv: iv);

    // Create a JSON object similar to Laravel's format
    final encryptedData = {
      'iv': base64.encode(iv.bytes), // IV in base64
      'value': encrypted.base64, // Encrypted value in base64
    };

    // Return the encrypted data as a JSON string
    return json.encode(encryptedData);
  }

  String decryptData(String encryptedData, String base64Key) {
    // Decode the base64 key into bytes
    final keyBytes = encrypt.Key.fromBase64(base64Key);

    // Parse the encrypted data (it is a JSON string)
    final decryptedData = json.decode(encryptedData);

    // Extract the IV and the encrypted value from the decrypted JSON
    final iv = encrypt.IV.fromBase64(decryptedData['iv']);
    final encryptedValue = decryptedData['value'];

    // Initialize the encrypter with AES in CBC mode
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    // Decrypt the data
    final decrypted = encrypter.decrypt64(encryptedValue, iv: iv);

    return decrypted;
  }

  Future<String> getIpAddress() async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiIP();
    return wifiIP ?? 'Unable to fetch IP';
  }

  Future<String> getDeviceId() async {
    String deviceId = 'Not available';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id ?? 'Not available';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'Not available';
    }
    return deviceId;
  }

  Future<Map<String, String>> getEncryptedDeviceData() async {
    // Combine all the data to encrypt
    Map<String, String> locationData = await getCityAndState();
    String ipAddress = await getIpAddress();
    String deviceId = await getDeviceId();

    String staticKey =
        'D+mc1VUA4d0lRblC5SiLvCDwRdLxr6+oXEWQF9DaBVs='; // Static key

    // Encrypt each data piece separately
    String encryptedCity = encryptData(locationData['city']!, staticKey);
    String encryptedState = encryptData(locationData['state']!, staticKey);
    String encryptedIpAddress = encryptData(ipAddress, staticKey);
    String encryptedDeviceId = encryptData(deviceId, staticKey);

    // Return a map containing each encrypted value separately
    return {
      'encryptedCity': encryptedCity,
      'encryptedState': encryptedState,
      'encryptedIpAddress': encryptedIpAddress,
      'encryptedDeviceId': encryptedDeviceId,
    };
  }
}
