state("blackops3")
{
    byte round_counter : 0xA55DDEC;
    byte is_paused : 0x3480E08; // No clue if this is actually the pause variable, but it seems to work as if it is
}

startup
{
    refreshRate = 100;
}

isLoading
{
    if(current.is_paused == 1) return true;
    return false;
}