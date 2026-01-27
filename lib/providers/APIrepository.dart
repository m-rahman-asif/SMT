import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Create a provider for Dio (allows for easy mocking in tests)
final dioProvider = Provider((ref) => Dio(BaseOptions(
  baseUrl: 'https://api.restful-api.dev',
  connectTimeout: const Duration(seconds: 5),
)));

// 2. The Repository Class
class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  Future<void> resetPassword(String userId, String newPassword) async {
  try {
    // In this API, we use PATCH or PUT to update specific fields
    await _dio.patch('/objects/$userId', data: {
      "data": {
        "password": newPassword,
      }
    });
  } on DioException catch (e) {
    throw e.message ?? "Failed to reset password";
  }
}

  Future<void> forgotPassword(String email) async {
  try {
    // In this playground API, we send a POST to simulate a reset trigger
    await _dio.post('/objects', data: {
      "name": "Password Reset Request",
      "data": {
        "email": email,
        "action": "send_verification_code"
      }
    });
  } on DioException catch (e) {
    throw e.message ?? "Could not send reset link";
  }
}

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/objects', data: {
        "name": "User Login Attempt",
        "data": {
          "email": email,
          "password": password, 
        }
      });
      
      // Cast the response to a Map so you can check for success in the UI
      return response.data as Map<String, dynamic>;
      
    } on DioException catch (e) {
      // Improved error handling: check for specific status codes
      if (e.response?.statusCode == 404) {
        throw "User not found. Please sign up first.";
      }
      throw e.message ?? "An error occurred during login";
    }
  }
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/objects', data: {
        "name": name, 
        "data": {
          "email": email,
          "password": password,
          "account_type": "theory_student"
        }
      });
      
      // FIX: Cast the response data to a Map so the UI can read result['id']
      return response.data as Map<String, dynamic>;
      
    } on DioException catch (e) {
      throw e.message ?? "Failed to create account";
    }
  }
}

// 3. Provider for the Repository
final authRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});