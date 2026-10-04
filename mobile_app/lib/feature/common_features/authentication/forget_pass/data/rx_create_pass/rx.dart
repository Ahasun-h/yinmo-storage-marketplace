// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/data/rx_create_pass/api.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';

final class CreatePassRX extends RxResponseInt<Map> {
  final api = CreatePassApi.instance;

  CreatePassRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> createPassRX({
    required String newPassword,
    required String confirmPassword,
    required String email,
    required String token,
  }) async {
    try {
      Map data = await api.createPassApi(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        email: email,
        token: token,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
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
