// NOTE: THIS MUST BE THE ROOT PRIM
// owner key & channel communication between objects
key owner;
integer BUMPER_HUD_CHANNEL = -8082;

// obj state properties
integer isOn;
string BTN_NAME = "OFF";

// obj texture state properties
key texture = "69f16fbb-78f4-f7dd-0ff6-0bd8079ef5c7";
float xOffsetVal;
float yOffsetVal;
integer PRIM_FACE = 1;

turnOffBumper()
{
    // this msg will be broadcasted to other btns
    // to turn themselves off except this btn due to
    // LINK_ALL_OTHERS param
    llMessageLinked(LINK_ALL_OTHERS, 0, "000", "000");
                
    // this message will turn the bumper obj on or off
    // and activate the necessary assets for this btn 
    llRegionSay(BUMPER_HUD_CHANNEL, "OFF");

                
    // change texture offset value on designated prim face
    xOffsetVal = -0.250;
    llOffsetTexture(xOffsetVal, 0.0, PRIM_FACE);
    isOn = TRUE; // this means that the button is active
}

default
{
    
    state_entry()
    {
        // initialize default values 
        owner = llGetOwner();

        yOffsetVal = 0.0;
        xOffsetVal = -0.250;
        llSetTexture(texture, PRIM_FACE);
    }

    attach(key id)
    {
        if (id)     // is a valid key and not NULL_KEY
        {
            turnOffBumper();
        }
    }
    
    touch(integer num)
    {
             // turn on this btn
            if(!isOn)
            {
                turnOffBumper();
            }
    }
    
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(id == "000" && msg == "000")
        {
             // turn off this btn
             // llRegionSay(BUMPER_HUD_CHANNEL, BTN_NAME  + "_OFF");
             xOffsetVal = 0.250;
             llOffsetTexture(xOffsetVal, 0.0, PRIM_FACE);
             isOn = FALSE;
        } 
    }
}
