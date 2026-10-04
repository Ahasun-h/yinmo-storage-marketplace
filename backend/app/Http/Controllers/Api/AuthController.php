<?php

namespace App\Http\Controllers\Api;


use Carbon\Carbon;
use App\Models\User;
use App\Mail\OtpSend;

use App\Models\Application;
use App\Models\AppSettings;
use App\Traits\ApiResponse;
use Illuminate\Support\Str;
use App\Models\SocialMedias;
use Illuminate\Http\Request;
use App\Models\ShippingAddress;
use App\Mail\ForgetPasswordMail;
use Tymon\JWTAuth\Facades\JWTAuth;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rules\Password;
use Tymon\JWTAuth\Exceptions\JWTException;

class AuthController extends Controller
{
    use ApiResponse;

    public function logout()
    {
        try {
            // Get token from request
            $token = JWTAuth::getToken();

            if (!$token) {
                return $this->error([], 'Token not provided', 401);
            }

            // Invalidate token
            JWTAuth::invalidate($token);

            return $this->success([], 'Successfully logged out', 200);
        } catch (JWTException $e) {
            return $this->error([], 'Failed to logout. ' . $e->getMessage(), 500);
        }
    }


    // user signup
    public function signup(Request $request)
    {
        $validator= $validator = Validator::make($request->all(), [
            'name'=>'required',
            'email' => 'required|email',
            'password' => [
                'required',
                'confirmed',
                Password::min(6)
            ]
        ]);

        if ($validator->fails()) {
            return $this->validationError([],$validator->errors());
        }
        try{

            $emailCheck=User::where('email',$request->email)->whereNull('deleted_at')->first();
            if($emailCheck){
                return $this->validationError([], 'Email already exists');
            }
              $user=new User();
              $user->name=$request->name;
              $user->email=$request->email;
              $user->password=Hash::make($request->password);
              $user->role=$request->role ?? 'user';
              $user->last_login_role=$request->role ?? 'user';
              $user->save();


              $user->assignRole($request->role);

              $token=JWTAuth::fromUser($user);
              $data=[
                  'token'=>$token,
                  'user'=>$user
              ];
              return $this->success($data, 'User created successfully', 200);
        }
        catch (\Exception $e) {
            return $this->error([], $e->getMessage());
        }
    }


public function forgetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required'
        ]);

        if ($validator->fails()) {
               return $this->validationError($validator->errors(), 'Validation Error', 422);
        }

        try {
            $user = User::where('email', $request->email)->first();

            if (!$user) {
               return response()->json([
                    'status' => false,
                    'message' => 'User not found',
                    'data' => (object)[]
                ], 404);
            }

            $otp = rand(100000, 999999);
            $user->otp = $otp;
            $user->otp_expires_at = now()->addMinutes(2);
            $user->save();

            $user->makeHidden(['password','created_at','updated_at']);
            $user->makeVisible(['otp', 'otp_expires_at']);


            Mail::to($user->email)->send(new ForgetPasswordMail($user));




            return $this->success($user, 'OTP sent successfully');
        } catch (\Exception $e) {
            return $this->error([], $e->getMessage());
        }
    }

 public function checkOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'otp' => 'required',
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        try {
            $user = User::where('email', $request->email)
                ->where('otp', $request->otp)
                ->first();

            if (!$user) {
                return $this->error([], 'Invalid OTP', 401);
            }

            if ($user->otp_expires_at < now()) {
                return $this->error([], 'OTP expired', 401);
            }

            $user->email_verified_at = now();
            $user->otp_verified_at = now();
            $user->reset_password_token = Str::random(60);
            $user->reset_password_token_expires_at = now()->addMinutes(5);
            $user->save();

            return $this->success($user, 'OTP verified successfully');
        } catch (\Exception $e) {
            return $this->error([], $e->getMessage());
        }
    }

    public function resetPassword(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'password' => 'required|min:6|confirmed',
            'email' => 'required|email',
            'reset_password_token' => 'required',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors());
        }

        try {
            $user = User::where('email', $request->email)
                ->whereNotNull('otp_verified_at')
                ->where('reset_password_token', $request->reset_password_token)
                ->first();

            if (!$user) {
                return $this->error([], 'Please try again', 401);
            }

            if ($user->reset_password_token_expires_at < now()) {
                return $this->error([], 'Token expired', 401);
            }

            $user->password = Hash::make($request->password);
            $user->save();
            $logout=$this->logout();
            // dd($logout);
            return $this->success($user, 'Password reset successfully');
        } catch (\Exception $e) {
            return $this->error([], $e->getMessage());
        }
    }

    public function resendOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        try {
            $user = User::where('email', $request->email)->first();

            if (!$user) {
                return $this->notFound([], 'User not found');
            }

            $otp = rand(100000, 999999);
            $user->otp = $otp;
            $user->otp_expires_at = now()->addSeconds(30);
            $user->save();

            Mail::to($user->email)->send(new ForgetPasswordMail($user));

            return $this->success($user, 'OTP resent successfully');
        } catch (\Exception $e) {
            return $this->error([], $e->getMessage());
        }
    }


    public function login(Request $request){
        $validator=Validator::make($request->all(),[
            'email'=>'required|email',
            'password'=>'required',
        ]);
        if($validator->fails()){
            return $this->error($validator->errors(), 'Validation Error', 422);
        }
        try{
            if(Auth::guard('api')->attempt(['email'=>$request->email,'password'=>$request->password])){
                  $user=Auth::guard('api')->user();
                  $user->last_login_role=$request->role ?? 'user';
                  $user->save();
                  $user->makeHidden(['password','created_at','updated_at']);
                  $token=JWTAuth::fromUser($user);
                $data=[
                    'token'=>$token,
                    'user'=>$user
                ];
                return $this->success($data, 'Login successfully');
            }

            return $this->error([], 'Invalid email or password', 401);
        }catch(\Exception $e){
            return $this->error([], $e->getMessage());
        }
    }




public function changePassword(Request $request){

    $validator=Validator::make($request->all(),[
        'new_password'=>'required|min:6|confirmed',
        'current_password'=>'required',
    ]);
    if($validator->fails()){
        return $this->error($validator->errors(), 'Validation Error', 422);
    }

    try{
        $user=Auth::guard('api')->user();
        if(Hash::check($request->current_password,$user->password)){
            $user->password=Hash::make($request->new_password);
            $user->save();
            return $this->success($user, 'Password changed successfully');
        }
        return $this->error([], ' Current password does not match', 401);
    }catch(\Exception $e){
        return $this->error([], $e->getMessage());
    }

}




public function deleteAccount(Request $request){
    try{
        $user=Auth::guard('api')->user();
        $user->email='';
        $user->save();
        $user->delete();
        return $this->success([], 'Account deleted successfully');
    }catch(\Exception $e){
        return $this->error([], $e->getMessage());
    }
}



public function userProfileImage(){
    try{
        $user=Auth::guard('api')->user();
        $profile_image=asset($user->profile_image);
        return $this->success($profile_image, 'Profile image fetched successfully');
    }catch(\Exception $e){
        return $this->error([], $e->getMessage());
    }
}




















public function ProfileImageUpdate(Request $request){
    $user=Auth::guard('api')->user();
     if($request->hasFile('profile_image')){
        $file = $request->file('profile_image');
        $extension = $file->Extension();
        $file_name = time() . '.' . $extension;
        $path = 'uploads/profile_photo/';
        $file->move($path, $file_name);
        $user->profile_image = $path.$file_name;
        $user->save();
        return $this->success($user, 'Profile image updated successfully');
     }
}


public function userProfileGet()
{

   try{
         $user=Auth::guard('api')->user();

         return $this->success($user, 'User profile fetched successfully');
    }
    catch(\Exception $e){
         return $this->error([], $e->getMessage());
   }

}


public function userProfileUpdate(Request $request){

try{
    $user=Auth::guard('api')->user();
    $user->name=$request->name ?? $user->name;
    $user->phone=$request->contact_number ?? $user->phone;
    $user->address=$request->address ?? $user->address;
    $user->dob=$request->dob ?? $user->dob;
    $user->gender=$request->gender ?? $user->gender;
    $user->save();
    return $this->success($user, 'Profile updated successfully');
}
catch(\Exception $e){
    return $this->error([], $e->getMessage());
}
}











  public function fcmToken(Request $request){


      $validator=Validator::make($request->all(),[
            'fcm_token'=>'required',
            'user_id'=>'required|exists:users,id',
        ]);
        if($validator->fails()){
            return $this->error($validator->errors(), 'Validation Error', 422);
        }
    try{



        $user=User::where('id',$request->user_id)->first();

        $user->fcm_token=$request->fcm_token;
        $user->save();

        return $this->success($user, 'Fcm token updated successfully');
    }catch(\Exception $e){
        return $this->error([], $e->getMessage());
    }
  }


    }




