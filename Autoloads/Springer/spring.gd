class_name Spring
extends RefCounted

signal updated(value: float)
signal killed()

var x: float
var stiffness: float
var dampening: float
var target_x: float
var v: float

var autokill: bool = true
var is_killed: bool = false
var realtime: bool = false

var min_val: float = -999999.0
var max_val: float = 999999.0

var target: Object
var property: NodePath

func _init(_x: float, _stiffness: float, _dampening: float) -> void:
	x = _x
	stiffness = _stiffness
	dampening = _dampening
	target_x = x
	v = 0

func update(delta: float) -> void:
	# Ajuste de delta para tiempo real
	if realtime: delta /= Engine.time_scale
	
	# Limitar delta para evitar oscilaciones extremas
	delta = min(0.05, delta)
	
	# Cálculo de aceleración basado en la física de un resorte
	var a: float = -stiffness * (x - target_x) - dampening * v
	
	# Actualizar velocidad
	v += a * delta
	
	# Actualizar posición, limitando entre valores mínimos y máximos
	x = clamp(x + v * delta, min_val, max_val)
	
	# Emitir señal de actualización
	updated.emit(x)
	
	# Auto-desactivar si está muy cerca del objetivo
	if autokill and abs(a) <= 0.0001:
		kill()

func pull(force: float) -> void:
	x += force

func set_range(minimum: float, maximum: float) -> void:
	min_val = minimum
	max_val = maximum

func kill() -> void:
	is_killed = true
	killed.emit()

func attach(_target: Object, _property: NodePath) -> void:
	target = _target
	property = _property

func set_autokill(_autokill: bool) -> void:
	autokill = _autokill

func set_realtime() -> Spring:
	realtime = true
	return self
