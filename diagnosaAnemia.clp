(defglobal
    ?*anemia* = 0
    ?*kronis* = yes
    ?*bpressure* = 100
)
(defrule trigger
    =>
    (assert(callAsk))
)
(defrule intro
    (callAsk)
    =>
    (printout t crlf "Do you want check you blood pressure? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(do_blood_check))
        else
            (if(eq ?answer n) 
                then 
                    (printout t "Thank you, stay healthy"crlf) 
            )
        else
            (if (and (neq ?answer y) (neq ?answer n))
                then
                    (printout t "Input not valid" crlf)
                    (assert(callAsk))
            )
    )
)
;/////////////////////user Data/////////////////////////////
(defrule gender
    (do_blood_check)
    =>
    (printout t crlf "Are you man or woman? m/w" crlf)
    (bind ?answer (read))
    (if(eq ?answer m)
        then
            (assert(man))
        else
            (if(eq ?answer n)
                then
                    (assert(woman))
            )
        else 
            (assert(do_blood_check))
    )
)
(defrule pressure
    (or (man) (woman))
    =>
    (printout t crlf "Do you know your blood pressure?y/n" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (printout t crlf "How much is your blood pressure? (just input number)"
            (bind ?*bpressure* (read))
            (if(< ?*bpressure* 90) 
                then
                    (assert(low_blood_pressure))
            )
            (assert(know_blood_pressure))
        else
            (if(eq ?answer n) 
                then 
                    (assert(dont_know_blood_pressure)) 
            )
    )
)
(defrule askChronic
    (or(man) (woman))
    =>
    (printout t crlf "Do you have chronic diseases?y/n" crlf)
    (bind ?answer (read))
    (if(eq ?answer y)
        then
            (printout t "What your chronic disease?" crlf)
            (bind ?*kronis* (read))
            (assert(have_chronic))
        else
            (assert(dont_have_chronic))
    )
)
;/////////////////////Phase 1/////////////////////////////
(defrule tired
    (or(have_chronic) (dont_have_chronic))
    =>
    (printout t crlf "Do you feel tired often? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(feel_tired)) 
            (bind ?*anemia* (+ ?*anemia* 2))
        else
            (assert (isnt_tired))
    )
)

(defrule pale
    (or (feel_tired) (isnt_tired))
    =>
    (printout t crlf "Are you pale? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(look_pale)) 
            (bind ?*anemia* (+ ?*anemia* 2))
        else
            (assert (not_pale))
    )
)

(defrule dizzy
    (or (look_pale) (not_pale))
    =>
    (printout t crlf "Do you feel dizzy often? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(feel_dizzy)) 
            (bind ?*anemia* (+ ?*anemia* 2))
        else
            (assert (not_dizzy))
    )
)

(defrule cold
    (or (feel_dizzy) (not_dizzy))
    =>
    (printout t crlf "Do your hand or left feel cold? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(feel_cold)) 
            (bind ?*anemia* (+ ?*anemia* 1))
        else
            (assert (isnt_cold))
    )
)

(defrule immunity
    (or (feel_cold) (isnt_cold))
    =>
    (printout t crlf "Do you have an immune problem? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(reduced_immune)) 
            (bind ?*anemia* (+ ?*anemia* 1))
        else
            (assert (normal_immune))
    )
)

(defrule breath
    (or (reduced_immune) (normal_immune))
    =>
    (printout t crlf "Do you have short breath? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(have_short_breath)) 
            (bind ?*anemia* (+ ?*anemia* 1))
        else
            (assert (isnt_have_short_breath))
    )
)

(defrule heartbeat
    (or (have_short_breath) (isnt_have_short_breath))
    =>
    (printout t crlf "Do you often feel your heart pounding fast? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(fast_heartbeat)) 
            (bind ?*anemia* (+ ?*anemia* 1))
        else
            (assert (normal_heartbeat))
    )
)

(defrule sore
    (or (fast_heartbeat) (normal_heartbeat))
    =>
    (printout t crlf "Do you have inflammation in your mouth? y/n" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (assert(have_inflammation)) 
            (bind ?*anemia* (+ ?*anemia* 1))
        else
            (assert (dont_have_inflammation))
    )
)
(defrule phase1
    (or (have_inflammation) (dont_have_inflammation))
    =>
    (if (eq ?*anemia* 0) then (printout t crlf "You're healthy, saty safe!" crlf))
    (if(> ?*anemia* 5) 
        then
            (assert(phase2))
        else 
            (if (< ?*bpressure* 90) then (assert(check_bp)))
        else
            (if (>= ?*bpressure* 90) then (assert (check_other)))
    )
)
;/////////////////////Phase 2/////////////////////////////
(defrule pregnant
    (woman)
    (phase2)
    =>
    (printout t crlf "Are you pregnant? y/n" crlf)
    (bind ?answer (read))
    (if(eq ?answer y)
        then
            (printout t "You may experience hemogoblin deficiency during pregnancy" crlf)
            (assert(pregnant))
        else
            (assert(not_pregnant))
    )
)
(defrule chronicheal
    (phase2)
    (have_chronic)
    =>
    (printout t crlf "Is the your " ?*kronis* "diseases cured?y/n" crlf)
    (bind ?answer (read))
    (if(eq ?answer y)
        then
            (assert(has_healed))
            (assert(phase2))
        else
            (printout t "You may get anemia due to the effects of body strees when suffering from the "?*kronis*" disease " crlf) 
            (assert(not_healed))
            (assert(phase2))
    )
)
(defrule iron 
    (phase2)
    =>
    (printout t crlf "Do you rarely eat foods that contain iron?? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (printout t "You may diagnosed with anemia because you rarely consume foods with iron content" crlf)
            (assert(rarely_consume_iron)) 
             (assert(diagnose))
        else
            (assert (consume_iron))
            (assert(diagnose))
    )
)
;/////////////////////Diagnose Anemia/////////////////////////////

;/////////////////////Diagnose Other/////////////////////////////
(defrule other0
    (check_other)
    (or(feel_tired) (feel_dizzy))
    =>
    (printout t crlf "Do you rarely consume mineral water?? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (printout t crlf "You may not have anemia but you got dehidrated" crlf)
            (printout t "Consume more mineral water so that it is not easily tired and dizzy" crlf)
        else
            (assert(check_other))
    )
)
(defrule other2 
    (check_other)(inflammation)
    =>
    (printout t crlf "Does your throat hurt and cough frequently? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (printout t crlf "You may not have anemia but strep throat disease" crlf)
        else
            (assert(check_other))
    )
)
(defrule other3 
    (check_other)(have_short_breath)
    =>
    (printout t crlf "Does your throat hurt and cough frequently?? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (printout t crlf "You may not have anemia but strep throat disease" crlf)
        else
            (assert(check_other))
    )
)
(defrule other4 
    (check_other)(fast_heartbeat)
    =>
    (printout t crlf "Does your chest or heart feel pain frequently?? (y/n)" crlf)
    (bind ?answer (read))
    (if(eq ?answer y) 
        then 
            (printout t crlf "You may have heart dissease" crlf)
        else
            (assert(check_other))
    )
)
(defrule other5
    (check_other)(reduced_immune)
    =>
    (printout t crlf "Are you susceptible to disease or virus?y/n" crlf)
    (bind ?answer (read))
    (if (eq ?answer y)
        then
            (printout t "You may have low immune because your hemogoblin reduced" crlf)
        else
            (assert(check_other))
    )
)
(defrule other6
    (check_other)(feel_cold)
    =>
    (printout t crlf "Do you often shiver??y/n" crlf)
    (bind ?answer (read))
    (if (eq ?answer y)
        then
            (printout t "You may get a cold." crlf)
        else
            (assert(check_other))
    )
)
(defrule other1
    (check_other)(look_pale)
    (not (feel_dizzy) (have_short_breath) (feel_tired) (fast_heartbeat) (have_inflammation) (reduced_immune) (feel_cold))
    =>
    (printout t crlf "You may not got anemia or other symptomps, but yo look pale just because ecologis factoror because your bad habit" crlf)
)
;/////////////////////Check BP/////////////////////////////
(defrule bp1
    (check_bp)
    =>
    (printout t crlf "Do you feel tired often?y/n" crlf)
    (bind ?answer (read))
    (if (eq ?answer y)
        then
            (printout t "You may not anemia, but got low pressure blood" crlf)
        else
            (assert(check_other))
    )
)