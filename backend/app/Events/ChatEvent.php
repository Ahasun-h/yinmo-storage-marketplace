<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class ChatEvent implements ShouldBroadcastNow
{
    use Dispatchable, SerializesModels,InteractsWithSockets;



    public $chat;

    public function __construct( $chat)
    {
        $this->chat = $chat;

    }

    // public function broadcastOn()
    // {
    //     return new PrivateChannel('chat-conversation.' . $this->chat->receiver_id);
    // }

    public function broadcastOn()
    {
        Log::info('enter broadcats');
        return new PrivateChannel('chat-conversation.'.$this->chat->conversation_id);
    }

    public function broadcastWith()
    {
        return [
        'message' => $this->chat->message,
        'sender_id' => $this->chat->sender_id,
        'receiver_id' => $this->chat->receiver_id,
        'conversation_id' => $this->chat->conversation_id,
        'image' => $this->chat->chatimage
            ? asset($this->chat->chatimage->image)
            : '',
        'image_id' => $this->chat->chatimage ? $this->chat->chatimage->id : null,
        'created_at' => $this->chat->created_at->toDateTimeString(),
    ];
    }
}
