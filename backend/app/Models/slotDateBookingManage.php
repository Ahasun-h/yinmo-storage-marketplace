<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class slotDateBookingManage extends Model
{
    public function slot()
    {
        return $this->belongsTo(Slot::class, 'slot_id', 'id');
    }

   public function listing()
    {
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }

    public function booking()
    {
        return $this->belongsTo(booking::class, 'booking_id', 'id');
    }
}
