<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ExtraServicesBooking extends Model
{
    public function extraService()
    {
        return $this->belongsTo(ExtraService::class);
    }

    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }

    public function listing()
    {
        return $this->belongsTo(Listing::class);
    }

   
}
