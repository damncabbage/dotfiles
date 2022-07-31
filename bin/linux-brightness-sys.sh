#!/usr/bin/env bash
set -e # fail on error
set -u # yell if a var is undefined

# get the backlight handler
handler_dir="/sys/class/backlight/intel_backlight"
brightness_file="${handler_dir}/brightness"

# get current brightness
old_brightness=$(cat "${brightness_file}")

# get max brightness
max_brightness=$(cat "${handler_dir}/max_brightness")

# get current brightness %
old_brightness_p=$(( 100 * old_brightness / max_brightness ))

# what % to step up and down
step_p=10

# calculate new brightness %
# (or tell the caller to fuck off)
case "${1:-}" in
  up)
    new_brightness_p=$(( old_brightness_p + step_p ))
    ;;
  down)
    new_brightness_p=$(( old_brightness_p - step_p ))
    ;;

  *)
    echo "Usage: $0 (up|down)"
    exit 1
    ;;
esac

if [ "$new_brightness_p" -gt 100 ]; then
  # too much bright
  exit
fi

# calculate new brightness value
new_brightness=$(( max_brightness * new_brightness_p / 100 ))

# Set the new brightness value
# (Needs /etc/rc.local to have been run on bootup first)
echo "$new_brightness" > "$brightness_file"
