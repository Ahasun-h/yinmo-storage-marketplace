<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Invoice #{{ $booking->invoice_id }}</title>
    <style>
        body {
            font-family: DejaVu Sans, sans-serif;
            color: #333;
            font-size: 13px;
            margin: 40px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 3px solid #e74c3c;
            padding-bottom: 10px;
        }

        .company-info {
            line-height: 1.5;
        }

        .company-info h2 {
            margin: 0;
            color: #e74c3c;
            font-size: 20px;
        }

        .invoice-title {
            text-align: right;
            color: #e74c3c;
            font-size: 30px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .bill-section {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }

        .bill-to {
            line-height: 1.5;
        }

        .bill-to h3 {
            color: #e74c3c;
            margin-bottom: 5px;
        }

        .invoice-meta {
            text-align: right;
        }

        .invoice-meta p {
            margin: 2px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }

        th {
            background-color: #e74c3c;
            color: #fff;
            padding: 10px;
            text-align: left;
        }

        td {
            border-bottom: 1px solid #ddd;
            padding: 10px;
        }

        .total-section {
            margin-top: 20px;
            text-align: right;
        }

        .total-section table {
            width: 250px;
            float: right;
            border: none;
        }

        .total-section td {
            padding: 6px 0;
        }

        .grand-total {
            font-weight: bold;
            color: #e74c3c;
            font-size: 16px;
        }

        .footer {
            margin-top: 80px;
            text-align: center;
            color: #666;
            font-size: 12px;
        }
    </style>
</head>
<body>

    {{-- Header --}}
    <div class="header">
        <div class="company-info">
            <h2>Your Company Inc.</h2>
            <p>1234 Company St,<br>Company Town, ST 12345</p>
        </div>
        <div class="invoice-title">
            INVOICE
        </div>
    </div>

    {{-- Billing --}}
    <div class="bill-section">
        <div class="bill-to">
            <h3>Bill To</h3>
            <p><strong>{{ $booking->user->name ?? 'Customer Name' }}</strong></p>
            <p>{{ $booking->user->address ?? 'Customer Address' }}</p>
        </div>

        <div class="invoice-meta">
            <p><strong>Invoice #:</strong> {{ $booking->invoice_id }}</p>
            <p><strong>Invoice Date:</strong> {{ $booking->created_at->format('d-m-Y') }}</p>
            <p><strong>Due Date:</strong> {{ now()->addDays(14)->format('d-m-Y') }}</p>
        </div>
    </div>

    {{-- Items Table --}}
    <table>
        <thead>
            <tr>
                <th>QTY</th>
                <th>Description</th>
                <th>Unit Price</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody>
            {{-- Main Booking --}}
            <tr>
                <td>1</td>
                <td>{{ ucfirst($booking->listing->listing_type ?? 'Service') }} Booking</td>
                <td>৳{{ number_format($booking->subtotal, 2) }}</td>
                <td>৳{{ number_format($booking->subtotal, 2) }}</td>
            </tr>

            {{-- Extra Services --}}
            @if($booking->extraServicesBooking->count())
                @foreach($booking->extraServicesBooking as $service)
                <tr>
                    <td>1</td>
                    <td>{{ $service->extraService->name ?? 'Service #'.$service->extra_service_id }}</td>
                    <td>৳{{ number_format($service->price, 2) }}</td>
                    <td>৳{{ number_format($service->total_service_price, 2) }}</td>
                </tr>
                @endforeach
            @endif
        </tbody>
    </table>

    {{-- Totals --}}
    <div class="total-section">
        <table>
            <tr>
                <td>Subtotal:</td>
                <td>৳{{ number_format($booking->subtotal, 2) }}</td>
            </tr>
            <tr>
                <td>Tax (5%):</td>
                <td>৳{{ number_format($booking->subtotal * 0.05, 2) }}</td>
            </tr>
            <tr class="grand-total">
                <td>Total (BDT):</td>
                <td>৳{{ number_format($booking->total, 2) }}</td>
            </tr>
        </table>
    </div>

    {{-- Footer --}}
    <div class="footer">
        <p><strong>Terms and Conditions:</strong> Payment due within 14 days.</p>
        <p>Please make checks payable to <strong>Your Company Inc.</strong></p>
        <p>Thank you for your business!</p>
    </div>

</body>
</html>
