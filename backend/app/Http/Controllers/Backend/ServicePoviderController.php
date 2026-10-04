<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use App\Models\booking;
use App\Models\Listing;
use App\Models\User;
use Dflydev\DotAccessData\Data;
use Illuminate\Http\Request;

use Yajra\DataTables\Facades\DataTables;

class ServicePoviderController extends Controller
{
    public function index()
    {
        return view('backend.layouts.serviceProvider.index');
    }



public function getData(Request $request)
{
    if ($request->ajax()) {

        // ✅ Get all service providers using Spatie role
        $providers = User::role('service_provider')->get();

        return DataTables::of($providers)
            ->addIndexColumn()

            // 🔹 Show phone (optional if exists in DB)
            ->addColumn('phone', function ($row) {
                return $row->phone ?? 'N/A';
            })

            // 🔹 Show block status (example boolean)
              ->addColumn('block_status', function ($row) {
                if ($row->block_status == 'blocked') {
                    return '<button class="btn btn-sm btn-danger toggle-status"
                                data-id="' . $row->id . '"
                                data-status="unblocked">
                                <i class="bi bi-lock-fill"></i> Blocked
                            </button>';
                } else {
                    return '<button class="btn btn-sm btn-success toggle-status"
                                data-id="' . $row->id . '"
                                data-status="blocked">
                                <i class="bi bi-unlock-fill"></i> Unblocked
                            </button>';
                }
            })

            // 🔹 Total Earnings for this provider
            ->addColumn('total_earn', function ($row) {
                return Booking::where('service_provider_id', $row->id)
                    ->sum('provider_fee_after_comission') ?? 0;
            })

            // 🔹 Total Shifts (total listings created)
            ->addColumn('total_shift', function ($row) {
                return Listing::where('user_id', $row->id)->count() ?? 0;
            })

            // 🔹 Action buttons
            ->addColumn('action', function ($row) {


                $btn = '<button class="btn btn-sm btn-danger delete" data-id="' . $row->id . '">';
                $btn .= '<i class="bi bi-trash"></i></button>';
                return $btn;
            })

            ->rawColumns(['action', 'block_status', 'total_earn', 'total_shift']) // ✅ render HTML badges & buttons
            ->make(true);
    }
}


public function statusChange(Request $request){
    $user = User::findOrFail($request->id);

    if($user->block_status == 'blocked'){
        $user->block_status = 'unblock';
    }else{
        $user->block_status = 'blocked';
    }
    $user->save();
    return response()->json(['success' => true,
                              'message' => 'Status changed successfully',
                              'data' => $user
                             ]);
}

public function destroy(Request $request){
    $user = User::findOrFail($request->id);

     $user->email='';
        $user->save();
        $user->delete();

    return response()->json(['success' => true,
                            'message' => 'User deleted successfully',
                            'data' => $user
                           ]);
}


//////////////////////////transfer booking money to service provider account////////////////////

}
