local level = {}

level.data = "levels/3"
level.image = "levels/3.png"
level.dosh = 250

level.tip = {
	text = "Place your turrets so they can cover multiple angles",
	x = 50,
	y = 10,
}

level.enemySpawns = {}

level.enemySpawns["red"] = {
	enemies = {
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"green_blob",
		"green_blob",
		"blue_blob",
		"blue_blob",
		"green_blob",
		"green_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob"
	},
	spawnDelay = 1
}

level.enemySpawns["green"] = {
	enemies = {
		"green_blob",
		"green_blob",
		"blue_blob",
		"blue_blob",
		"blue_blob",
		"blue_blob",
		"blue_blob",
		"blue_blob"
	},
	spawnDelay = 4
}

level.enemySpawns["blue"] = {
	enemies = {
		"red_blob",
		"red_blob",
		"red_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
	},
	spawnDelay = 2
}

return level