extends Node2D

@onready var back_btn: Button = $CanvasLayer/MarginContainer/VBoxContainer/BackBtn
@onready var nb_iron_storage_label: Label = $Storage/IronStorage/NbIronStorageLabel
@onready var nb_wood_storage_label: Label = $Storage/WoodStorage/NbWoodStorageLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_btn.pressed.connect(_on_back_btn_pressed)
	update_label_nb(nb_iron_storage_label, InventoryManager.get_item_count(Data.ResourcesNameArray[Data.ResourcesName.IRON]))
	update_label_nb(nb_wood_storage_label, InventoryManager.get_item_count(Data.ResourcesNameArray[Data.ResourcesName.WOOD]))

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/main.tscn")

func update_label_nb(label: Label, nb: int):
	label.text = str(nb)
