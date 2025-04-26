import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wordpress_app/config/wp_config.dart';
import 'package:wordpress_app/utils/toast.dart';
import '../models/user.dart';

class AuthService {
  static var client = http.Client();
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  static final FacebookAuth facebookAuth = FacebookAuth.instance;

  static Future<UserModel?> loginWithEmail(String userName, String password) async {
    Map<String, String> requestHeader = {
      'Content-type': 'application/x-www-form-urlencoded',
    };

    var response = await client.post(Uri.parse("${WpConfig.baseURL}/wp-json/jwt-auth/v1/token"),
        headers: requestHeader, body: {"username": userName, "password": password});
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      UserModel userModel = UserModel(
        userName: decoded['user_display_name'],
        emailId: decoded['user_email'],
        password: password,
        token: decoded['token'],
      );

      return userModel;
    } else {
      return null;
    }
  }

  static Future<UserResponseModel> createUser(UserModel model) async {
    Map<String, String> requestHeader = {'Content-type': 'application/json'};

    var response = await client.post(
      Uri.parse("${WpConfig.baseURL}/wp-json/wp/v2/users/register"),
      headers: requestHeader,
      body: jsonEncode(model.toJson()),
    );

    return userResponseFromJson(response.body);
  }

  static Future<bool> sendPasswordResetEmail(String email) async {
    String url = "${WpConfig.baseURL}/wp-login.php?action=lostpassword";

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data; charset=UTF-8',
      'Accept': 'application/json',
    };

    Map<String, String> body = {'user_login': email};

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields.addAll(body)
      ..headers.addAll(headers);

    var response = await request.send();
    debugPrint('response: ${response.statusCode}');
    if (response.statusCode == 302) {
      return true;
    } else if (response.statusCode == 200) {
      openToast('No Users Exist with this email');
      return false;
    } else {
      openToast('Failed to send. Please try again later.');
      return false;
    }
  }

  static Future<bool> deleteUserAccount(String token) async {
    const url = '${WpConfig.baseURL}/wp-json/remove_user/v1/user/me';
    try {
      final response = await client.delete(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        debugPrint('User deleted successfully');
        debugPrint(response.body.toString());
        return true;
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.body.toString());
        return false;
      }
    } catch (e) {
      openToast('Error while deleting user');
      debugPrint('error: $e');
      return false;
    }
  }

  static Future<UserModel?> socialLogin(String userName, String email) async {
    UserModel? userModel;

    var response = await client.post(
      Uri.parse("${WpConfig.baseURL}/wp-json/wp/v2/social-login"),
      body: {'username': userName, 'email': email},
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      userModel = UserModel(userName: json['username'], password: '', emailId: json['email'], token: '');
    }
    return userModel;
  }


  static Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      String username = googleUser.email.split("@").first;
      UserModel? userModel = await socialLogin(username, googleUser.email);
      if (userModel != null) {
        return userModel;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<UserModel?> signInWithFacebook() async {
    final LoginResult result = await facebookAuth.login();
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      String username = userData['email'].split("@").first;
      UserModel? userModel = await socialLogin(username, userData['email']);
      if (userModel != null) {
        return userModel;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<UserModel?> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    if (userCredential.user != null && userCredential.user!.email != null) {
      final String email = userCredential.user!.email!;
      final String username = email.split("@").first;
      UserModel? userModel = await socialLogin(username, email);
      if (userModel != null) {
        return userModel;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
