<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\booking;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ServiceProviderController extends Controller
{
    use ApiResponse;
    public function s_MyBooking(Request $request){

             try {
            $user = Auth::guard('api')->user();



                if($request->action_type == 'upcoming'){
                    $bookings = Booking::with(['listing', 'user'])
                    ->where('service_provider_id', $user->id)
                    ->where('status', 'upcoming')
                    ->get();
                }

                else if($request->action_type == 'completed'){
                    $bookings = Booking::with(['listing', 'user'])
                    ->where('user_id', $user->id)
                    ->where('status', 'completed')
                    ->get();
                }

                else if($request->action_type == 'canceled'){
                    $bookings = Booking::with(['listing', 'user'])
                    ->where('user_id', $user->id)
                    ->where('status', 'canceled')
                    ->get();
                }

                else {
                    $bookings = Booking::with(['listing', 'user'])
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
        catch(\Exception $e){
            return $this->error($e->getMessage());
        }
    }

public function s_MyBookingDetails($booking_id){

     try {
            $user = Auth::guard('api')->user();

           $booking= Booking::with(['listing', 'user'])
                    ->where('service_provider_id', $user->id)
                    ->where('id', $booking_id)
                    ->first();
                    if (!$booking) {
                        return $this->error('Booking not found', 404);
                    }

              $listing = $booking->listing;

                if ($listing->listing_type =="parking") {
                    $booking->load(['slotDateBookingManages.slot', 'extraServicesBooking.extraService']);
                } elseif ($listing->listing_type =="luggage") {
                    $booking->load(['boxBookingDateManages.box', 'extraServicesBooking.extraService']);
                } elseif ($listing->listing_type =="bike_rent") {

                    $booking->load(['bikeIdmanageDates.bikeId', 'extraServicesBooking.extraService']);
                }

             return $this->success($booking, 'Booking fetched successfully', 200);

        }

        catch (\Exception $e) {
            return $this->error($e->getMessage(), 500);
        }


}
}
