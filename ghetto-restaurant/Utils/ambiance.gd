extends Node
## burps
const BURP_1 = preload("uid://c3t4pdhqjqi7h")
const BURP_2 = preload("uid://d1yvtepxqm8ts")
const BURP_3 = preload("uid://mqw7bievp1ni")
const BURP_4 = preload("uid://1r26n0wxjrbm")
const BURP_5 = preload("uid://d25acrqi8qm0r")
## cleaning
const BROOM = preload("uid://cs17ygsketul6")
const PLATE_TO_DRY = preload("uid://pobj44au6b4v")
const WASHING_DISHES = preload("uid://csbcrkemke61b")
## coughs
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
@onready var eat: AudioStreamPlayer = $Eat
@onready var burps_timer: Timer = $Burps/BurpsTimer
@onready var cleaning_timer: Timer = $Cleaning/CleaningTimer
@onready var coughs_timer: Timer = $Coughs/CoughsTimer
@onready var chair_timer: Timer = $Chairs/ChairTimer
@onready var sneeze_timer: Timer = $Sneeze/SneezeTimer
@onready var flies: AudioStreamPlayer = $Flies
@onready var eat_timer: Timer = $Eat/EatTimer
@onready var kitchen: AudioStreamPlayer = $Kitchen
@onready var kitchen_timer: Timer = $Kitchen/KitchenTimer

func start() -> void:
	flies.play()
	burps_timer.start() 
	cleaning_timer.start() 
	coughs_timer.start() 
	chair_timer.start() 
	sneeze_timer.start() 
	eat_timer.start()
	kitchen_timer.start()

func _on_sneeze_timer_timeout() -> void:
	sneeze.stream = [SNEEZE_1, SNEEZE_2].pick_random()
	sneeze.play()
	
func _on_chair_timer_timeout() -> void:
	chairs.stream = [DRAG_CHAIR_1, DRAG_CHAIR_2, DRAG_CHAIR_3, DRAG_QUICK, DRAG_SOMETHING_1, DRAG_SOMETHING_2].pick_random()
	chairs.play()
	
func _on_coughs_timer_timeout() -> void:
	coughs.stream = [FEMALE_COUGH_1, FEMALE_COUGH_2, MALE_COUGH_1, MALE_COUGH_2, MALE_COUGH_3].pick_random()
	coughs.play()
	
func _on_cleaning_timer_timeout() -> void:
	cleaning.stream = [BROOM, PLATE_TO_DRY, WASHING_DISHES].pick_random()
	cleaning.play()
	
func _on_burps_timer_timeout() -> void:
	burps.stream = [BURP_1, BURP_2, BURP_3, BURP_4, BURP_5].pick_random()
	burps.play()
	
const APPLE_SLICING_1 = preload("uid://c85jwtidxxv78")
const APPLE_SLICING_2 = preload("uid://dcdpo4onrtsbu")
const BAKED_CUTTING_1 = preload("uid://dauqpahx0ljxh")
const BAKED_CUTTING_2 = preload("uid://do1v560rm3egi")
const BOTTLE_OPENING = preload("uid://bpgycshukah8q")
const CAN_CRUSHING = preload("uid://cs48gmsa0dbcn")
const CAN_OPENING = preload("uid://6xkkst07y4kr")
const CERAMIC_LID___CLOSE = preload("uid://bbyff20718yn4")
const CERAMIC_LID___OPEN = preload("uid://bkqhxy0kxf1rh")
const COFFEE_CUP_PICKING_UP = preload("uid://0bvdpdip4w55")
const COFFEE_CUP_PUTTING_DOWN = preload("uid://bnqopbum4cajp")
const COFFEE_CUP_VIBRATING = preload("uid://dgsbg6x01b4w0")
const FORK_DROP_IN_KITCHEN = preload("uid://jji2ei7x4mqt")
const GLASSES_CLINKING_1 = preload("uid://cyvp8d1ukjvam")
const GLASSES_CLINKING_2 = preload("uid://c430tb3t5opps")
const ICE_IN_GLASS_1 = preload("uid://bn1q3dwbggd5b")
const ICE_IN_GLASS_2 = preload("uid://cflfir0lep0j5")
const KNIFE_DROP_IN_KITCHEN = preload("uid://bfvywdui3082")
const PEELING = preload("uid://dlso8rjemcnau")
const SPOON_DROP_IN_KITCHEN = preload("uid://58olc6fvvjqt")
const WINE_BOTTLE_OPENING = preload("uid://vw5hhmbe4vut")

const KITCHEN_SOUNDS = [
  APPLE_SLICING_1,
  APPLE_SLICING_2,
  BAKED_CUTTING_1,
  BAKED_CUTTING_2,
  BOTTLE_OPENING,
  CAN_CRUSHING,
  CAN_OPENING,
  CERAMIC_LID___CLOSE,
  CERAMIC_LID___OPEN,
  COFFEE_CUP_PICKING_UP,
  COFFEE_CUP_PUTTING_DOWN,
  COFFEE_CUP_VIBRATING,
  FORK_DROP_IN_KITCHEN,
  GLASSES_CLINKING_1,
  GLASSES_CLINKING_2,
  ICE_IN_GLASS_1,
  ICE_IN_GLASS_2,
  PEELING,
  SPOON_DROP_IN_KITCHEN,
  WINE_BOTTLE_OPENING
];

const BITING_HARD_1 = preload("uid://ctnfsstvvdkx1")
const BITING_HARD_2 = preload("uid://rj544g1socox")
const DRINKING = preload("uid://3f1nm0fgmwcx")
const FOOD_EAT_1 = preload("uid://7hajjxivbnpy")
const STRAW_SLURPING_1 = preload("uid://d38qq8o0wl01p")
const STRAW_SLURPING_2 = preload("uid://bqkhkp8dwkhka")
const SWALLOW_DRINK = preload("uid://bnylns5tc7wlt")

const EAT_SOUNDS = [
  BITING_HARD_1,
  BITING_HARD_2,
  DRINKING,
  FOOD_EAT_1,
  STRAW_SLURPING_1,
  STRAW_SLURPING_2,
  SWALLOW_DRINK
];
func _on_eat_timer_timeout() -> void:
	eat.stream = EAT_SOUNDS.pick_random()
	eat.play()

func _on_kitchen_timer_timeout() -> void:
	kitchen.stream = KITCHEN_SOUNDS.pick_random()
	kitchen.play()
