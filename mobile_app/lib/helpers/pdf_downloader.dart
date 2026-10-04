import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../networks/endpoints.dart';

Future<String> downloadAndSavePdfDio(
  String pdfUrl,
  Function(int received, int total)? onReceiveProgress, {
  required String fileName,
}) async {
  try {
    log('📥 Original URL from API: $pdfUrl');

    // Handle relative URL
    String fullUrl = pdfUrl;
    if (!pdfUrl.startsWith('http://') && !pdfUrl.startsWith('https://')) {
      fullUrl = '$url/$pdfUrl';
      log('🔗 Relative path detected.');
      log('   Base URL: $url');
      log('   Relative path: $pdfUrl');
      log('   Full URL: $fullUrl');
    } else {
      log('🌐 Absolute URL detected: $fullUrl');
    }

    log('🔽 Starting download: $fullUrl');
    // final uri = Uri.parse(fullUrl);

    // Use custom fileName if provided, otherwise extract from URL
    final resolvedFileName = fileName;

    // Detect directory
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = '${directory!.path}/$resolvedFileName';
    log('📁 Save path: $filePath');

    await Dio().download(
      fullUrl,
      filePath,
      onReceiveProgress: onReceiveProgress,
      options: Options(responseType: ResponseType.bytes, followRedirects: true),
    );

    log('✅ Download completed: $filePath');

    if (Platform.isAndroid) {
      log('📱 File saved to Downloads folder');
    }

    return filePath;
  } on DioException catch (e) {
    log('❌ DioException: ${e.message}');
    log('❌ Error type: ${e.type}');

    if (e.response?.statusCode == 404) {
      log('❌ File not found on server (404)');
      return "ERROR_404";
    }

    return "";
  } catch (e) {
    log('❌ Unknown error: $e');
    return "";
  }
}

Future<String> savePdfBytes(
  List<int> bytes, {
  required String fileName,
}) async {
  try {
    log('💾 Saving PDF bytes...');

    // Use custom fileName if provided, otherwise extract from URL
    final resolvedFileNameValue = resolvedFileName(fileName);

    // Detect directory
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = '${directory!.path}/$resolvedFileNameValue';
    log('📁 Save path: $filePath');

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    log('✅ Save completed: $filePath');
    return filePath;
  } catch (e) {
    log('❌ Error saving file: $e');
    return "";
  }
}

String resolvedFileName(String fileName) {
  // Simple check to ensure extension
  if (!fileName.toLowerCase().endsWith('.pdf')) {
    return '$fileName.pdf';
  }
  return fileName;
}
