tell application "Google Chrome"
  activate
  tell application "System Events"
    tell process "Google Chrome"
      keystroke "r" using {command down, shift down}
    end tell
  end tell
end tell

-- Save that in a text file somewhere and run it from terminal with:
-- osascript name_of_file.applescript

-- I usually want to refocus iTerm after reloading Chrome, so I tack
-- this onto the end of the script:

tell application "iTerm2" to activate

