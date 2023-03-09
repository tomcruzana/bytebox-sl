// owner key & channel communication between objects
key owner;
integer BUMPER_HUD_CHANNEL = -8082;

// obj state properties
integer isOn;
string BTN_NAME = "FIREBALL";

// obj texture state properties
key texture = "c3e61fb2-18ff-32dc-92f9-734a301357cb";
float xOffsetVal;
float yOffsetVal;
integer PRIM_FACE = 1;

default
{
    
    state_entry()
    {
        // initialize default values 
        owner = llGetOwner();
        isOn = FALSE;
        yOffsetVal = 0.0;
        xOffsetVal = -0.250;
        llSetTexture(texture, PRIM_FACE);
    }
    
    touch(integer num)
    {
             // turn on this btn
            if(!isOn)
            {
                // this msg will be broadcasted to other btns
                // to turn themselves off except this btn due to
                // LINK_ALL_OTHERS param
                llMessageLinked(LINK_ALL_OTHERS, 0, "000", "000");
                
                // this message will turn the bumper obj on or off
                // and activate the necessary assets for this btn 
                llRegionSay(BUMPER_HUD_CHANNEL, BTN_NAME  + "_ON");
                
                // change texture offset value on designated prim face
                xOffsetVal = -0.250;
                llOffsetTexture(xOffsetVal, 0.0, PRIM_FACE);
                isOn = TRUE;
            }
    }
    
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(id == "000" && msg == "000")
        {
             // turn off this btn
             xOffsetVal = 0.250;
             llOffsetTexture(xOffsetVal, 0.0, PRIM_FACE);
             isOn = FALSE;
        } 
    }
}
