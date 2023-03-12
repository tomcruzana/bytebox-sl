key owner;
key gSfx;
string gAnim;
integer isTyping = FALSE;
float VOLUME = 1.0;

toggleTexture(float opacity){
    llSetLinkAlpha(LINK_SET, opacity, ALL_SIDES);
}

default
{
    state_entry()
    {
        // get owner
        owner = llGetOwner();

        // init fxs
        gAnim = "";
        gSfx = "";

        // request anim perms
        if(llGetAttached() != 0){
            llRequestPermissions(owner, PERMISSION_TRIGGER_ANIMATION);
        }

        // hide object
        toggleTexture(0.0);
    }
    
    attach(key id)
    {
        if(id == llGetOwner())
            llResetScript();
        else{
            llStopAnimation(gAnim);
            llStopSound();
        }
    }
    
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
            llResetScript();
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
            llSetTimerEvent(0.25);
    }
    
    timer()
    {
        // checks if agent is the owner and typing 
        if(llGetAgentInfo(owner) & AGENT_TYPING)
        {
            // show object 
            toggleTexture(1.0);
            
            if(isTyping){
                // TODO
                // change to variables holding sounds
                llLoopSound(gSfx, VOLUME);
            }else{
                isTyping = TRUE;
                llTriggerSound(gSfx, VOLUME);
                llStartAnimation(gAnim);
            }
        }else if(isTyping){
            isTyping = FALSE;
            llStopSound();
            llStopAnimation(gAnim);
            llTriggerSound("ending", VOLUME);
            
            /* hide guitar */
            toggleTexture(0.0);
        }
    }
}