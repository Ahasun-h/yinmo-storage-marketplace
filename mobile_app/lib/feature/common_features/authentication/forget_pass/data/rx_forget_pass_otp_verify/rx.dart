// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/data/rx_forget_pass_otp_verify/api.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/model/verify_model.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/toast.dart';
import 'package:urban_koala/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';

final class ForgetPassOtpVerifyRX extends RxResponseInt<OtpVerifyModel> {
  final api = ForgetPassOtpVerifyApi.instance;

  ForgetPassOtpVerifyRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> forgetPassOtpVerifyRX({
    required String email,
    required String otp,
  }) async {
    try {
      OtpVerifyModel data = await api.forgetPassOtpVerifyApi(
        email: email,
        otp: otp,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
    }
  }

  @override
  handleSuccessWithReturn(OtpVerifyModel data) {
    appData.write(resetPassToken, data.data?.resetPasswordToken);
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
