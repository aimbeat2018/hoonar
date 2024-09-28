import 'package:flutter/material.dart';

class ConstRes {
  static final String hoonarCamera = 'hoonar_camera';
  static final bool isDialog = false;

  static final String camera = '';
}

// max Video upload limit in MB
int maxUploadMB = 50;
// max Video upload second
int maxUploadSecond = 60;
const byDefaultLanguage = 'en';

List<Locale> supportedLocales = [
  const Locale('en', ''), // English
  const Locale('hi', ''), // Hindi
  const Locale('mr', ''), // Marathi
  const Locale('bn', ''), // Bengali
  const Locale('te', ''), // Telugu
  const Locale('ta', ''), // Tamil
  const Locale('gu', ''), // Gujarati
  const Locale('ur', ''), // Urdu
  const Locale('kn', ''), // Kannada
  const Locale('or', ''), // Odia
  const Locale('ml', ''), // Malayalam
  const Locale('pa', ''), // Punjabi
];
List<Map<String, dynamic>> languages = [
  {
    'title': 'English',
    'subHeading': 'English',
    'key': 'en',
  },
  {
    'title': 'हिंदी',
    'subHeading': 'Hindi',
    'key': 'hi',
  },
  {
    'title': 'मराठी',
    'subHeading': 'Marathi',
    'key': 'mr',
  },
  {
    'title': 'বাংলা',
    'subHeading': 'Bangla',
    'key': 'bn',
  },
  {
    'title': 'తెలుగు',
    'subHeading': 'Telugu',
    'key': 'te',
  },
  {
    'title': 'தமிழ்',
    'subHeading': 'Tamil',
    'key': 'ta',
  },
  {
    'title': 'ગુજરાતી',
    'subHeading': 'Gujarati',
    'key': 'gu',
  },
  {
    'title': 'اردو',
    'subHeading': 'Urdu',
    'key': 'ur',
  },
  {
    'title': 'ಕನ್ನಡ',
    'subHeading': 'Kannada',
    'key': 'kn',
  },
  {
    'title': 'ଓଡିଆ',
    'subHeading': 'Odia',
    'key': 'or',
  },
  {
    'title': 'മലയാളം',
    'subHeading': 'Malayalam',
    'key': 'ml',
  },
  {
    'title': 'ਪੰਜਾਬੀ',
    'subHeading': 'Punjabi',
    'key': 'pa',
  },
];
