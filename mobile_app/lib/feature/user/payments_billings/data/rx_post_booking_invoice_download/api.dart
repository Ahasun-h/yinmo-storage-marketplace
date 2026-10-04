import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostBookingDownlaodApi {
  static final PostBookingDownlaodApi _singleton =
      PostBookingDownlaodApi._internal();
  PostBookingDownlaodApi._internal();
  static PostBookingDownlaodApi get instance => _singleton;

  Future<dynamic> postBookingDownlaod(Map<String, dynamic> data) async {
    try {
      Response response = await DioSingleton.instance.dio.post(
        Endpoints.bookingDownloadInvoice(),
        data: FormData.fromMap(data),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
