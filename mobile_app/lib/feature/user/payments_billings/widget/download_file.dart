// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../helpers/pdf_downloader.dart';
// import '../model/payment_billings_model.dart';

// Future<void> downloadFiles(
//   BuildContext context,
//   List<PaymentBilling> files,
// ) async {
//   if (files.isEmpty) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("No items selected")));
//     return;
//   }

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return _DownloadProgressDialog(files: files);
//     },
//   );
// }

// class _DownloadProgressDialog extends StatefulWidget {
//   final List<PaymentBilling> files;

//   const _DownloadProgressDialog({required this.files});

//   @override
//   State<_DownloadProgressDialog> createState() =>
//       _DownloadProgressDialogState();
// }

// class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
//   double _progress = 0.0;
//   int _currentIndex = 0;
//   final List<String> _downloadedPaths = [];
//   bool _isDownloading = true;

//   @override
//   void initState() {
//     super.initState();
//     _startDownload();
//   }

//   Future<void> _startDownload() async {
//     log('📥 Starting download of ${widget.files.length} files');
//     for (int i = 0; i < widget.files.length; i++) {
//       if (!mounted) return;
//       setState(() {
//         _currentIndex = i;
//         _progress = 0.0;
//       });

//       final file = widget.files[i];
//       final url = file.pdfInvoice ?? "";
//       log('📄 File ${i + 1}: Invoice ID: ${file.id}, URL: $url');

//       if (url.isNotEmpty) {
//         final path = await downloadAndSavePdfDio(url, (received, total) {
//           if (total != -1 && mounted) {
//             setState(() {
//               _progress = received / total;
//             });
//           }
//         }, fileName: "Invoice-File-${file.invoiceId}.pdf");
//         log('💾 Downloaded path: $path');
//         if (path.isNotEmpty) {
//           if (path == "ERROR_404") {
//             log('⚠️ File not found on server for file ${i + 1}');
//             // Continue to next file instead of stopping
//           } else {
//             _downloadedPaths.add(path);
//           }
//         } else {
//           log('⚠️ Download failed for file ${i + 1}');
//         }
//       } else {
//         log('⚠️ Empty URL for file ${i + 1}');
//       }
//     }

//     log(
//       '✅ Download process completed. Downloaded ${_downloadedPaths.length} files',
//     );
//     if (mounted) {
//       setState(() {
//         _isDownloading = false;
//         _progress = 1.0;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(_isDownloading ? 'Downloading...' : 'Download Completed'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (_isDownloading) ...[
//             Text('File ${_currentIndex + 1} of ${widget.files.length}'),
//             SizedBox(height: 8.h),
//             LinearProgressIndicator(value: _progress),
//             SizedBox(height: 8.h),
//             Text('${(_progress * 100).toStringAsFixed(0)}%'),
//           ] else ...[
//             if (_downloadedPaths.isEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Download failed.',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     'The invoice files were not found on the server. Please contact support.',
//                   ),
//                 ],
//               )
//             else ...[
//               Text('Successfully downloaded ${_downloadedPaths.length} files.'),
//               SizedBox(height: 10.h),
//               Text('Saved to:', style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 5.h),
//               Container(
//                 constraints: BoxConstraints(maxHeight: 200.h),
//                 width: double.maxFinite,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: _downloadedPaths
//                         .map(
//                           (path) => Padding(
//                             padding: EdgeInsets.only(bottom: 4.h),
//                             child: Text(
//                               path,
//                               style: TextStyle(fontSize: 12.sp),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ],
//       ),
//       actions: [
//         if (!_isDownloading)
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('Close'),
//           ),
//       ],
//     );
//   }
// }
