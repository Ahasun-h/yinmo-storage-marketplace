// ignore_for_file: constant_identifier_names, non_constant_identifier_names

const String url = "https://backend.urbankoala.app";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();
  static String logIn() => "/api/user-login";
  // static String logInWithParams() =>
  //     "/api/user-login?email=md12502077ms@gmail.com&password=12345678";
  static String signUp() => "/api/user-signup";
  static String logout() => "/api/user-logout";
  static String switchAccount() => "/api/switch/account";
  static String forgetPassword() => "/api/forget/password";
  static String resetPassword() => "/api/reset/password";
  static String changePassword() => "/api/change/password";
  static String resendOtp() => "/api/resend/otp";
  static String otpCheck() => "/api/otp/check";

  // Profile
  static String getProfile() => "/api/user/profile/get";
  static String updateProfile() => "/api/user/profile/update";
  static String getProfileImage() => "/api/user/profile/image";
  static String updateProfileImage() => "/api/profile/image/update";

  // Listing
  static String searchListing() => "/api/listing/search/by/place";
  static String addListing() => "/api/listings/store";
  static String updateListing(int id) => "/api/listings/$id";
  static String deleteListing(int id) => "/api/listing/delete/$id";
  static String deleteListingPhoto(String id) =>
      "/api/listing/photo/delete/$id";
  static String getListingDetails(int id) => "/api/single/listing/details/$id";
  static String getGuestListingDetails(int? id) =>
      "/api/guest/listing/details/$id";
  static String allListProvider() => "/api/provider/listings";
  static String typeListSearch() => "/api/guest/search/listing";

  // Booking
  static String bookingStore() => "/api/booking/payment-intent";
  static String bookingDate() => "/api/bookiking/date/slot/box/bike";
  static String myBookingList() => "/api/my/bookings";
  static String cancelBooking() => "/api/my/booking/cancel";
  static String bookingSummary(String bookingId) =>
      "/api/my/booking/summery/$bookingId";
  static String bookingInvoice() => "/api/booking/invoice/user";
  static String singleBooking(String bookingId) =>
      "/api/single/booking/provider/$bookingId";
  static String singleInvoice(String bookingId) =>
      "/api/single/booking/invoice/$bookingId";
  static String bookingBeforeDataShow(int? listingId) =>
      "/api/booking/list/get/$listingId";
  static String bookingStoreData() => "/api/booking/store/data";
  //host booking
  static String hostBookingList() => "/api/provider/booking";

  // Reviews
  static String createReview() => "/api/reviews/store";
  static String updateReview(String id) => "/api/reviews/update/$id";
  static String deleteReview(String id) => "/api/reviews/delete/$id";
  static String listingReview() => "/api/single/listing/reviews";
  static String listingReviewGuest() => "/api/guest/single/listing/reviews";

  // Stripe
  static String stripeSetupStore() => "/api/stripe/set";
  static String getStripe() => "/api/stripe/set/show";
  static String stripeWebhook() => "/api/stripe/webhook";

  // Vehicle
  static String storeVehicle() => "/api/vehicle/store/data";
  static String updateVehicle(String id) => "/api/vehicle/update/$id";
  static String deleteVehicle(String id) => "/api/vehicle/delete/$id";
  static String getVehicleData() => "/api/vechicle/get/data";
  static String showVehicle(String id) => "/api/vehicle/$id";

  // Chat
  static String sendChat() => "/api/chat/send";
  static String getChatList() => "/api/chat/list/data";
  static String getConversation(String? conversationId) =>
      "/api/chat/get/$conversationId";
  static String chatMarkRead(String conversationId) =>
      "/api/chat/mark/read/$conversationId";
  static String chatDelete(String chatId) => "/api/chat/delete/$chatId";
  static String chatImageDelete(String imageId) =>
      "/api/chat/image/delete/$imageId";

  // Support & Help
  static String supportHelpStore() => "/api/support/help/store";

  // Dashboard
  static String dashboardData() => "/api/host/dashboard";

  // Privacy & Terms
  static String privacyPolicy() => "/api/privacy/policy";
  static String termsAndCondition() => "/api/terms/condition";

  // Account
  static String deleteAccount() => "/api/account/delete";

  // cancal booking reason
  static String cancelBookingReason() => "/api/my/booking/reject/data";

  // booking download invoice
  static String bookingDownloadInvoice() => "/api/bulk/invoice/system";

  // Notifications
  static String notificationList() => "/api/all/notification/list";
  static String notificationMarkAllRead() => "/api/all/notification/mark";
  // fcm token
  static String fcmToken() => "/api/fcm/token/store";
  // get distance
  static String getDistance() => "/api/guest/location/distance/user/listing";
  // get distance
  static String faq() => "/api/faq";
}
