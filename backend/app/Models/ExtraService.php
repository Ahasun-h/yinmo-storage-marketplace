<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ExtraService extends Model
{

    protected $fillable=[
        'listing_id',
        'service_name',
        'price'
    ];
    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }

    public function ExtraServicesBooking(){
        return $this->hasMany(ExtraServicesBooking::class, 'extra_service_id', 'id');
    }
}
