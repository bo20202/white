//Charger
/mob/living/simple_animal/hostile/guardian/charger
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1 //technically
	ranged_message = "charges"
	ranged_cooldown_cap = 5
	speed = -1
	damage_coeff = list(BRUTE = 0.6, BURN = 0.6, TOX = 0.6, CLONE = 0.6, STAMINA = 0, OXY = 0.6)
	playstyle_string = "As a charger type you do medium damage, have medium damage resistance, move very fast, and can charge at a location, stunning and heavily damaging any target hit."
	magic_fluff_string = "..And draw the Hunter, an alien master of rapid assault."
	tech_fluff_string = "Boot sequence complete. Charge modules loaded. Holoparasite swarm online."
	var/charging = 0
	var/obj/screen/alert/chargealert

/mob/living/simple_animal/hostile/guardian/charger/Life()
	..()
	if(!ranged_cooldown)
		if(!chargealert)
			chargealert = throw_alert("charge", /obj/screen/alert/cancharge)
	else
		clear_alert("charge")
		chargealert = null

/mob/living/simple_animal/hostile/guardian/charger/OpenFire(atom/A)
	if(!charging)
		visible_message("<span class='danger'><b>[src]</b> [ranged_message] at [A]!</span>")
		ranged_cooldown = ranged_cooldown_cap
		clear_alert("charge")
		chargealert = null
		Shoot(A)

/mob/living/simple_animal/hostile/guardian/charger/Shoot(atom/targeted_atom)
	charging = 1
	throw_at(targeted_atom, range, 1, src, 0)
	charging = 0

/mob/living/simple_animal/hostile/guardian/charger/Move()
	if(charging)
		PoolOrNew(/obj/effect/overlay/temp/decoy, list(loc,src))
	. = ..()

/mob/living/simple_animal/hostile/guardian/charger/snapback()
	if(!charging)
		..()

/mob/living/simple_animal/hostile/guardian/charger/throw_impact(atom/A)
	if(!charging)
		return ..()

	else if(A)
		if(isliving(A) && A != summoner)
			var/mob/living/L = A
			var/blocked = 0
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				if(H.check_shields(90, "the [name]", src, attack_type = THROWN_PROJECTILE_ATTACK))
					blocked = 1
			if(!blocked)

				L.visible_message("<span class='danger'>[src] slams into [L]!</span>", "<span class='userdanger'>[src] slams into you!</span>")
				L.Weaken(2)
				L.apply_damage(20, BRUTE)

		charging = 0

