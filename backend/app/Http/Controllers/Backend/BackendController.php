<?php

namespace App\Http\Controllers\Backend;

use Carbon\Carbon;
use App\Models\User;
use App\Models\Order;
use App\Models\Product;
use App\Models\OrderItemDetail;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class BackendController extends Controller
{
    // dashboard show
    public function index()
    {




        return view('backend.layouts.dashboard');
    }



}
