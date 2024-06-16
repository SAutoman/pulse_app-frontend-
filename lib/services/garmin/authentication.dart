import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class GarminAuth {
  final String clientId;
  final String clientSecret;
  final String redirectUri;

  GarminAuth({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
  });

  Future<void> launchAuthentication(BuildContext context) async {
    final authorizationUrl = Uri.parse(
      'https://connect.garmin.com/oauth2/authorize'
      '?client_id=$clientId'
      '&response_type=code'
      '&redirect_uri=$redirectUri',
    );

    // Using flutter_web_auth to handle the redirect automatically
    final result = await FlutterWebAuth.authenticate(
      url: authorizationUrl.toString(),
      callbackUrlScheme: Uri.parse(redirectUri).scheme,
    );

    // Handle the redirect and extract the authorization code
    final code = Uri.parse(result).queryParameters['code'];

    if (code != null) {
      await _exchangeCodeForToken(code);
    } else {
      throw 'Authorization code not found';
    }
  }

  Future<void> _exchangeCodeForToken(String code) async {
    final tokenUrl = Uri.parse('https://connect.garmin.com/oauth2/token');
    final response = await http.post(
      tokenUrl,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final tokenResponse = json.decode(response.body);
      // Save the access token and other details as required.
    } else {
      throw 'Failed to obtain access token: ${response.body}';
    }
  }
}