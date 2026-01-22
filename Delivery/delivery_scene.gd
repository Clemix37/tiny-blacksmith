extends Node2D

@onready var nb_iron_storage_label: Label = $Storage/IronStorage/NbIronStorageLabel
@onready var nb_wood_storage_label: Label = $Storage/WoodStorage/NbWoodStorageLabel
@onready var back_btn: Button = %ForgeBtn
@onready var money_label: Label = %MoneyLabel
# Buy buttons
@onready var add_wood_cart: Button = %AddWoodToCart
@onready var add_coal_cart: Button = %AddCoalToCart
@onready var add_copper_cart: Button = %AddCopperToCart
@onready var add_iron_cart: Button = %AddIronToCart
@onready var add_steel_cart: Button = %AddSteelToCart
@onready var buy_btn: Button = %BuyBtn
# Cart Labels
@onready var cart_label: Label = %CartLabel
@onready var cart_price: Label = %CartPrice
@onready var money_result: Label = %MoneyResult

var current_cart: Dictionary = {}
var current_cost: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create button connections
	back_btn.pressed.connect(_on_back_btn_pressed)
	add_wood_cart.pressed.connect(_on_buy_wood)
	add_coal_cart.pressed.connect(_on_buy_coal)
	add_copper_cart.pressed.connect(_on_buy_copper)
	add_iron_cart.pressed.connect(_on_buy_iron)
	add_steel_cart.pressed.connect(_on_buy_steel)
	buy_btn.pressed.connect(_on_buy_btn)
	# Update labels
	_update_current_money_label()
	_update_buy_btns_display()
	_update_cart_labels()

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/main.tscn")

func _on_buy_wood():
	_on_buy_item(Data.ResourcesIdsArray[Data.ResourcesName.WOOD])

func _on_buy_coal():
	_on_buy_item(Data.ResourcesIdsArray[Data.ResourcesName.COAL])

func _on_buy_copper():
	_on_buy_item(Data.ResourcesIdsArray[Data.ResourcesName.COPPER])

func _on_buy_iron():
	_on_buy_item(Data.ResourcesIdsArray[Data.ResourcesName.IRON])

func _on_buy_steel():
	_on_buy_item(Data.ResourcesIdsArray[Data.ResourcesName.STEEL])

func _on_buy_item(resource_name: String) -> void:
	_add_resource_to_buy(resource_name)
	_update_cart_labels()
	_update_buy_btns_display()

func _on_buy_btn() -> void:
	# Delete the cost from the current money
	InventoryManager.remove_money(current_cost)
	# Adds to the containers the bought resources
	for id_resource in current_cart.keys():
		var id_container: String = ContainersManager.ContainersIds[Data.ResourcesIdsArray.find(id_resource)]
		ContainersManager.add_quantity(id_container, current_cart[id_resource])
	current_cart = {}
	current_cost = 0
	# Update the UI
	_update_current_money_label()
	_update_buy_btns_display()
	_update_cart_labels()

func _update_buy_btns_display():
	var contains_cart: bool = current_cost > 0
	var money: int = InventoryManager.get_money() - current_cost
	add_wood_cart.disabled = money < Data.ResourcesPrices[Data.ResourcesName.WOOD]
	add_coal_cart.disabled = money < Data.ResourcesPrices[Data.ResourcesName.COAL]
	add_copper_cart.disabled = money < Data.ResourcesPrices[Data.ResourcesName.COPPER]
	add_iron_cart.disabled = money < Data.ResourcesPrices[Data.ResourcesName.IRON]
	add_steel_cart.disabled = money < Data.ResourcesPrices[Data.ResourcesName.STEEL]
	buy_btn.disabled = !contains_cart
	buy_btn.visible = contains_cart

func _update_current_money_label() -> void:
	money_label.text = str(InventoryManager.money) + "$"

func _update_cart_labels() -> void:
	var cart_string: String = ""
	for name_resource in current_cart.keys():
		cart_string += name_resource + "x" + str(current_cart[name_resource]) + ", "
	# Displays every item bought and the quantity
	cart_label.text = "Bought: " + (cart_string if cart_string.length() > 0 else "Nothing")
	# The cost of current cart
	cart_price.text = "Cost : " + str(current_cost) + "$"
	# Money resulting the cost
	money_result.text = "Money after : " + str(InventoryManager.money - current_cost) + "$"

func _add_resource_to_buy(id_resource: String, quantity: int = 1) -> void:
	if current_cart.has(id_resource):
		current_cart[id_resource] += quantity
	else:
		current_cart[id_resource] = quantity
	current_cost += Data.ResourcesPrices[Data.ResourcesIdsArray.find(id_resource)] * quantity
