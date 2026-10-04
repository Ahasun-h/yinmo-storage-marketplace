<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DynamicPage;
use App\Models\SupportAndHelp;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SupportHelpController extends Controller
{
    use ApiResponse;

    public function store(Request $request){
       try{

            $user=Auth::guard('api')->user();
            $support=new SupportAndHelp();
            $support->full_name=$request->full_name;
            $support->email=$request->email;
            $support->user_id=$user->id;
            $support->message=$request->message;
            $support->save();
            return $this->success($support, 'Message sent successfully');
       }
       catch(\Exception $e){
        return $this->error($e->getMessage());
       }
    }

 public function privacyPolicy(){
        $privacy = DynamicPage::where('slug', 'like','privacy-policy')
                              ->orWhere('slug', 'like','privacy')
                               ->where('status', 1)
                              ->first();

        $data = [
            'privacy' => $privacy
        ];

        return $this->success($data, "Privacy Policy retrieved successfully");
    }

    // Fetch Terms and Conditions
    public function termCondition(){
   $term_condition = DynamicPage::where('slug', 'like', 'term-and-condition%')
                            ->orWhere('slug', 'like', 'terms-and-conditions%')
                            ->first();




        $data = [
            'term_condition' => $term_condition
        ];

        return $this->success($data, "Terms and Conditions retrieved successfully"); // Correct message
    }


    public function faq(){
        try{
              $faq = Faq::all();

            return $this->success($faq, "Faq retrieved successfully");
        }
        catch(\Exception $e){
            return $this->error($e->getMessage());
        }
    }


}
