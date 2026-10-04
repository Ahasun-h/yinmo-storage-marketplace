<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Slot extends Model
{

    protected $fillable = [
        'listing_id',
        'slot_name',
    ];
    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }

    public function slotDateBookingManages(){
        return $this->hasMany(SlotDateBookingManage::class, 'slot_id', 'id');
    }
}
