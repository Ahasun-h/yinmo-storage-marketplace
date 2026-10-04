@extends('backend.master')

@section('title', 'FAQ Manage')

@section('content')
<div class="row">
    <div class="col-lg-12 col-md-12 col-12">
        <!-- Page header -->
        <div class="mb-5">
            <h3 class="mb-0">FAQ Manage</h3>
        </div>
    </div>
</div>

<div class="row">
    <!-- FAQ List -->
    <div class="col-lg-7 col-12">
        <div class="card mb-4">
            <div class="card-header d-md-flex border-bottom-0">
                <div class="flex-grow-1">
                    <label class="form-label">FAQ List</label>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive table-card p-3">
                    <table class="table table-striped table-hover align-middle text-nowrap table-centered p-3" id="faqTable">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>

                                <th>Question</th>
                                 <th>Answer</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- FAQ Add/Edit Form -->
    <div class="col-lg-5 col-12">
        <div id="addFAQForm">
            <form id="faqAddForm">
                @csrf
                <div class="card shadow-sm mb-2">
                    <div class="card-header text-white text-center">
                        <h5 class="mb-0">
                            <i class="bi bi-plus-circle me-2"></i> Add FAQ
                        </h5>
                    </div>
                </div>
                <div class="card mb-4">
                    <div class="card-body">
                        {{--  <div class="mb-3">
                            <label class="form-label">Main Title</label>
                            <input type="text" name="main_title" class="form-control" placeholder="Enter Main Title">
                        </div>  --}}
                        <div class="mb-3">
                            <label class="form-label">Question</label>
                            <input type="text" name="question" class="form-control" placeholder="Enter Question">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Answer</label>
                            <textarea name="answer" class="form-control" placeholder="Enter Answer"></textarea>
                        </div>

                        <div class="d-flex justify-content-end">
                            <button class="btn btn-outline-success faq_create">Create</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <div id="editFAQForm" class="d-none">
            <form id="faqEditForm">
                @csrf
                <input type="hidden" name="faq_id">
                <div class="card shadow-sm mb-2">
                    <div class="card-header text-white text-center bg-warning">
                        <h5 class="mb-0">
                            <i class="bi bi-pencil-square me-2"></i> Edit FAQ
                        </h5>
                    </div>
                </div>
                <div class="card mb-4">
                    <div class="card-body">
                        {{--  <div class="mb-3">
                            <label class="form-label">Main Title</label>
                            <input type="text" name="main_title" class="form-control">
                        </div>  --}}
                        <div class="mb-3">
                            <label class="form-label">Question</label>
                            <input type="text" name="question" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Answer</label>
                            <textarea name="answer" class="form-control"></textarea>
                        </div>
                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <button class="btn btn-success faq_update px-4">Update</button>
                            <button type="button" onclick="hideEditFAQForm()" class="btn btn-outline-secondary px-4">Cancel</button>
                        </div>
                    </div>
                </div>
            </form>
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

    // DataTable
    $('#faqTable').DataTable({
        processing: true,
        serverSide: true,
        ajax: "{{ route('faqs.data') }}",
        columns: [
            {data: 'DT_RowIndex', name: 'DT_RowIndex', orderable: false, searchable: false},

            {data: 'question', name: 'question'},
             {data: 'answer', name: 'answer'},
            {data: 'action', name: 'action', orderable: false, searchable: false},
        ]
    });

    // Add FAQ
    $(document).on('click', '.faq_create', function(e){
        e.preventDefault();

        $('input[name="main_title"], input[name="question"], textarea[name="answer"]').css('border', '');
        $('.text-danger').remove();


        let question = $('input[name="question"]').val().trim();
        let answer = $('textarea[name="answer"]').val().trim();

        if(!question){
            $('input[name="question"]').css('border','1px solid red').after('<span class="text-danger">Question required</span>');
            return false;
        }
        if(!answer){
            $('textarea[name="answer"]').css('border','1px solid red').after('<span class="text-danger">Answer required</span>');
            return false;
        }

        let formData = new FormData($('#faqAddForm')[0]);
        $.ajax({
            url: "{{ route('faq.store') }}",
            method: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function(response){
                if(response.success){
                    $('#faqTable').DataTable().ajax.reload();
                    $('#faqAddForm')[0].reset();
                    toastr.success(response.message);
                }else{
                    toastr.error(response.message);
                }
            },
            error: function(xhr){
                toastr.error('Something went wrong!');
            }
        });
    });

    // Edit FAQ
   $(document).on('click', '.editFAQ', function(){
    // Get data attributes from the clicked button
    let id = $(this).data('id');
    let question = $(this).data('question');
    let answer = $(this).data('answer');
    let main_title = $(this).data('main_title'); // If you want to pass 'main_title' as well

    // Pass the data to the edit form
    $('#editFAQForm input[name="faq_id"]').val(id);
    $('#editFAQForm input[name="question"]').val(question);
    $('#editFAQForm textarea[name="answer"]').val(answer);
    // If you need 'main_title', you can also assign it here:
    // $('#editFAQForm input[name="main_title"]').val(main_title);

    // Show the edit form and hide the add form
    $('#addFAQForm').addClass('d-none');
    $('#editFAQForm').removeClass('d-none');
});


    // Update FAQ
    $(document).on('click', '.faq_update', function(e){
        e.preventDefault();

        let id = $('#editFAQForm input[name="faq_id"]').val();
        let question = $('#editFAQForm input[name="question"]').val().trim();
        let answer = $('#editFAQForm textarea[name="answer"]').val().trim();

        if(!question){
            $('#editFAQForm input[name="question"]').css('border','1px solid red').after('<span class="text-danger">Question required</span>');
            return false;
        }
        if(!answer){
            $('#editFAQForm textarea[name="answer"]').css('border','1px solid red').after('<span class="text-danger">Answer required</span>');
            return false;
        }

        let formData = new FormData();
        formData.append('_token','{{ csrf_token() }}');

        formData.append('question', question);
        formData.append('answer', answer);

        $.ajax({
            url: `/faq/${id}`,
            method: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function(response){
                if(response.success){
                    $('#faqTable').DataTable().ajax.reload();
                    $('#editFAQForm').find('form')[0].reset();
                    hideEditFAQForm();
                    toastr.success(response.message);
                }else{
                    toastr.error(response.message);
                }
            }
        });
    });

    // Delete FAQ
    $(document).on('click', '.deleteFAQ', function(e){
        e.preventDefault();
        let id = $(this).data('id');

        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete!'
        }).then((result)=>{
            if(result.isConfirmed){
                $.ajax({
                    url: `/faq/destroy/${id}`,
                    method: 'POST',
                    data: {_token:'{{ csrf_token() }}'},
                    success: function(response){
                        if(response.success){
                            $('#faqTable').DataTable().ajax.reload();
                            toastr.success(response.message);
                        }else{
                            toastr.error(response.message);
                        }
                    }
                });
            }
        });
    });

});

// Hide edit form
function hideEditFAQForm(){
    $('#editFAQForm').addClass('d-none');
    $('#addFAQForm').removeClass('d-none');
}
</script>
@endpush
