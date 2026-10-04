// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:urban_koala/common_widgets/background.dart';
// import 'package:urban_koala/gen/assets.gen.dart';
// import 'package:urban_koala/gen/colors.gen.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.cF3F4F6,
//       body: Background(
//         child: Center(
//           child: Image.asset(
//             Assets.images.appLogo.path,
//             width: 300.w,
//             height: 200.h,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/background.dart';
import 'package:urban_koala/gen/assets.gen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _scale),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Image.asset(
              Assets.images.appLogo.path,
              width: 300.w,
              height: 200.h,
            ),
          ),
        ),
      ),
    );
  }
}
