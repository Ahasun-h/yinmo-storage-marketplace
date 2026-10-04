@extends('backend.master')

@section('title', 'Booking Summery')

@section('content')
<div class="container mt-5">
    <h2 class="mb-4">Booking Summery</h2>

    @if(session('error'))
        <div class="alert alert-danger">{{ session('error') }}</div>
    @endif

    <!-- Booking Info & User Info -->
    <div class="row">
        <!-- Booking Details -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    Booking Details
                </div>
                <div class="card-body">
                    <p><strong>Booking ID:</strong> #{{ $booking->id }}</p>
                    <p><strong>Listing:</strong> {{ $booking->listing->title ?? 'N/A' }} ({{ $booking->listing->listing_type ?? 'N/A' }})</p>
                    <p><strong>Total Amount:</strong> ${{ $booking->total ?? 0 }}</p>
                    <p><strong>Booked On:</strong> {{ $booking->created_at->format('d M Y, h:i A') }}</p>

                    <h5 class="mt-3">Extra Services</h5>
                    @if($booking->ExtraServicesBooking->count() > 0)
                        <ul class="list-group list-group-flush">
                            @foreach($booking->ExtraServicesBooking as $service)
                                <li class="list-group-item">{{ $service->name }} - ${{ $service->price }}</li>
                            @endforeach
                        </ul>
                    @else
                        <p>No extra services</p>
                    @endif
                </div>
            </div>
        </div>

        <!-- User Details -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white">
                    User Information
                </div>
                <div class="card-body">
                    <p><strong>Name:</strong> {{ $booking->user->name ?? 'N/A' }}</p>
                    <p><strong>Email:</strong> {{ $booking->user->email ?? 'N/A' }}</p>
                    <p><strong>Phone:</strong> {{ $booking->user->phone ?? 'N/A' }}</p>
                    <p><strong>Address:</strong> {{ $booking->user->address ?? 'N/A' }}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Booking Type Specific Details -->
    @php
        $type = $booking->listing->listing_type ?? '';
    @endphp

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-info text-white">
            @if($type == 'parking') Slots @elseif($type == 'luggage') Boxes @elseif($type == 'bike_rent') Bike Rent Dates @else Details @endif
        </div>
        <div class="card-body">
            @if($type == 'parking' && $booking->slotDateBookingManages->count() > 0)
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Slot Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($booking->slotDateBookingManages as $slot)
                        <tr>
                            <td>{{ $slot->slot_date }}</td>
                            <td>{{ $slot->slot->slot_name ?? 'N/A' }}</td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            @elseif($type == 'luggage' && $booking->boxBookingDateManages->count() > 0)
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Box Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($booking->boxBookingDateManages as $box)
                        <tr>
                            <td>{{ $box->box_date }}</td>
                            <td>{{ $box->box->box_name ?? 'N/A' }}</td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            @elseif($type == 'bike_rent' && $booking->bikeIdmanageDates->count() > 0)
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Bike ID</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($booking->bikeIdmanageDates as $bike)
                        <tr>
                            <td>{{ $bike->bike_date }}</td>
                            <td>{{ $bike->bikeId->bike_id ?? 'N/A' }}</td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            @else
                <p>No data available for this booking type.</p>
            @endif
        </div>
    </div>
</div>
@endsection
