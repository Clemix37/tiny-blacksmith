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
	ResourcesName.WOOD: 1,
	ResourcesName.COAL: 2,
	ResourcesName.COPPER: 3,
	ResourcesName.IRON: 5,
	ResourcesName.STEEL: 10,
}

var TimePerItemToCraft = 4
var TimePerBuild = 10
