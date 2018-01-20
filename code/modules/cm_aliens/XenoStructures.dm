/turf/simulated/wall/resin
	name = "resin wall"
	desc = "Weird slime solidified into a wall."
	icon = 'icons/Xeno/structures.dmi'
	icon_state = "resin0"
	walltype = "resin"
	mineral = "resin"
	damage_cap = 200
	layer = RESIN_STRUCTURE_LAYER

	tiles_with = list(/turf/simulated/wall/resin, /turf/simulated/wall/resin/membrane, /obj/structure/mineral_door/resin)

	New()
		..()
		if(!locate(/obj/effect/alien/weeds) in loc)
			new /obj/effect/alien/weeds(loc)

/turf/simulated/wall/resin/flamer_fire_act()
	take_damage(50)

//this one is only for map use
/turf/simulated/wall/resin/ondirt

	oldTurf = "/turf/unsimulated/floor/gm/dirt"

/turf/simulated/wall/resin/thick
	name = "thick resin wall"
	desc = "Weird slime solidified into a thick wall."
	damage_cap = 400
	icon_state = "thickresin0"
	walltype = "thickresin"
	mineral = "thickresin"

/turf/simulated/wall/resin/membrane
	name = "resin membrane"
	desc = "Weird slime translucent enough to let light pass through."
	icon_state = "membrane0"
	walltype = "membrane"
	mineral = "membrane"
	damage_cap = 120
	opacity = 0
	alpha = 180

//this one is only for map use
/turf/simulated/wall/resin/membrane/ondirt

	oldTurf = "/turf/unsimulated/floor/gm/dirt"

/turf/simulated/wall/resin/membrane/thick
	name = "thick resin membrane"
	desc = "Weird thick slime just translucent enough to let light pass through."
	damage_cap = 240
	icon_state = "thickmembrane0"
	walltype = "thickmembrane"
	mineral = "thickmembrane"
	alpha = 210

/turf/simulated/wall/resin/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.damage)
	..()

	return 1

/turf/simulated/wall/resin/ex_act(severity)
	switch(severity)
		if(1)
			take_damage(500)
		if(2)
			take_damage(rand(140, 300))
		if(3)
			take_damage(rand(50, 100))
	return

/turf/simulated/wall/resin/hitby(AM as mob|obj)
	..()
	if(istype(AM,/mob/living/carbon/Xenomorph))
		return
	visible_message("<span class='danger'>\The [src] was hit by \the [AM].</span>", \
	"<span class='danger'>You hit \the [src].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(src, 'sound/effects/attackblob.ogg', 25, 1)
	take_damage(max(0, damage_cap - tforce))

/turf/simulated/wall/resin/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) //Larvae can't do shit
		return 0
	M.animation_attack_on(src)
	M.visible_message("<span class='xenonotice'>\The [M] claws \the [src]!</span>", \
	"<span class='xenonotice'>You claw \the [src].</span>")
	playsound(src, 'sound/effects/attackblob.ogg', 25, 1)
	take_damage((M.melee_damage_upper + 50)) //Beef up the damage a bit

/turf/simulated/wall/resin/attack_animal(mob/living/M)
	M.visible_message("<span class='danger'>[M] tears \the [src]!</span>", \
	"<span class='danger'>You tear \the [name].</span>")
	playsound(src, 'sound/effects/attackblob.ogg', 25, 1)
	M.animation_attack_on(src)
	take_damage(40)

/turf/simulated/wall/resin/attack_hand(mob/user)
	user << "<span class='warning'>You scrape ineffectively at \the [src].</span>"

/turf/simulated/wall/resin/attack_paw(mob/user)
	return attack_hand(user)

/turf/simulated/wall/resin/attackby(obj/item/W, mob/living/user)
	if(!(W.flags_atom & NOBLUDGEON))
		user.animation_attack_on(src)
		take_damage(W.force)
		playsound(src, 'sound/effects/attackblob.ogg', 25, 1)
	return ..()

/turf/simulated/wall/resin/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group)
		return 0
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density

/turf/simulated/wall/resin/dismantle_wall(devastated = 0, explode = 0)
	if(oldTurf != "") ChangeTurf(text2path(oldTurf))
	else ChangeTurf(/turf/simulated/floor/plating)


/*
 * effect/alien
 */
/obj/effect/alien
	name = "alien thing"
	desc = "theres something alien about this"
	icon = 'icons/Xeno/Effects.dmi'
	unacidable = 1
	var/health = 1

/obj/effect/alien/flamer_fire_act()
	health -= 50
	if(health < 0) cdel(src)

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "Resin1"

	density = 1
	opacity = 1
	anchored = 1
	health = 200
	unacidable = 1

/obj/effect/alien/resin/sticky
	name = "sticky resin"
	desc = "A layer of disgusting sticky slime."
	icon_state = "sticky"
	density = 0
	opacity = 0
	health = 36
	layer = RESIN_STRUCTURE_LAYER

	Crossed(atom/movable/AM)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			H.next_move_slowdown += 8

// Praetorian Sticky Resin spit uses this.
/obj/effect/alien/resin/sticky/thin
	name = "thin sticky resin"
	desc = "A thin layer of disgusting sticky slime."
	health = 7

	Crossed(atom/movable/AM)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			H.next_move_slowdown += 4

//Carrier trap
/obj/effect/alien/resin/trap
	desc = "It looks like a hiding hole."
	name = "resin hole"
	icon_state = "trap0"
	density = 0
	opacity = 0
	anchored = 1
	health = 5
	layer = RESIN_STRUCTURE_LAYER
	var/hugger = FALSE
	var/carrier_number //the nicknumber of the carrier that placed us.

/obj/effect/alien/resin/trap/New(loc, mob/living/carbon/Xenomorph/Carrier/C)
	if(C)
		carrier_number = C.nicknumber
	..()

/obj/effect/alien/resin/trap/examine(mob/user)
	if(isXeno(user))
		user << "A hole for a little one to hide in ambush."
		if(hugger)
			user << "There's a little one inside."
		else
			user << "It's empty."
	else
		..()


/obj/effect/alien/resin/trap/flamer_fire_act()
	if(hugger)
		var/obj/item/clothing/mask/facehugger/FH = new (loc)
		FH.Die()
		hugger = FALSE
		icon_state = "trap0"
	..()

/obj/effect/alien/resin/trap/fire_act()
	if(hugger)
		var/obj/item/clothing/mask/facehugger/FH = new (loc)
		FH.Die()
		hugger = FALSE
		icon_state = "trap0"
	..()

/obj/effect/alien/resin/trap/bullet_act(obj/item/projectile/P)
	if(P.ammo.flags_ammo_behavior & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		return
	. = ..()

/obj/effect/alien/resin/trap/HasProximity(atom/movable/AM)
	if(hugger)
		if(CanHug(AM) && !isYautja(AM))
			var/mob/living/L = AM
			L.visible_message("<span class='warning'>[L] trips on [src]!</span>",\
							"<span class='danger'>You trip on [src]!</span>")
			L.KnockDown(1)
			if(carrier_number)
				for(var/mob/living/carbon/Xenomorph/X in living_mob_list)
					if(X.nicknumber == carrier_number)
						if(!X.stat)
							var/area/A = get_area(src)
							if(A)
								X << "<span class='xenoannounce'>You sense one of your traps at [A.name] has been triggered!</span>"
						break
			drop_hugger()

/obj/effect/alien/resin/trap/proc/drop_hugger()
	set waitfor = 0
	var/obj/item/clothing/mask/facehugger/FH = new (loc)
	hugger = FALSE
	icon_state = "trap0"
	visible_message("<span class='warning'>[FH] gets out of [src]!</span>")
	sleep(15)
	if(FH.stat == CONSCIOUS && FH.loc) //Make sure we're conscious and not idle or dead.
		FH.leap_at_nearest_target()

/obj/effect/alien/resin/trap/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.a_intent != "hurt")
		var/list/allowed_castes = list("Queen","Drone","Hivelord","Carrier")
		if(allowed_castes.Find(M.caste))
			if(!hugger)
				M << "<span class='warning'>[src] is empty.</span>"
			else
				hugger = FALSE
				icon_state = "trap0"
				var/obj/item/clothing/mask/facehugger/F = new ()
				M.put_in_active_hand(F)
				M << "<span class='xenonotice'>You remove the facehugger from [src].</span>"
		return
	..()

/obj/effect/alien/resin/trap/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/clothing/mask/facehugger) && isXeno(user))
		var/obj/item/clothing/mask/facehugger/FH = W
		if(FH.stat == DEAD)
			user << "<span class='warning'>You can't put a dead facehugger in [src].</span>"
		else
			hugger = TRUE
			icon_state = "trap1"
			user << "<span class='xenonotice'>You place a facehugger in [src].</span>"
			cdel(FH)
	else
		. = ..()

/obj/effect/alien/resin/trap/Crossed(atom/A)
	if(ismob(A))
		HasProximity(A)

/obj/effect/alien/resin/trap/Dispose()
	if(hugger && loc)
		drop_hugger()
	. = ..()


/obj/effect/alien/resin/proc/healthcheck()
	if(health <= 0)
		density = 0
		cdel(src)

/obj/effect/alien/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return 1

/obj/effect/alien/resin/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= 500
		if(2.0)
			health -= (rand(140, 300))
		if(3.0)
			health -= (rand(50, 100))
	healthcheck()
	return

/obj/effect/alien/resin/hitby(AM as mob|obj)
	..()
	if(istype(AM,/mob/living/carbon/Xenomorph))
		return
	visible_message("<span class='danger'>\The [src] was hit by \the [AM].</span>", \
	"<span class='danger'>You hit \the [src].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(loc, 'sound/effects/attackblob.ogg', 25, 1)
	health = max(0, health - tforce)
	healthcheck()

/obj/effect/alien/resin/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) //Larvae can't do shit
		return 0
	M.visible_message("<span class='xenonotice'>\The [M] claws \the [src]!</span>", \
	"<span class='xenonotice'>You claw \the [src].</span>")
	playsound(loc, 'sound/effects/attackblob.ogg', 25, 1)
	health -= (M.melee_damage_upper + 50) //Beef up the damage a bit
	healthcheck()

/obj/effect/alien/resin/attack_animal(mob/living/M as mob)
	M.visible_message("<span class='danger'>[M] tears \the [src]!</span>", \
	"<span class='danger'>You tear \the [name].</span>")
	playsound(loc, 'sound/effects/attackblob.ogg', 25, 1)
	health -= 40
	healthcheck()

/obj/effect/alien/resin/attack_hand()
	usr << "<span class='warning'>You scrape ineffectively at \the [src].</span>"

/obj/effect/alien/resin/attack_paw()
	return attack_hand()

/obj/effect/alien/resin/attackby(obj/item/W as obj, mob/user as mob)
	if(!(W.flags_atom & NOBLUDGEON))
		var/damage = W.force
		if(W.w_class < 4 || !W.sharp || W.force < 20) //only big strong sharp weapon are adequate
			damage /= 4
		health -= damage
		playsound(loc, 'sound/effects/attackblob.ogg', 25, 1)
		healthcheck()
	return ..(W, user)

/obj/effect/alien/resin/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group)
		return 0
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density

//Resin Doors
/obj/structure/mineral_door/resin
	name = "resin door"
	mineralType = "resin"
	icon = 'icons/Xeno/Effects.dmi'
	hardness = 1.5
	var/health = 80
	var/close_delay = 100

	tiles_with = list(/turf/simulated/wall/resin, /obj/structure/mineral_door/resin)

	New()
		spawn(0)
			relativewall()
			relativewall_neighbours()
			if(!locate(/obj/effect/alien/weeds) in loc)
				new /obj/effect/alien/weeds(loc)
		..()

/obj/structure/mineral_door/resin/attack_paw(mob/user as mob)
	if(user.a_intent == "hurt")
		user.visible_message("<span class='xenowarning'>\The [user] claws at \the [src].</span>", \
		"<span class='xenowarning'>You claw at \the [src].</span>")
		playsound(loc, 'sound/effects/attackblob.ogg', 25, 1, 9)
		health -= rand(40, 60)
		if(health <= 0)
			user.visible_message("<span class='xenodanger'>\The [user] slices \the [src] apart.</span>", \
			"<span class='xenodanger'>You slice \the [src] apart.</span>")
		healthcheck()
		return
	else
		return TryToSwitchState(user)

/obj/structure/mineral_door/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return 1

/obj/structure/mineral_door/resin/TryToSwitchState(atom/user)
	if(isXeno(user))
		return ..()

/obj/structure/mineral_door/resin/Open()
	if(state || !loc) return //already open
	isSwitchingStates = 1
	playsound(loc, 'sound/effects/attackblob.ogg', 25, 1)
	flick("[mineralType]opening",src)
	sleep(10)
	density = 0
	opacity = 0
	state = 1
	update_icon()
	isSwitchingStates = 0

	spawn(close_delay)
		if(!isSwitchingStates && state == 1)
			Close()

/obj/structure/mineral_door/resin/Close()
	if(!state || !loc) return //already closed
	//Can't close if someone is blocking it
	for(var/turf/turf in locs)
		if(locate(/mob/living) in turf)
			spawn (close_delay)
				Close()
			return
	isSwitchingStates = 1
	playsound(loc, 'sound/effects/attackblob.ogg', 25, 1)
	flick("[mineralType]closing",src)
	sleep(10)
	density = 1
	opacity = 1
	state = 0
	update_icon()
	isSwitchingStates = 0
	for(var/turf/turf in locs)
		if(locate(/mob/living) in turf)
			Open()
			return

/obj/structure/mineral_door/resin/Dismantle(devastated = 0)
	cdel(src)

/obj/structure/mineral_door/resin/CheckHardness()
	playsound(loc, 'sound/effects/attackblob.ogg', 25, 1)
	..()

/obj/structure/mineral_door/resin/Dispose()
	relativewall_neighbours()
	return ..()

/obj/structure/mineral_door/resin/proc/healthcheck()
	if(src.health <= 0)
		src.Dismantle(1)

/obj/structure/mineral_door/resin/thick
	name = "thick resin door"
	health = 160
	hardness = 2.0

/* //It turns out this is cloned in xenoprocs.dm. Wonderful.
 * Acid
 */
/obj/effect/alien/acid
	name = "acid"
	desc = "Bubling corrosive stuff. I wouldn't want to touch it."
	icon_state = "acid"

	density = 0
	opacity = 0
	anchored = 1
	var/ticks = 0
	health = 1

/obj/effect/alien/acid/New(loc, acid_t)
	..(loc)
	var/strength_t = isturf(acid_t) ? 8:4 // Turf take twice as long to take down.
	tick(acid_t,strength_t)

/obj/effect/alien/acid/proc/tick(atom/acid_t,strength_t)
	set waitfor = 0
	if(!acid_t || !acid_t.loc)
		cdel(src)
		return

	if(++ticks >= strength_t)
		visible_message("<span class='xenodanger'>\The [acid_t] collapses under its own weight into a puddle of goop and undigested debris!</span>")

		if(istype(acid_t, /turf/simulated/wall)) // I hate turf code.
			var/turf/simulated/wall/W = acid_t
			W.dismantle_wall(1)
		else
			if(acid_t.contents) //Hopefully won't auto-delete things inside melted stuff..
				for(var/mob/M in acid_t.contents)
					if(acid_t.loc) M.loc = acid_t.loc
			cdel(acid_t)
		cdel(src)
		return

	switch(strength_t - ticks)
		if(6) visible_message("<span class='xenowarning'>\The [acid_t] is barely holding up against the acid!</span>")
		if(4) visible_message("<span class='xenowarning'>\The [acid_t]\s structure is being melted by the acid!</span>")
		if(2) visible_message("<span class='xenowarning'>\The [acid_t] is struggling to withstand the acid!</span>")
		if(0 to 1) visible_message("<span class='xenowarning'>\The [acid_t] begins to crumble under the acid!</span>")
	sleep(rand(150, 200))
	.()

/obj/effect/alien/acid/flamer_fire_act()
	return //this prevents any acid trickery.


/*
 * Egg
 */
/var/const //for the status var
	BURST = 0
	BURSTING = 1
	GROWING = 2
	GROWN = 3
	DESTROYED = 4

	MIN_GROWTH_TIME = 100 //time it takes for the egg to mature once planted
	MAX_GROWTH_TIME = 150

/obj/effect/alien/egg
	desc = "It looks like a weird egg"
	name = "egg"
	icon_state = "Egg Growing"
	density = 0
	anchored = 1

	health = 80
	var/list/egg_triggers = list()
	var/status = GROWING //can be GROWING, GROWN or BURST; all mutually exclusive
	var/on_fire = 0

	New()
		..()
		create_egg_triggers()
		Grow()

	Dispose()
		. = ..()
		delete_egg_triggers()

/obj/effect/alien/egg/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= rand(50, 100)
		if(2.0)
			health -= rand(40, 95)
		if(3.0)
			health -= rand(20, 81)
	healthcheck()

/obj/effect/alien/egg/attack_alien(mob/living/carbon/Xenomorph/M)

	if(!istype(M))
		return attack_hand(M)

	switch(status)
		if(BURST, DESTROYED)
			switch(M.caste)
				if("Queen","Drone","Hivelord")
					M.visible_message("<span class='xenonotice'>\The [M] clears the hatched egg.</span>", \
					"<span class='xenonotice'>You clear the hatched egg.</span>")
					M.storedplasma++
					cdel(src)
		if(GROWING)
			M << "<span class='xenowarning'>The child is not developed yet.</span>"
		if(GROWN)
			if(isXenoLarva(M))
				M << "<span class='xenowarning'>You nudge the egg, but nothing happens.</span>"
				return
			M << "<span class='xenonotice'>You retrieve the child.</span>"
			Burst(0)

/obj/effect/alien/egg/proc/Grow()
	set waitfor = 0
	sleep(rand(MIN_GROWTH_TIME,MAX_GROWTH_TIME))
	if(status == GROWING)
		icon_state = "Egg"
		status = GROWN
		deploy_egg_triggers()

/obj/effect/alien/egg/proc/create_egg_triggers()
	for(var/i=1, i<=8, i++)
		egg_triggers += new /obj/effect/egg_trigger(src, src)

/obj/effect/alien/egg/proc/deploy_egg_triggers()
	var/i = 1
	var/x_coords = list(-1,-1,-1,0,0,1,1,1)
	var/y_coords = list(1,0,-1,1,-1,1,0,-1)
	var/turf/target_turf
	for(var/atom/trigger in egg_triggers)
		var/obj/effect/egg_trigger/ET = trigger
		target_turf = locate(x+x_coords[i],y+y_coords[i], z)
		if(target_turf)
			ET.loc = target_turf
			i++

/obj/effect/alien/egg/proc/delete_egg_triggers()
	for(var/atom/trigger in egg_triggers)
		egg_triggers -= trigger
		cdel(trigger)

/obj/effect/alien/egg/proc/Burst(kill = 1) //drops and kills the hugger if any is remaining
	set waitfor = 0
	if(kill)
		if(status != DESTROYED)
			delete_egg_triggers()
			status = DESTROYED
			icon_state = "Egg Exploded"
			flick("Egg Exploding", src)
	else
		if(status == GROWN || status == GROWING)
			status = BURSTING
			delete_egg_triggers()
			icon_state = "Egg Opened"
			flick("Egg Opening", src)
			sleep(10)
			if(loc && status != DESTROYED)
				status = BURST
				var/obj/item/clothing/mask/facehugger/child = new(loc)
				child.leap_at_nearest_target()

/obj/effect/alien/egg/bullet_act(var/obj/item/projectile/P)
	..()
	if(P.ammo.flags_ammo_behavior & (AMMO_XENO_ACID|AMMO_XENO_TOX)) return
	health -= P.ammo.damage_type == BURN ? P.damage * 1.3 : P.damage
	healthcheck()
	P.ammo.on_hit_obj(src,P)
	return 1

/obj/effect/alien/egg/update_icon()
	overlays.Cut()
	if(on_fire)
		overlays += "alienegg_fire"

/obj/effect/alien/egg/fire_act()
	on_fire = 1
	if(on_fire)
		update_icon()
		spawn(rand(125, 200))
			cdel(src)

/obj/effect/alien/egg/attackby(obj/item/W, mob/user)
	if(health <= 0)
		return

	if(istype(W,/obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = W
		if(F.stat != DEAD)
			switch(status)
				if(BURST)
					if(user)
						visible_message("<span class='xenowarning'>[user] slides [F] back into [src].</span>","<span class='xenonotice'>You place the child back in to [src].</span>")
						user.temp_drop_inv_item(F)
					else
						visible_message("<span class='xenowarning'>[F] crawls back into [src]!</span>") //Not sure how, but let's roll with it for now.
					status = GROWN
					icon_state = "Egg"
					cdel(F)
				if(DESTROYED) user << "<span class='xenowarning'>This egg is no longer usable.</span>"
				if(GROWING,GROWN) user << "<span class='xenowarning'>This one is occupied with a child.</span>"
		else user << "<span class='xenowarning'>This child is dead.</span>"
		return

	if(W.attack_verb.len)
		visible_message("<span class='danger'>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]</span>")
	else
		visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")
	var/damage = W.force
	if(W.w_class < 4 || !W.sharp || W.force < 20) //only big strong sharp weapon are adequate
		damage /= 4

	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)

	health -= damage
	healthcheck()

/obj/effect/alien/egg/proc/healthcheck()
	if(health <= 0)
		Burst(1)

/obj/effect/alien/egg/HasProximity(atom/movable/AM as mob|obj)
	if(status == GROWN)
		if(!CanHug(AM) || isYautja(AM)) //Predators are too stealthy to trigger eggs to burst. Maybe the huggers are afraid of them.
			return
		Burst(0)

/obj/effect/alien/egg/flamer_fire_act() // gotta kill the egg + hugger
	Burst(1)


//The invisible traps around the egg to tell it there's a mob right next to it.
/obj/effect/egg_trigger
	name = "egg trigger"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	mouse_opacity = 0
	invisibility = INVISIBILITY_MAXIMUM
	var/obj/effect/alien/egg/linked_egg

	New(loc, obj/effect/alien/egg/source_egg)
		..()
		linked_egg = source_egg


/obj/effect/egg_trigger/Crossed(atom/A)
	if(!linked_egg) //something went very wrong
		cdel(src)
	else if(get_dist(src, linked_egg) != 1 || !isturf(linked_egg.loc)) //something went wrong
		loc = linked_egg
	else if(iscarbon(A))
		var/mob/living/carbon/C = A
		linked_egg.HasProximity(C)




/*

TUNNEL

*/


/obj/structure/tunnel
	name = "tunnel"
	desc = "A tunnel entrance. Looks like it was dug by some kind of clawed beast."
	icon = 'icons/Xeno/effects.dmi'
	icon_state = "hole"

	density = 0
	opacity = 0
	anchored = 1
	unacidable = 1
	layer = RESIN_STRUCTURE_LAYER

	var/tunnel_desc = "" //description added by the hivelord.

	var/health = 140
	var/obj/structure/tunnel/other = null
	var/id = null //For mapping

	New()
		..()
		spawn(5)
			if(id && !other)
				for(var/obj/structure/tunnel/T in structure_list)
					if(T.id == id && T != src && T.other == null) //Found a matching tunnel
						T.other = src
						other = T //Link them!
						break

/obj/structure/tunnel/Dispose()
	if(other)
		other.other = null
		other = null
	. = ..()

/obj/structure/tunnel/examine(mob/user)
	..()
	if(!isXeno(user))
		return

	if(!other)
		user << "<span class='warning'>It does not seem to lead anywhere.</span>"
	else
		var/area/A = get_area(other)
		user << "<span class='info'>It seems to lead to <b>[A.name]</b>.</span>"
		if(tunnel_desc)
			user << "<span class='info'>The Hivelord scent reads: \'[tunnel_desc]\'</span>"

/obj/structure/tunnel/proc/healthcheck()
	if(health <= 0)
		visible_message("<span class='danger'>[src] suddenly collapses!</span>")
		if(other && isturf(other.loc))
			visible_message("<span class='danger'>[other] suddenly collapses!</span>")
			cdel(other)
			other = null
		cdel(src)

/obj/structure/tunnel/bullet_act(var/obj/item/projectile/Proj)
	return 0

/obj/structure/tunnel/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= 200
		if(2.0)
			health -= 120
		if(3.0)
			if(prob(50))
				health -= 50
			else
				health -= 25
	healthcheck()

/obj/structure/tunnel/attackby(obj/item/W as obj, mob/user as mob)
	if(!isXeno(user))
		return ..()
	attack_alien(user)

/obj/structure/tunnel/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!istype(M) || M.stat || M.lying)
		return

	//Prevents using tunnels by the queen to bypass the fog.
	if(ticker && ticker.mode && ticker.mode.flags_round_type & MODE_FOG_ACTIVATED)
		if(!living_xeno_queen)
			M << "<span class='xenowarning'>There is no Queen. You must choose a queen first.</span>"
			r_FAL
		else if(isXenoQueen(M))
			M << "<span class='xenowarning'>There is no reason to leave the safety of the caves yet.</span>"
			r_FAL

	var/tunnel_time = 40

	if(M.mob_size == MOB_SIZE_BIG) //Big xenos take WAY longer
		tunnel_time = 120

	if(isXenoLarva(M)) //Larva can zip through near-instantly, they are wormlike after all
		tunnel_time = 5

	if(!other || !isturf(other.loc))
		M << "<span class='warning'>\The [src] doesn't seem to lead anywhere.</span>"
		return
	if(tunnel_time <= 50)
		M.visible_message("<span class='xenonotice'>\The [M] begins crawling down into \the [src].</span>", \
		"<span class='xenonotice'>You begin crawling down into \the [src].</span>")
	else
		M.visible_message("<span class='xenonotice'>[M] begins heaving their huge bulk down into \the [src].</span>", \
		"<span class='xenonotice'>You begin heaving your monstrous bulk into \the [src].</span>")

	if(do_after(M, tunnel_time, FALSE))
		if(other && isturf(other.loc)) //Make sure the end tunnel is still there
			M.forceMove(other.loc)
			M.visible_message("<span class='xenonotice'>\The [M] pops out of \the [src].</span>", \
			"<span class='xenonotice'>You pop out through the other side!</span>")
		else
			M << "<span class='warning'>\The [src] ended unexpectedly, so you return back up.</span>"
	else
		M << "<span class='warning'>Your crawling was interrupted!</span>"

//Alien blood effects.
/obj/effect/decal/cleanable/blood/xeno
	name = "sizzling blood"
	desc = "It's yellow and acidic. It looks like... <i>blood?</i>"
	icon = 'icons/effects/blood.dmi'
	basecolor = "#dffc00"
	amount = 0

/obj/effect/decal/cleanable/blood/gibs/xeno
	name = "steaming gibs"
	desc = "Gnarly..."
	icon_state = "xgib1"
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6")
	basecolor = "#dffc00"
	amount = 0

/obj/effect/decal/cleanable/blood/gibs/xeno/update_icon()
	color = "#FFFFFF"

/obj/effect/decal/cleanable/blood/gibs/xeno/up
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibup1","xgibup1","xgibup1")

/obj/effect/decal/cleanable/blood/gibs/xeno/down
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibdown1","xgibdown1","xgibdown1")

/obj/effect/decal/cleanable/blood/gibs/xeno/body
	random_icon_states = list("xgibhead", "xgibtorso")

/obj/effect/decal/cleanable/blood/gibs/xeno/limb
	random_icon_states = list("xgibleg", "xgibarm")

/obj/effect/decal/cleanable/blood/gibs/xeno/core
	random_icon_states = list("xgibmid1", "xgibmid2", "xgibmid3")

/obj/effect/decal/cleanable/blood/xtracks
	basecolor = "#dffc00"
