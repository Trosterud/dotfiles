function personal_hotspot
    set --local PERSONAL_HOTSPOT_PASSWORD $argv[1]

    networksetup -setairportnetwork en0 "Nordic Roadshow" $PERSONAL_HOTSPOT_PASSWORD
end
