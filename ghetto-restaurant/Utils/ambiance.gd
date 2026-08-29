extends Node
## burps
const BURP_1 = preload("uid://c3t4pdhqjqi7h")
const BURP_2 = preload("uid://d1yvtepxqm8ts")
const BURP_3 = preload("uid://mqw7bievp1ni")
const BURP_4 = preload("uid://1r26n0wxjrbm")
const BURP_5 = preload("uid://d25acrqi8qm0r")
## cleaning
const BROOM = preload("uid://cs17ygsketul6")
const CLEAN_GLASS = preload("uid://c1h821q3s48s8")
const FAUCET_CLEAN = preload("uid://dgrdc2hbryri0")
const PLATE_TO_DRY = preload("uid://pobj44au6b4v")
const SPONGE_CLEAN = preload("uid://wsar4dgryty")
const WASHING_DISHES_WATER = preload("uid://dc2syjlkn3y0t")
const WASHING_DISHES = preload("uid://csbcrkemke61b")
## coughs
const BABY_COUGH_1 = preload("uid://b2k7r4o87tvqw")
const FEMALE_COUGH_1 = preload("uid://bduqbjcmkwr3n")
const FEMALE_COUGH_2 = preload("uid://vxka5tk66n4v")
const MALE_COUGH_1 = preload("uid://cr36u6jmerp4x")
const MALE_COUGH_2 = preload("uid://bu5pqhcyjfx0i")
const MALE_COUGH_3 = preload("uid://chvr4j44jponj")
## chairs
const DRAG_CHAIR_1 = preload("uid://dvs0565avyrrm")
const DRAG_CHAIR_2 = preload("uid://n68gbtmqg5sk")
const DRAG_CHAIR_3 = preload("uid://cwahokcgfl7nc")
const DRAG_QUICK = preload("uid://blknk8ufkqv3v")
const DRAG_SOMETHING_1 = preload("uid://bek4l6q8rk82y")
const DRAG_SOMETHING_2 = preload("uid://wlqrlf0yxhbv")
## sneeze
const SNEEZE_1 = preload("uid://dq1jvykefr4ch")
const SNEEZE_2 = preload("uid://37yjesp4k3nw")
@onready var burps: AudioStreamPlayer = $Burps
@onready var cleaning: AudioStreamPlayer = $Cleaning
@onready var coughs: AudioStreamPlayer = $Coughs
@onready var chairs: AudioStreamPlayer = $Chairs
@onready var sneeze: AudioStreamPlayer = $Sneeze

func _on_sneeze_timer_timeout() -> void:
	sneeze.stream = [SNEEZE_1, SNEEZE_2].pick_random()
	sneeze.play()
	
func _on_chair_timer_timeout() -> void:
	chairs.stream = [DRAG_CHAIR_1, DRAG_CHAIR_2, DRAG_CHAIR_3, DRAG_QUICK, DRAG_SOMETHING_1, DRAG_SOMETHING_2].pick_random()
	chairs.play()
	
func _on_coughs_timer_timeout() -> void:
	coughs.stream = [BABY_COUGH_1, FEMALE_COUGH_1, FEMALE_COUGH_2, MALE_COUGH_1, MALE_COUGH_2, MALE_COUGH_3].pick_random()
	coughs.play()
	
func _on_cleaning_timer_timeout() -> void:
	cleaning.stream = [BROOM, CLEAN_GLASS, FAUCET_CLEAN, PLATE_TO_DRY, SPONGE_CLEAN, WASHING_DISHES_WATER, WASHING_DISHES].pick_random()
	cleaning.play()
	
func _on_burps_timer_timeout() -> void:
	burps.stream = [BURP_1, BURP_2, BURP_3, BURP_4, BURP_5].pick_random()
	burps.play()
