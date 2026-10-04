# 📱 YinMo - Mobile Application (Flutter)

This directory contains the cross-platform mobile application for **YinMo** (Urban Koala), built with Flutter and Dart.

## 🔗 App Store Link

* **Google Play Store**: [YinMo on Play Store](https://play.google.com/store/apps/details?id=com.yinmo.YinMo&hl=en) (`com.yinmo.YinMo`)

## 🛠️ Architecture & Core Dependencies

* **State Management**: `GetX`, `Provider`, `RxDart`, `GetStorage`
* **Maps & Navigation**: `google_maps_flutter`, `apple_maps_flutter`, `geolocator`, `geocoding`
* **Payment Processing**: `flutter_stripe` (Stripe Connect for P2P host payouts)
* **Realtime Communication**: `dart_pusher_channels` for chat
* **Push Notifications**: `firebase_messaging`, `flutter_local_notifications`

## 📂 Feature Structure (`lib/feature`)

### 👤 User Features (`lib/feature/user`)
* `home/` & `all_item/`: Map-based storage hub discovery and list view
* `item_details/`: Storage host details, operating hours, box/slot options, and reviews
* `booking_form/` & `checkout/`: Date/time slot booking selector, extra service add-ons, and Stripe payment
* `mybooking/`: Active & past storage reservations, check-in QR codes, and cancellation handling

### 🏠 Host Features (`lib/feature/host`)
* `add_listing/` & `edit_listing/`: List new storage spaces, upload photos, and set pricing tariffs
* `stripe_connect/`: Host Stripe account onboarding for receiving booking payouts
* `mybooking/`: Review incoming storage requests, approve check-ins, or decline with reason code

## 🚀 Running the App

```bash
flutter pub get
flutter run
```
