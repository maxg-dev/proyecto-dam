<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\{Model, SoftDeletes};

class Evento extends Model
{
    use HasFactory, SoftDeletes;

    protected $appends = ['entradas_vendidas'];

    public function entradas(){
        return $this->belongsToMany(Entrada::class)->withPivot('correo');
    }

    public function getEntradasVendidasAttribute(){
        return count($this->entradas);
    }
}
