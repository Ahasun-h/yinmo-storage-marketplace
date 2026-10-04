<?php

namespace App\Services;

use Kreait\Firebase\Contract\Messaging;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class ChatNotificationService
{
    private $messaging;


    public function __construct(Messaging $messaging)
    {
        $this->messaging = $messaging;
        // dd($this->messaging);
    }



    public function sendChatNotification(string $token, string $senderName, string $messageText, array $extraData = [])
    {

        $notification = Notification::create($senderName, $messageText);


        $message = CloudMessage::withTarget('token', $token)
            ->withNotification($notification)
            ->withData($extraData);


        return $this->messaging->send($message);
    }
}
