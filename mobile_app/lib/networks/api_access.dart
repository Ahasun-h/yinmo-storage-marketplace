import 'package:urban_koala/feature/common_features/authentication/login/data/rx_post_set_fcm_token/rx.dart';
import 'package:urban_koala/feature/common_features/notification/data/rx_get_notification/rx.dart';
import 'package:urban_koala/feature/common_features/notification/data/rx_mark_read/rx.dart';
import 'package:urban_koala/feature/common_features/notification/model/notification_model.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/data/rx_create_pass/rx.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/data/rx_forget_pass/rx.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/data/rx_forget_pass_otp_verify/rx.dart';
import 'package:urban_koala/feature/common_features/authentication/forget_pass/model/verify_model.dart';
import 'package:urban_koala/feature/common_features/authentication/login/data/rx_login/rx.dart';
import 'package:urban_koala/feature/common_features/authentication/login/data/rx_post_logout/rx.dart';
import 'package:urban_koala/feature/common_features/authentication/login/model/login_response_model.dart';
import 'package:urban_koala/feature/common_features/authentication/signup/data/rx_signup/rx.dart';
import 'package:urban_koala/feature/common_features/authentication/signup/model/signup_model.dart';
import 'package:urban_koala/feature/host/listings/data/rx_get_listingList/rx.dart';

import 'package:urban_koala/feature/host/mybooking/data/rx_get_my_booking_list/rx.dart';
import 'package:urban_koala/feature/host/mybooking/data/rx_get_single_booking/rx.dart';
import 'package:urban_koala/feature/user/mybooking/data/rx_get_single_booking/rx.dart';
import 'package:urban_koala/feature/user/help_support/data/rx.dart';
import 'package:urban_koala/feature/user/home/data/rx_post_search_by_item/rx.dart';
import 'package:urban_koala/feature/user/payments_billings/data/rx_post_booking_invoice_download/rx.dart';
import 'package:urban_koala/feature/common_features/profie_info/data/rx_get_vehicle_info/rx.dart';
import 'package:urban_koala/feature/common_features/profie_info/data/rx_post_profile_update/rx.dart';
import 'package:urban_koala/feature/common_features/profie_info/data/rx_post_vahicle_updat/rx.dart';
import 'package:urban_koala/feature/user/security/data/rx_change_password/rx.dart';
import 'package:urban_koala/feature/user/security/data/rx_post_delete/rx.dart';
import 'package:rxdart/rxdart.dart';

import '../feature/common_features/notification/data/rx_notification_stream/rx.dart';
import '../feature/host/add_listing/data/rx_post_listing_add/rx.dart';
import '../feature/host/edit_listing/data/rx_post_listing_update/rx.dart';
import '../feature/host/basic_information/data/rx_post_basic_information/rx.dart';
import '../feature/host/home/data/rx_post_deshboard_data/rx.dart';
import '../feature/host/listing_details/data/rx_get_delete/rx.dart';
import '../feature/host/listing_details/data/rx_get_listing_details.dart/rx.dart';
import '../feature/host/listing_details/data/rx_post_review_get/rx.dart';
import '../feature/host/stripe_confirmation/data/rx_get_strip_data/rx.dart';
import '../feature/user/booking_details/data/rx_post_booking_cancle_request_submit/rx.dart';
import '../feature/user/booking_form/data/rx_get_booking_info/rx.dart';
import '../feature/user/booking_form/data/rx_post_booking_date/rx.dart';
import '../feature/user/booking_form/data/rx_post_booking_store/rx.dart';
import '../feature/user/home/data/rx_get_single_list_details/rx.dart';
import '../feature/user/home/data/rx_post_map/rx.dart';
import '../feature/user/item_details/data/rx_distance_get/rx.dart';
import '../feature/user/item_details/data/rx_get_item_details/rx.dart';
import '../feature/user/item_details/data/rx_post_item_review_get/rx.dart';
import '../feature/user/booking_details/data/rx_get_booking_cancel_reason/rx.dart';
import '../feature/common_features/chat_list/data/rx_get_all_chats/rx.dart';
import '../feature/common_features/messaging/data/rx_get_conversation/rx.dart';
import '../feature/common_features/messaging/data/rx_post_chat_msg/rx.dart';
import '../feature/user/mybooking/data/rx_post_my_booking_list/rx.dart';
import '../feature/user/mybooking/data/rx_post_review/rx.dart';
import '../feature/user/payments_billings/data/rx_get_booking_invoicList/rx.dart';
import '../feature/common_features/profie_info/data/rx_get_profile/rx.dart';
import '../feature/common_features/profile/data/rx_post_profile_image/rx.dart';
import '../feature/common_features/profile/data/rx_post_switch_account/rx.dart';

// signin
import 'package:urban_koala/feature/user/faq/data/rx_get_faq/rx.dart';
import 'package:urban_koala/feature/user/faq/model/faq_model.dart';

LogInRX logInRXOBJ = LogInRX(
  empty: LoginResponseModel(),
  dataFetcher: BehaviorSubject<LoginResponseModel>(),
);

// Logout
LogoutRx logoutRxOBJ = LogoutRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

// SignupRX
SignupRX signupRXOBJ = SignupRX(
  empty: SignUpResponseModel(),
  dataFetcher: BehaviorSubject<SignUpResponseModel>(),
);

// ForgetPassRX
ForgetPassRX forgetPassRXOBJ = ForgetPassRX(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

// ForgetPassRX
ForgetPassOtpVerifyRX forgetPassOtpVerifyRXOBJ = ForgetPassOtpVerifyRX(
  empty: OtpVerifyModel(),
  dataFetcher: BehaviorSubject<OtpVerifyModel>(),
);

// CreatePassRX
CreatePassRX createPassRXOBJ = CreatePassRX(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

// UpdatePasswordRX
UpdatePasswordRX updatePasswordRXOBJ = UpdatePasswordRX(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

// GetProfileRX
GetProfileRx getProfileRxOBJ = GetProfileRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
// PostProfileUpdateRX
PostProfileUpdateRx postProfileUpdateRxOBJ = PostProfileUpdateRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
// PostVehicleUpdateRX
PostVehicleUpdateRx postVehicleUpdateRxOBJ = PostVehicleUpdateRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
// GetVehicleInfoRX
GetVehicleInfoRx getVehicleInfoRxOBJ = GetVehicleInfoRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
// PostHelpSupportRX
PostHelpSupportRx postHelpSupportRxOBJ = PostHelpSupportRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
// PostProfileImageRX
PostProfileImageRx postProfileImageRxOBJ = PostProfileImageRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostBasicInformationRx postBasicInformationRxOBJ = PostBasicInformationRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetStripInfoRx getStripInfoRxOBJ = GetStripInfoRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostListingAddRx postListingAddRxOBJ = PostListingAddRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostListingUpdateRx postListingUpdateRxOBJ = PostListingUpdateRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetListingListRx getListingListRxOBJ = GetListingListRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostDeshboardDataRx postDeshboardDataRxOBJ = PostDeshboardDataRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetListingDetailsRx getListingDetailsRxOBJ = GetListingDetailsRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostReviewRetingGetRx postReviewRetingGetRxOBJ = PostReviewRetingGetRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetDeleteListingRx getDeleteListingRxOBJ = GetDeleteListingRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostMapDataRx postMapDataRxOBJ = PostMapDataRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetSingleListDetailsRx getSingleListDetailsRxOBJ = GetSingleListDetailsRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostItemReviewRetingGetRx postItemReviewRetingGetRxOBJ =
    PostItemReviewRetingGetRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
GetItemDetailsRx getItemDetailsRxOBJ = GetItemDetailsRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetDistanceRx getDistanceRxOBJ = GetDistanceRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetBookingInfoRx getBookingInfoRxOBJ = GetBookingInfoRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostSwitchAccountRx postSwitchAccountRxOBJ = PostSwitchAccountRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostBookingDateRx postBookingDateRxOBJ = PostBookingDateRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostBookingStoreRx postBookingStoreRxOBJ = PostBookingStoreRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostMyBookingListRx postMyBookingListRxOBJ = PostMyBookingListRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostReviewRx postReviewRxOBJ = PostReviewRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetBookingInvoiceListRx getBookingInvoiceListRxOBJ = GetBookingInvoiceListRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetBookingCancelReasonRx getBookingCancelReasonRxOBJ = GetBookingCancelReasonRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostBookingCancleRequestSubmitRx postBookingCancleRequestSubmitRxOBJ =
    PostBookingCancleRequestSubmitRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostChatMsgRx postChatMsgRxOBJ = PostChatMsgRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetAllChatsRx getAllChatsRxOBJ = GetAllChatsRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
GetConversationRx getConversationRxOBJ = GetConversationRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostAccountDeleteRx postAccountDeleteRxOBJ = PostAccountDeleteRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);
PostBookingDownlaodRx postBookingDownlaodRxOBJ = PostBookingDownlaodRx(
  empty: {},
  dataFetcher: BehaviorSubject<dynamic>(),
);
PostSearchByItemRx postSearchByItemRxOBJ = PostSearchByItemRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetNotificationRx getNotificationRxOBJ = GetNotificationRx(
  empty: NotificationRes(),
  dataFetcher: BehaviorSubject<NotificationRes>(),
);

MarkNotificationReadRx markNotificationReadRxOBJ = MarkNotificationReadRx(
  empty: {},
  dataFetcher: BehaviorSubject<dynamic>(),
);
NotificationRx notificationRxObj = NotificationRx(
  hasNotification: BehaviorSubject<bool>.seeded(false),
);

PostFcmTokenRx postFcmTokenRxOBJ = PostFcmTokenRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetHostBookingListRx getHostBookingListRxOBJ = GetHostBookingListRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetSingleBookingHostRx getSingleBookingHostRxOBJ = GetSingleBookingHostRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetSingleBookingGuestRx getSingleBookingGuestRxOBJ = GetSingleBookingGuestRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

GetFaqRx getFaqRxOBJ = GetFaqRx(
  empty: FaqRes(),
  dataFetcher: BehaviorSubject<FaqRes>(),
);
