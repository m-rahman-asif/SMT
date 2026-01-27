import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Create a provider for Dio (allows for easy mocking in tests)
final dioProvider = Provider((ref) => Dio(BaseOptions(
      baseUrl: 'https://poodle-flexible-carefully.ngrok-free.app',
      connectTimeout: const Duration(seconds: 5),
    )));

// 2. The Repository Class
class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  Future<void> requestPasswordReset(String email) async {
  try {
    // Your API example only showed {"email": "..."}
    await _dio.post('/accounts/request_password_reset/', data: {
      "email": email.trim().toLowerCase(),
    });
  } on DioException catch (e) {
    print("Request Reset Error: ${e.response?.data}");
    throw e.response?.data['detail'] ?? "Failed to send reset request";
  }
}

// 2. Verify OTP and get the action_token
Future<String> verifyOtp(String email, String otp) async {
  try {
    final response = await _dio.post('/accounts/verify_otp/', data: {
      "email": email.trim().toLowerCase(),
      "otp": otp.trim(), // It is also safer to trim the OTP
      "action": "password_reset" // Changed from "password_reset/activate_account"
    });
    
    return response.data['action_token']; 
    
  } on DioException catch (e) {
    print("Verify OTP Error: ${e.response?.data}");
    throw e.response?.data['detail'] ?? "Verification failed";
  }
}
// 3. Set the new password using the token
Future<void> completePasswordReset(String email, String token, String newPassword) async {
  try {
    await _dio.post('/accounts/reset_password/', data: {
      "email": email.trim().toLowerCase(),
      "action_token": token,
      "new_password": newPassword,
    });
  } on DioException catch (e) {
    print("Final Reset Error: ${e.response?.data}");
    throw e.response?.data['detail'] ?? "Failed to update password";
  }
}

  Future<Map<String, dynamic>> getUserById(String id) async {
    try {
      final response = await _dio.get('/objects/$id');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw e.message ?? "User session expired or not found";
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    final response = await _dio.get('/objects');
    return response.data as List<dynamic>;
  }

// 2. UPDATE - Modify user data (e.g., Resetting password or changing name)
  Future<void> updateAccount(
      String userId, Map<String, dynamic> newData) async {
    try {
      // We use PUT for a full replace or PATCH for a partial update
      await _dio.put('/objects/$userId', data: newData);
    } on DioException catch (e) {
      throw e.message ?? "Failed to update account";
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    try {
      // Attempting to get the list of objects
      final response = await _dio.get('/objects');
      if (response.data is List) {
        return response.data;
      }
      return [];
    } on DioException catch (e) {
      throw e.message ?? "Failed to connect to server";
    }
  }

// 3. DELETE - Remove the user object entirely
  Future<void> deleteAccount(String userId) async {
    try {
      await _dio.delete('/objects/$userId');
    } on DioException catch (e) {
      throw e.message ?? "Failed to delete account";
    }
  }

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
        "data": {"email": email, "action": "send_verification_code"}
      });
    } on DioException catch (e) {
      throw e.message ?? "Could not send reset link";
    }
  }

  Future<List<dynamic>> getMyAppData() async {
    try {
      // We use the same GET /objects but we must accept that
      // it only shows recent data. To fix this for a demo,
      // consider storing the created IDs in local storage (SharedPreferences)
      // and fetching them directly: /objects?id=ff8081...&id=ff8082...
      final response = await _dio.get('/objects');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw e.message ?? "Connection Error";
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final response = await _dio.post(
      '/accounts/login/',
      data: {
        "email": email.trim().toLowerCase(),
        "password": password,
      },
    );

    // The new API likely returns a token and user info
    print("Login Success: ${response.data}");
    return response.data as Map<String, dynamic>;
  } on DioException catch (e) {
    print("Login Error: ${e.response?.data}");
    
    // Handle specific error messages from the backend
    if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
      throw "Invalid email or password.";
    }
    throw e.message ?? "An error occurred during login.";
  }
}

  Future<Map<String, dynamic>> register(
  String name,
  String email,
  String password,
) async {
  try {
    // We send the whole 'name' as 'first_name'
    // and send an empty string for 'last_name' to satisfy the API
    final payload = {
      "email": email.trim().toLowerCase(),
      "password": password,
      "first_name": name.trim(), // Everything goes here
      "last_name": "",           // Keep this empty
    };

    print("Sending Payload: $payload");

    final response = await _dio.post(
      '/accounts/register/', 
      data: payload
    );

    print("Server Response: ${response.data}");
    return response.data as Map<String, dynamic>;
  } on DioException catch (e) {
    print("Error: ${e.response?.data}");
    // Extracting the error message from the backend
    final errorData = e.response?.data;
    String errorMessage = "Registration failed";
    
    if (errorData is Map) {
      errorMessage = errorData.values.first.toString();
    }
    throw errorMessage;
  }
}
}

// 3. Provider for the Repository
final authRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});
