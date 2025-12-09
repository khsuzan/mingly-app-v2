import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mingly/src/constant/app_urls.dart';

// Import AppUrls

class ApiService {
  // Constructor no longer needs to pass baseUrl because it's now in AppUrls
  ApiService._();
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  Future<Map<String, dynamic>> postDataRegular(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? queryParams,
    String? authToken,
  }) async {
    // Construct the URI with query parameters if any
    Uri uri = Uri.parse('${AppUrls.baseUrl}$endpoint');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    // Create headers for the POST request
    Map<String, String> headers = {
      'Content-Type': 'application/json', // Set content type to JSON
    };

    // Add Authorization header if authToken is provided
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    // Encode the data to JSON format
    String body = json.encode(data);

    // Make the POST request using http.post
    final response = await http.post(uri, headers: headers, body: body);
    if (kDebugMode) {
      print("Post Api Regular ${response.body}");
    }
    // Handle the response based on the status code or other logic
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Successfully received a response, parse the response body
      return _handleResponse(response);
    } else {
      // Handle different HTTP error status codes
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> postDataOrThrow(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? queryParams,
    String? authToken,
  }) async {
    try {
      Uri uri = Uri.parse('${AppUrls.baseUrl}$endpoint');
      if (queryParams != null) uri = uri.replace(queryParameters: queryParams);

      final headers = {'Content-Type': 'application/json'};
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final body = json.encode(data);
      final response = await http.post(uri, headers: headers, body: body);

      if (kDebugMode) print("Post Api Regular ${response.body}");

      // Try to parse body safely
      Map<String, dynamic>? decoded;
      try {
        decoded = json.decode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        decoded = {'body': response.body};
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded ?? {};
      }

      // For 400/other errors, throw so caller's try/catch can handle it
      final message =
          decoded ??
          {'error': 'Request failed with status ${response.statusCode}'};
      throw Exception({'status': response.statusCode, 'response': message});
    } catch (e) {
      // Re-throw so callers receive the exception
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postDataRegular2(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? queryParams,
    String? authToken,
  }) async {
    try {
      // Construct the URI with query parameters if any
      Uri uri = Uri.parse('${AppUrls.baseUrl}$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      // Create headers for the POST request
      Map<String, String> headers = {
        'Content-Type':
            'application/x-www-form-urlencoded', // Set content type to form-urlencoded
      };

      // Add Authorization header if authToken is provided
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      // Encode the data to JSON format
      String body = json.encode(data);

      // Make the POST request using http.post
      final response = await http.post(uri, headers: headers, body: body);

      // Handle the response based on the status code or other logic
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successfully received a response, parse the response body
        return _handleResponse(response);
      } else if (response.statusCode == 400) {
        return _handleResponse(response);
      } else {
        // Handle different HTTP error status codes
        return _handleError(
          'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle any exception during the request
      return _handleError('An unexpected error occurred: $e');
    }
  }

  // POST Request - Add Data
  Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? queryParams,
    File? image,
    String? authToken,
    String imageParamNam = "image",
  }) async {
    try {
      Uri uri = Uri.parse('${AppUrls.baseUrl}$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }
      var request;
      if (image == null) {
        request = http.Request('POST', uri);

        request.headers['Content-Type'] = 'application/json';
        request.body = json.encode(data);
      } else {
        request = http.MultipartRequest('POST', uri);

        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        var fileStream = http.MultipartFile(
          imageParamNam,
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.uri.pathSegments.last,
        );
        request.files.add(fileStream);
      }

      if (authToken != null && authToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await request.send();

      final responseBody = await http.Response.fromStream(response);
      print("Data reposen : ${responseBody.body}");
      // Return the parsed response
      return _handleResponse(responseBody);
    } on http.ClientException catch (e) {
      return _handleError('Network error: ${e.message}');
    } catch (e) {
      return _handleError('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> patchData(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? queryParams,
    File? image,
    String? authToken,
  }) async {
    try {
      Uri uri = Uri.parse('${AppUrls.baseUrl}$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }
      var request;
      if (image == null) {
        request = http.Request('PATCH', uri);

        request.headers['Content-Type'] = 'application/json';
        request.body = json.encode(data);
      } else {
        request = http.MultipartRequest('PATCH', uri);

        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        final imageBytes = await image.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'avatar',
          imageBytes,
          filename: image.uri.pathSegments.last,
        );
        request.files.add(multipartFile);
      }

      if (authToken != null && authToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await request.send();

      final responseBody = await http.Response.fromStream(response);

      // Return the parsed response
      return _handleResponse(responseBody);
    } on http.ClientException catch (e) {
      return _handleError('Network error: ${e.message}');
    } catch (e) {
      return _handleError('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getData(
    String endpoint, {
    String? authToken,
  }) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};

      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await http.get(
        Uri.parse('${AppUrls.baseUrl}$endpoint'),
        headers: headers,
      );
      if (kDebugMode) {
        print("Regular Get Data ${response.body}");
      }
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      return _handleError('Network error: ${e.message}');
    } catch (e) {
      return _handleError('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getOrThrow(
    String endpoint, {
    String? authToken,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final response = await http.get(
      Uri.parse('${AppUrls.baseUrl}$endpoint'),
      headers: headers,
    );
    if (kDebugMode) {
      print("Regular Get Data ${response.body}");
    }
    if (response.statusCode >= 400) {
      throw Exception(response.body);
    }
    return json.decode(response.body);
  }

  Future<List<dynamic>> getList(String endpoint, {String? authToken}) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};

      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }
      final url = '${AppUrls.baseUrl}$endpoint';
      final response = await http.get(Uri.parse(url), headers: headers);

      if (kDebugMode) {
        print("Get List from: $url\n Response: ${response.body}");
      }

      return _handleListResponse(response);
    } on http.ClientException catch (e) {
      return _handleErrorList('Network error: ${e.message}');
    } catch (e) {
      return _handleErrorList('An unexpected error occurred: $e');
    }
  }

  Future<List<dynamic>> getListOrThrow(
    String endpoint, {
    String? authToken,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final response = await http.get(
      Uri.parse('${AppUrls.baseUrl}$endpoint'),
      headers: headers,
    );

    if (kDebugMode) {
      print("Get List Response: ${response.body}");
    }

    if (response.statusCode >= 400) {
      throw Exception(response.body);
    }
    return json.decode(response.body) as List<dynamic>;
  }

  List<dynamic> _handleListResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        // Parse the response body as a list
        return json.decode(response.body) as List<dynamic>;
      } catch (e) {
        return _handleErrorList('Failed to parse response body: $e');
      }
    } else {
      return _handleErrorList('Failed to load data: ${response.statusCode}');
    }
  }

  List<dynamic> _handleErrorList(String error) {
    // Handle error, you could throw an exception or return an empty list, depending on your use case
    print(error);
    return [];
  }

  // DELETE Request - Delete Data by ID
  Future<Map<String, dynamic>> deleteData(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppUrls.baseUrl}$endpoint'),
      );

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      return _handleError('Network error: ${e.message}');
    } catch (e) {
      return _handleError('An unexpected error occurred: $e');
    }
  }

  // DELETE Request - Delete Data by ID
  Future<Map<String, dynamic>> deleteDataOrThrow(
    String endpoint, {
    String? authToken,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final response = await http.delete(
      Uri.parse('${AppUrls.baseUrl}$endpoint'),
      headers: headers,
    );
    if (response.statusCode >= 400) {
      throw Exception(response.body);
    }
    return json.decode(response.body);
  }

  // Helper method to handle the HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return json.decode(response.body); // Successfully decode the response
      } catch (e) {
        return _handleError('Failed to parse response: $e');
      }
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      try {
        return json.decode(response.body); // Successfully decode the response
      } catch (e) {
        return _handleError('Failed to parse response: $e');
      }
    } else {
      return _handleErrorForStatusCode(response.statusCode, response.body);
    }
  }

  // Handle errors based on the status code
  _handleErrorForStatusCode(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        return {body};
      case 401:
        return {body};
      case 403:
        return {body};
      case 404:
        return {body};
      case 500:
        return {body};
      case 502:
        return {body};
      case 503:
        return {body};
      case 504:
        return {body};
      default:
        return {body};
    }
  }

  // Handle generic errors
  Map<String, dynamic> _handleError(String errorMessage) {
    return {'error': errorMessage};
  }
}
