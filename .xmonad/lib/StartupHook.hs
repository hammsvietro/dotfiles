module StartupHook (myStartupHook) where

  import XMonad
  import XMonad.Util.Run
  import XMonad.Util.SpawnOnce
  import XMonad.Hooks.SetWMName

  ------------------------------------------------------------------------
  -- Startup hook

  -- Perform an arbitrary action each time xmonad starts or is restarted
  -- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
  -- per-workspace layout choices.
  --
  -- By default, do nothing.

  myStartupHook isDesktop = do
    spawn "picom &"
    spawn "xss-lock -- i3lock -n -i ~/wallpapers/city.png &"
    setWMName "HVWM"
    spawn "/usr/bin/feh --bg-fill ~/wallpapers/tarantula_nebula.png &"
    if isDesktop then do
      spawn "/usr/bin/feh --bg-fill ~/wallpapers/tarantula_nebula.png --bg-fill ~/wallpapers/tarantula_nebula.png &"
      spawnOnce "xrandr --output DVI-D-0 --off --output HDMI-0 --mode 2560x1080 --rate 75 --pos 1920x0 --rate 75 --rotate normal --output DP-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --rate 144 --output DP-1 --off &"
    else do
      spawn "/usr/bin/feh --bg-fill ~/wallpapers/tarantula_nebula.png &"
      return ()

      
