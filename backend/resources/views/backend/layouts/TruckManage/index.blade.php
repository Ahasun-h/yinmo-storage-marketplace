@extends('backend.master')

@section('title', 'truck Manage')

@section('content')
    <div class="row">
        <div class="col-lg-12 col-md-12 col-12">
            <!-- Page header -->
            <div class="mb-5">
                <h3 class="mb-0">Truck Manage</h3>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Tag List -->
        <div class="col-lg-7 col-12">
            <div class="card mb-4">
                <div class="card-header d-md-flex border-bottom-0">
                    <div class="flex-grow-1">
                        <a href="#" class="text-bolder"><label class="form-label">Truck List</label></a>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive table-card p-3">
                        <table class="table table-striped table-hover align-middle text-nowrap table-centered p-3"
                            id="table">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Truck Name</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tag Add Form -->
        <div class="col-lg-5 col-12">
            <div id="addTagForm">
                <form id="addTag">
                    @csrf
                    <div class="card shadow-sm mb-2">
                        <div class="card-header text-white text-center ">
                            <h5 class="mb-0">
                                <i class="bi bi-plus-circle me-2"></i> Add Truck
                            </h5>
                        </div>
                    </div>
                    <div class="card mb-4">
                        <div class="card-body">
                            <!-- Tag Title -->
                            <div class="mb-3">
                                <label class="form-label">Truck Name</label>
                                <input type="text" name="name" class="form-control" placeholder="Enter Truck Name"
                                    value="">
                            </div>

                            <!-- Submit Button -->
                          <div class="d-flex justify-content-end">
                            <button class="btn btn-outline-success mb-4 truck_create">
                                Create
                            </button>
                        </div>
                        </div>
                    </div>
                </form>
            </div>


            <div id="editTagForm" class="d-none">
                <form action="#" method="post">
                    @csrf

                    <div class="card shadow-sm mb-2">
                        <div class="card-header text-white text-center bg-warning">
                            <h5 class="mb-0">
                                <i class="bi bi-pencil-square me-2"></i> Edit Truck
                            </h5>
                        </div>
                    </div>
                    <div class="card mb-4">
                        <div class="card-body">
                            <input type="text" name="truck_id" class="d-none">
                            <div class="mb-3">
                                <label class="form-label">Truck Name</label>
                                <input type="text" name="truck_name" class="form-control" placeholder="Enter Truck Name"
                                    value="Featured">
                            </div>

                            <!-- Submit Button -->
                            <div class="d-flex justify-content-end gap-2 mt-3">
                                <button class="btn btn-success update px-4">
                                    <i class="bi bi-check-circle"></i> Update
                                </button>
                                <button type="button" onclick="hideEditForm()" class="btn btn-outline-secondary px-4">
                                    <i class="bi bi-x-circle"></i> Cancel
                                </button>
                            </div>

                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection

@push('scripts')
    <!-- toastr CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />

    <!-- toastr JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        $(document).ready(function() {

            $('#table').DataTable({

                processing: true,
                serverSide: true,
                ajax: {
                    url: "",
                    type: "GET"
                },
                columns: [{
                        data: 'DT_RowIndex',
                        name: 'DT_RowIndex',
                        orderable: false,
                        searchable: false
                    },
                    {
                        data: 'name',
                        name: 'name'
                    },

                    {
                        data: 'action',
                        name: 'action',
                        orderable: false,
                        searchable: false
                    }
                ]
            });



            $(document).on('click', '.edit', function() {
                var id = $(this).data('id');
                var name = $(this).data('name');


                $('#addTagForm').addClass('d-none');
                $('#editTagForm').removeClass('d-none');

                $('#editTagForm input[name="truck_name"]').val(name);
                $('#editTagForm input[name="truck_id"]').val(id);
            })

            $(document).on('click', '.truck_create', function(e) {
                e.preventDefault();

                // Clear previous error
                $('input[name="name"]').css('border', '');
                $('input[name="name"]').next('.text-danger').remove();

                let truck_name = $('input[name="name"]').val().trim();

                if (truck_name === '') {
                    $('input[name="name"]').css('border', '1px solid red');
                    $('input[name="name"]').after(
                        '<span class="text-danger">This field is required</span>');
                    return false; // stop ajax
                }

                let formData = new FormData($('#addTag')[0]);

                $.ajax({
                    url: "",
                    method: "POST",
                    data: formData,
                    processData: false, // important
                    contentType: false, // important
                    success: function(response) {

                        if (response.success) {
                            $('#table').DataTable().ajax.reload();
                            $('#addTag')[0].reset();
                            toastr.success(response.message);
                        } else {
                            toastr.error(response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX Error:', status, error);
                        toastr.error('An error occurred while processing your request.');
                    }
                });
            });

            $(document).on('click', '.update', function(e) {
                e.preventDefault();


                $('#editTagForm input[name="truck_name"]').css('border', '');
                $('#editTagForm input[name="truck_name"]').next('.text-danger').remove();

                let name = $('#editTagForm input[name="truck_name"]').val().trim();
                let truck_id = $('#editTagForm input[name="truck_id"]').val();

                if (name === '') {
                    $('#editTagForm input[name="truck_name"]').css('border', '1px solid red');
                    $('#editTagForm input[name="truck_name"]').after(
                        '<span class="text-danger">This field is required</span>');
                    return false;
                }

                let formData = new FormData();
                formData.append('_token', '{{ csrf_token() }}');
                formData.append('name', name);

                $.ajax({
                    url: `/admin/truck/${truck_id}`,
                    method: "POST",
                    data: formData,
                    processData: false, // important
                    contentType: false, // important
                    success: function(response) {
                        console.log(response);
                        if (response.success) {
                            $('#table').DataTable().ajax.reload();
                            $('#editTagForm').find('form')[0].reset();
                            hideEditForm();
                            toastr.success(response.message);
                        } else {
                            toastr.error(response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX Error:', status, error);
                        toastr.error('An error occurred while processing your request.');
                    }
                });
            });

     $(document).on('click', '.delete', function(e) {
    e.preventDefault();
    var truck_id = $(this).data('id');

    // SweetAlert confirmation
    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
        if (result.isConfirmed) {

            $.ajax({
                url: `/admin/truck/delete/${truck_id}`,
                type: 'POST',
                data: {
                    _token: '{{ csrf_token() }}'
                },
                success: function(response) {
                    if (response.success) {
                        $('#table').DataTable().ajax.reload();
                        toastr.success(response.message);
                    } else {
                        toastr.error(response.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error:', status, error);
                    toastr.error('An error occurred while processing your request.');
                }
            });
        }
    });
});





    });






        function hideEditForm() {
            $('#editTagForm').addClass('d-none');
            $('#addTagForm').removeClass('d-none');
        }
    </script>
@endpush
