<?php

namespace App\Models;

use Spatie\Permission\Traits\HasRoles;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable implements JWTSubject
{

    use  HasRoles, HasFactory, Notifiable, SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'username',
        'first_name',
        'last_name',
        'deletion_reason',
        'email',
        'phone',
        'password',
        'profile_image',
        'role',
        'status',
        'otp',
        'otp_expired_at',
        'otp_verified_at',
        'password_reset_token',
        'password_reset_token_expires_at',
        'terms_and_conditions',
        'address',
        'zipcode',
        'last_login_at',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */

     protected $hidden = [
        'password',
        'fcm_token',
        'reset_password_token',
        'otp',
        'google_id',
        'facebook_id',
        'apple_id',
        'otp_expires_at',
        'otp_verified_at',
        'is_verified',
        'account_delete_comment',
        'account_delete_reason',
        'remember_token',
        'reset_password_token_expires_at',
        'created_at',
        'updated_at',
        'email_verified_at',
    ];

    // Cast specific attributes to the correct data type
    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_agree' => 'boolean',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'is_verified' => 'boolean',
        'status' => 'string',  // Cast enum to string
    ];


    // implement 2 methods for token get
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

   public function listings(){
        return $this->hasMany(Listing::class, 'user_id', 'id');
    }



   public function stripesetup(){
        return $this->hasOne(StripeSetup::class, 'user_id', 'id');
    }

    public function bookings(){
        return $this->hasMany(booking::class, 'user_id', 'id');
    }
 public function bookingProvider(){
        return $this->hasMany(booking::class, 'service_provider_id', 'id');
    }

}
