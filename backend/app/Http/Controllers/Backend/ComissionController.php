<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use App\Models\Commission;
use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;

class ComissionController extends Controller
{
    public function index(){
        return view('backend.layouts.comission.index');
    }

    public function getData(Request $request){
        if($request->ajax()){
            $data=Commission::all();
            return DataTables::of($data)
            ->addIndexColumn()
              ->addColumn('action', function ($row) {
                $btn = '<a href="javascript:void(0)" data-id="' . $row->id . '" data-comission="' . $row->comission . '" class="btn btn-sm btn-primary edit"><i class="bi bi-pencil-square"></i></a> ';

                return $btn;
            })
            ->make(true);
        }
    }

    public function store(Request $request){
        $comission=Commission::where('id',1)->first();

        if(!$comission)
        $commission=new Commission();
        $commission->comission=$request->comission;
        $commission->save();
       return response()->json([
        'success' => true,
        'message' => 'Comission Added Successfully',
       ]);
    }

    public function update(Request $request){


        $commission=Commission::find($request->comission_id);
      
        $commission->comission=$request->comission;
        $commission->update();
       return response()->json([
        'success' => true,
        'message' => 'Comission Updated Successfully',
       ]);
    }
}
