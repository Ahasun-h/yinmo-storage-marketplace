import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/common_widgets/custom_profile_image.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/networks/api_access.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/chat_service.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/helper_methods.dart';
import '../../../../helpers/websocket_config.dart';
import '../model/chat_message_model.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MessagingScreen extends StatefulWidget {
  final Map<String, dynamic>? arg;
  const MessagingScreen({super.key, this.arg});

  @override
  MessagingScreenState createState() => MessagingScreenState();
}

class MessagingScreenState extends State<MessagingScreen> {
  final ChatService _chatService = ChatService.instance;
  final List<Data> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;

  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  late KeyboardVisibilityController _keyboardVisibilityController;
  bool _isLoading = true;
  StreamSubscription? _conversationSubscription;
  int? _myId;

  @override
  void initState() {
    super.initState();
    getConversationRxOBJ.clean();
    if (widget.arg?["conversationId"] != null) {
      getConversationRxOBJ.fetchfunctionName(widget.arg?["conversationId"]);
    } else {
      _isLoading = false;
    }

    // Initialize myId
    final userIdStr = appData.read(kKeyUserID);
    if (userIdStr != null) {
      if (userIdStr is int) {
        _myId = userIdStr;
      } else if (userIdStr is String) {
        _myId = int.tryParse(userIdStr);
      }
    }
    _conversationSubscription = getConversationRxOBJ.fillData.listen((value) {
      if (mounted && value is Map && value.keys.isNotEmpty) {
        if (value["data"] != null && value["data"] is List) {
          List<Data> list = [];
          for (var element in value["data"]) {
            list.add(Data.fromJson(element));
          }
          setState(() {
            _messages.clear();
            _messages.addAll(list);
            _isLoading = false;
          });
          _scheduleScrollToBottom();
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });

    _initializeWebSocket();
    _initializeKeyboardListener();
  }

  void _initializeKeyboardListener() {
    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilitySubscription =
        _keyboardVisibilityController.onChange.listen((visible) {
      if (mounted) {
        if (visible) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _scrollToBottom();
          });
        }
      }
    });
  }

  Future<void> _initializeWebSocket() async {
    try {
      // Get auth token
      final token = appData.read(kKeyAccessToken);
      if (token != null) {
        log('🔄 Initializing WebSocket...');
        // Initialize WebSocket
        await WebSocketConfig.init();
        await WebSocketConfig.connect();

        // Check if we have a conversation ID
        if (widget.arg?["conversationId"] != null) {
          log('📞 Joining conversation: ${widget.arg?["conversationId"]}');
          // Join the conversation channel
          await _chatService.joinConversation(
            widget.arg?["conversationId"],
            _onMessageReceived,
          );
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
        } else {
          log('⚠️ No conversation ID found yet');
        }

        log('✅ WebSocket initialized in MessagingScreen');
      } else {
        log('⚠️ No auth token found');
      }
    } catch (e) {
      log('❌ WebSocket initialization failed: $e');
    }
  }

  void _onMessageReceived(Data message) {
    // 1. Check if this is my own message to prevent duplicates
    if (_myId != null && message.senderId == _myId) {
      log('🚫 Skipping own message from socket: ${message.message}');
      return;
    }

    if (mounted) {
      setState(() {
        _messages.add(message);
      });
      _scheduleScrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final messageText = _controller.text;
      _controller.clear();

      log('📤 Sending message: $messageText');

      // Optimistic Update: Add message to UI immediately
      final tempMessage = Data(
        message: messageText,
        senderId: _myId ?? 0,
        createdAt: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _messages.add(tempMessage);
        });
        _scheduleScrollToBottom();
      }

      // Send via API
      final success = await postChatMsgRxOBJ.postChatMsg(
        message: messageText,
        receiverId: widget.arg?["receiverId"],
      );

      if (success) {
        log('✅ Message sent successfully');

        // After first message, join conversation if not already joined
        final conversationId = appData.read(kkeyConversationId);
        if (conversationId != null && !_isInitialized) {
          log('📞 Joining conversation after first message: $conversationId');
          await _chatService.joinConversation(
            conversationId.toString(),
            _onMessageReceived,
          );
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
        }
      } else {
        log('❌ Message send failed');
        // Remove the message if sending failed
        if (mounted) {
          setState(() {
            _messages.remove(tempMessage);
          });
          // Optional: Show error toast here if needed
        }
      }
    }
  }

  @override
  void dispose() {
    getConversationRxOBJ.clean();
    _conversationSubscription?.cancel();
    _keyboardVisibilitySubscription.cancel();
    _chatService.leaveConversation();
    WebSocketConfig.disconnect();
    _chatService.disconnect();
    _controller.dispose();
    _scrollController.dispose();
    _messages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomAppBar(
            title: widget.arg?["receiverName"] ?? "",
            onBack: () {
              getAllChatsRxOBJ.fetchAllChatsList();
            },
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 20.h),
                      physics: const PageScrollPhysics(),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMyMessage =
                            message.senderId == widget.arg?["receiverId"];

                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: isMyMessage
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        150.r,
                                      ),
                                      child: CustomProfileImage(
                                        imageUrl:
                                            widget.arg?["reciverImg"] ?? "",
                                        width: 32.h,
                                        height: 32.h,
                                      ),
                                    ),
                                    UIHelper.horizontalSpace(10.w),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(12.sp),
                                        decoration: ShapeDecoration(
                                          color: const Color(0x7FE9E9E9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.r),
                                              bottomLeft: Radius.circular(20.r),
                                              bottomRight: Radius.circular(
                                                20.r,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.message ?? '',
                                              style: TextStyle(
                                                color: const Color(0xFF202020),
                                                fontSize: 14.sp,
                                                fontFamily: 'SF Pro',
                                              ),
                                            ),
                                            UIHelper.verticalSpace(5.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  formatTime(
                                                    message.createdAt
                                                        ?.toIso8601String(),
                                                  ),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0x99101010,
                                                    ),
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(12.sp),
                                        decoration: ShapeDecoration(
                                          color: const Color(0x19001937),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.r),
                                              bottomLeft: Radius.circular(20.r),
                                              bottomRight: Radius.circular(
                                                20.r,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              message.message ?? '',
                                              style: TextStyle(
                                                color: const Color(0xFF202020),
                                                fontSize: 14.sp,
                                                fontFamily: 'SF Pro',
                                              ),
                                            ),
                                            UIHelper.verticalSpace(5.h),
                                            Row(
                                              children: [
                                                Text(
                                                  formatTime(
                                                    message.createdAt
                                                        ?.toIso8601String(),
                                                  ),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0x99001937,
                                                    ),
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    UIHelper.horizontalSpace(10.w),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        150.r,
                                      ),
                                      child: CustomProfileImage(
                                        imageUrl: widget.arg?["myImg"] ?? "",
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
          ),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33202020),
                    blurRadius: 10,
                    offset: Offset(0, -12),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonTextFormField(
                        controller: _controller,
                        textInputStyle: TextStyle(
                          color: const Color(0xFF202020),
                          fontSize: 14.sp,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                        borderRadius: 32.r,
                        isBorder: false,
                        isPrefixIcon: false,
                        fillColor: const Color(0xFFE9E9E9),
                        hintText: "Write a message...",
                        onFieldSubmitted: (value) => _sendMessage(),
                      ),
                    ),
                    UIHelper.horizontalSpace(12.w),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: SvgPicture.asset(Assets.icons.sendMessage),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
