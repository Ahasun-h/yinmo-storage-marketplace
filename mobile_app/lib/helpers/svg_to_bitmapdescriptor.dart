// // Source - https://stackoverflow.com/a
// // Posted by rednuht, modified by community. See post 'Timeline' for change history
// // Retrieved 2025-11-14, License - CC BY-SA 4.0

// import 'dart:ui'
//     as ui; // imported as ui to prevent conflict between ui.Image and the Image widget
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:urban_koala/gen/assets.gen.dart';
// // Source - https://stackoverflow.com/a
// // Posted by Matt
// // Retrieved 2025-11-14, License - CC BY-SA 4.0

// String busSvg() {
//   return '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
// <text x="40" y="40" font-size="40" text-anchor="middle" fill="black">🚌</text>
// </svg>''';
// }

// Future<BitmapDescriptor> getSvgIcon() async {
//   final PictureInfo pictureInfo = await vg.loadPicture(
//     SvgAssetLoader(Assets.icons.car),
//     null,
//   );

//   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//   final Canvas canvas = Canvas(pictureRecorder);
//   canvas.drawPicture(pictureInfo.picture);
//   final ui.Image image = await pictureRecorder.endRecording().toImage(100, 100);
//   final ByteData? byteData = await image.toByteData(
//     format: ui.ImageByteFormat.png,
//   );
//   final Uint8List uint8list = byteData!.buffer.asUint8List();

//   return BitmapDescriptor.bytes(uint8list);
// }

// Widget myCustomWidget() {
//   return Container(
//     padding: EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       color: Colors.blue,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Text(
//       'Custom Marker',
//       style: TextStyle(color: Colors.white, fontSize: 16),
//     ),
//   );
// }

// Future<BitmapDescriptor> widgetToBitmapDescriptor(
//   // Widget widget,
//   BuildContext context,
// ) async {
//   // Create a RepaintBoundary widget to capture the rendered widget as an image
//   final boundary = RepaintBoundary();

//   // Create a RenderObject to capture the widget
//   final renderObject = boundary.createRenderObject(myCustomWidget());

//   // Render the widget onto the boundary
//   final image = await renderObject.toImage(
//     pixelRatio: 3.0,
//   ); // Use pixelRatio for quality

//   // Convert the image to byte data (in PNG format)
//   final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//   final uint8List = byteData!.buffer.asUint8List();

//   // Convert the byte array to BitmapDescriptor
//   return BitmapDescriptor.bytes(uint8List);
// }
