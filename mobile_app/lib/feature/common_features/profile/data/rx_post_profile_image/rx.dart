import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart' as path;
import '../../../../../common_widgets/custom_toast.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostProfileImageRx extends RxResponseInt {
  final api = PostProfileImageApi.instance;

  String message = "Something went wrong";

  PostProfileImageRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> post({XFile? imageFile}) async {
    try {
      if (imageFile == null) {
        customToastMessage('Error', 'No image selected');
        return false;
      }

      // Create multipart file
      final String fileName = path.basename(imageFile.path);
      final MultipartFile multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      );

      // Build form data
      final FormData formData = FormData.fromMap({
        'profile_image': multipartFile,
      });

      Map resdata = await api.post(formData);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error.response?.statusCode == 401) {
      Future.delayed(const Duration(milliseconds: 100), () {
        NavigationService.navigateToUntilReplacement(Routes.login);
      });
    }
    if (error is DioException) {
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
