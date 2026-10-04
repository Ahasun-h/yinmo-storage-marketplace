<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class booking extends Model
{
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }

    public function listing()
    {
        return $this->belongsTo(Listing::class);
    }

    public function ExtraServicesBooking(){
        return $this->hasMany(ExtraServicesBooking::class, 'booking_id', 'id');
    }

    public function slotDateBookingManages(){
        return $this->hasMany(slotDateBookingManage::class, 'booking_id', 'id');
    }
    public function boxBookingDateManages(){
        return $this->hasMany(boxBookingDateManage::class, 'booking_id', 'id');
    }

    public function bikeIdmanageDates(){
        return $this->hasMany(bikeIdmanageDate::class, 'booking_id', 'id');
    }

    public function reject(){
         return $this->belongsTo(BookingRejectReason::class,'reject_id','id');
    }

    public function transaction(){
        return $this->hasMany(transaction::class,'transaction_id','id');
    }
    public function serviceProvider(){
        return $this->belongsTo(User::class,'service_provider_id','id');
    }
}
