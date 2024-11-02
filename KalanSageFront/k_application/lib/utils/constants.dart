import 'package:flutter/material.dart';
import 'dart:convert';

// API URL
const String apiUrl = 'https://bf0a-154-118-156-78.ngrok-free.app/api';
// const String apiUrl = 'http://localhost:8080/api';

// App colors
const Color primaryColor = Color(0xFF194860);
const Color secondaryColor = Color(0xFFED6A19);

// Text styles
const TextStyle appTitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle appSubtitleStyle = TextStyle(
  fontSize: 16,
  color: Colors.white70,
);

const TextStyle footerTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white54,
);



class EncodingUtils {
  // Method to decode a UTF-8 encoded string
  static String decode(String input) {
    return utf8.decode(input.codeUnits);
  }
}

