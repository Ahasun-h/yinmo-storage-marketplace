<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Traits\ApiResponse;
use App\Models\ReviewRating;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
class ReviewRatingController extends Controller
{

    use ApiResponse;

    public function store(Request $request)
    {
       $validator = Validator::make($request->all(), [
            'listing_id' => 'required',
            'rating' => 'required',
       ]);

       if ($validator->fails()) {
           return $this->validationError($validator->errors());
       }

       try{
             $user=Auth::guard('api')->user();
           $review = new ReviewRating();
           $review->listing_id = $request->listing_id;
           $review->user_id = $user->id;
           $review->rating = $request->rating;
           $review->comment = $request->comment;
           $review->save();
           return $this->success($review, 'Review Rated Successfully', 200);
       }
       catch(\Exception $e){
           return $this->error(['errors' => $e->getMessage()], 500);
       }
    }


    public function show($id)
    {
        try{
            $review = ReviewRating::where('listing_id', $id)->get();
            return $this->success($review, 200);
        }
        catch(\Exception $e){
            return $this->error(['errors' => $e->getMessage()], 500);
        }
    }

    public function update(Request $request, $id)
    {

        try{
            $user=Auth::guard('api')->user();
            $review = ReviewRating::find($id);
            $review->listing_id = $request->listing_id;
            $review->user_id = $user->id;
            $review->rating = $request->rating;
            $review->comment = $request->comment;
            $review->save();
            return $this->success( $review, 'Review Rated Successfully', 200);
        }
        catch(\Exception $e){
            return $this->error(['errors' => $e->getMessage()], 500);
        }

    }

    public function destroy($id)
    {
        try{
            $review = ReviewRating::find($id);
            $review->delete();
            return $this->success('Review Deleted Successfully', 200);
        }
        catch(\Exception $e){
            return $this->error(['errors' => $e->getMessage()], 500);
        }
    }
}
