// Shared scripts
#include scripts\shared\flag_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\trigger_shared;

// ZM scripts
#include scripts\zm\_zm_utility;

init()
{
}

on_player_connect()
{
    // 1 = Activate splits for each map - 0 = Activate splits only on map completion
    level.splits_enabled = 1;
}

on_player_spawned()
{
    // Start splits
    self thread start_splits();
}

start_splits()
{
    level endon("end_game");

    // Check for fade in to split
    self start_on_fade_in();
    switch(level.script)
    {
        case "zm_zod":
            self zod_egg_splits();
            break;
        case "zm_factory":
            self factory_egg_splits();
            break;
        case "zm_castle":
            self castle_egg_splits();
            break;
        case "zm_island":
            self island_egg_splits();
            break;
        case "zm_stalingrad":
            self stalingrad_egg_splits();
            break;
        case "zm_genesis":
            self genesis_egg_splits();
            break;
    }
}

start_on_fade_in()
{
    level endon("end_game");

    // Wait until rounds have started, then wait accordingly for when fade in starts and split
    level flag::wait_till("start_zombie_round_logic");
    wait 2.15;
    switch(level.script)
    {
        case "zm_zod":
            compiler::livesplit("start");
            break;
        case "zm_factory":
            if(GetTime() < 20000) compiler::livesplit("resume");
            break;
        case "zm_castle":
            if(GetTime() < 20000) compiler::livesplit("resume");
            break;
        case "zm_island":
            if(GetTime() < 20000) compiler::livesplit("resume");
            break;
        case "zm_stalingrad":
            if(GetTime() < 20000) compiler::livesplit("resume");
            break;
        case "zm_genesis":
            if(GetTime() < 20000) compiler::livesplit("resume");
            break;
    }
}

zod_egg_splits()
{
    level endon("end_game");

    if(level.splits_enabled)
    {
        // Check if the player has the sword, then notify detour to check for player passing through a portal
        level.look_for_sword = false;
        while(!self HasWeapon(level.var_15954023.weapons[self.characterindex][1])) wait 0.05;
        level.look_for_sword = true;

        // Check for each ovum to be activated and then finished. On the final ovum, don't wait to clear because we split when it's activated
        max = level.activePlayers.size * 4;
        for(i = 0; i < max; i++)
        {
            level flag::wait_till("magic_circle_in_progress");
            if(i < max - level.activePlayers.size) level flag::wait_till_clear("magic_circle_in_progress");
            else 
            {
                compiler::livesplit("split");
                break;
            }
        }

        // Check if the totem is in state 2, which means it's been picked up. Then wait for round flip and start again - split 1st, 2nd, and 4th flag
        while(level clientfield::get("ee_totem_state") != 2) wait 0.05;
        compiler::livesplit("split");
        level waittill("end_of_round");
        while(level clientfield::get("ee_totem_state") != 2) wait 0.05;
        compiler::livesplit("split");
        level waittill("end_of_round");
        level waittill("end_of_round");
        while(level clientfield::get("ee_totem_state") != 2) wait 0.05;
        compiler::livesplit("split");
    }

    // Wait for the shadowman to be defeated
    level flag::wait_till("ee_boss_defeated");
    compiler::livesplit("split");
    compiler::livesplit("pause");

    // If 4 players are in the game, wait for the egg to be complete
    if(level.activePlayers.size == 4)
    {
        level flag::wait_till("ee_complete");
        compiler::livesplit("split");
        compiler::livesplit("pause");
    }
}

factory_egg_splits()
{
    level endon("end_game");

    // Wait until egg is completed then split
    player = trigger::wait_till("flytrap_prize");
    compiler::livesplit("split");
    compiler::livesplit("pause");
}

castle_egg_splits()
{
    level endon("end_game");

    if(level.splits_enabled)
    {
        // Wait until the dragons are filled and then check to see if anyone has picked up the bow. Split if anyone has the bow.
        level flag::wait_till("soul_catchers_charged");
        break_loop = false;
        for(;;)
        {
            foreach(player in level.players)
            {
                if(player HasWeapon(GetWeapon("elemental_bow")))
                {
                    compiler::livesplit("split");
                    break_loop = true;
                }
            }
            if(break_loop) break;
            wait 0.05;
        }

        // Wait until round 6 round end to split
        while(level.round_number < 6) wait 0.05;
        level waittill("end_of_round");
        compiler::livesplit("split");

        // Monitor both teleporters to see if they are activated, and when they are, check if wisps are finished. Split if teleporter is activated and wisps are finished
        teleporters = GetEntArray("trigger_teleport_pad", "targetname");
        foreach(teleporter in teleporters) teleporter thread monitor_teleport_split();

        // Wait for boss fight to begin then split
        level flag::wait_till("boss_fight_begin");
        wait 1;
        compiler::livesplit("split");
    }

    // Wait for outro to start playing then split
    level flag::wait_till("ee_outro");
    compiler::livesplit("split");
    compiler::livesplit("pause");
}

monitor_teleport_split()
{
    for(;;)
    {
        // Wait for teleporter to be triggered, then check the according flags to see if wisps are finished
        self waittill("trigger", e_player);
        if(zm_utility::is_player_valid(e_player) && !level.is_cooldown && !level flag::get("rocket_firing") && level flag::get("time_travel_teleporter_ready"))
        {
            compiler::livesplit("split");
            break;
        }
    }
}

island_egg_splits()
{
    level endon("end_game");

    if(level.splits_enabled)
    {
        // Wait for power to turn on then split
        level flag::wait_till("power_on");
        compiler::livesplit("split");

        // Wait for any player to obtain the skull then split
        break_loop = false;
        for(;;)
        {
            foreach(player in level.players)
            {
                if(player HasWeapon(level.var_c003f5b))
                {
                    compiler::livesplit("split");
                    break_loop = true;
                }
            }
            if(break_loop) break;
            wait 0.05;
        }

        // Wait for any player to obtain the kt4 then split
        break_loop = false;
        for(;;)
        {
            foreach(player in level.players)
            {
                if(player HasWeapon(level.var_5e75629a))
                {
                    compiler::livesplit("split");
                    break_loop = true;
                }
            }
            if(break_loop) break;
            wait 0.05;
        }
    }

    // Wait for ending cutscene to play then split
    level flag::wait_till("flag_play_outro_cutscene");
    compiler::livesplit("split");
    compiler::livesplit("pause");


}

stalingrad_egg_splits()
{
    level endon("end_game");

    if(level.splits_enabled)
    {
        // Wait for dragon to timeout or be full, then wait 2 seconds because there's a slight delay for the dragon to fly
        level flag::wait_till_any(array("dragon_rider_timeout", "dragon_full"));
        wait 2;
        compiler::livesplit("split");

        // Wait for dragon to be finished then look for the next fly
        level flag::wait_till_clear_all(array("dragon_platform_arrive", "dragon_platform_one_rider"));
        level flag::wait_till_clear("dragon_console_global_disable");

        // Wait for dragon to timeout or be full, then wait 2 seconds because there's a slight delay for the dragon to fly - again
        level flag::wait_till_any(array("dragon_rider_timeout", "dragon_full"));
        wait 2;
        compiler::livesplit("split");

        // Wait for dragon egg incubation
        level flag::wait_till("egg_placed_incubator");
        compiler::livesplit("split");

        // Wait for challenges to start
        level flag::wait_till("keys_placed");
        compiler::livesplit("split");

        // Wait for final download to start
        level flag::wait_till("lockdown_active");
        compiler::livesplit("split");

        // Wait for player to start boss
        sewer = GetEnt("ee_sewer_to_arena_trig", "targetname");
        sewer waittill("trigger", e_who);
        compiler::livesplit("split");
    }
}

genesis_egg_splits()
{
    level endon("end_game");

    if(level.splits_enabled)
    {
        // Wait for second reel to be placed
        level flag::wait_till("placed_audio2");
        compiler::livesplit("split");

        // Wait for player to be teleported into sam's room
        level flag::wait_till("sophia_at_teleporter");
        wait 3.25;
        compiler::livesplit("split");

        // Wait for player to be teleported into 1st boss arena
        level flag::wait_till("arena_occupied_by_player");
        compiler::livesplit("split");

        // Wait for play to pickup key after 1st boss
        break_loop = false;
        level flag::wait_till("grand_tour");
        for(;;)
        {
            foreach(player in level.players)
            {
                if(player HasWeapon(level.ballWeapon))
                {
                    compiler::livesplit("split");
                    break_loop = true;
                }
            }
            if(break_loop) break;
            wait 0.05;
        }

        // Wait for play to be teleported into 2nd boss arena
        level flag::wait_till("boss_fight");
        compiler::livesplit("split");
    }

}
