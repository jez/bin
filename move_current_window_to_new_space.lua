window = hs.window.focusedWindow()
screen = window:screen()
hs.spaces.addSpaceToScreen(screen, False)
allSpaces = hs.spaces.allSpaces()
spacesOnScreen = allSpaces[screen:getUUID()]
newSpace = spacesOnScreen[#(spacesOnScreen)]
hs.spaces.moveWindowToSpace(window, newSpace)
