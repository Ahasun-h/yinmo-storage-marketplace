# 🖥️ YinMo - Backend API (Laravel 12)

This directory contains the REST API server and admin backend for **YinMo**, built with Laravel 12 and PHP 8.2+.

## 🛠️ Stack & Dependencies

* **Framework**: Laravel 12.x
* **PHP**: 8.2+
* **Database**: MySQL
* **Realtime Communication**: Pusher WebSockets

## 🗄️ Database Models (`app/Models`)

* `Listing`, `ListingPhoto`: Storage space listings, capacity specs, rates, and photo galleries
* `Box`, `BikeId`, `Slot`: Specific storage unit types (lockers, boxes, bike racks)
* `boxBookingDateManage`, `slotDateBookingManage`, `bikeIdmanageDate`: Date and slot availability calendars
* `booking`, `BookingRejectReason`: Storage reservation details, payment status, check-in timestamps, and rejection reasons
* `StripeSetup`, `Commission`, `transaction`: Host payout configuration, platform commission calculation, and payment transactions
* `ReviewRating`, `UserReview`: Storage location reviews and host ratings

## 🚀 Setup & Execution

```bash
# Install PHP dependencies
composer install

# Configure environment
cp .env.example .env
php artisan key:generate

# Migration & Seed Database
php artisan migrate --seed

# Run Development Server
php artisan serve
```
