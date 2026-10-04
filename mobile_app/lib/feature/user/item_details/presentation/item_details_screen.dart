import 'package:flutter/material.dart';
import 'package:urban_koala/common_widgets/item_details_widget.dart';
import 'package:urban_koala/feature/user/item_details/widget/book_now_button.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';

import '../../../../networks/api_access.dart';

class ItemDetailsScreen extends StatefulWidget {
  final int? itemId;
  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getItemDetailsRxOBJ.get(widget.itemId);
    postItemReviewRetingGetRxOBJ.post(value: widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ItemDetailsWidget(itemId: widget.itemId),
      bottomNavigationBar: BookNowButton(
        onTap: () {
          NavigationService.navigateToWithObject(
            Routes.bookingForm,
            widget.itemId,
          );
        },
      ),
    );
  }
}
