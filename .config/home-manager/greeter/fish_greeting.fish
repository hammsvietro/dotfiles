function fish_greeting --description 'Mandelbrot greeter'
    status is-interactive; or return

    set -l awk "$HOME/.config/greeter/mandelbrot.awk"

    set -l cols "$COLUMNS"
    test -n "$cols"; or set cols (tput cols 2>/dev/null); or set cols 80

    set -l truecolor 1
    if test -z "$COLORTERM"; and not string match -qr '256|ghostty|kitty|direct' -- "$TERM"
        set truecolor 0
    end

    # A curated region of the Mandelbrot set: cx cy span maxit density name
    set -l views \
        "-0.75 0.0 3.2 200 0.9 the whole set" \
        "-0.55 0.0 1.35 200 0.9 western bulb" \
        "0.28 0.008 0.06 220 0.9 elephant valley" \
        "-0.16 1.035 0.22 220 0.9 northern reach" \
        "-1.362 0.045 0.18 220 0.9 seahorse shoals" \
        "0.36 0.10 0.35 200 0.9 eastern shore"
    set -l pick (string split ' ' -- $views[(random 1 (count $views))])
    set -l cx $pick[1]; set -l cy $pick[2]; set -l span $pick[3]
    set -l maxit $pick[4]; set -l den $pick[5]
    set -l region (string join ' ' -- $pick[6..-1])

    if test "$truecolor" = 0; or test "$cols" -lt 96; or not test -r "$awk"
        set_color -o 61afef
        printf '\n  %s@%s' (whoami) (prompt_hostname)
        set_color normal
        printf '  ·  z ↦ z² + c  ·  %s\n\n' "$region"
        return
    end

    set -l blue (set_color 61afef)
    set -l mauve (set_color c678dd)
    set -l green (set_color 98c379)
    set -l yellow (set_color e5c07b)
    set -l peach (set_color d19a66)
    set -l cyan (set_color 56b6c2)
    set -l red (set_color e06c75)
    set -l txt (set_color abb2bf)
    set -l sub (set_color 5c6370)
    set -l off (set_color normal)
    set -l bold (set_color -o)

    set -l user (whoami)
    set -l host (prompt_hostname)
    set -l ver (string replace -r '.*"(.*)".*' '$1' -- (grep -m1 '^VERSION_ID=' /etc/os-release 2>/dev/null))
    set -l os (string trim "NixOS $ver")
    set -l kern (uname -r)
    set -l sh "fish $version"
    set -l wm "$XDG_CURRENT_DESKTOP"
    test -n "$wm"; or set wm tty

    set -l secs (string split ' ' -- (cat /proc/uptime))[1]
    set secs (math -s0 "floor($secs)")
    set -l up
    set -l d (math -s0 "$secs/86400")
    set -l h (math -s0 "$secs%86400/3600")
    set -l m (math -s0 "$secs%3600/60")
    test $d -gt 0; and set up "$up$d"d" "
    test $h -gt 0; and set up "$up$h"h" "
    set up "$up$m"m""

    set -l mt (awk '/^MemTotal:/{print $2}' /proc/meminfo)
    set -l ma (awk '/^MemAvailable:/{print $2}' /proc/meminfo)
    set -l used (math -s1 "($mt - $ma)/1048576")
    set -l total (math -s0 "$mt/1048576")
    set -l mem "$used / $total GiB"

    set -l zoom (math -s0 "floor(3.2/$span)")

    function _row -a col icon label value
        echo -n -s $col $icon '  ' $sub (string pad -r -w 8 -- $label) $col $value (set_color normal)
    end

    set -l panel \
        "$bold$txt$user$off$sub@$bold$blue$host$off" \
        "$sub────────────────────$off" \
        "" \
        (_row $peach  ❄ os     $os) \
        (_row $blue   󰌽 kernel $kern) \
        (_row $green  󰅐 uptime $up) \
        (_row $cyan   󰆍 shell  $sh) \
        (_row $yellow 󰘚 memory $mem) \
        (_row $mauve  󰍹 wm     $wm) \
        "" \
        "$red⌖ $txt$region  $sub×$zoom$off" \
        "$sub  $cx, $cy    z ↦ z² + c$off"

    functions -e _row

    set -l joined (string join \x1e -- $panel)

    echo
    env GREETER_PANEL="$joined" \
        gawk -v W=52 -v ROWS=20 -v CX=$cx -v CY=$cy -v SPAN=$span \
             -v MAXIT=$maxit -v DENSITY=$den -v PANELCOL=57 -v PANELPAD=4 \
             -f "$awk"
    echo
end
