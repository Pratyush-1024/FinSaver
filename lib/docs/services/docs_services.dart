// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:budget_tracker/constants/error_handling.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DocumentService {
  // Base URL for API endpoints
  static String baseUrl = '$uri/api/docs';

  // Upload a document
  static Future<void> uploadDocument({
    required BuildContext context,
    required String filePath,
    required String fileName,
    required String fileSize,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      request.headers['x-auth-token'] = userProvider.user.token;
      request.files.add(http.MultipartFile(
        'document',
        File(filePath).readAsBytes().asStream(),
        int.parse(fileSize),
        filename: fileName,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Get all documents
  static Future<List<Map<String, dynamic>>> getAllDocuments(
      BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var response = await http.get(
        Uri.parse('$baseUrl/getAll'),
        headers: {
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );

      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> documents = data
          .map((e) => {
                '_id': e['_id'].toString(),
                'fileName': e['fileName'].toString(),
                'fileSize': e['fileSize'].toString(),
                'fileUrl': getDocumentUrl(e['fileName'].toString()),
              })
          .toList();

      return documents;
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  // Get a specific document by ID
  static Future<Map<String, dynamic>?> getDocumentById(
      BuildContext context, String documentId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var response = await http.get(
        Uri.parse('$baseUrl/get/$documentId'),
        headers: {
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );

      var data = jsonDecode(response.body);
      return {
        '_id': data['_id'].toString(),
        'fileName': data['fileName'].toString(),
        'fileSize': data['fileSize'].toString(),
        'fileUrl': getDocumentUrl(data['fileName'].toString()),
      };
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

  // Update a document by ID
  static Future updateDocument({
    required BuildContext context,
    required String documentId,
    required Map<String, dynamic> updates,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var response = await http.put(
        Uri.parse('$baseUrl/update/$documentId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(updates),
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Delete a document by ID
  static Future deleteDocument({
    required BuildContext context,
    required String documentId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var response = await http.delete(
        Uri.parse('$baseUrl/delete/$documentId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Uint8List?> fetchImage(BuildContext context, String url) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-auth-token': userProvider.user.token,
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }

  static String getDocumentUrl(String fileName) {
    return '$uri/api/docs/files/$fileName';
  }
}
