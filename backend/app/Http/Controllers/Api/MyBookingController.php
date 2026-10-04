<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\booking;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class MyBookingController extends Controller
{
    use ApiResponse;

    public function index(Request $request)
    {
        try {
            $user = Auth::guard('api')->user();



                if($request->action_type == 'upcoming'){
                    $bookings = booking::with(['listing', 'user'])
                    ->where('user_id', $user->id)
                    ->where('status', 'upcoming')
                    ->get();
                }

                else if($request->action_type == 'completed'){
                    $bookings = booking::with(['listing', 'user'])
                    ->where('user_id', $user->id)
                    ->where('status', 'completed')
                    ->get();
                }

                else if($request->action_type == 'canceled'){
                    $bookings = booking::with(['listing', 'user'])
                    ->where('user_id', $user->id)
                    ->where('status', 'canceled')
                    ->get();
                }

                else {
                    $bookings = booking::with(['listing', 'user'])
                    ->where('user_id', $user->id)
                    ->get();
                }

            $bookings->each(function ($booking) {
                $type = $booking->listing->listing_type ?? null;

                if ($type =="parking") {
                    $booking->load(['slotDateBookingManages.slot', 'extraServicesBooking.extraService']);
                } elseif ($type =="luggage") {
                    $booking->load(['boxBookingDateManages.box', 'extraServicesBooking.extraService']);
                } elseif ($type =="bike_rent") {

                    $booking->load(['bikeIdmanageDates.bikeId', 'extraServicesBooking.extraService']);
                }
            });

            return $this->success($bookings, 'Bookings fetched successfully', 200);
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 500);
        }
    }

    // public function myBookingDate(Request $request){

    // }

public function BookingSummery($id){
    try {
        $userId = Auth::guard('api')->user()->id;

        $booking = booking::where('user_id', $userId)->where('id', $id)->with('listing', 'user', 'extraServicesBooking.extraService')->first();

        if(!$booking){
            return $this->error('Booking not found', 404);
        }

        // Load relations based on listing type
        switch ($booking->listing->listing_type) {
            case 'parking':
                $booking->load('slotDateBookingManages.slot');
                break;
            case 'luggage':
                $booking->load('boxBookingDateManages.box');
                break;
            case 'bike_rent':
                $booking->load('bikeIdmanageDates.bikeId');
                break;
            default:
                $booking->load('slotDateBookingManages.slot');
        }

        return $this->success($booking, 'Booking fetched successfully', 200);

    } catch (\Exception $e) {
        return $this->error($e->getMessage(), 500);
    }
}

public function cancelBooking(Request $request){
    try {
        $booking = booking::where('id', $request->booking_id)->first();

        if (!$booking) {
            return $this->error('Booking not found', 404);
        }

        // Update reject reason or status
        $booking->reject_id = $request->reject_id; // যদি তোমার table-এ reject_id column থাকে
        $booking->status = 'canceled';
        $booking->save();

        // Soft delete (optional, যদি চান DB থেকে hide করতে)
        // $booking->delete();

        return $this->success($booking, 'Booking canceled successfully', 200);
    } catch (\Exception $e) {
        return $this->error($e->getMessage(), 500);
    }
}


}
    