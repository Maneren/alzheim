extends Node2D

var available_npc_quests = {
	"ghost-town":
	{
		"target": "Ghost",
		"amount": 3,
		"xp": 50,
		"coords": [8, 15],
		"description":
		"Oh, I need someone like you. Well, where to start… let's say I used to be a mayor of a little island town up the north. After they elected me people wanted that I should keep up with my promises a help the village. And thady dhady da, the village became a ghost town. And I mean literally GHOST town. Like those flying transparent guys. Well, I just need you to clear the town so they can reelect me.\n\nSo you need to take the south road all the way to the desert. On the first crossing took the northwest road. You gonna find a roundabout and you gonna take again the northwest road. It's gonna lead you to a jungle village. Then keep following the road up the north as much as possible and it gonna lead you to a beach. There is a bridge that is gonna take you to my lovely town."
	},
	"fishing-spot":
	{
		"target": "Slime",
		"amount": 4,
		"xp": 50,
		"coords": [109, 47],
		"description":
		"Oh, Hero, I need your help. A bunch of imps has overrun my fishing spot! It is the best fishing spot in this whole region. I don't know why they would do this, because as far as I recall, those little bastards don't even eat fish! Oh, they drive me mad!\n\nI need you to go up the north, until you bump into a first crossing, then hit the road to the west, it is going to take you to the bridge, where I used to fish."
	},
	"raided-village":
	{
		"target": "Imp",
		"amount": 2,
		"xp": 100,
		"coords": [83, 180],
		"description":
		"I see you carry a weapon. Wouldn't you mind killing a bunch of those red pricks? Those green scumbags kept on raiding my home village, so I have to leave. Don't know what they get from it. Maybe it is just a kind of sick pleasure.\n\nSo if you want to help a man out, take the east road till you make it to the crossing, then took the south road to my home village. You gonna find them south-east of the village, it's the place where they usually are."
	},
	"playground":
	{
		"target": "Skeleton",
		"amount": 2,
		"xp": 100,
		"coords": [126, 166],
		"description":
		"Oh glad to see a Hero! You are just the man I need. You see there are a bunch of bone boys nearby. I wouldn't mind them if they wouldn't make their creepy xylophone stuff. It's spooky and scary and I would like you to if you get rid of them.\n\nIf you go to the west end of the town, then take the road south. The road starts to go west and you should keep following it. Then there is a crossing you should go a little further north. Then you're gonna see their meeting patch."
	}
}
var active_npc_quests = []

var available_bard_quests = {
	"islands":
	{
		"target": "Imp",
		"amount": 1,
		"xp": 100,
		"coords": [23, 50],
		"description":
		"Oh, you came to listen to my music? Oh, a quest. That's a shame. Well, there is a debt I need to settle. Once I had I beautiful concert on the beach. People came from all around. But when I was in a middle of a song, this stupid creature came out of nowhere and ruined it whole. Now people think that my voice lures that beast! My beautiful voice! So I need that you kill him and I can get back to business.\n\nSo if you make your way all the way south, right behind the first bridge is a town. It is the one with the tavern. And from that town, you need to make your way northwest through the jungle. You should bump onto the water and you should see a bunch of islands. Not sure where he exactly is, but he should be on one of the islands."
	},
	"stolen-tuba":
	{
		"target": "Skeleton",
		"amount": 1,
		"xp": 100,
		"coords": [116, 1],
		"description":
		"Oh hey. Need you to teach someone a lesson. And that someone is my old student. To start from the beginning, one day came this skeleton guy that he wants to learn how to play the tuba. I was happy to finally find myself a student. So I gave him my tuba and before I realized that bastard has no lips nor lungs, he was long gone. Don't know what he did to that tuba but I take it already as a loss. So just beat that guy up.\n\nSo the path is, the south road from here down to the crossing, take it up west through the village. Then the road goes north. It takes you to two cabins. You will find him northeast behind those."
	},
	"oasis":
	{
		"target": "Imp",
		"amount": 2,
		"xp": 200,
		"coords": [22, 164],
		"description":
		"Ah, a Hero! I could use you. I mean I could use your help. Well you see, there lives this lovely lady near the oasis. At least she used to live there before that big mean monster came in. And this is where I shine. And when I say I, I mean you. You gonna kill the monster, say no one that you did, and I take the credit. Well, and when the lady hears of the things I have done for her…\n\nYou need to go south as far as the road takes you then go west to the crossing. Take the north road, it is gonna take you to town with a tavern. Then exit the town by the west road, then the road makes it down to the south. The road there makes there some kind of spiral and her house is in the middle of it. "
	},
	"monster-by-the-river":
	{
		"target": "Imp",
		"amount": 1,
		"xp": 150,
		"coords": [112, 167],
		"description":
		"Roses are red, violets are blue… …Nah that's bad. Oh, you came just in time. Please tell me of your adventures Hero! Wait no, probably someone already wrote a song about that. Aha, I have an idea! Yes, but first I need to make you familiar with my story. So right now I am little low on the muse, so I need a good story to spark the creativity in me. And you can give me that! So I need you to slay a beast and then tell the story to me. Easy as that.\n\nI heard there is a one good, if you head on the north road from here, on crossing make your way west through the town with that lovely tavern. Still on the west road until you find a river. Then cross it on the bridge and take it south by the river. Soon or later you gonna bump right into it. "
	}
}
var active_bard_quests = []

const spawner_template = preload("res://scenes/SingleSpawner.tscn")
onready var enemies_node = get_node("/root/Game/Enemies")


func start_npc_quest(id: String):
	var quest = available_npc_quests[id]

	var spawner = spawner_template.instance()

	spawner.max_enemy_count = quest.amount
	spawner.enemy_template = load("res://scenes/enemies/" + quest.target + ".tscn")
	spawner.spawn_name = id
	var x = quest.coords[0]
	var y = quest.coords[1]
	spawner.position = Vector2(x, y) * 128
	spawner.connect("enemy_killed", enemies_node, "_on_Spawner_enemy_killed")

	enemies_node.add_child(spawner)


func start_bard_quest(id: String):
	var quest = available_bard_quests[id]

	var spawner = spawner_template.instance()

	spawner.max_enemy_count = quest.amount
	spawner.enemy_template = load("res://scenes/enemies/" + quest.target + ".tscn")
	spawner.spawn_name = id
	var x = quest.coords[0]
	var y = quest.coords[1]
	spawner.position = Vector2(x, y) * 128
	spawner.connect("enemy_killed", enemies_node, "_on_Spawner_enemy_killed")

	enemies_node.add_child(spawner)
