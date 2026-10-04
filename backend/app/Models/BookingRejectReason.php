<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BookingRejectReason extends Model
{
    public function booking(){
          return $this->hasMany(booking::class,'reject_id','id');
    }
}
