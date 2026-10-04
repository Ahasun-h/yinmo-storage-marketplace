<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ReviewRating extends Model
{

    public function user(){
        return $this->belongsTo(User::class, 'user_id', 'id');
    }

    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }
}
