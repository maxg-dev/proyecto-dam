<?php

namespace App\Http\Controllers;

use App\Models\EntradaEvento;
use App\Http\Requests\StoreEntradaEventoRequest;
use App\Http\Requests\UpdateEntradaEventoRequest;

class EntradaEventoController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return EntradaEvento::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \App\Http\Requests\StoreEntradaEventoRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreEntradaEventoRequest $request)
    {
        $entradaEvento = new EntradaEvento();
        $entradaEvento->correo = $request->correo;
        $entradaEvento->evento_id = $request->evento_id;
        $entradaEvento->entrada_id = $request->entrada_id;
        $entradaEvento->save();
        return $entradaEvento;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\EntradaEvento  $entradaEvento
     * @return \Illuminate\Http\Response
     */
    public function show(EntradaEvento $entradaEvento)
    {
        // hay?
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateEntradaEventoRequest  $request
     * @param  \App\Models\EntradaEvento  $entradaEvento
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateEntradaEventoRequest $request, EntradaEvento $entradaEvento)
    {
        // hay?
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\EntradaEvento  $entradaEvento
     * @return \Illuminate\Http\Response
     */
    public function destroy(EntradaEvento $entradaEvento)
    {
        // hay?
    }
}
