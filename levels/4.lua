local level = {}

level.data = "levels/4"
level.image = "levels/4.png"

level.dosh = 250

level.enemySpawns = {}

level.enemySpawns["red"] = {
	enemies = {
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
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
		"blue_blob",
		"red_blob",
		"blue_blob",
		"blue_blob",
		"blue_blob",
		"red_blob",
		"blue_blob",
		"red_blob",
		"blue_blob",
		"blue_blob",
		"red_blob",
		"blue_blob"
	},
	spawnDelay = 3
}

level.enemySpawns["blue"] = {
	enemies = {
		"blue_blob",
		"blue_blob",
		"blue_blob",
		"blue_blob",
		"blue_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"blue_blob",
		"green_blob",
		"green_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"blue_blob"
	},
	spawnDelay = 1
}

return level