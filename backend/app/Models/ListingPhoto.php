<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ListingPhoto extends Model
{



        protected $fillable = [
        'listing_id',
        'image',
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
    ];
    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }
}
