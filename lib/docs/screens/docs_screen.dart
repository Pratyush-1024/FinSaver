// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:budget_tracker/constants/utils.dart';
import 'package:path/path.dart' as path;
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/docs/services/docs_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:budget_tracker/providers/user_provider.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  List<Map<String, dynamic>> documents = [];

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    try {
      List<Map<String, dynamic>> loadedDocuments =
          await DocumentService.getAllDocuments(context);
      setState(() {
        documents = loadedDocuments;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> uploadDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileName = path.basename(file.path);
      String fileSize = await file.length().then((value) => value.toString());

      try {
        await DocumentService.uploadDocument(
          context: context,
          filePath: file.path,
          fileName: fileName,
          fileSize: fileSize,
        );
        loadDocuments();
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      await DocumentService.deleteDocument(
        context: context,
        documentId: documentId,
      );
      loadDocuments(); // Refresh documents list after delete
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

  void showImageDialog(BuildContext context, String imageUrl) async {
    final imageData = await fetchImage(context, imageUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageData != null
                    ? Image.memory(imageData)
                    : const Icon(Icons.broken_image),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColorGradient,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to the Document Management Screen! Here you can efficiently manage your documents.',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: documents.isEmpty
                  ? const Center(
                      child: Text('No documents available.'),
                    )
                  : ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> document = documents[index];

                        return ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              if (document['fileUrl'] != null) {
                                showImageDialog(context, document['fileUrl']);
                              }
                            },
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: FutureBuilder<Uint8List?>(
                                future:
                                    fetchImage(context, document['fileUrl']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError ||
                                      !snapshot.hasData) {
                                    return const Icon(Icons.broken_image);
                                  } else {
                                    return Image.memory(snapshot.data!);
                                  }
                                },
                              ),
                            ),
                          ),
                          title: Text(document['fileName']),
                          subtitle: Text('Size: ${document['fileSize']} bytes'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteDocument(document['_id']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0, right: 8.0),
        child: FloatingActionButton(
          onPressed: uploadDocument,
          tooltip: 'Upload Document',
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
