<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class bikeIdmanageDate extends Model
{
    protected $table = 'bike_idmanage_dates';
    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }

    public function bikeId(){
        return $this->belongsTo(BikeId::class, 'bike_id', 'id');
    }

    public function booking(){
        return $this->belongsTo(booking::class, 'booking_id', 'id');
    }
}
