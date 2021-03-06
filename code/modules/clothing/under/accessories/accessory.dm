/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/clothing/accessories/ties/tie.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_TIE
	w_class = ITEM_SIZE_SMALL

	var/slot = ACCESSORY_SLOT_DECOR
	var/obj/item/clothing/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/list/mob_overlay = list()
	var/overlay_state = null
	var/list/on_rolled = list()	//used when jumpsuit sleevels are rolled ("rolled" entry) or it's rolled down ("down"). Set to "none" to hide in those states.
	var/high_visibility	//if it should appear on examine without detailed view
	var/slowdown //used when an accessory is meant to slow the wearer down when attached to clothing
	var/removable = TRUE

/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()

/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		if(use_single_icon)
			inv_overlay = image(icon, "inventory")
			inv_overlay.color = color
		else
			var/tmp_icon_state = overlay_state? overlay_state : icon_state
			if(icon_override && ("[tmp_icon_state]_tie" in icon_states(icon_override)))
				inv_overlay = image(icon = icon_override, icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
			else if("[tmp_icon_state]_tie" in icon_states(default_onmob_icons[slot_tie_str]))
				inv_overlay = image(icon = global.default_onmob_icons[slot_tie_str], icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
			else
				inv_overlay = image(icon = global.default_onmob_icons[slot_tie_str], icon_state = tmp_icon_state, dir = SOUTH)
	inv_overlay.color = color
	inv_overlay.appearance_flags = RESET_COLOR
	return inv_overlay

/obj/item/clothing/accessory/get_fallback_slot(var/slot)
	if(slot != BP_L_HAND && slot != BP_R_HAND)
		return slot_tie_str

/obj/item/clothing/accessory/get_mob_overlay(mob/user_mob, slot, bodypart)
	if(!istype(loc,/obj/item/clothing) || use_single_icon)	//don't need special handling if it's worn as normal item.
		return ..()
	var/bodytype = BODYTYPE_HUMANOID
	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		if(user_human.species.get_bodytype(user_human) in sprite_sheets)
			bodytype = user_human.species.get_bodytype(user_human)

		var/tmp_icon_state = overlay_state? overlay_state : icon_state

		if(istype(loc,/obj/item/clothing/under))
			var/obj/item/clothing/under/C = loc
			if(on_rolled["down"] && C.rolled_down > 0)
				tmp_icon_state = on_rolled["down"]
			else if(on_rolled["rolled"] && C.rolled_sleeves > 0)
				tmp_icon_state = on_rolled["rolled"]

		var/do_species_offset = (lowertext(bodytype) != lowertext(user_human.species.get_bodytype(user_human)))
		var/use_sprite_sheet = FALSE
		if(sprite_sheets[bodytype])
			use_sprite_sheet = sprite_sheets[bodytype]


		if(icon_override && ("[tmp_icon_state]_mob" in icon_states(icon_override)))
			return overlay_image(icon_override, "[tmp_icon_state]_mob", color, RESET_COLOR)
		else if(do_species_offset)
			user_human.species.get_offset_overlay_image(FALSE, use_sprite_sheet, tmp_icon_state, color, bodypart || slot)
		else
			return overlay_image(use_sprite_sheet, tmp_icon_state, color, RESET_COLOR)

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	forceMove(has_suit)
	has_suit.overlays += get_inv_overlay()

	if(user)
		to_chat(user, "<span class='notice'>You attach \the [src] to \the [has_suit].</span>")
		src.add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!has_suit)
		return
	has_suit.overlays -= get_inv_overlay()
	has_suit = null
	if(user)
		usr.put_in_hands(src)
		src.add_fingerprint(user)
	else
		dropInto(loc)

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

/obj/item/clothing/accessory/get_pressure_weakness(pressure,zone)
	if(body_parts_covered & zone)
		return ..()
	return 1

//Necklaces
/obj/item/clothing/accessory/necklace
	name = "necklace"
	desc = "A simple necklace."
	icon = 'icons/clothing/accessories/jewelry/necklace.dmi'
	slot_flags = SLOT_FACE | SLOT_TIE

//Misc
/obj/item/clothing/accessory/kneepads
	name = "kneepads"
	desc = "A pair of synthetic kneepads. Doesn't provide protection from more than arthritis."
	icon = 'icons/clothing/accessories/armor/kneepads.dmi'

//Scarves
/obj/item/clothing/accessory/scarf
	name = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon = 'icons/clothing/accessories/clothing/scarf.dmi'

//Bracelets
/obj/item/clothing/accessory/bracelet
	name = "bracelet"
	desc = "A simple bracelet with a clasp."
	icon = 'icons/clothing/accessories/jewelry/bracelet.dmi'

/obj/item/clothing/accessory/ftupin
	name = "\improper Free Trade Union pin"
	desc = "A pin denoting employment in the Free Trade Union, a trading company."
	icon = 'icons/clothing/accessories/jewelry/ftupin.dmi'
	high_visibility = 1
