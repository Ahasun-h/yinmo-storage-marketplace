<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Listing extends Model
{




     protected $fillable = [
        'user_id',
        'title',
        'description',
        'location',
        'price',
        'longitude',
        'latitude',
        'listing_type',
    ];
    public  function user(){
        return $this->belongsTo(User::class, 'user_id', 'id');
    }

    public function photos(){
        return $this->hasMany(ListingPhoto::class, 'listing_id', 'id');
    }

    public function slot(){
        return $this->hasMany(Slot::class, 'listing_id', 'id');
    }

    public function features(){
        return $this->hasMany(Feature::class, 'listing_id', 'id');
    }

    public function extraservices(){
        return $this->hasMany(ExtraService::class, 'listing_id', 'id');
    }

    public function boxes(){
        return $this->hasMany(Box::class, 'listing_id', 'id');
    }

    public function reviews(){
        return $this->hasMany(ReviewRating::class, 'listing_id', 'id');
    }

    public function bikeIds(){
        return $this->hasMany(BikeId::class, 'listing_id', 'id');
    }

    public function slotDateBookingManages(){
        return $this->hasMany(SlotDateBookingManage::class, 'listing_id', 'id');
    }
    public function boxBookingDateManages(){
        return $this->hasMany(BoxBookingDateManage::class, 'listing_id', 'id');
    }

    public function bikeIdmanageDates(){
        return $this->hasMany(BikeIdManageDate::class, 'listing_id', 'id');
    }
}
