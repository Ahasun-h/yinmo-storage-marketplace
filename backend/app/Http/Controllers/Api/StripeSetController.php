<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Traits\ApiResponse;
use App\Models\StripeSetup;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
class StripeSetController extends Controller
{
    use ApiResponse;
    public function store(Request $request) {
        try{
            $user =Auth::guard('api')->user();

            $user->name=$request->name ?? $user->name;
            $user->phone=$request->contact_number ?? $user->phone;
            $user->address=$request->address ?? $user->address;
            $user->save();

            $stripeSetup=StripeSetup::where('user_id', $user->id)->first();
            if(!$stripeSetup){
                  $stripeSetup=new StripeSetup();
            }

            $stripeSetup->user_id=$user->id;
             $stripeSetup->Account_holder=$request->Account_holder;
             $stripeSetup->account_number=$request->account_number;
             $stripeSetup->payout_schedule=$request->payout_schedule;
             $stripeSetup->tax_identity=$request->tax_identity;
             $stripeSetup->save();
            $user->assignRole('service_provider');

            return $this->success($user, 'Profile updated successfully');

        }
        catch(\Exception $e) {
            return $this->error($e->getMessage());
        }
    }

    public function show() {
        try{
            $user =Auth::guard('api')->user();
            $stripeSetup=StripeSetup::with('user')->where('user_id', $user->id)->first();
            return $this->success($stripeSetup, 'stripeSetup fetched successfully');
        }
        catch(\Exception $e) {
            return $this->error($e->getMessage());
        }
    }
}
