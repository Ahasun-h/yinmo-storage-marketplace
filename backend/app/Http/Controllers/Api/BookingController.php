<?php

namespace App\Http\Controllers\Api;


use App\Http\Controllers\Controller;
use App\Models\bikeIdmanageDate;
use App\Models\booking;
use App\Models\boxBookingDateManage;
use App\Models\Commission;
use App\Models\ExtraServicesBooking;
use App\Models\Listing;
use App\Models\slotDateBookingManage;
use App\Models\transaction;
use App\Traits\ApiResponse;
use Barryvdh\DomPDF\Facade\Pdf;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Stripe\Checkout\Session;
use Stripe\PaymentIntent;
use Stripe\Stripe;

class BookingController extends Controller
{
    use ApiResponse;
    public function bookingListData($id)
    {

        try {
            $listingCheck = Listing::find($id);
            if ($listingCheck->listing_type == "parking") {
                $listing = Listing::with(['slot', 'features', 'extraservices'])->find($id);
            } elseif ($listingCheck->listing_type == "luggage") {
                $listing = Listing::with(['features', 'extraservices', 'boxes'])->find($id);
            } elseif ($listingCheck->listing_type == "bike_rent") {
                $listing = Listing::with(['bikeIds', 'features', 'extraservices'])->find($id);
            }

            return $this->success($listing, 'Listings fetched successfully', 200);
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), 'Error', 500);
        }
    }

    public function bookingDateSlotBoxBike(Request $request)
    {
        try {

            $listingCheck = Listing::with(['slot', 'features', 'extraservices'])->find($request->listing_id);


            $startOfMonth = Carbon::now()->startOfMonth()->startOfDay();
                    $endOfMonth   = Carbon::now()->endOfMonth()->endOfDay();

            if ($listingCheck->listing_type == "parking") {


                $slot_date = slotDateBookingManage::where('listing_id', $request->listing_id)
                    ->where('slot_id', $request->slot_id)
                     ->whereBetween('slot_date', [$startOfMonth, $endOfMonth])
                    ->get();

                return $this->success($slot_date, 'Listings slot fetched successfully', 200);
            } elseif ($listingCheck->listing_type == "luggage") {

                $box_date = boxBookingDateManage::where('listing_id', $request->listing_id)
                    ->where('box_id', $request->box_id)
                    ->whereBetween('box_date', [$startOfMonth, $endOfMonth])
                    ->get();

                return $this->success($box_date, 'Listings slot fetched successfully', 200);
            } elseif ($listingCheck->listing_type == "bike_rent") {


                $bike_date = bikeIdmanageDate::where('listing_id', $request->listing_id)
                    ->where('bike_id', $request->bike_id)
                    ->whereBetween('bike_date', [$startOfMonth, $endOfMonth])
                    ->get();

                return $this->success($bike_date, 'Listings slot fetched successfully', 200);
            } else {
                return $this->error(['errors' => 'Invalid listing type'], 500);
            }
        } catch (\Exception $e) {
            return $this->error(['errors' => $e->getMessage()], 500);
        }
    }

    public function createPaymentIntent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'listing_id' => 'required',
            'user_id' => 'required',
            'total' => 'required|numeric',
            'subtotal' => 'required|numeric',

            'extra_services' => 'array', // optional
        ]);
        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        try{

            $user = Auth::guard('api')->user();
            if(!$user){
                return $this->error(['errors' => 'User not found'], 500);
            }
            Stripe::setApiKey(env('STRIPE_SECRET'));


                    $slots = json_decode($metadata->slots ?? '[]', true);
                    $boxes = json_decode($metadata->boxes ?? '[]', true);
                    $bikes = json_decode($metadata->bikes ?? '[]', true);

                    // Total days = sum of all dates user booked
                    $total_days = 0;

                    if (!empty($slots)) {
                        $total_days += count($slots);
                    }

                    if (!empty($boxes)) {
                        $total_days += count($boxes);
                    }

                    if (!empty($bikes)) {
                        $total_days += count($bikes);
                    }

                    $user=Auth::guard('api')->user();


        $listing_type=Listing::find($request->listing_id);


            $intent = PaymentIntent::create([
                'amount' => $request->total * 100,
                'currency' => 'usd',
                'metadata' => [
                    'listing_id' => $request->listing_id,
                    'user_id' =>  $user->id,
                    'subtotal' => $request->subtotal,
                    'total' => $request->total,
                    'total_days' => $total_days,
                    'listing_type' =>$listing_type->listing_type,
                    'provider_id' => $listing_type->user_id,
                    'slots' => json_encode($request->slots ?? []),
                    'boxes' => json_encode($request->boxes ?? []),
                    'bikes' => json_encode($request->bikes ?? []),
                    'extra_services' => json_encode($request->extra_services ?? []),
                ],
                'automatic_payment_methods' => ['enabled' => true],
            ]);

            return $this->success(['client_secret' => $intent->client_secret], 'Payment intent created', 200);
        }
        catch(\Exception $e){
            return $this->error(['errors' => $e->getMessage()], 500);
        }
    }




public function stripeWebhook(Request $request)
{
    $endpoint_secret = env('STRIPE_WEBHOOK_SECRET');

    $payload = @file_get_contents('php://input');
    $sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'] ?? '';
     log::info($sig_header);
    $event = null;

    try {
        $event = \Stripe\Webhook::constructEvent($payload, $sig_header, $endpoint_secret);
    } catch (\Exception $e) {
        Log::error('Webhook Error: '.$e->getMessage());
        return response('Invalid Signature', 400);
    }

    if ($event->type === 'payment_intent.succeeded') {
        $paymentIntent = $event->data->object;

        DB::beginTransaction();
        try {
            $metadata = $paymentIntent->metadata;
            // Log::info($metadata);
            $getcommission=Commission::first();
            $listing_id = $metadata->listing_id;
            $user_id = $metadata->user_id;
            $subtotal = $metadata->subtotal;
            $total = $metadata->total;
            $provider_id = $metadata->provider_id;
            $total_days = $metadata->total_days;
            $admin_commission=($metadata->total)*$getcommission->commission/100;
            $provider_money=($metadata->total)-$admin_commission;
            $listing_type = $metadata->listing_type;
             $invoice = 'invoice' . rand(100000, 999999);
            $slots = json_decode($metadata->slots ?? '[]', true);
            $boxes = json_decode($metadata->boxes ?? '[]', true);
            $bikes = json_decode($metadata->bikes ?? '[]', true);
            $extra_services = json_decode($metadata->extra_services ?? '[]', true);

            $booking = new booking();
            $booking->listing_id = $listing_id;
            $booking->user_id = $user_id;
            $booking->service_provider_id=$provider_id;
            $booking->subtotal = $subtotal;
            $booking->admin_comission=$admin_commission;
            $booking->provider_fee_after_comission=$provider_money;
            $booking->payment_status = 'unpaid';
            $booking->user_payment_id = $paymentIntent->id;
            $booking->total = $total;
            $booking->total_days = $total_days;
            $booking->invoice_id = $invoice;
            $booking->status = 'upcoming';
            $booking->save();

            // ✅ Handle extra services
            if (!empty($extra_services)) {
                foreach ($extra_services as $service) {

                    $bookingService=new ExtraServicesBooking();
                    $bookingService->listing_id=$listing_id;
                    $bookingService->extra_service_id=$service['id'];
                    $bookingService->price=$service['price'] ?? 0;
                    $bookingService->total_service_price=$service['total_price'] ?? 0;
                    $bookingService->booking_id=$booking->id;
                    $bookingService->save();
                }
            }

            // ✅ Handle type-specific date management
            if ($listing_type === 'parking' && !empty($slots)) {
                foreach ($slots as $slot) {

                    $slot_date = new slotDateBookingManage();
                    $slot_date->listing_id = $listing_id;
                    $slot_date->slot_id = $slot['slot_id'];
                    $slot_date->slot_date = $slot['slot_date'];
                    $slot_date->booking_id = $booking->id;
                    $slot_date->save();
                }
            }

            if ($listing_type === 'luggage' && !empty($boxes)) {
                foreach ($boxes as $box) {


                    $luggage_date = new boxBookingDateManage();
                    $luggage_date->listing_id = $listing_id;
                    $luggage_date->box_id = $box['box_id'];
                    $luggage_date->box_date = $box['box_date'];
                    $luggage_date->booking_id = $booking->id;
                    $luggage_date->save();
                }
            }

            if ($listing_type === 'bike_rent' && !empty($bikes)) {
                foreach ($bikes as $bike) {


                    $bike_date = new bikeIdmanageDate();
                    $bike_date->listing_id = $listing_id;
                    $bike_date->bike_id = $bike['bike_id'];
                    $bike_date->bike_date = $bike['bike_date'];
                    $bike_date->booking_id = $booking->id;
                    $bike_date->save();
                }
            }



       $booking->load([
            'listing',
            'extraServicesBooking.extraService',
            'slotDateBookingManages.slot',
            'boxBookingDateManages.box',
            'bikeIdManageDates.bike',
        ]);

              /////////pdf generate/////////
           $pdfFolder = public_path('pdfs/bookings');
            if (!File::exists($pdfFolder)) {
                File::makeDirectory($pdfFolder, 0755, true);
            }

            $pdfFileName = 'invoice_'.$booking->invoice_id.'.pdf';
            $pdfFilePath = $pdfFolder.'/'.$pdfFileName;

            $pdf = \Barryvdh\DomPDF\Facade\Pdf::loadView('backend.layouts.pdf.booking_invoice', ['booking' => $booking]);
            $pdf->save($pdfFilePath);

            // Save PDF path
            $booking->pdf_invoice = 'pdfs/bookings/'.$pdfFileName;
            // $booking->save();


             $pdf=asset($booking->pdf_invoice) ;

              $booking->pdf_invoice = $pdf;
               $booking->save();

               if($booking){
                    $adminTransaction = new Transaction();
                    $adminTransaction->transaction_by = $user_id;
                    $adminTransaction->transaction_for = null; // Admin
                    $adminTransaction->listing_id = $listing_id;
                    $adminTransaction->booking_id = $booking->id;
                    $adminTransaction->booking_invoice_number = $booking->invoice_id;
                    $adminTransaction->payment_id = $paymentIntent->id;
                    $adminTransaction->transaction_user_type = 'customer';
                    $adminTransaction->amount = $total;
                    $adminTransaction->save();
               }



            DB::commit();
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Booking creation failed: '.$e->getMessage());
            return response('Booking creation failed', 500);
        }
    }

    return $this->success([], 'Webhook received successfully', 200);
}






///////////////////////////////test///////////////////////


public function testBooking(Request $request)
{
    DB::beginTransaction();

    try {
        $listing_id = $request->listing_id;

        $user_id = Auth::guard('api')->user()->id;
        $subtotal = $request->subtotal;
        $total = $request->total;
        $total_days = $request->total_days ?? 0;
        // $listing_type = $request->listing_type;
        $invoice = 'invoice' . rand(100000, 999999);

        $slots = $request->slots ?? [];
        $boxes = $request->boxes ?? [];
        $bikes = $request->bikes ?? [];
        $extra_services = $request->extra_services ?? [];

        $listing = Listing::find($listing_id);

        $provider_id = $listing->user_id;

        // কমিশন বের করা
        // dd(Commission::first());
        $getcommission = Commission::first();


        $admin_commission = ($total * $getcommission?->comission??0) / 100;
        $provider_money = $total - $admin_commission;

        // ✅ Booking create
        $booking = new booking();
        $booking->listing_id = $listing_id;
        $booking->user_id = $user_id;
        $booking->subtotal = $subtotal;
        $booking->total = $total;
        $booking->total_days = $total_days;
        $booking->invoice_id = $invoice;
        $booking->service_provider_id = $provider_id;
        $booking->status = 'upcoming';
        $booking->admin_comission = $admin_commission;
        $booking->provider_fee_after_comission = $provider_money;
        $booking->payment_status = 'unpaid';
        $booking->user_payment_id = 'test_payment_' . rand(100000, 999999);
        $booking->save();

        // ✅ Extra Services
        foreach ($extra_services as $service) {
            $bookingService = new ExtraServicesBooking();
            $bookingService->listing_id = $listing_id;
            $bookingService->extra_service_id = $service['id'];
            $bookingService->price = $service['price'] ?? 0;
            $bookingService->total_service_price = $service['total_price'] ?? 0;
            $bookingService->booking_id = $booking->id;
            $bookingService->save();
        }

        // ✅ Parking Slots
        if ($listing->listing_type =="parking") {

            foreach ($slots as $slot) {
                $slot_date = new SlotDateBookingManage();
                $slot_date->listing_id = $listing_id;
                $slot_date->slot_id = $slot['slot_id'];
                $slot_date->slot_date = $slot['slot_date'];
                $slot_date->booking_id = $booking->id;
                $slot_date->save();
            }
        }

        // ✅ Luggage Boxes
        if (  $listing->listing_type =='luggage') {
            foreach ($boxes as $box) {
                $box_date = new boxBookingDateManage();
                $box_date->listing_id = $listing_id;
                $box_date->box_id = $box['box_id'];
                $box_date->box_date = $box['box_date'];
                $box_date->booking_id = $booking->id;
                $box_date->save();
            }
        }

        // ✅ Bike Rent
        if (  $listing->listing_type =='bike_rent') {
            foreach ($bikes as $bike) {
                $bike_date = new bikeIdmanageDate();
                $bike_date->listing_id = $listing_id;
                $bike_date->bike_id = $bike['bike_id'];
                $bike_date->bike_date = $bike['bike_date'];
                $bike_date->booking_id = $booking->id;
                $bike_date->save();
            }
        }

        // ✅ Load relations for PDF
        $booking->load([
            'listing',
            'extraServicesBooking.extraService',
            'slotDateBookingManages.slot',
            'boxBookingDateManages.box',
            'bikeIdManageDates.bike',
        ]);

        ///////// PDF Generate /////////


        $pdfFolder = public_path('pdfs/bookings');
            if (!File::exists($pdfFolder)) {
                File::makeDirectory($pdfFolder, 0755, true);
            }
        $pdfFileName = 'invoice_'.$booking->invoice_id.'.pdf';
            $pdfFilePath = $pdfFolder.'/'.$pdfFileName;

            $pdf = \Barryvdh\DomPDF\Facade\Pdf::loadView('backend.layouts.pdf.booking_invoice', ['booking' => $booking]);
            $pdf->save($pdfFilePath);

            // Save PDF path
            $booking->pdf_invoice = 'pdfs/bookings/'.$pdfFileName;
            // $booking->save();


             $pdf=asset($booking->pdf_invoice) ;

              $booking->pdf_invoice = $pdf;
               $booking->save();


        $adminTransaction = new Transaction();
        $adminTransaction->transaction_by = $user_id;
        $adminTransaction->transaction_for = null;
        $adminTransaction->listing_id = $listing_id;
        $adminTransaction->booking_id = $booking->id;
        $adminTransaction->booking_invoice_number = $booking->invoice_id;
        $adminTransaction->payment_id = $booking->user_payment_id;
        $adminTransaction->transaction_user_type = 'customer';
        $adminTransaction->amount = $total;
        $adminTransaction->save();
        DB::commit();

        return response()->json([
            'status' => true,
            'message' => 'Test Booking created successfully with Transactions!',
            'booking' => $booking,
        ]);
    } catch (\Exception $e) {
        DB::rollBack();
        return response()->json([
            'status' => false,
            'message' => 'Error: ' . $e->getMessage(),
        ], 500);
    }
}



public function getinvoice(){

    try {

        $user = Auth::guard('api')->user();
        $booking = Booking::where('user_id', $user->id)->get();

        return $this->success($booking, 'Booking fetched successfully', 200);
    } catch (\Exception $e) {
        return $this->error($e->getMessage(), 'Error', 500);
    }
}

 public function singleInvoice($id){
    try{

        $user = Auth::guard('api')->user();
        $booking = Booking::where('user_id', $user->id)->find($id)??[];

        return $this->success($booking, 'Booking fetched successfully', 200);
    }
    catch(\Exception $e){
        return $this->error($e->getMessage());
    }
}


}
