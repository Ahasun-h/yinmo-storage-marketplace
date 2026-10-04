import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class AddressSuggestion {
  final String description;
  final String placeId;
  final String mainText;
  final String secondaryText;

  const AddressSuggestion({
    required this.description,
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  factory AddressSuggestion.fromJson(Map<String, dynamic> json) {
    final prediction = json['placePrediction'] as Map<String, dynamic>? ?? json;
    final text = prediction['text'] as Map<String, dynamic>? ?? {};
    final structuredFormat =
        prediction['structuredFormat'] as Map<String, dynamic>? ?? {};
    final mainText =
        structuredFormat['mainText'] as Map<String, dynamic>? ?? {};
    final secondaryText =
        structuredFormat['secondaryText'] as Map<String, dynamic>? ?? {};

    return AddressSuggestion(
      description: text['text']?.toString() ??
          prediction['description']?.toString() ??
          '',
      placeId: prediction['placeId']?.toString() ??
          prediction['place_id']?.toString() ??
          '',
      mainText: mainText['text']?.toString() ??
          prediction['main_text']?.toString() ??
          '',
      secondaryText: secondaryText['text']?.toString() ??
          prediction['secondary_text']?.toString() ??
          '',
    );
  }
}

class AddressAutocompleteService {
  AddressAutocompleteService._();

  // Matches the key already configured for the native Google Maps SDKs.
  static const String _googleMapsApiKey =
      'AIzaSyA6Nsn63JVOdPbW7r3FckoTeSmwD3ZjLMg';

  static Future<List<AddressSuggestion>> fetchSuggestions({
    required String input,
    double? latitude,
    double? longitude,
    String? sessionToken,
  }) async {
    final query = input.trim();
    if (query.length < 3) return const [];

    final requestBody = <String, dynamic>{
      'input': query,
      'languageCode': 'en',
      if (sessionToken != null && sessionToken.isNotEmpty)
        'sessionToken': sessionToken,
      if (latitude != null && longitude != null)
        'locationBias': {
          'circle': {
            'center': {
              'latitude': latitude,
              'longitude': longitude,
            },
            'radius': 50000.0,
          },
        },
    };

    final uri = Uri.https(
      'places.googleapis.com',
      '/v1/places:autocomplete',
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _googleMapsApiKey,
          'X-Goog-FieldMask': 'suggestions.placePrediction.placeId,'
              'suggestions.placePrediction.text.text,'
              'suggestions.placePrediction.structuredFormat.mainText.text,'
              'suggestions.placePrediction.structuredFormat.secondaryText.text',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode != 200) {
        log(
          'Address autocomplete failed with status ${response.statusCode}',
          name: 'AddressAutocompleteService',
        );
        return const [];
      }

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      final suggestions =
          responseBody['suggestions'] as List<dynamic>? ?? const [];
      return suggestions
          .map(
            (item) => AddressSuggestion.fromJson(item as Map<String, dynamic>),
          )
          .where((item) => item.description.isNotEmpty)
          .toList();
    } catch (e) {
      log(
        'Address autocomplete error: $e',
        name: 'AddressAutocompleteService',
      );
      return const [];
    }
  }
}
