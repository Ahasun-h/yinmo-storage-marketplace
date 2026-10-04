<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChatImage extends Model
{
    public function chat(){
        return $this->belongsTo(Chat::class, 'chat_id', 'id');
    }
}
