Config = {

	OpenGestionAnimal = "F10",
	
	JobName = "animal",
	SocietyName = "society_animal", 
	ESXSociety = true,
	TriggerOpenBoss = "five_society:openBossMenu", -- if esx_society = false you can put your trigger

	Marker = {
		Type = 6,
		Color = {R = 0, G = 0, B = 255},
		Size =  {x = 1.0, y = 1.0, z = 1.0},
		DrawDistance = 10,
		DrawInteract = 1.5,
	},

	Pos = {
		Blips = vector3(562.34, 2737.95, 42.26),
		MenuVente = vector3(561.59, 2752.84, 41.88),
		MenuCoffre = vector3(565.5, 2750.91, 41.88),
		Boss = vector3(559.80560302734,2746.9108886719,41.87712097168),
		Garage = vector3(559.09, 2739.66, 41.2),
		SpawnVeh = vector3(555.72, 2734.32, 42.06),
		SpawnHeading = 182.15,
		DeleteVeh = vector3(558.77783203125,2734.6630859375,41.060234069824),
	},

	ListVeh = {
		{nom = "Blista", model = "blista"},
	},

	Logs = {
		vente = "",
		coffre = "",
		boss = "",
	},

    PetShop = {
		{
			pet = 'chien',
			label = "Chien",
			price = 50000
		},

		{
			pet = 'chat',
			label = "Chat",
			price = 15000
		},

		{
			pet = 'lapin',
			label = "Lapin",
			price = 25000
		},

		{
			pet = 'husky',
			label = "Husky",
			price = 35000
		},

		{
			pet = 'cochon',
			label = "Cochon",
			price = 10000
		},

		{
			pet = 'caniche',
			label = "Caniche",
			price = 50000
		},

		{
			pet = 'carlin',
			label = "Carlin",
			price = 6000
		},

		{
			pet = 'retriever',
			label = "Retriever",
			price = 10000
		},

		{
			pet = 'berger',
			label = "Berger allemand",
			price = 55000
		},

		{
			pet = 'westie',
			label = "Westie",
			price = 50000
		},

		{
			pet = 'chop',
			label = "Chop",
			price = 12000
		}
	}
}