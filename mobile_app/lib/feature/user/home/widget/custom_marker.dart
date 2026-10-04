import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class CustomMarker extends StatelessWidget {
  final String? type;
  final dynamic rating;
  final Color? color;
  const CustomMarker({
    super.key,
    required this.type,
    required this.rating,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    String iconPath;
    switch (type) {
      case "parking":
        iconPath = Assets.icons.car;
        break;
      case "bike_rent":
        iconPath = Assets.icons.bike;
        break;
      case "luggage":
        iconPath = Assets.icons.lugaje;
        break;
      default:
        iconPath = Assets.icons.car;
    }

    return Container(
      height: 32.h,
      width: 52.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            color != null
                ? Assets.icons.locationViewRed.path
                : Assets.icons.locationView.path,
          ),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.horizontalSpace(3.w),
            Container(
              padding: EdgeInsets.all(2.h),
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(iconPath, height: 14.h, width: 14.h),
            ),
            Spacer(),
            Text(
              rating?.toString() ?? '',
              style: TextFontStyle.text14c202020w500SFPro.copyWith(
                color: AppColors.cFFFFFF,
              ),
            ),
            UIHelper.horizontalSpace(3.w),
          ],
        ),
      ),
    );
  }
}
