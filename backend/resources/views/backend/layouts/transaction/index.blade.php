@extends('backend.master')

@section('title', 'Transaction History')

@section('content')
<div class="row">
    <div class="col-12">
        <div class="mb-4 d-flex justify-content-between align-items-center">
            <h3 class="mb-0 fw-bold">Transaction History</h3>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-12">
        <div class="card shadow-sm border-0">
            <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                <h5 class="mb-0">
                    <i class="bi bi-wallet2 me-2 text-primary"></i>My Transactions
                </h5>
                <div class="mt-2 mt-sm-0">
                    <button class="btn btn-outline-secondary filter-btn active" data-filter="">All</button>
                    <button class="btn btn-outline-primary filter-btn" data-filter="today">Today</button>
                    <button class="btn btn-outline-success filter-btn" data-filter="week">This Week</button>
                    <button class="btn btn-outline-warning filter-btn" data-filter="month">This Month</button>
                    <button class="btn btn-outline-danger filter-btn" data-filter="year">This Year</button>
                </div>
            </div>

            <div class="card-body p-2">
                <div class="table-responsive">
                    <table id="transactionTable" class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Booking ID</th>
                                <th>Invoice ID</th>
                                <th>Listing</th>
                                <th>Provider</th>
                                <th>Paying User</th>
                                <th>Amount (USD)</th>
                                <th>Payment ID</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

                <div class="mt-3 fw-bold fs-5 text-end">
                    Total Revenue: $<span id="totalRevenue">0.00</span>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
$(document).ready(function() {
    let currentFilter = '';

    let table = $('#transactionTable').DataTable({
        processing: true,
        serverSide: true,
        ajax: {
            url: "{{ route('transaction.data') }}",
            data: function(d) {
                d.filter = currentFilter;
            }
        },
        columns: [
            { data: 'DT_RowIndex', name: 'DT_RowIndex', orderable: false, searchable: false },
            { data: 'booking_id', name: 'booking_id' },
            { data: 'booking_invoice_number', name: 'booking_invoice_number' },
            { data: 'listing_title', name: 'listing_title' },
            { data: 'provider_name', name: 'provider_name' },

            {data:'transaction_user_type',name:'transaction_user_type'},

            { data: 'amount', name: 'amount' },
            { data: 'payment_id', name: 'payment_id' },
            { data: 'created_at', name: 'created_at' },
        ],
       drawCallback: function(settings) {
        // Safely get totalRevenue
        let revenue = 0;
        if(settings.json && settings.json.totalRevenue) {
            revenue = parseFloat(settings.json.totalRevenue);
        }
        $('#totalRevenue').text(revenue.toFixed(2));
    }
    });

    // Filter buttons
    $(document).on('click', '.filter-btn', function(){
        $('.filter-btn').removeClass('active btn-primary btn-success btn-warning btn-danger btn-secondary')
            .addClass('btn-outline-secondary');

        let filter = $(this).data('filter');
        if(filter === 'today') $(this).removeClass('btn-outline-primary').addClass('btn-primary');
        else if(filter === 'week') $(this).removeClass('btn-outline-success').addClass('btn-success');
        else if(filter === 'month') $(this).removeClass('btn-outline-warning').addClass('btn-warning');
        else if(filter === 'year') $(this).removeClass('btn-outline-danger').addClass('btn-danger');
        else $(this).removeClass('btn-outline-secondary').addClass('btn-secondary');

        $(this).addClass('active');
        currentFilter = filter;
        table.ajax.reload();
    });
});
</script>
@endpush
