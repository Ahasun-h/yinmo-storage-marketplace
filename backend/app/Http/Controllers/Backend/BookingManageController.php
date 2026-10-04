<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use App\Models\booking;
use App\Models\BookingRejectReason;
use App\Models\StripeSetup;
use App\Models\transaction;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Stripe\StripeClient;
use Yajra\DataTables\Facades\DataTables;

class BookingManageController extends Controller
{
    public function index(){
        return view('backend.layouts.bookingManage.bookingdelete');
    }

    public function data(Request $request){
      if($request->ajax()){
        $BookingReason=BookingRejectReason::get();
        return datatables()->of($BookingReason)
        ->addIndexColumn()
         ->addColumn('action', function ($row) {
                $btn = '<a href="javascript:void(0)" data-id="' . $row->id . '" data-name="' . $row->reason . '" class="btn btn-sm btn-primary edit"><i class="bi bi-pencil-square"></i></a> ';
                $btn .= '<button  class="btn btn-sm btn-danger delete" data-id="'. $row->id . '"><i class="bi bi-trash"></i></button>';
                return $btn;
            })
        ->make(true);
      }

    }

    public function store(Request $request){


        $bookingReason = new BookingRejectReason();
        $bookingReason->reason = $request->input('name');
        $bookingReason->save();


       return response()->json([
        'success' => true,
        'message' => 'Reason created successfully.'
        ]);
    }

    public function update($reject_id, Request $request){

        $bookingReason = BookingRejectReason::find($reject_id);
        $bookingReason->reason = $request->input('name');
        $bookingReason->update();

       return response()->json([
        'success' => true,
        'message' => 'Reason updated successfully.'
        ]);
    }

    public function destroy($reason_id){
        $bookingReason = BookingRejectReason::find($reason_id);
        $bookingReason->delete();

       return response()->json([
        'success' => true,
        'message' => 'Reason deleted successfully.'
        ]);
    }

/////////////////////////////////provider booking manage admin////////////////
public function Providerbooking(){
    return view('backend.layouts.bookingManage.providerbookinglist');
}


public function ProviderbookingData(Request $request)
{
    $query = Booking::with(['user', 'listing', 'serviceProvider', 'reject']);

    if ($request->has('status') && $request->status != '') {
        $query->where('status', $request->status);
    }

    return DataTables::of($query)
        ->addIndexColumn()
        ->addColumn('invoice_id', fn($row) => $row->invoice_id ?? 'N/A')
        ->addColumn('customer', fn($row) => $row->user->name ?? 'N/A')
        ->addColumn('listing', fn($row) => $row->listing->title ?? 'N/A')
        ->addColumn('provider', fn($row) => $row->serviceProvider->name ?? 'N/A')
        ->addColumn('total', fn($row) => number_format($row->total, 2))
        ->addColumn('admin_commission', fn($row) => number_format($row->admin_comission ?? 0, 2))
        ->addColumn('provider_total', fn($row) => number_format($row->provider_fee_after_comission ?? 0, 2))
        ->addColumn('provider_payment_status', fn($row) => ucfirst($row->payment_status ?? 'Unpaid'))
        ->addColumn('status', function($row) {
            $color = match($row->status) {
                'completed' => 'success',
                'upcoming' => 'primary',
                'canceled' => 'danger',
                default => 'secondary'
            };
            return '<span class="badge bg-'.$color.' text-capitalize">'.$row->status.'</span>';
        })
        ->addColumn('reject_reason', fn($row) => $row->reject->reason ?? '-')
        ->addColumn('created_at', fn($row) => $row->created_at->format('d M Y'))
       ->addColumn('action', function($row) {
                return '
                    <a href="'.route('bookings.show', $row->id).'" class="btn btn-sm btn-primary me-1">
                        <i class="bi bi-eye"></i> View
                    </a>
                    <button href="" class="btn btn-sm btn-success me-1"
                       data-id="'.$row->id.'"
                       data-provider-id="'.$row->service_provider_id.'"
                       data-provider-name="'.$row->serviceProvider->name.'"
                       data-amount="'.$row->provider_fee_after_comission.'"
                       data-invoice-id="'.$row->invoice_id.'"

                    data-bs-toggle="modal" data-bs-target="#paymentModal"

                      >
                        <i class="bi bi-credit-card"></i> Pay
                    </button>

                ';
            })

        ->rawColumns(['status', 'action'])
        ->make(true);
}

public function bookingSummery($booking_id)
{

        $booking = Booking::with(['user', 'listing', 'ExtraServicesBooking', 'slotDateBookingManages', 'boxBookingDateManages', 'bikeIdmanageDates'])
                          ->findOrFail($booking_id);

        return view('backend.layouts.bookingManage.show', compact('booking'));

}


public function transferMoney(Request $request)
{
    $payment_id = null;

   $booking = Booking::findOrFail($request->booking_id);

    if (!$booking) {
        return response()->json(['error' => 'Booking not found.'], 404);
    }

    // Prevent overpayment
    if ($request->amount > $booking->provider_fee_after_comission) {
       return response()->json(['error' => 'Overpayment not allowed.'], 400);
    }




    // Stripe payment
    if ($request->payment_type == "stripe") {

        $provider_account = StripeSetup::where('user_id', $request->provider_id)->first();

        $stripe = new \Stripe\StripeClient(env('STRIPE_SECRET'));

        $account = $stripe->accounts->retrieve($provider_account->account_number);

        $balance = $stripe->balance->retrieve();

        $amount = (int) round($request->amount * 100);

        $available = $balance->available[0]->amount ?? 0;

        if ($available < $amount) {
            $stripe->charges->create([
                'amount' => $amount + 1000,
                'currency' => 'usd',
                'source' => 'tok_bypassPending',
                'description' => 'Auto top-up for test transfer',
            ]);
        }

        $stripe->accounts->update(
            $provider_account->account_number,
            [
                'capabilities' => [
                    'transfers' => ['requested' => true],
                ],
            ]
        );

        $transfer = $stripe->transfers->create([
            'amount' => $amount,
            'currency' => 'usd',
            'destination' => $provider_account->account_number,
            'description' => 'Payout to provider account',
        ]);

        if (!$transfer) {
            return redirect()->back()->with('error', 'Transfer failed');
        }

        $payment_id = $transfer->id; // Stripe transfer ID
       
    }

    // Manual payment
    if ($request->payment_type == "manual") {
        $payment_id = 'cust-' . rand(1000, 9999); // e.g., cust-1289
    }

    // Booking payment logic


    if ($request->payment_mode == "partial") {
        $booking->payment_status = "partial";
        $booking->partial_paid = $request->amount;
        $booking->provider_fee_after_comission -= $request->amount;
        $booking->total_paid += $request->amount;
    } else {
        $booking->payment_status = "paid";
        $booking->partial_paid = 0;
        $booking->provider_fee_after_comission -= $request->amount;
        $booking->total_paid += $request->amount;
    }

    $booking->save();

    // Save transaction
    $transaction = new Transaction();
    $transaction->transaction_by = Auth::user()->id;
    $transaction->transaction_for = $booking->user_id;
    $transaction->listing_id = $booking->listing_id;
    $transaction->booking_id = $booking->id;
    $transaction->booking_invoice_number = $booking->invoice_id;
    $transaction->payment_id = $payment_id;
    $transaction->transaction_user_type = "provider";
    $transaction->amount = $request->amount;
    $transaction->save();

    return response()->json([
        'success' => true,
        'message' => 'Payment successful',
    ]);
}




}
