import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:urban_koala/constants/app_constants.dart';
import 'package:urban_koala/helpers/di.dart';
import 'package:urban_koala/helpers/websocket_config.dart';

import '../feature/common_features/messaging/model/chat_message_model.dart';

class ChatService {
  static ChatService? _instance;

  ChatService._();
  static ChatService get instance => _instance ??= ChatService._();

  Function(Data)? _onMessageReceived;
  StreamSubscription? _chatEventSubscription;
  StreamSubscription? _connectionSubscription;
  PrivateChannel? _channel;

  // ------------------------------
  // JOIN CONVERSATION
  // ------------------------------
  Future<void> joinConversation(
    String conversationId,
    Function(Data) onMessageReceived,
  ) async {
    try {
      _onMessageReceived = onMessageReceived;
      // final conversationId = "6-11";
      final client = WebSocketConfig.client;
      final channelName = "private-chat-conversation.$conversationId";

      log("🔌 Connecting to channel: $channelName");

      // Prepare private channel
      _channel = client.privateChannel(
        channelName,
        authorizationDelegate: _CustomAuthDelegate(
          endpoint: Uri.parse(
            'https://backend.urbankoala.app/api/broadcasting/broadcasting/auth',
          ),
          headers: {
            "Authorization": "Bearer ${appData.read(kKeyAccessToken)}",
            "Accept": "application/json",
          },
        ),
      );

      // ⛓ Auto-subscribe when websocket connects
      _connectionSubscription = client.onConnectionEstablished.listen((_) {
        log("🔄 WebSocket connected — subscribing...");
        _channel?.subscribeIfNotUnsubscribed();
      });

      // Manual subscribe attempt
      _channel?.subscribeIfNotUnsubscribed();

      // Listen to chat events
      _chatEventSubscription = _channel?.bind('ChatEvent').listen((event) {
        if (event.data != null) {
          try {
            log("📩 Event received: ${event.data}");

            final decoded = jsonDecode(event.data!) as Map<String, dynamic>;
            final dataMap = decoded.containsKey('message') &&
                    decoded['message'] is Map<String, dynamic>
                ? decoded['message']
                : decoded;
            final message = Data.fromJson(dataMap);

            // if (message.senderId == appData.read(kKeyUserID)) {
            //   log("Skipping duplicate self message: ${message.message}");
            //   return;
            // }

            log("✅ Parsed message: ${message.message}");
            log("📞 Invoking callback...");
            _onMessageReceived?.call(message);
          } catch (e) {
            log("❌ JSON Parse Error: $e");
          }
        }
      });

      log("✅ Joined conversation: $conversationId");
    } catch (e) {
      log("❌ Failed to join conversation: $e");
    }
  }

  // ------------------------------
  // LEAVE CONVERSATION
  // ------------------------------
  Future<void> leaveConversation() async {
    try {
      await _chatEventSubscription?.cancel();
      await _connectionSubscription?.cancel();
      _chatEventSubscription = null;
      _connectionSubscription = null;
      _channel = null;
      _onMessageReceived = null;

      log("👋 Left conversation");
    } catch (e) {
      log("❌ Error leaving conversation: $e");
    }
  }

  // ------------------------------
  // DISCONNECT ALL
  // ------------------------------
  Future<void> disconnect() async {
    await leaveConversation();
    log("🔌 Chat service fully disconnected");
  }
}

class _CustomAuthDelegate
    implements
        EndpointAuthorizableChannelAuthorizationDelegate<
            PrivateChannelAuthorizationData> {
  final Uri endpoint;
  final Map<String, String> headers;

  _CustomAuthDelegate({required this.endpoint, required this.headers});

  @override
  Future<PrivateChannelAuthorizationData> authorizationData(
    String socketId,
    String channelName,
  ) async {
    try {
      log(
        "Auth Request: $endpoint, socketId: $socketId, channel: $channelName",
      );
      final response = await http.post(
        endpoint,
        headers: {
          ...headers,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'socket_id': socketId, 'channel_name': channelName},
      );

      log("Auth Response Status: ${response.statusCode}");
      log("Auth Response Body: ${response.body}");

      // Accept 200 OK or 201 Created, or try to parse if body exists
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.body.contains('"auth"')) {
        final decoded = jsonDecode(response.body);
        return PrivateChannelAuthorizationData(authKey: decoded['auth']);
      } else {
        throw Exception("Failed auth: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      log("Auth Error: $e");
      rethrow;
    }
  }

  @override
  void Function(dynamic error, StackTrace stackTrace)? get onAuthFailed =>
      (error, stackTrace) {
        log(
          "Auth Failed Callback: $error",
          error: error,
          stackTrace: stackTrace,
        );
      };
}
