import 'package:dio/dio.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/model/verify_model.dart';
import 'package:urban_koala/networks/dio/dio.dart';
import 'package:urban_koala/networks/endpoints.dart';
import 'package:urban_koala/networks/exception_handler/data_source.dart';

final class ForgetPassOtpVerifyApi {
  static final ForgetPassOtpVerifyApi _singleton =
      ForgetPassOtpVerifyApi._internal();
  ForgetPassOtpVerifyApi._internal();
  static ForgetPassOtpVerifyApi get instance => _singleton;

  Future<OtpVerifyModel> forgetPassOtpVerifyApi({
    required String email,
    required String otp,
  }) async {
    try {
      FormData data = FormData.fromMap({"email": email, "otp": otp});

      Response response = await postHttp(Endpoints.otpCheck(), data);

      if (response.statusCode == 200) {
        final data = OtpVerifyModel.fromJson(response.data);
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
