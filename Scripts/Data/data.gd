extends Node

enum WeaponType { SWORD, DAGGER, AXE }

enum ResourcesName { WOOD, COAL, COPPER, IRON, STEEL }

var ResourcesNameArray = ["Wood", "Coal", "Copper", "Iron", "Steel"]

var ResourcesPrices = {
	ResourcesName.WOOD: 1,
	ResourcesName.COAL: 2,
	ResourcesName.COPPER: 3,
	ResourcesName.IRON: 5,
	ResourcesName.STEEL: 10,
}

var weapon_prices = {
	WeaponType.SWORD: 10,
	WeaponType.DAGGER: 6,
	WeaponType.AXE: 15,
}

var TimePerItemToCraft = 4
var TimePerBuild = 10
