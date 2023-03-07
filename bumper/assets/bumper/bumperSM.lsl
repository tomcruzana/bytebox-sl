integer isBumperON;
key owner;

integer listener;
integer BUMPER_HUD_CHANNEL = -8082;

string gAnim = "toinkAnim";
key gGfx = "364a4655-22d7-ee0e-5e53-22f8fb9c20be";
key gSfx = "fe5a320a-f9e4-1542-15bd-e4ec7ad36003";

// ["random", "shell", "breakBlock", "1Up", "coin", "fireBall", "stomp"]
list gSfxList = ["random", "shell", "breakBlock", "1Up", "coin", "fireBall", "stomp"];

stopBumper()
{
    llSetTimerEvent(0.0);
    //llStopSound();
    llStopAnimation(gAnim);    
}

randomize()
{
    // generate random nums between 1 to 6
    // this function is used to pick which sfx/anims to play
    integer gSfxListLen = llGetListLength(gSfxList);
    integer gSfxIndex = llFloor(llFrand(gSfxListLen - 1)) + 1;
    
    // llOwnerSay("LOG: " + (string) gSfxIndex + " " + llList2String(gSfxList, gSfxIndex));
    
    if(gSfxIndex == 1)
    {
        // load shell assets
        gGfx = "364a4655-22d7-ee0e-5e53-22f8fb9c20be";
        gSfx = "fe5a320a-f9e4-1542-15bd-e4ec7ad36003";
        
    }
    else if(gSfxIndex == 2)
    {
        // load breakBox assets
        gGfx = "98b48f46-b7da-041d-f522-01a020de5c2e";
        gSfx = "3eaacd94-2e16-39a9-cfad-ea1a38eb7da4";
        
    }
    else if(gSfxIndex == 3)
    {
        // load 1Up assets
        gGfx = "122f3fc2-41ba-c451-6084-9581c961bf89";
        gSfx = "08fad956-4089-b18c-225b-6c21d9166abc";
        
    }
    else if(gSfxIndex == 4)
    {
        // load coin assets
        gGfx = "5bb6e948-f93d-e081-6a2a-8c80dfee2f43";
        gSfx = "9ab79f23-06eb-28c6-0b06-2a16e4948fe5";
        
    }
    else if(gSfxIndex == 5)
    {
        // load fireBall assets
        gGfx = "e70b8c0d-79c7-87ea-4cca-016ea058efd3";
        gSfx = "6a42027f-05ea-547c-973f-a8b659b5f5e0";
        
    }
    else if(gSfxIndex == 6)
    {
        // load stomp assets
        gGfx = "5ffcd671-09e0-879e-655c-af7901f2a4ab";
        gSfx = "84747338-aa80-2fec-5da6-666896ab709a"; 
    }
}

emitParticle()
{
    //  PSYS_SRC_TEXTURE, "364a4655-22d7-ee0e-5e53-22f8fb9c20be",
            llParticleSystem([PSYS_PART_MAX_AGE,0.37,
            PSYS_PART_FLAGS, 295,
            PSYS_PART_START_COLOR, <0.96, 0.96, 0.96>,
            PSYS_PART_END_COLOR, <1.00, 1.00, 1.00>,
            PSYS_PART_START_SCALE,<0.98, 0.98, 0.00>,
            PSYS_PART_END_SCALE,<0.00, 0.00, 0.00>,
            PSYS_SRC_PATTERN, 2,
            PSYS_SRC_BURST_RATE,0.74,
            PSYS_SRC_BURST_PART_COUNT,7,
            PSYS_SRC_BURST_RADIUS,0.50,
            PSYS_SRC_BURST_SPEED_MIN,4.00,
            PSYS_SRC_BURST_SPEED_MAX,0.87,
            PSYS_SRC_ANGLE_BEGIN, 0.00,
            PSYS_SRC_ANGLE_END, 0.20,
            PSYS_SRC_MAX_AGE, 0.0,
            PSYS_SRC_TEXTURE, gGfx,
            PSYS_PART_START_ALPHA, 0.52,
            PSYS_PART_END_ALPHA, 0.94,
            PSYS_SRC_ACCEL, <-0.03, -0.05, 0.29>,
            PSYS_SRC_OMEGA, <0.03, -0.09, -50.00>]);
}

default
{
    
    state_entry()
    {
        llOwnerSay("INITIALIZING... PLEASE WAIT.");
        isBumperON = TRUE;
        owner = llGetOwner();
        listener = llListen(BUMPER_HUD_CHANNEL, "", "", "");
        llOwnerSay("LOG: BUMPER OBJECT READY.");
    }
    
    // attach & detach events
    attach(key id)
    {
        // kill listener if detached
        if(id)
        {
            llOwnerSay("LOG: BUMPER ATTACHED SUCCESSFULLY.");
        }
        if(id == NULL_KEY)
        {
            llOwnerSay("LOG: BUMPER DETACHED SUCCESSFULLY.");
        }
    }
    
    // turn on or off bumber
    listen( integer channel, string name, key id, string message )
    {
        
        // listen from the switcher
        if(channel == BUMPER_HUD_CHANNEL && message == "ON")
        {
            // flag on
            isBumperON = TRUE;
            llOwnerSay("BUMPER ON");
        }
        else if(channel == BUMPER_HUD_CHANNEL && message == "OFF")
        {
            // flag off
            isBumperON = FALSE;
            llOwnerSay("BUMPER OFF");
        }
    }

    collision_start(integer num_detected)
    {
        // TODO: add options here1
        randomize();
        
        if(isBumperON)
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
             // play bumper effects
             llPlaySound(gSfx, 1.0);
             llStartAnimation(gAnim);
             emitParticle();
             llSetTimerEvent(0.5);
        }
    }
    
    timer()
    {
        // stop bumper effects
        stopBumper();
        llParticleSystem([]);
    }
   
    changed(integer change)
    {
        if(change & (CHANGED_OWNER | CHANGED_INVENTORY))
        llResetScript();
    }
}