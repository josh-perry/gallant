local level = {}

level.data = "levels/2"
level.image = "levels/2.png"

level.tip = {
	text = "Upgrading turrets is important!",
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
		"red_blob"
	},
	spawnDelay = 2
}

level.enemySpawns["green"] = {
	enemies = {
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob",
		"green_blob"
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
		"blue_blob",
		"blue_blob",
		"blue_blob"
	},
	spawnDelay = 1
}

return level