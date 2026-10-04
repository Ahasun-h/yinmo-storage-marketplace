# 🧳 YinMo - On-Demand Luggage, Locker & Bike Storage Marketplace

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Laravel-12-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" alt="Laravel 12" />
  <img src="https://img.shields.io/badge/PHP-8.2+-777BB4?style=for-the-badge&logo=php&logoColor=white" alt="PHP" />
  <img src="https://img.shields.io/badge/Google_Maps-4285F4?style=for-the-badge&logo=google-maps&logoColor=white" alt="Google Maps" />
  <img src="https://img.shields.io/badge/Apple_Maps-000000?style=for-the-badge&logo=apple&logoColor=white" alt="Apple Maps" />
  <img src="https://img.shields.io/badge/Stripe_Connect-6772E5?style=for-the-badge&logo=stripe&logoColor=white" alt="Stripe Connect" />
  <img src="https://img.shields.io/badge/Pusher-300D4F?style=for-the-badge&logo=pusher&logoColor=white" alt="Pusher" />
</p>

<p align="center">
  <b>YinMo</b> (also known as <i>Urban Koala</i>) is an on-demand luggage storage, locker rental, and bike parking marketplace platform. It seamlessly connects travelers, commuters, and tourists with local hosts (shops, hotels, spaces) offering secure bag drop-off locations, real-time map search, automated booking slots, Stripe Connect payouts, and messaging.
</p>

---

## 📱 Download YinMo App

Get the official **YinMo** mobile application on Google Play:

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.yinmo.YinMo&hl=en" target="_blank">
    <img src="https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white" alt="Google Play Store" />
  </a>
</p>

* 🤖 **Android**: [YinMo on Google Play Store](https://play.google.com/store/apps/details?id=com.yinmo.YinMo&hl=en)

---

## ✨ Key Features

### 🗺️ Interactive Storage Map & Booking (`feature/user`)
* **Map Search & Discovery**: Find nearby luggage storage hubs using interactive Google Maps (`google_maps_flutter`) and Apple Maps (`apple_maps_flutter`).
* **Slot & Box Reservation**: Real-time date/time slot availability (`slotDateBookingManage`, `boxBookingDateManage`, `bikeIdmanageDate`) for bags, suitcases, boxes, or bicycles.
* **Instant Checkout & Invoicing**: Secure payments via Stripe SDK (`flutter_stripe`) with optional extra services (e.g., luggage insurance).

### 🏠 Host Space Listing & Stripe Connect (`feature/host`)
* **Add & Edit Storage Listings**: Hosts can list storage spaces, define capacity, set hourly/daily rates, and upload photos (`ListingPhoto`).
* **Stripe Connect Onboarding**: Direct payout integration for hosts to receive earnings automatically upon booking completion.
* **Booking Management**: Accept, manage, or reject incoming reservations with reason tracking (`BookingRejectReason`).

### 💬 Real-Time Chat & Notifications
* **Pusher Messaging**: Live in-app chat (`dart_pusher_channels`) between travelers and storage hosts.
* **Firebase Push Alerts**: Instant FCM notifications (`firebase_messaging`) for booking confirmations, check-in reminders, and chat alerts.

### ⭐ Reviews, Ratings & Security
* **Host & User Ratings**: Two-way review system (`ReviewRating`, `UserReview`) ensuring trust and safety across the network.

---

## 🛠️ Technology Stack

| Layer | Component | Technology | Description |
| :--- | :--- | :--- | :--- |
| **Mobile Client** | `mobile_app` | [Flutter](https://flutter.dev) (v3.x) & Dart | Cross-platform app for iOS & Android (`com.yinmo.YinMo` / `app.urbankoala.urbankoala`) |
| **Backend API** | `backend` | [Laravel 12](https://laravel.com) & PHP 8.2+ | REST API server for storage listings, slot availability, and payments |
| **Database** | `backend` | MySQL | Relational database powering users, listings, bookings, reviews, and transactions |
| **Maps & Location**| Google Maps & Apple Maps | `google_maps_flutter`, `apple_maps_flutter` | Dual map engine for precise drop-off point navigation |
| **Payments** | Stripe Connect | `flutter_stripe` | Split payments between platform fee and host earnings |
| **Realtime Chat** | Pusher Channels | `dart_pusher_channels` | Instant messaging between guests and hosts |

---

## 📂 Project Architecture & Directory Structure

```
yinmo/
│
├── mobile_app/                 # 📱 Flutter Mobile Application (iOS & Android)
│   ├── android/                # Android native config (Package: com.yinmo.YinMo)
│   ├── ios/                    # iOS native config
│   ├── lib/
│   │   ├── feature/
│   │   │   ├── user/           # Map Search, Slot Booking, Item Details, Checkout, Bookings
│   │   │   ├── host/           # Add/Edit Listings, Stripe Connect, Booking Approvals
│   │   │   └── common_features/# Auth, Chat, Notifications, Profile Settings
│   │   └── main.dart           # App entry point
│   ├── pubspec.yaml            # Dependencies (google_maps_flutter, apple_maps_flutter, flutter_stripe)
│   └── README.md               # Mobile App Documentation
│
├── backend/                    # 🖥️ Laravel REST API & Admin Backend
│   ├── app/
│   │   ├── Http/Controllers/   # API Endpoints for Listings, Bookings, Slots, & Payments
│   │   └── Models/             # Eloquent Models (Listing, Booking, Box, Slot, StripeSetup)
│   ├── routes/                 # API & Web route definitions
│   ├── database/               # Database migrations & seeders
│   ├── composer.json           # PHP dependencies
│   └── README.md               # Backend API Documentation
│
└── README.md                   # 🚀 Workspace Root README (This File)
```

---

## 🚀 Getting Started & Local Setup

### 📱 1. Mobile Application Setup (`mobile_app`)

```bash
cd mobile_app
flutter pub get
flutter run
```

### 🖥️ 2. Backend Service Setup (`backend`)

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

---

## 📄 License

This repository is proprietary software owned by **YinMo / Urban Koala**. All rights reserved.
