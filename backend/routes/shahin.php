<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\ChatController;
use App\Http\Controllers\Api\GuestSearchListController;
use App\Http\Controllers\Api\listingController;
use App\Http\Controllers\Api\MyBookingController;

use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\ReviewRatingController;
use App\Http\Controllers\Api\ServiceProviderController;
use App\Http\Controllers\Api\StripeSetController;
use App\Http\Controllers\Api\SupportHelpController;
use Illuminate\Support\Facades\Route;





Route::middleware('auth:api')->group(function () {


Route::controller(listingController::class)->group(function () {

    Route::post('/listings/store', 'store');
    Route::get('/listings/{id}', 'show');
    Route::post('/listings/{id}', 'update');
    Route::get('/listing/photo/delete/{id}', 'deletePhoto');
    Route::delete('/listings/{id}', 'destroy');
    Route::get('/provider/listings', 'providerListings');
    Route::get('single/listing/details/{id}', 'singleListingDetails');
    Route::post('single/listing/reviews', 'singleListingReviews');

});


Route::controller(ReviewRatingController::class)->group(function () {

    Route::post('/reviews/store', 'store');
    Route::get('/reviews/{id}', 'show');
    Route::post('/reviews/update/{id}', 'update');
    Route::get('/reviews/delete/{id}', 'destroy');
});

Route::controller(StripeSetController::class)->group(function () {

    Route::post('/stripe/set', 'store');
    Route::get('/stripe/set/show', 'show');
});





Route::controller(BookingController::class)->group(function () {
     Route::post('/booking/payment-intent', 'createPaymentIntent');
     Route::post('/booking/store/data', 'testBooking');
     Route::get('/booking/invoice/user', 'getinvoice');
     Route::get('/single/booking/invoice/{booking_id}', 'singleInvoice');

});

Route::controller(MyBookingController::class)->group(function () {
   Route::post('/my/bookings', 'index');
   Route::post('/my/bookings/date', 'myBookingDate');
   Route::get('my/booking/summery/{booking_id}','BookingSummery');
   Route::post('my/booking/cancel','cancelBooking');
});

   Route::controller(ChatController::class)->group(function () {
        Route::post('/chat/send', 'sendMessage');
        Route::get('/chat/mark/read/{conversation_id}', 'markAsRead');
        Route::get('/chat/get/{conversation_id}', 'getConversation');
        Route::get('chat/list', 'getchatlist');
        Route::get('/chat/delete/{chat_id}', 'chatdelete');
        Route::get('/chat/image/delete/{image_id}', 'chatImageDelete');
    });

    Route::controller(SupportHelpController::class)->group(function () {
        // Route::get('/support/help', 'index');
        Route::post('/support/help/store', 'store');

    });

    Route::controller(ServiceProviderController::class)->group(function () {
        Route::post('/provider/booking','s_MyBooking');
        Route::get("/single/booking/provider/{booking_id}", 's_MyBookingDetails');
    });


});

///////////////////////////////////////guest////////////////////////////

Route::controller(GuestSearchListController::class)->group(function () {

    Route::post('/guest/search/listing', 'searchListing');
    Route::get('/guest/listing/details/{id}', 'listingDetails');
    Route::post('/guest/single/listing/reviews', 'listingReviews');
});

Route::controller(BookingController::class)->group(function () {
     Route::get('booking/list/get/{listing_id}', 'bookingListData');
     Route::post('bookiking/date/slot/box/bike', 'bookingDateSlotBoxBike');
      Route::post('stripe/webhook', 'stripeWebhook');
});


 Route::controller(SupportHelpController::class)->group(function () {

        Route::get('/privacy/policy', 'privacyPolicy');
        Route::get('/terms/condition', 'termCondition');
         Route::get('faq','faq');
    });
