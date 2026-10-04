// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:urban_koala/common_widgets/custom_app_bar.dart';
import 'package:urban_koala/feature/user/payments_billings/widget/billings_row.dart';
import 'package:urban_koala/helpers/loading_helper.dart';

import 'package:urban_koala/helpers/ui_helpers.dart';
import 'package:urban_koala/helpers/pdf_downloader.dart';
import '../../../../common_widgets/custom_toast.dart';

import '../../../../networks/api_access.dart';
import '../model/payment_billings_model.dart';

class PaymentsBillingsScreen extends StatefulWidget {
  const PaymentsBillingsScreen({super.key});

  @override
  State<PaymentsBillingsScreen> createState() => _PaymentsBillingsScreenState();
}

class _PaymentsBillingsScreenState extends State<PaymentsBillingsScreen> {
  List<int> selectedItems = [];
  bool selectAll = false;
  final double _progress = 0.0;
  @override
  void initState() {
    super.initState();
    getBookingInvoiceListRxOBJ.getBookingInvoiceList();
  }

  void _downloadSelectedFiles() {
    List selectedIds = [];
    for (var item in selectedItems) {
      selectedIds.add(item);
    }
    postBookingDownlaodRxOBJ
        .postBookingDownlaod(value: selectedIds)
        .waitingForFutureWithoutBg()
        .then((value) {
      if (value is List<int>) {
        savePdfBytes(value, fileName: "Invoice-$selectedIds.pdf").then((path) {
          if (path.isNotEmpty) {
            customToastMessage("Success", "File downloaded successfully");
          } else {
            customToastMessage("Error", "Failed to save file");
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Payments & Billings"),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: StreamBuilder(
                  stream: getBookingInvoiceListRxOBJ.fillData,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox(
                        height: 0.6.sh,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (!asyncSnapshot.hasError &&
                        asyncSnapshot.data != null) {
                      PaymentBillingRes? paymentBillingRes =
                          PaymentBillingRes.fromJson(asyncSnapshot.data);
                      return Column(
                        children: [
                          UIHelper.verticalSpace(20.h),
                          Container(
                            decoration: ShapeDecoration(
                              color: const Color(0x7FE9E9E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Billing history and invoices',
                                            style: TextStyle(
                                              color: const Color(0xFF101010),
                                              fontSize: 16.sp,
                                              fontFamily: 'SF Pro',
                                              fontWeight: FontWeight.w600,
                                              height: 1.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                      UIHelper.verticalSpace(4.h),
                                      Text(
                                        'Manage Your billing and payment details',
                                        style: TextStyle(
                                          color: const Color(0xFF404040),
                                          fontSize: 14.sp,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w400,
                                          height: 1.43,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                UIHelper.verticalSpace(12.h),
                                UIHelper.customDivider(),
                                UIHelper.verticalSpace(12.h),
                                (paymentBillingRes.data?.isNotEmpty ?? false)
                                    ? Column(
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                ),
                                                child: BillingsRow(
                                                  value: selectAll,
                                                  title: 'Select All',
                                                  isSelectAll:
                                                      selectedItems.isNotEmpty,
                                                  amount: '',
                                                  onChanged: (value) {
                                                    if (value!) {
                                                      selectAll = true;
                                                      selectedItems.addAll(
                                                        paymentBillingRes.data!
                                                            .map(
                                                          (e) => e.id!,
                                                        ),
                                                      );
                                                    } else {
                                                      selectAll = false;
                                                      selectedItems.clear();
                                                    }
                                                    setState(() {});
                                                  },
                                                  downloadOnTap:
                                                      _downloadSelectedFiles,
                                                ),
                                              ),
                                              UIHelper.verticalSpace(12.h),
                                              UIHelper.customDivider(),
                                              UIHelper.verticalSpace(12.h),
                                            ],
                                          ),
                                          ListView.builder(
                                            itemCount: paymentBillingRes
                                                    .data?.length ??
                                                0,
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (_, index) {
                                              PaymentBilling? paymentBilling =
                                                  paymentBillingRes
                                                      .data?[index];
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16.w,
                                                    ),
                                                    child: BillingsRow(
                                                      value: selectAll == false
                                                          ? selectedItems.any(
                                                              (item) =>
                                                                  item ==
                                                                  paymentBilling
                                                                      ?.id,
                                                            )
                                                          : true,
                                                      title:
                                                          'Invoice #${paymentBilling?.invoiceId}',
                                                      amount:
                                                          '${paymentBilling?.total} CHF',
                                                      onChanged: (value) {
                                                        if (value!) {
                                                          selectedItems.add(
                                                            paymentBilling!.id!,
                                                          );
                                                        } else {
                                                          selectedItems
                                                              .removeWhere(
                                                            (item) =>
                                                                item ==
                                                                paymentBilling
                                                                    ?.id,
                                                          );
                                                          selectAll = false;
                                                        }
                                                        setState(() {});
                                                      },
                                                      downloadOnTap: () {
                                                        if (paymentBilling !=
                                                            null) {
                                                          List<int> idList = [];
                                                          idList.add(
                                                              paymentBilling
                                                                  .id!);
                                                          postBookingDownlaodRxOBJ
                                                              .postBookingDownlaod(
                                                                  value: idList)
                                                              .waitingForFutureWithoutBg()
                                                              .then((value) {
                                                            if (value
                                                                is List<int>) {
                                                              savePdfBytes(
                                                                      value,
                                                                      fileName:
                                                                          "Invoice-${paymentBilling.invoiceId}.pdf")
                                                                  .then((path) {
                                                                if (path
                                                                    .isNotEmpty) {
                                                                  customToastMessage(
                                                                      "Success",
                                                                      "File downloaded successfully");
                                                                } else {
                                                                  customToastMessage(
                                                                      "Error",
                                                                      "Failed to save file");
                                                                }
                                                              });
                                                            }
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  UIHelper.verticalSpace(12.h),
                                                  UIHelper.customDivider(),
                                                  UIHelper.verticalSpace(12.h),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height: 0.7.sh,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'No invoices yet',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.sp,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                UIHelper.verticalSpace(8.h),
                                                Text(
                                                  "You haven't made any payments yet. Invoices and billing history will appear here.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF505050),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                UIHelper.verticalSpace(16.h),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No invoices yet',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              UIHelper.verticalSpace(8.h),
                              Text(
                                "You haven't made any payments yet. Invoices and billing history will appear here.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF505050),
                                  fontSize: 14.sp,
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
            ),
          ),
        ],
      ),
    );
  }
}
