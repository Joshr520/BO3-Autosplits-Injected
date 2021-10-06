#include scripts\shared\fx_shared;
#include scripts\shared\util_shared;
#include scripts\shared\scene_shared;

detour sys::playlocalsound(sound_name)
{
    switch(level.script)
    {
        case "zm_zod":
        {
            // Wait for player to first enter the rift and when leaving after sword pickup
            if(sound_name == "zmb_teleporter_teleport_2d")
            {
                if(!isdefined(level.portal_split)) level.portal_split = 0;
                if(level.portal_split == 0) compiler::livesplit("split");
                else if(level.look_for_sword)
                {
                    level.look_for_sword = false;
                    compiler::livesplit("split");
                }
                level.portal_split++;
            }
            break;
        }
    }
    self playLocalSound(sound_name);
}

detour sys::playsound(sound_name)
{
	switch(level.script)
    {
        case "zm_zod":
        {
            // Wait for player to pickup the final egg
            if(sound_name == "zmb_zod_egg_pickup")
            {
                if(!isdefined(level.num_eggs_done)) level.num_eggs_done = -1;
                level.num_eggs_done++;
                if(level.num_eggs_done == 4) compiler::livesplit("split");
            }
            break;
        }
        case "zm_island":
        {
            // Wait for player to fix the elevator
            if(sound_name == "zmb_elevator_fix") compiler::livesplit("split");
            break;
        }
    }
    self playSound(sound_name);
}

detour scene<scripts\shared\scene_shared.gsc>::play(arg1, arg2, arg3, b_test_run = false, str_state, str_mode = "")
{
    switch(level.script)
    {
        case "zm_stalingrad":
        {
            // Wait for outro of egg to be played
            if(arg1 == "cin_sta_outro_3rd_sh020") compiler::livesplit("split");
            break;
        }
        case "zm_island":
        {
            // Wait for bunker door to open
            if(arg1 == "p7_fxanim_zm_island_bunker_door_main_bundle") compiler::livesplit("split");
            break;
        }
        case "zm_genesis":
        {
            // Wait for keeper to start ritual
            if(arg1 == "cin_zm_dlc4_keeper_prtctr_ee_idle") compiler::livesplit("split");
            // Wait for outro of egg to play
            else if(arg1 == "genesis_ee_sams_room") thread split_on_delay(0.6);
            break;
        }
    }

    scene::Play(arg1, arg2, arg3, b_test_run, str_state, str_mode);
}

detour fx<scripts\shared\fx_shared.gsc>::play(str_fx, v_origin = (0, 0, 0), v_angles = (0, 0, 0), time_to_delete_or_notify, b_link_to_self = false, str_tag, b_no_cull, b_ignore_pause_world)
{
    switch(level.script)
    {
        case "zm_castle":
        {
            // Wait for keeper key to be placed
            if(str_fx == "keeper_summon") compiler::livesplit("split");
            break;
        }
    }
    // FX::Play code implemented directly because it CIs otherwise for some reason
    self notify(str_fx);
	
	if((!isdefined(time_to_delete_or_notify) || (!IsString(time_to_delete_or_notify) && time_to_delete_or_notify == -1)) && (isdefined(b_link_to_self) && b_link_to_self) && isdefined(str_tag))
	{
		PlayFXOnTag(FX::get(str_fx), self, str_tag, b_ignore_pause_world);
		return self;
	}
	else
	{
		if(isdefined(time_to_delete_or_notify))
		{
			m_fx = util::spawn_model("tag_origin", v_origin, v_angles);
			
			if(isdefined(b_link_to_Self) && b_link_to_self)
			{
				if(isdefined(str_tag))
				{
					m_fx LinkTo(self, str_tag, (0, 0, 0), (0, 0, 0));
				}
				else
				{
					m_fx LinkTo(self);
				}
			}
			
			if(isdefined(b_no_cull) && b_no_cull)
			{
				m_fx SetForceNoCull();
			}
			
			PlayFXOnTag(FX::get(str_fx), m_fx, "tag_origin", b_ignore_pause_world);
			m_fx thread FX::_play_fx_delete(self, time_to_delete_or_notify);
			return m_fx;
		}
		else
		{
			PlayFX(FX::get(str_fx ), v_origin, AnglesToForward(v_angles), AnglesToUp(v_angles), b_ignore_pause_world);
		}
	}
}

split_on_delay(delay)
{
    wait delay;
    compiler::livesplit("split");
}