// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/data/rx_forget_pass/api.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/networks/rx_base.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';

final class ForgetPassRX extends RxResponseInt<Map> {
  final api = ForgetPassApi.instance;

  ForgetPassRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> forgetPassRX({required String email}) async {
    try {
      Map data = await api.forgetPassApi(email: email);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error.response?.statusCode == 401) {
      Future.delayed(const Duration(milliseconds: 100), () {
        NavigationService.navigateToUntilReplacement(Routes.login);
      });
    }
    if (error is DioException) {
      if (error.response!.statusCode == 400) {
        ToastUtil.showShortToast(error.response!.data["error"]);
      } else {
        ToastUtil.showShortToast(error.response!.data["message"]);
      }
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
