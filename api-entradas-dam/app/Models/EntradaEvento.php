<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\{Model, SoftDeletes};

class EntradaEvento extends Model
{
    use HasFactory,softDeletes;
    protected $table = "entrada_evento";
}
