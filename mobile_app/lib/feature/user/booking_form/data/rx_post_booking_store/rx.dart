import 'package:dio/dio.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../helpers/di.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostBookingStoreRx extends RxResponseInt {
  final api = PostBookingStoreApi.instance;

  String message = "Something went wrong";

  PostBookingStoreRx({required super.empty, required super.dataFetcher});

  ValueStream get filleData => dataFetcher.stream;

  Future<bool> post(String data) async {
    try {
      Map resdata = await api.postBookingStore(data);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    appData.write(kKeyClientSecret, data['data']['client_secret']);
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        Future.delayed(const Duration(milliseconds: 100), () {
          NavigationService.navigateToUntilReplacement(Routes.login);
        });
      }
      message =
          error.response?.data["message"].toString() ?? "Something went wrong";
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return false;
  }
}
