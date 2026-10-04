<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Feature extends Model
{

    protected $fillable = [
        'feature_name',
        'listing_id',
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
    ];
    public function listing(){
        return $this->belongsTo(Listing::class, 'listing_id', 'id');
    }
}
