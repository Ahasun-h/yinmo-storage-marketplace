<?php

use App\Http\Controllers\Backend\BackendController;
use App\Http\Controllers\Backend\BookingManageController;
use App\Http\Controllers\Backend\ComissionController;
use App\Http\Controllers\Backend\FaqController;
use App\Http\Controllers\Backend\ServicePoviderController;
use App\Http\Controllers\Backend\TagController;
use App\Http\Controllers\Backend\TransactionController;
use App\Http\Controllers\Backend\TruckManageController;
use App\Http\Controllers\Category\CategoryController;
use App\Http\Controllers\Dynamic\DynamicPageController;
use App\Http\Controllers\Product\ProductController;
use App\Http\Controllers\RolePermission\PermissionController;
use App\Http\Controllers\RolePermission\RoleController;

use App\Http\Controllers\RolePermission\RolePermissionController;
use App\Http\Controllers\RolePermission\UserController;
use App\Http\Controllers\Settings\AdminSettingsController;
use App\Http\Controllers\Settings\MailSettingController;
use App\Http\Controllers\Settings\ProfileSettingController;
use App\Http\Controllers\Settings\SystemController;
use Illuminate\Support\Facades\Route;






// Route::get('/', [BackendController::class, 'Page404'])->name('dashboard');


 Route::middleware('auth.check')->group(function () {

  Route::controller(BookingManageController::class)->group(function () {
        Route::get('/booking/manage', 'index')->name('booking.delete.manage');
        Route::get('booking/reason/data', 'data')->name('booking.reason.data');
        Route::post('/booking/store/reason', 'store')->name('booking.reason.create');
        Route::post('/admin/reject/{reject_id}', 'update')->name('booking.reason.edit');
        Route::post('/admin/reason/delete/{reason_id}', 'destroy')->name('booking.reason.delete');

        ////////////////////////////////////booking manage admin////////////////
        Route::get('/admin/booking/manage', 'Providerbooking')->name('booking.list');
        Route::get('admin/booking/data', 'ProviderbookingData')->name('booking.list.data');
        Route::get('/admin/booking/summery/{booking_id}', 'BookingSummery')->name('bookings.show');
        Route::get('bookings/payment/{id}', 'getPayment')->name('bookings.pay');
        Route::post('/admin/transfer/money','transferMoney')->name('booking.payment');
  });
     Route::controller(FaqController::class)->group(function(){
       Route::get('/faq/index','index')->name('faq.index');
       Route::get('faqs.data','getData')->name('faqs.data');

       Route::post('/faq/store','store')->name('faq.store');
       Route::post('/faq/{id}','update')->name('faq.update');
       Route::post('/faq/destroy/{id}','destroy')->name('faq.destroy');

    });

    Route::controller(ComissionController::class)->group(function(){
        Route::get('/comission/index','index')->name('comission.index');
        Route::get('comission.data','getData')->name('comission.data');

        Route::post('/comission/store','store')->name('comission.store');
        Route::post('/admin/comission/{comission_id}','update')->name('comission.update');
    });

    Route::controller(ServicePoviderController::class)->group(function(){
        Route::get('/service-provider/index','index')->name('service.provider.index');
        Route::get('service/provider/data','getData')->name('serviceProvider.list.data');
        Route::post('/admin/provider/status/{id}','statusChange')->name('service.provider.status.change');
        Route::post('provider/delete','destroy')->name('service.provider.destroy');

        ////////////////////transfer money/////////////////////

    });

  Route::controller(TransactionController::class)->group(function(){
        Route::get('/transaction/index','index')->name('transaction.index');
        Route::get('transaction/data','getData')->name('transaction.data');
  });


 });













Route::controller(BackendController::class)->middleware('auth.check')->group(function () {
    Route::get('/', 'index')->name('dashboard');
    Route::get('/dashboard-data', 'monthlyData');
});




// Role and Permission Management start
Route::controller(RoleController::class)->middleware('auth.check')->group(function () {
    Route::get('/role/index', 'index')->name('role.index');
    Route::post('/role/store', 'store')->name('role.store');
    Route::get('/role/destroy/{id}', 'destroy')->name('role.destroy');
    Route::get('/role/edit/{id}', 'edit')->name('role.edit');
    Route::put('/role/update/{id}', 'update')->name('role.update');
    Route::get('/permission/edit/{id}', 'editPermission')->name('permission.edit');
});

Route::controller(RolePermissionController::class)->middleware('auth.check')->group(function () {});

Route::controller(UserController::class)->middleware('auth.check')->group(function () {
    Route::get('/user/index', 'index')->name('user.index');
    Route::post('/user/store', 'store')->name('user.store');
    Route::get('/user/edit/{id}', 'edit')->name('user.edit');
    Route::put('/user/update/{id}', 'update')->name('user.update');
    Route::get('/user/destroy/{id}', 'destroy')->name('user.destroy');
    Route::get('/user/show/{id}', 'show')->name('user.show');
    Route::get('/user/role/change/{id}', 'ChangeRole')->name('user.role.change');
    Route::post('/user/role/Update/{id}', 'assignRoleUpate')->name('user.role.update');
});

Route::controller(PermissionController::class)->middleware('auth.check')->group(function () {
    Route::get('/permission/index', 'index')->name('permission.index');
    Route::post('/permission/store', 'store')->name('permission.store');
    // Route::get('/permission/destroy/{id}', 'destroy')->name('permission.destroy');
    Route::post('role/permission/update/{id}', 'UpdatePermissionByRole')->name('role.permission.update');
});


// settings Management start
Route::controller(MailSettingController::class)->middleware('auth.check')->group(function () {
    Route::get('/settings/mail', 'index')->name('mail.index');
    Route::post('/settings/mail-store', 'mailstore')->name('mail.store');
});

// Route::controller(ProfileSettingController::class)->middleware('auth.check')->group(function () {
//     Route::get('/settings/profile', 'index')->name('profile.index');
//     Route::post('/settings/profile-update', 'profileupdate')->name('profile.update');
//     Route::post('/settings/profile-password-update', 'PasswordUpdate')->name('profile.password.update');
// });

Route::controller(SystemController::class)->middleware('auth.check')->group(function () {
    Route::get('/settings/system', 'index')->name('system.index');
    Route::post('/settings/system-store', 'systemupdate')->name('system.update');
    Route::post('/settings/social-store', 'updateSocials')->name('social.update');
});

Route::controller(AdminSettingsController::class)->middleware('auth.check')->group(function () {
    Route::get('/settings/admin', 'index')->name('admin.setting.index');
    Route::post('/settings/admin/update', 'adminSettingUpdate')->name('admin.setting.update');
});


// dynamic page management start
Route::controller(DynamicPageController::class)->middleware('auth.check')->group(function () {
    Route::resource('dynamic-pages', DynamicPageController::class);
    Route::get('/dynamic/pages/destroy/{id}', 'destroy')->name('dynamic-pages.delete');
    Route::get('/dynamic/pages/toggle-status/{id}/{status}', 'pageSatus')->name('dynamic-pages.toggleStatus');
});
