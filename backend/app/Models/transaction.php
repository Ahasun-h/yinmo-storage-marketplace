<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class transaction extends Model
{
    public function booking(){
        return $this->belongsTo(booking::class,'booking_id','id');
    }
}
