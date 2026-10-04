<?php

namespace App\Console\Commands;

use App\Models\booking;
use App\Models\slotDateBookingManage;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class BookingCompleteDate extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'booking';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
   public function handle()
{
    // 1️⃣ Fetch all upcoming bookings
    $bookings = booking::where('status', 'upcoming')->get();


    foreach ($bookings as $booking) {


        switch($booking->listing->listing_type){
            case 'parking':
                $slotDates = \App\Models\slotDateBookingManage::where('booking_id', $booking->id)
                                ->pluck('slot_date');
                                Log::info($slotDates);
                break;

            case 'bike_rent':
                $slotDates = \App\Models\bikeIdManageDate::where('booking_id', $booking->id)
                                ->pluck('bike_date');
                break;

            case 'luggage':
                $slotDates = \App\Models\boxBookingDateManage::where('booking_id', $booking->id)
                                ->pluck('box_date');
                break;

            default:
                $slotDates = collect();
        }

        if ($slotDates->isEmpty()) {

            continue;
        }


        $currentMonth = now()->month;

        $datesInCurrentMonth = $slotDates->filter(function ($date) use ($currentMonth) {
            return \Carbon\Carbon::parse($date)->month == $currentMonth;
        });

        if ($datesInCurrentMonth->isEmpty()) {
            continue;
        }


        $lastDate = $datesInCurrentMonth->max();


        if (now()->gte(\Carbon\Carbon::parse($lastDate))) {
            Log::info("Booking ID {$booking->id} marked as complete.");
            $booking->status = 'completed';
            $booking->save();

            $this->info("Booking ID {$booking->id} marked as complete.");
        }
    }
}
}
