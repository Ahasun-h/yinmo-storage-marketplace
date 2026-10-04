import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/constants/text_font_style.dart';

class CustomViewAll extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const CustomViewAll({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF202020),
            fontSize: 16.sp,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text('View All',
                style: TextFontStyle.text14primaryColorw500inter),
          ),
      ],
    );
  }
}

// class FilterItems {
//   final IconData icon;
//   final String name;
//   FilterItems({required this.icon, required this.name});
// }
