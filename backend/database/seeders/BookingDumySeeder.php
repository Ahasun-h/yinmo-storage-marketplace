<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Booking;
use App\Models\ExtraServicesBooking;
use App\Models\slotDateBookingManage;
use App\Models\boxBookingDateManage;
use App\Models\BikeIdManageDate;
class BookingDumySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // ✅ 1. Create a booking
        $booking = Booking::create([
            'listing_id' => 1,
            'user_id' => 1,
            'subtotal' => 100,
            'total' => 150,
            'total_days' => 2,
            'status' => 'upcoming',
        ]);

        // ✅ 2. Add extra services
        ExtraServicesBooking::create([
            'listing_id' => 1,
            'extra_service_id' => 1,
            'price' => 50,
            'total_service_price' => 50,
            'booking_id' => $booking->id,
        ]);

        // ✅ 3. Add slot dates for parking
        slotDateBookingManage::insert([
            [
                'listing_id' => 1,
                'slot_id' => 1,
                'slot_date' => '2025-11-01',
                'booking_id' => $booking->id,
            ],
            [
                'listing_id' => 1,
                'slot_id' => 2,
                'slot_date' => '2025-11-02',
                'booking_id' => $booking->id,
            ]
        ]);

        // ✅ 4. Add box dates for luggage (example)
        boxBookingDateManage::insert([
            [
                'listing_id' => 1,
                'box_id' => 1,
                'box_date' => '2025-11-01',
                'booking_id' => $booking->id,
            ]
        ]);

        // ✅ 5. Add bike rental dates (example)
        BikeIdManageDate::insert([
            [
                'listing_id' => 1,
                'bike_id' => 1,
                'bike_date' => '2025-11-01',
                'booking_id' => $booking->id,
            ]
        ]);
    }
}
