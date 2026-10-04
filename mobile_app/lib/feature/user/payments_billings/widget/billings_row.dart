import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

class BillingsRow extends StatelessWidget {
  final bool value;
  final String title;
  final String amount;
  final bool? isSelectAll;
  final void Function(bool?)? onChanged;
  final void Function()? downloadOnTap;
  final void Function()? onTap;
  final Color? color;
  const BillingsRow({
    super.key,
    required this.value,
    required this.title,
    required this.amount,
    this.onChanged,
    this.isSelectAll,
    this.downloadOnTap,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                fillColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primaryColor;
                  }
                  return Colors.white;
                }),
                checkColor: AppColors.cFFFFFF,
                activeColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
                side: BorderSide(color: const Color(0xFFE9E9E9), width: 1.5.w),
                splashRadius: 1.r,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              UIHelper.horizontalSpace(4.w),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF101010),
                  fontSize: 14.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: const Color(0xFF101010),
            fontSize: 14.sp,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isSelectAll == null || isSelectAll == true)
          GestureDetector(
            onTap: downloadOnTap,
            child: SvgPicture.asset(
              Assets.icons.downloadPromaryColor,
              // ignore: deprecated_member_use
              color: color,
            ),
          ),
      ],
    );
  }
}
