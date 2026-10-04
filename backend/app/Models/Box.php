<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Box extends Model
{

    protected $fillable=[
        'listing_id',
        'box_name',
    ];
    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }

    public function boxBookingDateManages(){
        return $this->hasMany(BoxBookingDateManage::class, 'box_id', 'id');
    }
}
