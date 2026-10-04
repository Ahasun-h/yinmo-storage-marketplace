import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urban_koala/common_widgets/custom_text_form_field.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/helpers/address_autocomplete_service.dart';

class AddressAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final double? biasLatitude;
  final double? biasLongitude;
  final Future<void> Function(String address, LatLng? latLng) onAddressSelected;

  const AddressAutocompleteField({
    super.key,
    required this.controller,
    required this.onAddressSelected,
    this.hintText = 'Enter an address',
    this.biasLatitude,
    this.biasLongitude,
  });

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<AddressSuggestion> _suggestions = [];
  bool _isLoading = false;
  bool _ignoreNextChange = false;
  late final String _sessionToken;

  @override
  void initState() {
    super.initState();
    _sessionToken = DateTime.now().microsecondsSinceEpoch.toString();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_ignoreNextChange) {
      _ignoreNextChange = false;
      return;
    }

    _debounce?.cancel();
    final query = value.trim();
    if (query.length < 3) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
      }
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });

      final suggestions = await AddressAutocompleteService.fetchSuggestions(
        input: query,
        latitude: widget.biasLatitude,
        longitude: widget.biasLongitude,
        sessionToken: _sessionToken,
      );

      if (!mounted || widget.controller.text.trim() != query) return;
      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });
    });
  }

  Future<void> _submitAddress(String value) async {
    final address = value.trim();
    if (address.isEmpty) return;

    _debounce?.cancel();
    if (mounted) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
    }

    final latLng = await _resolveLatLng(address);
    if (!mounted) return;
    await widget.onAddressSelected(address, latLng);
  }

  Future<void> _selectSuggestion(AddressSuggestion suggestion) async {
    _ignoreNextChange = true;
    widget.controller.text = suggestion.description;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
    FocusScope.of(context).unfocus();
    await _submitAddress(suggestion.description);
  }

  Future<LatLng?> _resolveLatLng(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isEmpty) return null;
      final first = locations.first;
      return LatLng(first.latitude, first.longitude);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextFormField(
          controller: widget.controller,
          isPrefixIcon: false,
          hintText: widget.hintText,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.next,
          focusNode: _focusNode,
          onChanged: _onChanged,
          onFieldSubmitted: _submitAddress,
          suffixIcon: _isLoading
              ? Padding(
                  padding: EdgeInsets.all(14.sp),
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : null,
        ),
        if (_suggestions.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: const Color(0x51919EAB)),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length > 5 ? 5 : _suggestions.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: const Color(0xFFE9E9E9)),
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return InkWell(
                  onTap: () => _selectSuggestion(suggestion),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion.mainText.isNotEmpty
                              ? suggestion.mainText
                              : suggestion.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF202020),
                            fontSize: 13.sp,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (suggestion.secondaryText.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            suggestion.secondaryText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0x99101010),
                              fontSize: 11.sp,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
