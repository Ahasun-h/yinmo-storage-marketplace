<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Listing;
use App\Models\ReviewRating;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Traits\ApiResponse;

class GuestSearchListController extends Controller
{
    use ApiResponse;

    public function searchListing(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'latitude' => 'required',
            'longitude' => 'required',
            'search_type' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        try {
            $latitude  = $request->latitude;
            $longitude = $request->longitude;
            $radius    = 5; // 5 KM

            $query = Listing::with(['features', 'photos'])
                ->select('*')
                ->selectRaw("
                    (6371 * acos(
                        cos(radians(?)) *
                        cos(radians(latitude)) *
                        cos(radians(longitude) - radians(?)) +
                        sin(radians(?)) *
                        sin(radians(latitude))
                    )) AS distance
                ", [$latitude, $longitude, $latitude])
                ->when($request->search_type, function ($q) use ($request) {
                    $q->where('listing_type', $request->search_type);
                })
                ->having('distance', '<=', $radius)
                ->orderBy('distance', 'asc');

            if ($request->search_type == 'parking') {
                $query->where('listing_type', 'parking');
            } elseif ($request->search_type == 'bike_rent') {
                $query->where('listing_type', 'bike_rent');
            } elseif ($request->search_type == 'luggage') {
                $query->where('listing_type', 'luggage');
            }

            $listings = $query->get();

            // Modify output with rating and full photo URLs
            $listings->map(function ($listing) {
                // Add ratings
                $listing->average_rating = round(
                    ReviewRating::where('listing_id', $listing->id)->avg('rating'), 1
                );
                $listing->total_reviews = ReviewRating::where('listing_id', $listing->id)->count();

                // Convert photo URLs to full asset URLs
                if ($listing->photos && count($listing->photos) > 0) {
                    $listing->photos->map(function ($photo) {
                        if (isset($photo->image)) {
                            $photo->image = asset($photo->image);
                        }
                        return $photo;
                    });
                }

                return $listing;
            });

            return $this->success($listings, 'Listings fetched successfully', 200);

        } catch (\Exception $e) {
            return $this->error($e->getMessage());
        }
    }
    public function listingDetails($id){
        try{
        $list=Listing::with(['features','photos'])->with(['reviews' => function ($query) {
        $query->select('id', 'listing_id', 'user_id', 'rating');
        }])
        ->find($id);
        $data=[
            'id'=>$list->id,
            'title'=>$list->title,
            'description'=>$list->description,
            'price'=>$list->price,
            'location'=>$list->location,
            'listing_type'=>$list->listing_type,
            'latitude'=>$list->latitude,
            'longitude'=>$list->longitude,
            'avg_rating'=>$list->reviews->avg('rating'),
            'unique_user_count'=>$list->reviews->pluck('user_id')->unique()->count(),
            'features'=>$list->features,
            'photos'=>$list->photos->each(function($photo){
                $photo->image=asset($photo->image);
            }),

            'reviews'=>$list->reviews
        ];
        return $this->success($data, 'Listings fetched successfully', 200);
    }
    catch(\Exception $e){
        return $this->error([], $e->getMessage(), 500);
    }
    }

    public function listingReviews(Request $request){
        try{
       $rating=$request->rating;
       $fiveStar=ReviewRating::where('listing_id', $request->listing_id)->where('rating', 5)->count();
       $fourStar=ReviewRating::where('listing_id', $request->listing_id)->where('rating', 4)->count();
       $threeStar=ReviewRating::where('listing_id', $request->listing_id)->where('rating', 3)->count();
       $twoStar=ReviewRating::where('listing_id', $request->listing_id)->where('rating', 2)->count();
       $oneStar=ReviewRating::where('listing_id', $request->listing_id)->where('rating', 1)->count();
       $avgRating=ReviewRating::where('listing_id', $request->listing_id)->avg('rating');
       if($rating==5){
        $review=ReviewRating::with('user')->where('listing_id', $request->listing_id)->where('rating', 5)->get();
       }
       else if($rating==4){
        $review=ReviewRating::with('user')->where('listing_id', $request->listing_id)->where('rating', 4)->get();
       }
       else if($rating==3){
        $review=ReviewRating::with('user')->where('listing_id', $request->listing_id)->where('rating', 3)->get();
       }
       else if($rating==2){
        $review=ReviewRating::with('user')->where('listing_id', $request->listing_id)->where('rating', 2)->get();
       }
       else if($rating==1){
        $review=ReviewRating::with('user')->where('listing_id', $request->listing_id)->where('rating', 1)->get();
       }
       else{
        $review=ReviewRating::with('user')->where('listing_id', $request->listing_id)->get();
       }

       if($review){
        $data=[
            'fiveStar'=>$fiveStar,
            'fourStar'=>$fourStar,
            'threeStar'=>$threeStar,
            'twoStar'=>$twoStar,
            'oneStar'=>$oneStar,
            'avgRating'=>round($avgRating, 2),
            'reviews'=>$review,


        ];
        return $this->success($data, 'Listings fetched successfully', 200);
       }
       else{
        return $this->success([], 'No Reviews Found', 200);
       }
  }
  catch(\Exception $e){
      return $this->error([], $e->getMessage(), 500);
  }
    }
}
