<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('slot_date_booking_manages', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('listing_id');
            $table->unsignedBigInteger('slot_id');
            $table->timestamp('slot_date');
             $table->unsignedBigInteger('booking_id')->nullable();
            $table->foreign('booking_id')->references('id')->on('bookings')->onDelete('cascade');
             $table->foreign('listing_id')->references('id')->on('listings')->onDelete('cascade');
             $table->foreign('slot_id')->references('id')->on('slots')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('slot_date_booking_manages');
    }
};
