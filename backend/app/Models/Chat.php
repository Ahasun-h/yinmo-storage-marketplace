<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Chat extends Model
{
    protected $fillable = [
        'sender_id',
        'receiver_id',
        'conversation_id',
        'is_read',
        'message',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'sender_id', 'id');
    }

    public function chatimage(){
        return $this->hasOne(ChatImage::class, 'chat_id', 'id');
    }
}
