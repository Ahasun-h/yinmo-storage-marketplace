import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/gen/colors.gen.dart';

import '../gen/assets.gen.dart';
import '../networks/endpoints.dart';

class CustomProfileImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  const CustomProfileImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  // Helper to ensure full URL
  String getFullImageUrl(String imageUrl) {
    if (imageUrl.contains(url)) {
      return imageUrl;
    } else {
      return "$url/$imageUrl";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(150.r),
      child: CachedNetworkImage(
        placeholder: (context, url) {
          return CircleAvatar(
            backgroundColor: AppColors.cFFFFFF,
            radius: 20.r,
            child: const Center(
              child: Icon(Icons.person, color: AppColors.cFFFFFF),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return CircleAvatar(
            backgroundColor: AppColors.cFFFFFF,
            radius: 20.r,
            child: Center(
              child: SvgPicture.asset(Assets.icons.profile, fit: BoxFit.cover),
            ),
          );
        },
        imageUrl: getFullImageUrl(imageUrl),
        width: height ?? 40.h,
        height: width ?? 40.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
