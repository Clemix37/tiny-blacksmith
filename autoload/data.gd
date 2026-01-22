extends Node

enum ResourcesName { WOOD, COAL, COPPER, IRON, STEEL }

var ResourcesNameArray = ["Wood", "Coal", "Copper", "Iron", "Steel"]

var ResourcesIdsArray := [
	"wood",
	"coal",
	"copper",
	"iron",
	"steel",
]

var ResourcesPrices = {
	ResourcesName.WOOD: 2,
	ResourcesName.COAL: 4,
	ResourcesName.COPPER: 6,
	ResourcesName.IRON: 10,
	ResourcesName.STEEL: 18,
}

var moneyToStart: int = 30
var TimePerItemToCraft = 4
var TimePerBuild = 10
var version: int = 0
