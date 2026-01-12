PORT=5900
HOST=127.0.0.1
MONITOR="oPD-1"
MONITOR_MODE="2800x2000@60"
MONITOR_POS="0x-59"
MONITOR_SCALE=1.67
ANDROID_DEVICE="OPD2203"

create_output(){
    hyprctl output create headless "$MONITOR"\
        >/dev/null
}
check_output(){
    # 0:success
    hyprctl monitors |\
        grep -q "$MONITOR"
}

if ! check_output; then
    create_output
    if ! check_output; then
        hyprctl notify 3 3000 "rgb(ff0000)" "Failed to create Headless Output to $MONITOR."\
            >/dev/null
        exit 1
    fi
fi

check_mode() {
    hyprctl monitors -j | \
        jq -r --arg name "$MONITOR" '.[] | select(.name == $name) | "\(.width)x\(.height)@\(.refreshRate | round)"' | \
        grep -q "$MONITOR_MODE"
}

set_mode() {

    local options="keyword monitor $MONITOR,$MONITOR_MODE,$MONITOR_POS,$MONITOR_SCALE"

    # extra options 
    #options+=" ; keyword workspace r[4-6], monitor:$MONITOR, gapsout:9"
    #options+=" ; keyword windowrule rounding 20, match:workspace r[4-6]"

    hyprctl --batch "$cmd" \
      >/dev/null
}

if ! check_mode; then
    set_mode
    if ! check_mode; then
        hyprctl notify 3 3000 "rgb(ff0000)" "Failed to set mode to $MONITOR."\
            >/dev/null
        exit 1
    fi
fi

get_id() {
    adb devices -l |\
        grep "$ANDROID_DEVICE" |\
        grep -oP 'transport_id:\K\d+' |\
        head -n 1
}

TRANSPORT_ID=$(get_id)

if [ -z "$TRANSPORT_ID" ]; then
    hyprctl notify 2 3000 "rgb(eedd00)" "No Android device found. Please connect USB and enable Debugging."\
        >/dev/null
    exit 1
fi

check_tcp_reverse(){
    adb -t "$TRANSPORT_ID" reverse --list |\
      grep -q $PORT
}

if ! check_tcp_reverse; then
    adb -t "$TRANSPORT_ID" reverse tcp:$PORT tcp:$PORT\
        >/dev/null
fi

check_vnc(){
    ss -tuplen sport = :$PORT |\
      grep -q wayvnc
}

if ! check_vnc; then
    hyprctl notify 5 3000 "rgb(00ff00)" "Starting WayVNC..."\
        >/dev/null
    wayvnc -o "$MONITOR" "$HOST" "$PORT" >/dev/null 2>&1 &
    disown
else
    hyprctl notify 2 3000 "rgb(eedd00)" "WayVNC is already running."
fi
