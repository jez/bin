#!/usr/bin/env bash

# https://www.rightpoint.com/rplabs/script-keyboard-os-x-shortcuts

addCustomMenuEntryIfNeeded() {
    if [[ $# == 0 || $# -gt 1 ]]; then
        echo "usage: addCustomMenuEntryIfNeeded com.company.appname"
        return 1
    else
        local contents
        contents=$(defaults read com.apple.universalaccess "com.apple.custommenu.apps")
        local grepResults
        grepResults=$(echo "$contents" | grep "$1")
        if [[ -z $grepResults ]]; then
            # does not contain app
            defaults write com.apple.universalaccess "com.apple.custommenu.apps" -array-add "$1"
        else
            # contains app already, so do nothing
            true
        fi
    fi
}

fixKeyboardShortcuts() {
    local command_key_symbol="@"
    # local control_key_symbol="^"
    local option_key_symbol="~"
    # local shift_key_symbol="$"
    # local tab_key_symbol="\\U21e5"

    defaults write com.google.Chrome NSUserKeyEquivalents "{
        'Select Next Tab' = '${command_key_symbol}${option_key_symbol}]';
        'Select Previous Tab' = '${command_key_symbol}${option_key_symbol}[';
    }"
    addCustomMenuEntryIfNeeded "com.google.Chrome"

    # Restart cfprefsd and Finder for changes to take effect.
    # You may also have to restart any apps that were running
    # when you changed their keyboard shortcuts. There is some
    # amount of voodoo as to what you do or do not have to
    # restart, and when.
    killall cfprefsd
    killall Finder
}

fixKeyboardShortcuts

# defaults write com.google.Chrome NSRequiresAquaSystemAppearance -bool yes
