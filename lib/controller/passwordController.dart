import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordController {
  final String _authUrl = "https://api-production-696d.up.railway.app/auth";

  void forgotPassword(String email, BuildContext context) async {
    try {
      var response = await Dio().post(
        "$_authUrl/forgot_password",
        data: {
          "userEmail": email,
        },
      );
      if (response.data.containsKey('message')) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(response.data['message']),
            );
          },
        );
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
    }
  }

  void resetPassword(String email, String token, String newPassword,
      BuildContext context) async {
    try {
      var response = await Dio().post(
        "$_authUrl/reset_password",
        data: {
          "userEmail": email,
          "token": token,
          "newPassword": newPassword,
        },
      );
      if (response.data.containsKey('message')) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(response.data['message']),
            );
          },
        );
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
    }
  }
}
