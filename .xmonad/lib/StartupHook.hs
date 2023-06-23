module StartupHook (myStartupHook) where

import Control.Monad
import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Util.Cursor
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

------------------------------------------------------------------------
-- Startup hook
------------------------------------------------------------------------

specificStartup :: Bool -> X ()
specificStartup True =
  spawn "/usr/bin/feh --bg-fill ~/wallpapers/patterns.png --bg-fill ~/wallpapers/patterns.png &"
    >> spawnOnce "xrandr --output DVI-D-0 --off --output HDMI-0 --mode 2560x1080 --rate 75 --pos 1920x0 --rate 75 --rotate normal --output DP-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --rate 144 --output DP-1 --off &"
specificStartup False =
  void $ spawn "/usr/bin/feh --bg-fill ~/wallpapers/patterns.png &"

myStartupHook isDesktop =
  spawn "picom &"
    >> spawn "nvidia-settings --load-config-only &"
    >> spawn "xss-lock -- i3lock -n -i ~/wallpapers/city.png &"
    >> setDefaultCursor xC_left_ptr
    >> setWMName "HVWM"
    >> specificStartup isDesktop
