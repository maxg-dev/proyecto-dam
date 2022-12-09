<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\{Model, SoftDeletes};

class Entrada extends Model
{
    use HasFactory,SoftDeletes;

    protected $appends = ['link'];

    public function eventos(){
        return $this->belongsToMany(Evento::class)->withPivot('correo');
    }

    public function getLinkAttribute(){
        return 'http://www.usmentradas.cl/'.$this->id;
    }
}
