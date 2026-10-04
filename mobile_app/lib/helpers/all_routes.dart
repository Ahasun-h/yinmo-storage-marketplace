// ignore_for_file: unreachable_switch_case, unused_element

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:urban_koala/feature/common_features/notification/presentation/notification_screen.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/presaentation/create_pass_screen.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/presaentation/forget_pass_screen.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/presaentation/verify_screen.dart';
import 'package:urban_koala/feature/common_features/authentication/login/presaentation/login_screen.dart';
import 'package:urban_koala/feature/common_features/authentication/signup/presaentation/signup_screen.dart';
import 'package:urban_koala/feature/host/add_listing/presentation/add_listing_screen.dart';
import 'package:urban_koala/feature/host/basic_information/presentation/basic_information_screen.dart';
import 'package:urban_koala/feature/host/listing_details/presentation/listing_details_screen.dart';
import 'package:urban_koala/feature/host/mybooking/presentation/host_booking_screen.dart';
import 'package:urban_koala/feature/host/navigation/host_navigation_screen.dart';
import 'package:urban_koala/feature/host/stripe_confirmation/presentation/stripe_confirmation_screen.dart';
import 'package:urban_koala/feature/host/stripe_connect/presentation/stripe_connect_screen.dart';
import 'package:urban_koala/feature/user/all_item/presentation/all_item_screen.dart';
import 'package:urban_koala/feature/user/booking_details/presentation/booking_details_screen.dart';
import 'package:urban_koala/feature/user/booking_form/presentation/booking_form_screen.dart';
import 'package:urban_koala/feature/user/checkout/presentation/check_out_screen.dart';
import 'package:urban_koala/feature/user/help_support/presentation/help_support_screen.dart';
import 'package:urban_koala/feature/user/home/model/map_data_model.dart';
import 'package:urban_koala/feature/user/item_details/presentation/item_details_screen.dart';
import 'package:urban_koala/feature/common_features/messaging/presentation/messaging_screen.dart';
import 'package:urban_koala/feature/user/notification_preference/presentation/notification_preferance_screen.dart';
import 'package:urban_koala/feature/user/payments_billings/presentation/payments_billings_screen.dart';
import 'package:urban_koala/feature/common_features/profie_info/presentation/profile_info_screeen.dart';
import 'package:urban_koala/feature/user/security/presentation/security_screen.dart';
import 'package:urban_koala/navigation_screen.dart';

import '../feature/host/edit_listing/presentation/edit_listing_screen.dart';
import '../feature/user/mybooking/model/my_booking_list_model.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;
  static const String navigation = '/navigation';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String forgetPass = '/forgetPass';
  static const String verify = '/verify';
  static const String createPass = '/createPass';
  static const String allItem = '/allItem';
  static const String itemDetails = '/itemDetails';
  static const String bookingForm = '/bookingForm';
  static const String checkOut = '/checkOut';
  static const String bookingDetails = '/bookingDetails';
  static const String messaging = '/messaging';
  static const String profileInfo = '/profileInfo';
  static const String notificationPreferance = '/notificationPreferance';
  static const String security = '/security';
  static const String paymentsBillings = '/paymentsBillings';
  static const String helpSupport = '/helpSupport';
  static const String basicInformation = '/basicInformation';
  static const String stripeConnect = '/stripeConnect';
  static const String stripeConfirmation = '/stripeConfirmation';
  static const String hostNavigation = '/hostNavigation';
  static const String listingDetails = '/listingDetails';
  static const String addListing = '/addListing';
  static const String notificationList = '/notificationList';
  static const String editListing = '/editListing';
  static const String hostBooking = '/hostBooking';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.addListing:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: AddListingScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => AddListingScreen());
      case Routes.listingDetails:
        int arg = settings.arguments as int;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(
                  widget: ListingDetailsScreen(listingId: arg),
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => ListingDetailsScreen(listingId: arg),
              );
      case Routes.hostNavigation:
        int? arg = settings.arguments as int?;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: HostNavigationScreen(pageNum: arg)),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => HostNavigationScreen(pageNum: arg));
      case Routes.stripeConfirmation:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: StripeConfirmationScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => StripeConfirmationScreen(),
              );
      case Routes.stripeConnect:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: StripeConnectScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => StripeConnectScreen());
      case Routes.basicInformation:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: BasicInformationScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BasicInformationScreen(),
              );
      case Routes.helpSupport:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: HelpSupportScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => HelpSupportScreen());
      case Routes.paymentsBillings:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: PaymentsBillingsScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => PaymentsBillingsScreen(),
              );
      case Routes.security:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: SecurityScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => SecurityScreen());
      case Routes.notificationPreferance:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: NotificationPreferanceScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => NotificationPreferanceScreen(),
              );
      case Routes.profileInfo:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: ProfileInfoScreeen()),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => ProfileInfoScreeen());
      case Routes.createPass:
        Map arg = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(
                  widget: CreatePassScreen(email: arg["email"]),
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => CreatePassScreen(email: arg["email"]),
              );
      case Routes.verify:
        Map arg = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: VerifyScreen(email: arg["email"])),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => VerifyScreen(email: arg["email"]),
              );
      case Routes.forgetPass:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: ForgetPassScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => ForgetPassScreen());
      case Routes.signUp:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: SignupScreen()),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => SignupScreen());
      case Routes.login:
        Map? args = settings.arguments as Map?;
        bool isFromAuthHole = args?['isFromAuthHole'] ?? false;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(
                    widget: LoginScreen(isFromAuthHole: isFromAuthHole)),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) =>
                    LoginScreen(isFromAuthHole: isFromAuthHole));
      case Routes.messaging:
        Map<String, dynamic>? arg = settings.arguments as Map<String, dynamic>?;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: MessagingScreen(arg: arg)),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => MessagingScreen(arg: arg),
              );
      case Routes.bookingDetails:
        dynamic args = settings.arguments;
        MyBookingListModel? model;
        String? bookingId;

        if (args is MyBookingListModel) {
          model = args;
        } else if (args is Map) {
          if (args['model'] != null) model = args['model'];
          if (args['bookingId'] != null) bookingId = args['bookingId'];
        }

        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(
                  widget: BookingDetailsScreen(
                      myBookingListModel: model, bookingId: bookingId),
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BookingDetailsScreen(
                    myBookingListModel: model, bookingId: bookingId),
              );
      case Routes.checkOut:
        Map<String, dynamic>? arg = settings.arguments as Map<String, dynamic>?;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: CheckOutScreen(jsonData: arg)),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => CheckOutScreen(jsonData: arg),
              );
      case Routes.bookingForm:
        int? arg = settings.arguments as int?;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: BookingFormScreen(itemId: arg)),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BookingFormScreen(itemId: arg),
              );
      case Routes.itemDetails:
        int? arg = settings.arguments as int?;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: ItemDetailsScreen(itemId: arg)),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => ItemDetailsScreen(itemId: arg),
              );
      case Routes.allItem:
        MapDataRes? mapDataRes = settings.arguments as MapDataRes?;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(
                  widget: AllItemScreen(mapDataRes: mapDataRes),
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => AllItemScreen(mapDataRes: mapDataRes),
              );
      case Routes.navigation:
        int? arg = settings.arguments as int?;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(widget: NavigationScreen(pageNum: arg)),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => NavigationScreen(pageNum: arg),
              );
      case Routes.notificationList:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(
                  widget: NotificationScreen(),
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => NotificationScreen(),
              );
      case Routes.editListing:
        int listingId = settings.arguments as int;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(
                  widget: EditListingScreen(listingId: listingId),
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => EditListingScreen(listingId: listingId),
              );
      case Routes.hostBooking:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ScreenTitle(
                  widget: HostBookingScreen(),
                ),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => HostBookingScreen(),
              );

      default:
        return null;
    }
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
      : super(
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 1),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
          transitionDuration: const Duration(milliseconds: 1),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
              child: child,
            );
          },
        );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
