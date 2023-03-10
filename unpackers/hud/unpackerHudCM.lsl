// change the value to your product's name
string productName = "Unpacker";
string POST_TEXT = " HUD (ADD)";

default
{
    
    state_entry()
    {
        llSetObjectName(productName + POST_TEXT);
    }
    
    touch_start(integer num_detected)
    {
        string thisScript = llGetScriptName();
        list inventoryItems;
        integer inventoryNumber = llGetInventoryNumber(INVENTORY_ALL);

        integer index;
        for ( ; index < inventoryNumber; ++index )
        {
            string itemName = llGetInventoryName(INVENTORY_ALL, index);

            if (itemName != thisScript)
            {
                if (llGetInventoryPermMask(itemName, MASK_OWNER) & PERM_COPY)
                {
                    inventoryItems += itemName;
                }
                else
                {
                    llSay(0, "Unable to copy the item named '" + itemName + "'.");
                }
            }
        }

        if (inventoryItems == [] )
        {
            llSay(0, "No copiable items found, sorry.");
        }
        else
        {
            llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventoryItems);    // 3.0 seconds delay
        }
    }
}