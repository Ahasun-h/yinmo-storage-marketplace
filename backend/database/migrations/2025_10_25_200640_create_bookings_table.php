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
        Schema::create('bookings', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('listing_id');
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('service_provider_id')->nullable();
            $table->decimal('subtotal', 10, 2)->nullable();
            $table->decimal('total', 10, 2)->nullable();
            $table->integer('total_days')->nullable();
            $table->string('invoice_id')->nullable();
            $table->string('pdf_invoice')->nullable();

            $table->decimal('provider_fee_after_comission', 10, 2)->nullable();
            $table->decimal('partial_paid', 10, 2)->nullable();
            $table->decimal('total_paid', 10, 2)->nullable();
            $table->decimal('admin_comission', 10, 2)->nullable();
            $table->enum('payment_status',['paid','partial','unpaid','refund'])->default('unpaid');
            $table->string('user_payment_id')->nullable();
             $table->string('admin_paymant_id')->nullable();
            $table->enum('status',['upcoming','completed','canceled'])->default('upcoming');
            $table->foreign('listing_id')->references('id')->on('listings')->onDelete('cascade');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('service_provider_id')->references('id')->on('users')->onDelete('cascade');
            // $table->timestamp('deleted_at');
            $table->unsignedBigInteger('reject_id')->nullable();
            $table->foreign('reject_id')->references('id')->on('booking_reject_reasons')->onDelete('cascade');
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bookings');
    }
};
