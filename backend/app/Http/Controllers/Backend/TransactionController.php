<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use App\Models\transaction;
use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;

class TransactionController extends Controller
{
   public function index()
    {
        return view('backend.layouts.transaction.index');
    }


public function getData(Request $request)
{
    $transactions = transaction::with(['booking.listing', 'booking.serviceProvider']);
        // ->where('transaction_by', auth()->id());

    if ($request->filter == 'today') {
        $transactions->whereDate('created_at', now());
    } elseif ($request->filter == 'week') {
        $transactions->whereBetween('created_at', [now()->startOfWeek(), now()->endOfWeek()]);
    } elseif ($request->filter == 'month') {
        $transactions->whereMonth('created_at', now()->month);
    } elseif ($request->filter == 'year') {
        $transactions->whereYear('created_at', now()->year);
    }

    $totalRevenue = $transactions->sum('amount');
     $transactions = $transactions->get();
    return datatables()->of($transactions)
        ->addIndexColumn()
        ->addColumn('listing_title', fn($tx) => $tx->booking->listing->title ?? '')
        ->addColumn('provider_name', fn($tx) => $tx->booking->serviceProvider->name ?? '')
        ->addColumn('created_at', fn($tx) => $tx->created_at->format('Y-m-d H:i'))
        ->with('totalRevenue', $totalRevenue) // <- send totalRevenue
        ->make(true);
}

}
