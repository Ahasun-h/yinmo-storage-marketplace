import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetBookingInvoiceListApi {
  static final GetBookingInvoiceListApi _singleton =
      GetBookingInvoiceListApi._internal();
  GetBookingInvoiceListApi._internal();
  static GetBookingInvoiceListApi get instance => _singleton;

  Future<Map> getBookingInvoiceList() async {
    try {
      Response response = await getHttp(Endpoints.bookingInvoice());
      if (response.statusCode == 200) {
        Map data = json.decode(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
