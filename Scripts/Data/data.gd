extends Node

enum WeaponType { SWORD, DAGGER, AXE }

enum ResourcesName { WOOD, COAL, COPPER, IRON, STEEL }

var ResourcesNameArray = ["Wood", "Coal", "Copper", "Iron", "Steel"]

var weapon_prices = {
	WeaponType.SWORD: 10,
	WeaponType.DAGGER: 6,
	WeaponType.AXE: 15,
}

var TimePerItemToCraft = 4
var TimePerBuild = 10
