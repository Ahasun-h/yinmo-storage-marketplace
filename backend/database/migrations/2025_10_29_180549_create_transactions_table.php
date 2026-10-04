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
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('transaction_by');
            $table->unsignedBigInteger('transaction_for')->nullable();
            $table->unsignedBigInteger('listing_id');
            $table->unsignedBigInteger('booking_id');
            $table->string('booking_invoice_number');
            $table->string('payment_id');
            $table->enum('transaction_user_type', ['provider', 'customer']);
            $table->decimal('amount', 10, 2);
            $table->foreign('transaction_by')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('transaction_for')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('listing_id')->references('id')->on('listings')->onDelete('cascade');
            $table->foreign('booking_id')->references('id')->on('bookings')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
