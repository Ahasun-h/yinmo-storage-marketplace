// ignore_for_file: deprecated_member_use

import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

Future<void> urlLunch(String url) async {
  if (Platform.isIOS) {
    await launch(url, forceSafariVC: false);
  } else {
    await launch(url, forceWebView: false);
  }
}
