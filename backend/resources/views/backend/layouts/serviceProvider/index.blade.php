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


            <div class="card-body p-2">
                <div class="table-responsive">
                    <table id="bookingTable" class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Provider Name</th>
                                <th>email</th>
                                <th>Phone</th>
                                <th>Block status</th>
                                <th>Total Earn</th>
                                <th>total shift</th>

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
            url: "{{ route('serviceProvider.list.data') }}",
            type: "GET",

        },
        columns: [
            { data: 'DT_RowIndex', name: 'DT_RowIndex', orderable: false, searchable: false },
            { data: 'name', name: 'name' },
            { data: 'email', name: 'email' },
            { data: 'phone', name: 'phone' },
            { data: 'block_status', name: 'block_status' },
            { data: 'total_earn', name: 'total_earn' },
            { data: 'total_shift', name: 'total_shift' },

            {
                data: 'action',
                name: 'action',
                orderable: false,
                searchable: false
            }
        ]
    });

   $(document).on('click','.toggle-status',function(e){
        e.preventDefault();
        let id = $(this).data('id');
        let status = $(this).data('status');
        $.ajax({
            url: `/admin/provider/status/${id}`,
            method: 'POST',
            data: { _token: '{{ csrf_token() }}', status: status },
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
                    url: "{{ route('service.provider.destroy') }}",
                    method: 'POST',
                    data: {
                          id:id,
                         _token: '{{ csrf_token() }}' },
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
