import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';

import '../../../../common_widgets/custom_profile_image.dart';
import '../../../../helpers/helper_methods.dart';
import '../../../../networks/api_access.dart';
import '../model/all_chat_message_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    getAllChatsRxOBJ.fetchAllChatsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Messages", backButton: false),
          Expanded(
            child: StreamBuilder(
              stream: getAllChatsRxOBJ.fillData,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!asyncSnapshot.hasError &&
                    asyncSnapshot.data != null) {
                  AllChatListRes? chatMessageRes = AllChatListRes.fromJson(
                    asyncSnapshot.data,
                  );

                  if (chatMessageRes.data == null ||
                      chatMessageRes.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No messages yet",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              "You don’t have any conversations. When someone messages you, it will appear here.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF505050),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          UIHelper.verticalSpace(20.h),
                          ListView.builder(
                            itemCount: chatMessageRes.data?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              ChatModel? chatModel =
                                  chatMessageRes.data?[index];
                              return GestureDetector(
                                onTap: () {
                                  NavigationService.navigateToWithArgs(
                                    Routes.messaging,
                                    {
                                      "receiverId": chatModel?.receiverId,
                                      "receiverName": chatModel?.userName,
                                      "reciverImg": chatModel?.userImage,
                                      "myImg": chatModel?.myImage,
                                      "conversationId":
                                          chatModel?.conversationId,
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: const Color(0xFFE9E9E9),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadiusGeometry.circular(
                                                100.r,
                                              ),
                                              child: CustomProfileImage(
                                                imageUrl:
                                                    chatModel?.userImage ?? '',
                                                width: 44.h,
                                                height: 44.h,
                                              ),
                                            ),
                                            UIHelper.horizontalSpace(8.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    chatModel?.userName ?? '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFF202020,
                                                      ),
                                                      fontSize: 14.sp,
                                                      fontFamily: 'SF Pro',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  UIHelper.verticalSpace(6.h),
                                                  Text(
                                                    chatModel?.message ?? '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFF202020,
                                                      ),
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        formatTime(chatModel?.latestTime),
                                        style: TextStyle(
                                          color: const Color(0xFF6A6A6A),
                                          fontSize: 12.sp,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No messages yet",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          UIHelper.verticalSpace(8.h),
                          Text(
                            "You don’t have any conversations. When someone messages you, it will appear here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF505050),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
