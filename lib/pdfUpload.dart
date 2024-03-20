import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfUploaderScreen extends StatefulWidget {
  @override
  _PdfUploaderScreenState createState() => _PdfUploaderScreenState();
}

class _PdfUploaderScreenState extends State<PdfUploaderScreen> {
  File? _selectedPdf;
  String? _pdfUrl;

  void _selectPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File pdfFile = File(result.files.single.path!);
        await _uploadPdfToFirebase(pdfFile);
      }
    } catch (e) {
      print('Error picking PDF file: $e');
    }
  }

  Future<void> _uploadPdfToFirebase(File pdfFile) async {
    try {
      String fileName = basename(pdfFile.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(pdfFile);

      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        _selectedPdf = pdfFile;
        _pdfUrl = downloadUrl;
      });

      print('PDF uploaded to Firebase Storage: $_pdfUrl');
    } catch (e) {
      print('Error uploading PDF to Firebase Storage: $e');
    }
  }

  Future<void> _downloadPdf() async {
    if (_pdfUrl == null) {
      print('No PDF to download');
      return;
    }

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String appDirPath = appDir.path;
      final String fileName = basename(_pdfUrl!); // Get the file name from the URL
      final String filePath = '$appDirPath/$fileName';

      final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.refFromURL(_pdfUrl!);
      final List<int> fileData = (await ref.getData()) as List<int>;
      final File pdfFile = File(filePath);
      await pdfFile.writeAsBytes(fileData);

      print('PDF downloaded to: $filePath');

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded successfully'),
        ),
      );
    } catch (e) {
      print('Error downloading PDF: $e');
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text('Failed to download PDF'),
        ),
      );
    }
  }

  Future<void> _viewPdf() async {
    if (_pdfUrl != null) {
      await launch(_pdfUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectPdf,
              child: Text('Select PDF'),
            ),
            SizedBox(height: 20),
            if (_selectedPdf != null)
              Text('Selected PDF: ${_selectedPdf!.path.split('/').last}'),
            SizedBox(height: 20),
            if (_pdfUrl != null)
              Expanded(
                child: Column(
                  children: [
                    Text('PDF Preview'),
                    SizedBox(height: 10),
                    Flexible(
                      child: PDFView(
                        filePath: _pdfUrl!,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _downloadPdf,
                      child: Text('Download PDF'),
                    ),
                    ElevatedButton(
                      onPressed: _viewPdf,
                      child: Text('View PDF'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
