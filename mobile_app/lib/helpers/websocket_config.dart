import 'dart:async';
import 'dart:developer';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';

class WebSocketConfig {
  static PusherChannelsClient? _client;
  static bool _isInitialized = false;

  // Reverb Configuration
  static const String appKey = 'kvnot449of43mgwwgwd6';
  static const String host = 'backend.urbankoala.app';
  static const int port = 443;
  static const String scheme = 'wss';

  static PusherChannelsClient get client {
    if (_client == null || !_isInitialized) {
      throw Exception('Pusher client not initialized. Call init() first.');
    }
    return _client!;
  }

  static Future<void> init() async {
    if (_isInitialized) {
      log('⚠️ Pusher client already initialized');
      return;
    }

    try {
      PusherChannelsPackageLogger.enableLogs();

      final options = PusherChannelsOptions.fromHost(
        scheme: scheme,
        host: host,
        key: appKey,
        shouldSupplyMetadataQueries: true,
        metadata: PusherChannelsOptionsMetadata.byDefault(),
        port: port,
      );
      // final options = PusherChannelsOptions.fromHost(
      //   scheme: 'wss',
      //   host: "foodlab.site",
      //   key: '5bcus2pmxhiwlo28uzz3',
      //   shouldSupplyMetadataQueries: true,
      //   metadata: PusherChannelsOptionsMetadata.byDefault(),
      //   port: 443,
      // );

      _client = PusherChannelsClient.websocket(
        options: options,
        connectionErrorHandler: (exception, trace, refresh) async {
          log("Pusher connection error: $exception");
          refresh();
        },
      );
      log("Pusher client initialized.");

      _isInitialized = true;
      log('✅ Pusher client initialized successfully');
    } catch (e) {
      log('❌ Pusher initialization error: $e');
      rethrow;
    }
  }

  static Future<void> connect() async {
    if (_client != null) {
      await _client!.connect();
    }
  }

  static Future<void> disconnect() async {
    if (_client != null) {
      _client!.dispose();
      _isInitialized = false;
      _client = null;
      log('🔌 Pusher disconnected');
    }
  }
}
