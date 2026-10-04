<?php

namespace App\Http\Controllers\Api;

use App\Models\Slot;
use App\Models\Feature;
use App\Models\Listing;
use App\Traits\ApiResponse;
use App\Models\ExtraService;
use App\Models\ListingPhoto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\BikeId;
use App\Models\User;
use App\Models\ReviewRating;
class listingController extends Controller
{
    use ApiResponse;


public function store(Request $request)
{

    $validator = Validator::make($request->all(), [
        'title' => 'required|string|max:255',
        'description' => 'required|string',
        'price' => 'required|numeric',
        'langitude' => 'required|numeric',
        'latitude' => 'required|numeric',
    ]);

    if ($validator->fails()) {
        return $this->validationError($validator->errors());
    }

    DB::beginTransaction();

    try {
        $user = Auth::guard('api')->user();


        if (!$user->hasRole('service_provider')) {
            DB::rollBack();
            return $this->error([], 'You are not authorized to create a listing.', 403);
        }

        // Create the listing
        $listing = new Listing();
        $listing->title = $request->input('title');
        $listing->description = $request->input('description');
        $listing->location = $request->input('location');
        $listing->price = $request->input('price');
        $listing->longitude = $request->input('langitude');
        $listing->latitude = $request->input('latitude');
        $listing->listing_type = $request->input('listing_type');
        $listing->user_id = $user->id;
        $listing->save();


        if ($listing) {


            if ($request->slot_name) {
                foreach ($request->slot_name as $slot) {
                    $listingSlot = new Slot();
                    $listingSlot->slot_name = $slot;
                    $listingSlot->listing_id = $listing->id;
                    $listingSlot->save();
                }
            }


            if ($request->feature_name) {
                foreach ($request->feature_name as $feature) {
                    $featureSlot = new Feature();
                    $featureSlot->feature_name = $feature;
                    $featureSlot->listing_id = $listing->id;
                    $featureSlot->save();
                }
            }


            if ($request->service_name) {
                foreach ($request->service_name as $index => $extra_service) {
                    $extraService = new ExtraService();
                    $extraService->service_name = $extra_service;
                    $extraService->price = $request->extra_service_price[$index];
                    $extraService->listing_id = $listing->id;
                    $extraService->save();
                }
            }


            if ($request->hasFile('images')) {
                $images = $request->file('images');
                foreach ($images as $image) {
                    $file = $image;
                    $filename = time() . '_' . uniqid() . $file->getClientOriginalName();
                    $filePath = 'uploads/listing/';
                    $file->move(public_path($filePath), $filename);

                    $listingImage = new ListingPhoto();
                    $listingImage->image = $filePath . $filename;
                    $listingImage->listing_id = $listing->id;
                    $listingImage->save();
                }
            }


            if ($request->box_name && $request->listing_type == 'luggage') {
                foreach ($request->box_name as $index => $box) {
                    $luggageBox = new Feature();
                    $luggageBox->box_name = $box;
                    $luggageBox->listing_id = $listing->id;
                    $luggageBox->save();
                }
            }

            if($request->bike_id && $request->listing_type == 'bike_rent'){
                foreach ($request->bike_id as $index => $bike) {
                    $bikeId = new BikeId();
                    $bikeId->bike_id = $bike;
                    $bikeId->listing_id = $listing->id;
                    $bikeId->save();
                }
            }

        }

        DB::commit();

        return $this->success($listing, 'Listing created successfully.', 201);

    } catch (\Exception $e) {
        DB::rollBack();
        return $this->error([], $e->getMessage(), 500);
    }
}


    public function show($id)
    {

    }

   public function update(Request $request, $id)
{
    $validator = Validator::make($request->all(), [
        'title' => 'required|string|max:255',
        'description' => 'required|string',
        'price' => 'required|numeric',
        'langitude' => 'required|numeric',
        'latitude' => 'required|numeric',
    ]);

    if ($validator->fails()) {
        return $this->validationError($validator->errors());
    }

    DB::beginTransaction();

    try {
        $user = Auth::guard('api')->user();

        if (!$user->hasRole('service_provider')) {
            DB::rollBack();
            return $this->error([], 'You are not authorized to update a listing.', 403);
        }

        $listing = Listing::find($id);
        if (!$listing) {
            DB::rollBack();
            return $this->error([], 'Listing not found.', 404);
        }


        $listing->update([
            'title' => $request->title,
            'description' => $request->description,
            'location' => $request->location,
            'price' => $request->price,
            'longitude' => $request->langitude,
            'latitude' => $request->latitude,
            'listing_type' => $request->listing_type,
        ]);


        Slot::where('listing_id', $listing->id)->delete();
        Feature::where('listing_id', $listing->id)->delete();
        ExtraService::where('listing_id', $listing->id)->delete();
        BikeId::where('listing_id', $listing->id)->delete();
        // ListingPhoto::where('listing_id', $listing->id)->delete();


        if (!empty($request->slot_name) && is_array($request->slot_name)) {
            foreach ($request->slot_name as $slot) {
                Slot::create([
                    'listing_id' => $listing->id,
                    'slot_name' => $slot,
                ]);
            }
        }


        if (!empty($request->feature_name) && is_array($request->feature_name)) {
            foreach ($request->feature_name as $feature) {
                Feature::create([
                    'listing_id' => $listing->id,
                    'feature_name' => $feature,
                ]);
            }
        }


        if (!empty($request->service_name) && is_array($request->service_name)) {
            foreach ($request->service_name as $index => $extra_service) {
                ExtraService::create([
                    'listing_id' => $listing->id,
                    'service_name' => $extra_service,
                    'price' => $request->extra_service_price[$index] ?? 0,
                ]);
            }
        }


        if (!empty($request->box_name) && $request->listing_type == 'luggage' && is_array($request->box_name)) {
            foreach ($request->box_name as $box) {
                Feature::create([
                    'listing_id' => $listing->id,
                    'box_name' => $box,
                ]);
            }
        }


        if (!empty($request->bike_id) && $request->listing_type == 'bike_rent' && is_array($request->bike_id)) {
            foreach ($request->bike_id as $bike) {
                BikeId::create([
                    'listing_id' => $listing->id,
                    'bike_id' => $bike,
                ]);
            }
        }


        if ($request->hasFile('images')) {

            foreach ($request->file('images') as $file) {
                $filename = time() . '_' . uniqid() . '.' . $file->getClientOriginalExtension();
                $filePath = 'uploads/listing/' . $filename;
                $file->move(public_path('uploads/listing/'), $filename);

                ListingPhoto::create([
                    'listing_id' => $listing->id,
                    'image' => $filePath,
                ]);
            }
        }

        DB::commit();

        return $this->success($listing, 'Listing updated successfully.', 200);

    } catch (\Exception $e) {
        DB::rollBack();
        return $this->error([], $e->getMessage(), 500);
    }
}



    public function destroy($id)
    {
        // Logic to delete a specific listing by ID
    }

    public function deletePhoto($id)
    {
        try{
        $photo = ListingPhoto::findOrFail($id);
        $photo->delete();

        return $this->success([], 'Photo deleted successfully.', 200);
        }
        catch(\Exception $e){
            return $this->error([], $e->getMessage(), 500);
        }
    }

  public function providerListings()
{
    try {
        $user = Auth::guard('api')->user();

        // Get all listings by this provider
        $listings = Listing::with('features')->where('user_id', $user->id)
            ->with(['reviews' => function ($query) {
                $query->select('id', 'listing_id', 'user_id', 'rating');
            }])
            ->get();



           // Map each listing with avg rating and unique user count
            $data = $listings->map(function ($listing) {
            $avgRating = $listing->reviews->avg('rating');
            $uniqueUserCount = $listing->reviews->pluck('user_id')->unique()->count();

            return [
                'id' => $listing->id,
                'title' => $listing->title,
                'description' => $listing->description,
                'price' => $listing->price,
                'location' => $listing->location,
                'listing_type' => $listing->listing_type,
                 'features' => $listing->features,
                'avg_rating' => round($avgRating, 2),
                'unique_user_count' => $uniqueUserCount,
            ];
        });

        return $this->success($data, 'Listings fetched successfully', 200);

    } catch (\Exception $e) {
        return $this->error([], $e->getMessage(), 500);
    }
}


public function singleListingDetails($id){
    try{


        $user = Auth::guard('api')->user();
        $list=Listing::with(['features','photos'])->where('user_id', $user->id)->with(['reviews' => function ($query) {
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

public function singleListingReviews(Request $request){
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
