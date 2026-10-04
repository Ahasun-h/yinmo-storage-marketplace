<?php

namespace App\Http\Controllers\Backend;

use App\Models\Faq;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\Validator;

class FaqController extends Controller
{
    public function index(){
        
        return view('backend.layouts.Faq.index');
    }



public function getData(Request $request)
{
    if ($request->ajax()) {

        $shifts = Faq::latest(); // eager load relations

        return DataTables::of($shifts)
            ->addIndexColumn() // DT_RowIndex

            ->addColumn('action', function($row) {
                    // Edit Button with data attributes
                    $editBtn = '<button data-id="'.$row->id.'"
                                        data-question="'.$row->question.'"
                                        data-answer="'.$row->answer.'"
                                        class="btn btn-sm btn-primary editFAQ">
                                    <i class="bi bi-pencil-square"></i>
                                </button>';

                    // Delete Button with data-id attribute
                    $deleteBtn = '<button data-id="'.$row->id.'" class="btn btn-sm btn-danger deleteFAQ">
                                    <i class="bi bi-trash"></i>
                                </button>';

                    // Return both buttons concatenated
                    return $editBtn.' '.$deleteBtn;
                })
            ->rawColumns(['action'])
            ->make(true);
    }
}





   public function store(Request $request)
{

    $validator = Validator::make($request->all(), [
        'question' => 'required|string|max:255',
        'answer' => 'required',
    ]);


    if ($validator->fails()) {

        return response()->json([
            'status' => 'error',
            'message' => 'Validation failed',
            'errors' => $validator->errors(),
        ], 422);
    }

    $faq = new Faq();
    $faq->question = $request->question;
    $faq->answer = $request->answer;
    $faq->save();


    return response()->json([
        'success' => true,
        'message' => 'FAQ created successfully!',
        'data' => $faq,
    ], 201);
}

public function update(Request $request, $id)
{

    $validator = Validator::make($request->all(), [
        'question' => 'required|string|max:255',
        'answer' => 'required',
    ]);


    if ($validator->fails()) {

        return response()->json([
          'success' => true,
            'message' => 'Validation failed',
            'errors' => $validator->errors(),
        ], 422);
    }


    $faq = Faq::find($id);

    if (!$faq) {

        return response()->json([
            'status' => 'error',
            'message' => 'FAQ not found.',
        ], 404);
    }


    $faq->question = $request->question;
    $faq->answer = $request->answer;
    $faq->save();


    return response()->json([
        'success' => true,
        'message' => 'FAQ updated successfully!',
        'data' => $faq,
    ], 200);
}


public function destroy($id){
        $caretype = Faq::find($id);
        if ($caretype) {
            $caretype->delete();
            return response()->json([
                'success' => true,
                'message' => 'Faq deleted successfully.'
            ]);
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Faq not found.'
            ], 404);
        }
    }


}
