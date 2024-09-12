import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {
  final Dio _dio;
  final String baseUrl = "http://localhost:8080/";

  Api(this._dio);

  Future<List<dynamic>> get(
      {required String endPoint, @required String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.get("$baseUrl$endPoint");
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getUser({
    required String endPoint,
    String? token,
  }) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.get("$baseUrl$endPoint");
    return response.data as Map<String, dynamic>; // Ensure this is a Map
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    required dynamic body,
    required String?
        token, // Ensure token is not nullable or handle it properly
  }) async {
    // Set the Content-Type to application/json
    _dio.options.headers['Content-Type'] = 'application/json';
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.put("$baseUrl$endPoint", data: body);
    print("PUT response: ${response.data}");
    if (response.statusCode == 200) {
      if (response.data is String) {
        return response.data;
      }
    } else {
      throw Exception('Failed to update group');
    }

    return response.data as Map<String, dynamic>;
  }

  Future<dynamic> post({
    required String endPoint,
    required dynamic body,
    String? token,
  }) async {
    try {
      // Set the authorization header if a token is provided
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      // Make the POST request
      final response = await _dio.post(
        "$baseUrl$endPoint",
        data: body,
        options: Options(
          headers: {
            'Content-Type':
                'application/json', // Ensure the content type is set
          },
        ),
      );

      // Log the response for debugging
      print("POST response: ${response.data}");

      // Check if response data is a string and return it directly
      if (response.data is String) {
        return response.data;
      }

      // Check response status code and handle accordingly
      if (response.statusCode == 200) {
        print('Users assigned successfully');
        return response.data; // Return the data if successful
      } else {
        print('Failed to assign users: ${response.statusCode}');
        return response.data; // Return the error data or message
      }
    } catch (e) {
      print('Error making POST request: $e');
      // Handle and rethrow or return error as needed
      throw Exception('Error making POST request: $e');
    }
  }

  Future<dynamic> delete({
    required String endPoint,
    required dynamic body,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        "$baseUrl$endPoint",
        data: body,
        options: options,
      );
      return response.data;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        print('Resource not found (404).'); // Specific handling for 404 errors
      } else {
        print('Failed to delete: $e'); // General error handling
      }
      throw Exception('Failed to delete: $e');
    }
  }
}
