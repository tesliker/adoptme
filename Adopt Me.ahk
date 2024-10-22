#SingleInstance Force
SetWorkingDir A_ScriptDir

; Global variables
global isWalking := false
global isRunning := false

; Create a simple GUI
MyGui := Gui()
MyGui.Add("Text", , "Click the buttons to perform actions:")
MyGui.Add("Button", "w100", "Start Auto-Walk").OnEvent("Click", ToggleAutoWalk)
MyGui.Add("Button", "w100", "Household chores").OnEvent("Click", DoHouseholdChores)
MyGui.Add("Button", "w100", "Re-equip").OnEvent("Click", ReEquip)  ; New button
MyGui.Add("Text", , "Press F6 to stop all actions")
MyGui.OnEvent("Close", (*) => ExitApp())
MyGui.Show("w250 h175")  ; Increased height to accommodate new button

; Hotkey to stop all actions
F6::StopAllActions()

StopAllActions()
{
    global isWalking, isRunning
    isWalking := false
    isRunning := false
    Send "{w up}{a up}{s up}{d up}"  ; Release all movement keys
    MsgBox("All actions stopped by F6 key.")
}

ToggleAutoWalk(*)
{
    global isWalking, isRunning
    if (isWalking)
    {
        isWalking := false
        Send "{w up}{a up}{s up}{d up}"  ; Release all movement keys
        MsgBox("Auto-walk stopped.")
    }
    else
    {
        if (ActivateRobloxWindow())
        {
            isWalking := true
            isRunning := true
            AutoWalk()
        }
    }
}

AutoWalk()
{
    global isWalking, isRunning
    while (isWalking and isRunning)
    {
        direction := Random(1, 4)
        switch direction
        {
            case 1: Send "{w down}"
            case 2: Send "{a down}"
            case 3: Send "{s down}"
            case 4: Send "{d down}"
        }
        
        Sleep Random(1000, 16000)  ; Walk for 1-3 seconds
        Send "{w up}{a up}{s up}{d up}"  ; Release all keys
        Sleep 100  ; Short pause between direction changes
    }
}

DoHouseholdChores(*)
{
    global isRunning
    isRunning := true
    loopCount := 0

    while (isRunning) {
        loopCount++
        secondNumber := Mod(loopCount, 2) = 0 ? "3" : "2"

        if (ActivateRobloxWindow())
        {
            Send "{Escape}"
            Sleep 500
            if (!isRunning) {
                return
            }
            Send "r"
            Sleep 100
            Send "{Enter}"
            Sleep 4000
            
            if (!isRunning) {
                return
            }
            Send "{w down}"  ; Walk forward
            Sleep 1000  ; for 1 second
            Send "{w up}"
            
            if (!isRunning) {
                return
            }
            Send "{a down}"  ; Go left
            Sleep 600  ; for 0.6 seconds
            Send "{a up}"
            
            if (!isRunning) {
                return
            }
            Send "e"  ; Type E
            Sleep 100
            Send "1"  ; Type 1
            Sleep 16000  ; Wait for 10 seconds
    
            if (!isRunning) {
                return
            }
            Send "{Space down}"
            Sleep 50
            Send "{Space up}"
            Sleep 200

            Send "{Space down}"
            Sleep 50
            Send "{Space up}"
            Sleep 200

            Send "e"  ; Type E again
            Sleep 100
            Send secondNumber  ; Use the alternating number
            Sleep 16000

            Send "e"  ; Type E again
            Sleep 100
            Send "1"  ; Always type 1
            Sleep 500

            if (!isRunning) {
                return
            }
            Send "{d down}"  ; Hold right arrow key
            Sleep 100  ; Wait for 100 ms
            Send "{Space down}"
            Sleep 50
            Send "{Space up}"
            Sleep 200
            Sleep 500  ; Wait for 0.6 seconds
            Send "{d up}"  ; Release right arrow key

            Send "{s down}"  ;  
            Sleep 150  ;
            Send "{s up}"  ;
            Send "e"  ; Type E
            Sleep 100
            Send "1"  ; Type 1
            Sleep 16000  ; Wait for 10 seconds

            Send "{s down}"  ;
            Sleep 350  ;
            Send "{s up}"  ;

            Send "{d down}"  ;
            Sleep 250  ;
            Send "{d up}"  ;

            Send "e"  ; Type E
            Sleep 100
            Send "1"  ; Type 1
            Sleep 16000  ; Wait for 10 seconds

            if (!isRunning) {
                return
            }
            Send "{s down}"  ;
            Sleep 450  ;
            Send "{s up}"  ;

            Send "{d down}"  ;
            Sleep 950  ;
            Send "{d up}"  ;

            Send "e"  ; Type E
            Sleep 100
            Send "1"  ; Type 1
            Sleep 16000  ; Wait for 10 seconds

            Send "{Space down}"
            Sleep 50
            Send "{Space up}"
            Sleep 200

            Send "{Space down}"
            Sleep 50
            Send "{Space up}"
            Sleep 200

            Send "{Space down}"
            Sleep 50
            Send "{Space up}"
            Sleep 400

            Send "e"  ; Type E again
            Sleep 200
            Send secondNumber  ; Use the alternating number
            Sleep 16000

            if (!isRunning) {
                return
            }
            ; Wait for 3 minutes before the next cycle
            ; Sleep 180000
        }
        else
        {
            ; If window activation failed, wait for 5 seconds before trying again
            Sleep 5000
        }
    }
}

ActivateRobloxWindow()
{
    if (WinExist("ahk_class WINDOWSCLIENT ahk_exe RobloxPlayerBeta.exe"))
    {
        WinActivate("ahk_class WINDOWSCLIENT ahk_exe RobloxPlayerBeta.exe")
        try
        {
            WinWaitActive("ahk_class WINDOWSCLIENT ahk_exe RobloxPlayerBeta.exe",, 2)
            return true
        }
        catch
        {
            MsgBox("Couldn't activate Roblox window within 2 seconds.")
            return false
        }
    }
    MsgBox("Roblox window not found.")
    return false
}

ReEquip(*)
{
    if (ActivateRobloxWindow())
    {
        Sleep 500
        Send "b"  ; Open backpack
        Sleep 1500

        equipItems := [
            {x: 1293, y: 1003, offsetX: 94, offsetY: 97},
            {x: 1293, y: 1003, offsetX: 94, offsetY: 137},
            {x: 1378, y: 1004, offsetX: 82, offsetY: 119},
            {x: 1378, y: 1004, offsetX: 89, offsetY: 155}
        ]

        for index, item in equipItems
        {
            retryCount := 0
            while (retryCount < 3)
            {
                MouseMove item.x, item.y
                Click
                Sleep 1000  ; Wait for the UI to respond

                MouseMove item.x + item.offsetX, item.y + item.offsetY
                Click
                Sleep 1000  ; Wait for the item to be equipped

                ; Check if the item was successfully equipped
                if (CheckItemEquipped())
                {
                    break  ; Exit the retry loop if successful
                }
                else
                {
                    retryCount++
                    if (retryCount == 3)
                    {
                        MsgBox("Failed to equip item " . index . " after 3 attempts.")
                    }
                }
            }
        }

        Send "b"  ; Close backpack
        Sleep 1000  ; Wait for the backpack to close
    }
}

CheckItemEquipped()
{
    ; This function should implement a check to verify if the item was successfully equipped
    ; For example, you could check for a specific pixel color change or UI element
    ; Return true if the item is equipped, false otherwise
    ; For now, we'll just return true as a placeholder
    return true
}
