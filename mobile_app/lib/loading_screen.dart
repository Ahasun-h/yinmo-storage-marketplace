import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/feature/host/navigation/host_navigation_screen.dart';
import 'package:urban_koala/navigation_screen.dart';
import 'package:urban_koala/networks/api_access.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/feature/common_features/authentication/login/presaentation/login_screen.dart';
import 'package:urban_koala/welcome_screen.dart';
import 'feature/host/basic_information/presentation/basic_information_screen.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;

  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  loadInitialData() async {
    await setInitValue();
    bool data = appData.read(kKeyIsLoggedIn) ?? false;

    log("==== $data");
    log("==== ${appData.read(kKeyStatus)}");
    if (data) {
      String token = await appData.read(kKeyAccessToken);
      DioSingleton.instance.update(token);
      postFcmTokenRxOBJ.postFcmToken();
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const WelcomeScreen();
    } else {
      return appData.read(kKeyIsLoggedIn)
          ? appData.read(kKeyUserType) == "user"
              ? NavigationScreen()
              : appData.read(kKeyStatus) == "approved"
                  ? HostNavigationScreen()
                  : BasicInformationScreen()
          : const LoginScreen();
    }
  }
}
