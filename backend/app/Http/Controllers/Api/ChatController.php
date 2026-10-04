<?php

namespace App\Http\Controllers\Api;

use App\Events\ChatEvent;
use App\Http\Controllers\Controller;
use App\Models\Chat;
use App\Models\ChatImage;
use App\Models\User;
use App\Services\ChatNotificationService;
use App\Traits\ApiResponse;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class ChatController extends Controller
{
    use ApiResponse;

    public function sendMessage(Request $request, ChatNotificationService $chatNotificationService)
    {
        $validator = Validator::make($request->all(), [
        'receiver_id' => 'required|exists:users,id',
        'message'     => 'required|string|max:1000',
    ]);

    if ($validator->fails()) {
        return $this->validationError($validator->errors());
    }

    try {
        $receiverId = $request->receiver_id;

        // Generate unique conversation ID (for 1-to-1 chat)
        $conversationId = implode('-', [
            min(Auth::id(), $receiverId),
            max(Auth::id(), $receiverId),
        ]);

        // $chat = Chat::create([
        //     'sender_id'      => Auth::id(),
        //     'receiver_id'    => $receiverId,
        //     'message'        => $request->message,
        //     'conversation_id'=> $conversationId,
        //     'created_at'     => Carbon::now(),
        //     'updated_at'     => Carbon::now(),
        // ]);

        $chat=new Chat();
        $chat->sender_id      = Auth::id();
        $chat->receiver_id    = $receiverId;
        $chat->message        = $request->message;
        $chat->conversation_id= $conversationId;
        $chat->save();

        if ($request->has('image')) {
            $file=$request->file('image');
            $extension=$file->getClientOriginalExtension();
            $file_name=time().'.'.$extension;
            $path='uploads/chat_images/';
            $file->move($path,$file_name);
            $chatImage=new ChatImage();
            $chatImage->chat_id=$chat->id;
            $chatImage->image=$path.$file_name;
            $chatImage->save();

        }

        $image=asset($chat->chatimage->image);
        $chat->image=$image;
        broadcast(new ChatEvent($chat))->toOthers();


        $receiver = User::find($receiverId);

        if ($receiver && $receiver->fcm_token) {
            $chatNotificationService->sendChatNotification(
                $receiver->fcm_token,
                Auth::user()->name,
                $request->message,
                [
                    'conversation_id' => $conversationId,
                    'sender_id'       => Auth::id(),
                    'chat_id'         => $chat->id,
                ]
            );
        }

        return $this->success($chat, 'Message sent successfully');
    } catch (\Exception $e) {
        return $this->error($e->getMessage(), [], 500);
    }
    }

    public function getConversation($conversation_id)
    {
        try {
            $messages = Chat::where('conversation_id', $conversation_id)
                ->orderBy('created_at', 'asc')
                ->get();

            // $messages->each->makeHidden(['created_at', 'updated_at']);
             $messages->each(function ($msg) {
                 $msg->image=asset($msg->chatimage->image);
                 $msg->image_id=$msg->chatimage->id;
             });
            return $this->success($messages, 'Conversation retrieved successfully');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), [], 500);
        }
    }


public function chatdelete( $id){

    try {
        $chat=Chat::find($id);
        $chat->delete();

        return $this->success($chat, 'Chat deleted successfully');
    } catch (\Exception $e) {
        return $this->error($e->getMessage(), [], 500);
    }
}

public function chatImageDelete($id){

    try {
        $chatImage=ChatImage::find($id);
        $chatImage->delete();

        return $this->success($chatImage, 'Chat Image deleted successfully');
    } catch (\Exception $e) {
        return $this->error($e->getMessage(), [], 500);
    }
}



public function getchatlist()
{
    $authId = Auth::id();

    $chats = Chat::where(function ($query) use ($authId) {
            $query->where('sender_id', $authId)
                  ->orWhere('receiver_id', $authId);
        })
        ->select('conversation_id', DB::raw('MAX(created_at) as latest_time'))
        ->groupBy('conversation_id')
        ->orderByDesc('latest_time')
        ->get()
        ->map(function ($chat) use ($authId) {

            $lastMessage = Chat::where('conversation_id', $chat->conversation_id)
                ->latest()
                ->with('chatimage') // 👈 eager load image relation
                ->first();

            $otherUserId = $lastMessage->sender_id == $authId
                ? $lastMessage->receiver_id
                : $lastMessage->sender_id;

            $otherUser = User::find($otherUserId);

            $unreadCount = Chat::where('conversation_id', $chat->conversation_id)
                ->where('receiver_id', $authId)
                ->where('is_read', 0)
                ->count();

            return [
                 'chat_id'         => $lastMessage->id ?? '',
                'conversation_id' => $chat->conversation_id,
                'latest_time'     => Carbon::parse($chat->latest_time)
                                            ->timezone(config('app.timezone'))
                                            ->format('Y-m-d H:i:s'),
                'message'         => $lastMessage->message ?? '',
                'user_name'       => $otherUser->name ?? '',
                'receiver_id'     => $otherUserId,
                'user_profile'    => $otherUser && $otherUser->profile
                                        ? asset($otherUser->profile)
                                        : '',
                'chat_image'      => $lastMessage && $lastMessage->chatimage
                                        ? asset($lastMessage->chatimage->image)
                                        : '',
                 'image_id'        => $lastMessage->chatimage->id ?? '',
                'unread_count'    => $unreadCount,
            ];
        });

    return $this->success($chats, 'Chats list retrieved successfully', 200);
}


public function markAsRead($conversation_id)
{
    try {
        $authId = Auth::id();


        $messages = Chat::where('conversation_id', $conversation_id)
            ->where('receiver_id', $authId)
            ->where('is_read', 0)
            ->get();


        Chat::where('conversation_id', $conversation_id)
            ->where('receiver_id', $authId)
            ->where('is_read', 0)
            ->update(['is_read' => 1]);


        $messages->each(function ($msg) {
            $msg->is_read = 1;
        });


        return $this->success($messages, 'Messages marked as read');
    } catch (\Exception $e) {
        return $this->error($e->getMessage(), [], 500);
    }
}



}
