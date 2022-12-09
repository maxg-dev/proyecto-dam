<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\{EntradaController, EventoController, EntradaEventoController};

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::apiResource('/entradas',EntradaController::class);
Route::apiResource('/eventos',EventoController::class);
Route::apiResource('/entradaEvento',EntradaEventoController::class);
Route::get('/estado',[EventoController::class,'estado']);
Route::post('/email',[EntradaController::class,'email']);