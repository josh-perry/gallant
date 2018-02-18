local level = {}

level.tip = {
	text = "Face a wall and press space to build a turret!",
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
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"red_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob"
	},
	spawnDelay = 1
}

level.enemySpawns["green"] = {
	enemies = {
		"green_blob",
		"red_blob",
		"red_blob",
		"green_blob",
		"red_blob",
		"red_blob",
		"green_blob",
		"red_blob",
		"red_blob",
		"green_blob",
		"red_blob",
		"red_blob"
	},
	spawnDelay = 3
}

level.enemySpawns["blue"] = {
	enemies = {},
	spawnDelay = 1
}

return level