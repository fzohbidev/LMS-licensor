import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {
  final Dio _dio;
  final String baseUrl = "http://localhost:8082/";

  Api(this._dio);

  Future<dynamic> get(
      {required String endPoint, @required String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.get("$baseUrl$endPoint");
    return response.data as List<dynamic>;
  }

  Future<dynamic> put({
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

  Future<dynamic> post(
      {required String endPoint,
      required dynamic body,
      @required String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.post("$baseUrl$endPoint", data: body);
    print("POST response: ${response.data}"); // Log the response

    if (response.data is String) {
      // Return the string message if that's what the response contains
      return response.data;
    }

    // Otherwise, return the JSON map
    return response.data as Map<String, dynamic>;
  }

  Future<dynamic> post2({
    required String endPoint,
    required List<dynamic> body,
    @required String? token,
  }) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }

    var response = await _dio.post("$baseUrl$endPoint", data: body);
    print("POST response: ${response.data}"); // Log the response

    // Check the type of the response and return accordingly
    if (response.data is String) {
      return response.data;
    } else if (response.data is List) {
      return response.data; // Return the list if the response is a list
    } else if (response.data is Map<String, dynamic>) {
      return response.data; // Return the map if the response is a map
    } else {
      throw Exception("Unexpected response type: ${response.data.runtimeType}");
    }
  }

  Future<dynamic> delete({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        "$baseUrl$endPoint",
        queryParameters: queryParameters,
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
