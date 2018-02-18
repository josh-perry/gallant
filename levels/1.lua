local level = {}

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
		"red_blob"
	},
	spawnDelay = 1
}

level.enemySpawns["green"] = {
	enemies = {
		"red_blob",
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