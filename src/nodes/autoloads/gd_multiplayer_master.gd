extends Node

var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()

var client = preload("res://scenes/nodes/sc_character.tscn")

var connected_ids:Array = []

signal client_connected
var local_client:Client:
	get: return local_client
	set(val):
		local_client = val
		emit_signal("client_connected", local_client)

func _ready():
	pass

func join(port:int):
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer
	

func host(port:int):
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	
	_add_client(1)
	
	peer.peer_connected.connect(
		func(id): 
			await get_tree().create_timer(1).timeout
			rpc("add_new_client", id)
			rpc_id(id, "add_previous_client", connected_ids)
			_add_client(id)
	)
	
func _add_client(id):
	connected_ids.append(id)
	#Master.local_client.queue_free()
	var client_instance = client.instantiate()
	client_instance.set_multiplayer_authority(id)
	#client_instance.id = str(id)
	get_tree().get_current_scene().add_child(client_instance, true)
	if id == multiplayer.get_unique_id():
		local_client = client_instance
	emit_signal("client_connected", client_instance)
	
@rpc
func add_new_client(id):
	_add_client(id)

@rpc
func add_previous_client(ids):
	for id in ids:
		add_new_client(id)
