extends Node

## controla el flujo de combos al atacar

@onready var x_button :XButtonActions = $X_Button

# attack state
var current_attack_state :ATTACK_STATE = ATTACK_STATE.ATTACK_0
enum ATTACK_STATE {
    ATTACK_0,
    ATTACK_1,
    ATTACK_2,
    ATTACK_3,
    FINISHER,
}
#-------------------------

# Timers
@onready var start_up_timer: Timer = $StartUp
@onready var active_timer: Timer = $Active
@onready var recovery_timer: Timer = $Recovery

var start_up_duration :float = 0.5
var active_duration :float = 0.5
var recovery_duration :float = 0.5
#---------------------------------------


func _process(delta: float) -> void:
    # if Input.is_action_just_pressed('x_button'):
        attack()
        pass


func attack()->void:
    if active_timer.time_left > 0.0:
        return

    match current_attack_state:
        ATTACK_STATE.ATTACK_0:
            if Input.is_action_just_pressed('x_button'):
                x_button.attack_1()
                current_attack_state = ATTACK_STATE.ATTACK_1
                active_timer.start(active_duration)

        ATTACK_STATE.ATTACK_1:
            if Input.is_action_just_pressed('x_button'):
                x_button.attack_2()
                current_attack_state = ATTACK_STATE.ATTACK_2
                active_timer.start(active_duration)
            elif Input.is_action_just_pressed('y_button'):
                # y_button.finisher_1()
                print('finisher 1')
                current_attack_state = ATTACK_STATE.ATTACK_0

        ATTACK_STATE.ATTACK_2:
            if Input.is_action_just_pressed('x_button'):
                x_button.attack_3()
                current_attack_state = ATTACK_STATE.ATTACK_3
                active_timer.start(active_duration)

        ATTACK_STATE.ATTACK_3:
            if Input.is_action_just_pressed('y_button'):
                # y_button.attack()
                print('y attack')
                current_attack_state = ATTACK_STATE.ATTACK_0
            elif Input.is_action_just_pressed('x_button'):
                print('fallo combo/finisher')
                current_attack_state = ATTACK_STATE.ATTACK_0
                active_timer.start(active_duration)
            

            
       