@extends('backend.master')

@section('title', 'Booking Manage')

@section('content')
<div class="row">
    <div class="col-12">
        <!-- Page Header -->
        <div class="mb-4 d-flex justify-content-between align-items-center">
            <h3 class="mb-0 fw-bold">Booking List</h3>

        </div>
    </div>
</div>

<div class="row">
    <!-- Booking Table -->
    <div class="col-12">
        <div class="card shadow-sm border-0">
            <div class="card-header bg-light border-bottom-0 d-flex justify-content-between align-items-center flex-wrap">
                <h5 class="mb-0">
                    <i class="bi bi-list-ul me-2 text-primary"></i>All Bookings
                </h5>
                <div class="mt-2 mt-sm-0">
                    <button class="btn btn-outline-secondary filter-btn active" data-status="">All</button>
                    <button class="btn btn-outline-primary filter-btn" data-status="upcoming">Upcoming</button>
                    <button class="btn btn-outline-success filter-btn" data-status="completed">Completed</button>
                    <button class="btn btn-outline-danger filter-btn" data-status="canceled">Canceled</button>
                </div>
            </div>

            <div class="card-body p-2">
                <div class="table-responsive">
                    <table id="bookingTable" class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Invoice ID</th>
                                <th>Customer</th>
                                <th>Listing</th>
                                <th>Provider</th>
                                <th>Total</th>
                                <th>Admin Commission</th>
                                <th>Provider Total</th>
                                <th>Provider Payment Status</th>
                                <th>Provider Partial paid</th>
                                <th>Provider Total Paid</th>
                                <th>Status</th>
                                <th>Reject Reason</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- Payment Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title text-white" id="paymentModalLabel">Pay Service Provider</h5>
        <button type="button" class="btn-close text-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body">
        <form id="paymentForm">
          @csrf
          <input type="hidden" name="booking_id" id="pm_booking_id">
          <input type="hidden" name="provider_id" id="pm_provider_id">
          <input type="hidden" name="invoice_id" id="pm_invoice_id">
          <input type="hidden" name="total_amount" id="pm_total_amount">

          <!-- Provider Name -->
          <div class="mb-3">
            <label class="form-label">Provider</label>
            <input type="text" id="pm_provider_name" class="form-control" readonly>
          </div>

          <!-- Payment Method -->
          <div class="mb-3">
            <label class="form-label">Payment Method</label>
            <select class="form-select" id="pm_payment_type" name="payment_type" required>
              <option value="">-- Select Payment Type --</option>
              <option value="manual">Custom Payment</option>
              <option value="stripe">Stripe Payment</option>
            </select>
          </div>

          <!-- Partial / Full Payment -->
          <div class="mb-3">
            <label class="form-label">Payment Mode</label>
            <div class="d-flex gap-2">
              <div class="form-check">
                <input class="form-check-input" type="radio" name="payment_mode" id="full_payment" value="full" checked>
                <label class="form-check-label" for="full_payment">Full Payment</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="payment_mode" id="partial_payment" value="partial">
                <label class="form-check-label" for="partial_payment">Partial Payment</label>
              </div>
            </div>
          </div>

          <!-- Amount -->
          <div class="mb-3">
            <label class="form-label">Amount (USD)</label>
            <div class="input-group">
              <input type="number" step="0.01" min="0" name="amount" id="pm_amount" class="form-control" required>
              <span class="input-group-text">USD</span>
            </div>
            <small class="text-muted">Ensure you have enough balance in Super Admin Stripe account.</small>
          </div>

          <!-- Note -->
          <div class="mb-3">
            <label class="form-label">Note (optional)</label>
            <input type="text" name="note" id="pm_note" class="form-control" placeholder="Payment note (e.g. payout for booking)">
          </div>

          <a  class="btn btn-success w-100 pay" id="pm_submit_btn">
            <i class="bi bi-credit-card pay"></i> Send Payment
          </a>
        </form>
      </div>
    </div>
  </div>
</div>



@endsection


@push('scripts')
<!-- Toastr -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<!-- SweetAlert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- DataTables -->
<script>
$(document).ready(function() {
    let currentStatus = ''; // default filter (All)

    let table = $('#bookingTable').DataTable({
        processing: true,
        serverSide: true,
        ajax: {
            url: "{{ route('booking.list.data') }}",
            type: "GET",
            data: function(d) {
                d.status = currentStatus; // send filter value to controller
            }
        },
        columns: [
            { data: 'DT_RowIndex', name: 'DT_RowIndex', orderable: false, searchable: false },
            { data: 'invoice_id', name: 'invoice_id' },
            { data: 'customer', name: 'customer' },
            { data: 'listing', name: 'listing' },
            { data: 'provider', name: 'provider' },
            { data: 'total', name: 'total' },
            { data: 'admin_commission', name: 'admin_commission' },
            { data: 'provider_total', name: 'provider_total' },
            { data: 'provider_payment_status', name: 'provider_payment_status' },
            {data:'partial_paid',name:'partial_paid'},
            {data:'total_paid',name:'total_paid'},
            { data: 'status', name: 'status' },
            { data: 'reject_reason', name: 'reject_reason' },
            { data: 'created_at', name: 'created_at' },
            {
                data: 'action',
                name: 'action',
                orderable: false,
                searchable: false
            }
        ]
    });




 $(document).on('click', '.pay', function(e) {
    e.preventDefault();

    // Get the payment amount from the form
    var amount = parseFloat($('#paymentForm').find('input[name="amount"]').val());
    var paymentType = $('#paymentForm').find('select[name="payment_type"]').val();

    if(paymentType==""){
        toastr.error("Please select payment type");
        return;
    }
    // Check if amount is valid
    if (isNaN(amount) || amount < 1) {
        toastr.error("This value must be greater than or equal to 1.");
        return; // Stop the AJAX call
    }

    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    });

    var formdata = new FormData($('#paymentForm')[0]);

   $.ajax({
    url: "{{ route('booking.payment') }}",
    type: "POST",
    data: formdata,
    contentType: false,
    cache: false,
    processData: false,
    success: function(response) {
        if (response.success) {
            $('#paymentModal').modal('hide');
            table.ajax.reload();
            toastr.success(response.message);
        }
    },
    error: function(xhr) {
        var err = xhr.responseJSON;
        if (err && err.error) {
            toastr.error(err.error); // show server error message
        } else {
            toastr.error('Something went wrong.');
        }
    }
});
});

    $(document).on('click', 'button[data-bs-target="#paymentModal"]', function(e){
        e.preventDefault();
        // read attributes (set in your DataTables action column)
        let bookingId = $(this).data('id');
        let providerId = $(this).data('provider-id');
        let providerName = $(this).data('provider-name');
        let amount = $(this).data('amount');
        let invoiceId = $(this).data('invoice-id');


        $('#pm_booking_id').val(bookingId);
        $('#pm_provider_id').val(providerId);
        $('#pm_invoice_id').val(invoiceId || '');
        $('#pm_provider_name').val(providerName || '');
        $('#pm_amount').val(amount || '');

        // show modal (Bootstrap 5)
        var myModal = new bootstrap.Modal(document.getElementById('paymentModal'));
        myModal.show();
    });











    // 🔹 Filter Button Click
    $(document).on('click', '.filter-btn', function() {
        $('.filter-btn').removeClass('active btn-primary btn-success btn-danger btn-secondary')
            .addClass('btn-outline-secondary');

        // Add color based on selected
        let status = $(this).data('status');
        if(status === 'completed') $(this).removeClass('btn-outline-success').addClass('btn-success');
        else if(status === 'upcoming') $(this).removeClass('btn-outline-primary').addClass('btn-primary');
        else if(status === 'canceled') $(this).removeClass('btn-outline-danger').addClass('btn-danger');
        else $(this).removeClass('btn-outline-secondary').addClass('btn-secondary');

        $(this).addClass('active');
        currentStatus = status;
        table.ajax.reload();
    });


      $('#paymentModal').on('hidden.bs.modal', function () {
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
        $('body').css('padding-right', '');
    });

    // 🔹 Delete booking
    $(document).on('click', '.delete', function(e){
        e.preventDefault();
        let id = $(this).data('id');

        Swal.fire({
            title: 'Are you sure?',
            text: 'This booking will be permanently deleted.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!'
        }).then(result => {
            if(result.isConfirmed){
                $.ajax({
                    url: `/admin/booking/delete/${id}`,
                    method: 'POST',
                    data: { _token: '{{ csrf_token() }}' },
                    success: function(response){
                        if(response.success){
                            toastr.success(response.message);
                            table.ajax.reload();
                        } else {
                            toastr.error(response.message);
                        }
                    },
                    error: function(){
                        toastr.error('Something went wrong!');
                    }
                });
            }
        });
    });
});
</script>
@endpush
