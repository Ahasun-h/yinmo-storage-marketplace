<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BikeId extends Model
{
       protected $fillable = [
        'listing_id',
        'bike_id',
    ];

    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }

    public function bikeIdmanageDates(){
        return $this->hasMany(BikeIdManageDate::class, 'bike_id', 'id');
    }
}
