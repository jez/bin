window = hs.window.focusedWindow()
screen = window:screen()
allSpaces = hs.spaces.allSpaces()
spacesOnScreen = allSpaces[screen:getUUID()]
lastSpace = spacesOnScreen[#(spacesOnScreen)]
hs.spaces.moveWindowToSpace(window, lastSpace)
hs.spaces.gotoSpace(lastSpace)
