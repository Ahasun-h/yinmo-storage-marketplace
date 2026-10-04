<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class boxBookingDateManage extends Model
{
    public function box(){
        return $this->belongsTo(Box::class, 'box_id', 'id');
    }

    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }
      public function booking()
    {
        return $this->belongsTo(booking::class, 'booking_id', 'id');
    }
}
