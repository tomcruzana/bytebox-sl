key owner;
integer BUMPER_HUD_CHANNEL = -8082;
integer isOn;
string onSwitchTx = "b991c0ea-8c81-6346-2f63-68dc77cd48e3";
string offSwitchTx = "8e251e6e-c43e-ab02-d583-ecb9f5c4b809";

default
{
    
    state_entry()
    {
        owner = llGetOwner();
        
        isOn = TRUE;
        
        llSetTexture(onSwitchTx, ALL_SIDES);
        
        llOwnerSay("LOG: BUMPER HUD READY.");
    }
    
    touch(integer num)
    {
        // toggle HUD on or off
            if(isOn)
            {
                llRegionSay(BUMPER_HUD_CHANNEL, "OFF");
                isOn = FALSE;
                llSetTexture(offSwitchTx, ALL_SIDES);
            }
            else
            {
                llRegionSay(BUMPER_HUD_CHANNEL, "ON");
                isOn = TRUE;
                llSetTexture(onSwitchTx, ALL_SIDES);
            }
    } 
}
