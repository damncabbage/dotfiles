#!/bin/bash
# <bitbar.title>AnyConnect Umbrella Status</bitbar.title>
# <bitbar.version>v1.3</bitbar.version>
# <bitbar.author>Jason Masker</bitbar.author>
# <bitbar.author.github>jasmas</bitbar.author.github>
# <bitbar.desc>Check and toggle status of Umbrella Roaming Security Module for Cisco AnyConnect.</bitbar.desc>
# <bitbar.image>https://i.imgur.com/Jznovev.png</bitbar.image>

PLUGIN_BASE='/opt/cisco/anyconnect/bin/plugins'

IMG_DISABLED='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'
IMG_ENABLED='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'

# Check plugin status, return 0 if enabled, 1 if disabled
function check_status {
    [[ -f $PLUGIN_BASE/libacumbrellaapi.dylib ]] &&
    [[ -f $PLUGIN_BASE/libacumbrellactrl.dylib ]] &&
    [[ -f $PLUGIN_BASE/libacumbrellaplugin.dylib ]]
}

# Check if plugin disabled by utility, return 0 if yes, 1 if no
function verify_plugin_disabled {
    [[ -f $PLUGIN_BASE/disabled/libacumbrellaapi.dylib ]] &&
    [[ -f $PLUGIN_BASE/disabled/libacumbrellactrl.dylib ]] &&
    [[ -f $PLUGIN_BASE/disabled/libacumbrellaplugin.dylib ]]
}

# Disable plugin
function disable_plugin {
    /usr/bin/osascript -e "do shell script \"mkdir -p $PLUGIN_BASE/disabled && mv -f $PLUGIN_BASE/libacumbrellaapi.dylib $PLUGIN_BASE/libacumbrellactrl.dylib $PLUGIN_BASE/libacumbrellaplugin.dylib $PLUGIN_BASE/disabled/\" with administrator privileges"
}

# Enable plugin
function enable_plugin {
    /usr/bin/osascript -e "do shell script \"mv -f $PLUGIN_BASE/disabled/libacumbrellaapi.dylib $PLUGIN_BASE/disabled/libacumbrellactrl.dylib $PLUGIN_BASE/disabled/libacumbrellaplugin.dylib $PLUGIN_BASE/\" with administrator privileges"
}

case "$1" in
    'enable')
        verify_plugin_disabled &&
        enable_plugin
        ;;
    'disable')
        check_status &&
        disable_plugin
        ;;
    *)
        check_status &&
        echo "| image=$IMG_ENABLED" ||
        echo "| image=$IMG_DISABLED"

        echo '---'

        (check_status &&
        echo "Disable Cisco Umbrella| terminal=false refresh=true bash='$0' param1=disable") ||
        (verify_plugin_disabled &&
        echo "Enable Cisco Umbrella| terminal=false refresh=true bash='$0' param1=enable")

esac