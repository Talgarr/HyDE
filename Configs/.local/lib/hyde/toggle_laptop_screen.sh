monitorPath="$HOME/.config/hypr/monitors.conf"
if grep -q "monitor=eDP-1,disable" $monitorPath; then
    sed -i '/monitor=eDP-1,disable/d' $monitorPath
else
    echo "monitor=eDP-1,disable" >> $monitorPath
fi
