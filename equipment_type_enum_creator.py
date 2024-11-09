text = """---| 0 # none
---| 1 # diving
---| 2 # firefighter
---| 3 # scuba
---| 4 # parachute [int = {0 = deployed, 1 = ready}]
---| 5 # arctic
---| 6 # binoculars
---| 7 # cable
---| 8 # compass
---| 9 # defibrillator [int = charges]
---| 10 # fire_extinguisher [float = ammo]
---| 11 # first_aid [int = charges]
---| 12 # flare [int = charges]
---| 13 # flaregun [int = ammo]
---| 14 # flaregun_ammo [int = ammo]
---| 15 # flashlight [float = battery]
---| 16 # hose [int = {0 = hose off, 1 = hose on}]
---| 17 # night_vision_binoculars [float = battery]
---| 18 # oxygen_mask [float = oxygen]
---| 19 # radio [int = channel] [float = battery]
---| 20 # radio_signal_locator [float = battery]
---| 21 # remote_control [int = channel] [float = battery]
---| 22 # rope
---| 23 # strobe_light [int = {0 = off, 1 = on}] [float = battery]
---| 24 # strobe_light_infrared [int = {0 = off, 1 = on}] [float = battery]
---| 25 # transponder [int = {0 = off, 1 = on}] [float = battery]
---| 26 # underwater_welding_torch [float = charge]
---| 27 # welding_torch [float = charge]
---| 28 # coal
---| 29 # hazmat
---| 30 # radiation_detector [float = battery]
---| 31 # c4 [int = ammo]
---| 32 # c4_detonator
---| 33 # speargun [int = ammo]
---| 34 # speargun_ammo
---| 35 # pistol [int = ammo]
---| 36 # pistol_ammo
---| 37 # smg [int = ammo]
---| 38 # smg_ammo
---| 39 # rifle [int = ammo]
---| 40 # rifle_ammo
---| 41 # grenade [int = ammo]
---| 42 # machine_gun_ammo_box_k
---| 43 # machine_gun_ammo_box_he
---| 44 # machine_gun_ammo_box_he_frag
---| 45 # machine_gun_ammo_box_ap
---| 46 # machine_gun_ammo_box_i
---| 47 # light_auto_ammo_box_k
---| 48 # light_auto_ammo_box_he
---| 49 # light_auto_ammo_box_he_frag
---| 50 # light_auto_ammo_box_ap
---| 51 # light_auto_ammo_box_i
---| 52 # rotary_auto_ammo_box_k
---| 53 # rotary_auto_ammo_box_he
---| 54 # rotary_auto_ammo_box_he_frag
---| 55 # rotary_auto_ammo_box_ap
---| 56 # rotary_auto_ammo_box_i
---| 57 # heavy_auto_ammo_box_k
---| 58 # heavy_auto_ammo_box_he
---| 59 # heavy_auto_ammo_box_he_frag
---| 60 # heavy_auto_ammo_box_ap
---| 61 # heavy_auto_ammo_box_i
---| 62 # battle_shell_k
---| 63 # battle_shell_he
---| 64 # battle_shell_he_frag
---| 65 # battle_shell_ap
---| 66 # battle_shell_i
---| 67 # artillery_shell_k
---| 68 # artillery_shell_he
---| 69 # artillery_shell_he_frag
---| 70 # artillery_shell_ap
---| 71 # artillery_shell_i
---| 72 # glowstick
---| 73 # dog_whistle
---| 74 # bomb_disposal
---| 75 # chest_rig
---| 76 # black_hawk_vest
---| 77 # plate_vest
---| 78 # armor_vest
---| 79 # space_suit
---| 80 # exploration_space_suit
---| 81 # fishing rod
---| 82 # anchovie [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 83 # anglerfish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 84 # arctic_char [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 85 # ballan_lizardfish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 86 # ballan_wrasse [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 87 # barreleye_fish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 88 # black_Bream [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 89 # black_dragonfish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 90 # clown_fish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 91 # cod [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 92 # dolphinfish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 93 # gulper_eel [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 94 # haddock [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 95 # hake [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 96 # herring [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 97 # john_dory [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 98 # labrus [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 99 # lanternfish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 100 # mackerel [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 101 # midshipman [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 102 # perch [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 103 # pike [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 104 # pinecone_fish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 105 # pollack [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 106 # red_mullet [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 107 # rockfish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 108 # sablefish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 109 # salmon [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 110 # sardine [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 111 # scad [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 112 # sea_bream [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 113 # sea_halibut [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 114 # sea_piranha [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 115 # seabass [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 116 # slimehead [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 117 # snapper [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 118 # snapper_gold [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 119 # snook [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 120 # spadefish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 121 # trout [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 122 # tubeshoulders_fish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 123 # viperfish [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 124 # yellowfin_tuna [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 125 # blue_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 126 # brown_box_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 127 # coconut_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 128 # dungeness_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 129 # furry_lobster [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 130 # homarus_americanus [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 131 # homarus_gammarus [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 132 # horseshoe_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 133 # jasus_edwardsii [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 134 # jasus_lalandii [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 135 # jonah_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 136 # king_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 137 # mud_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 138 # munida_lobster [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 139 # ornate_rock_lobster [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 140 # panulirus_interruptus [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 141 # red_king_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 142 # reef_lobster [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 143 # slipper_lobster [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 144 # snow_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 145 # southern_rock_lobster [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 146 # spider_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 147 # spiny_lobster [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]
---| 148 # stone_crab [int = fish {0 = idle, 1 = flee, 2 = flop, 3 = dead}]"""

import pyperclip

generated = []

for line in text.splitlines():
    _name = line.split(" ")[3]
    equipmentType = int(line.split(" ")[1])
    name = ""
    
    for segment in _name.split("_"):
        name += segment.capitalize()
    
    generated.append(f"{name} = {equipmentType},")

pyperclip.copy("\n".join(generated))
print("\n".join(generated))