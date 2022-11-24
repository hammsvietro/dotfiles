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

  myStartupHook = do
    spawn "picom &"
    spawn "xss-lock -- i3lock -n -i ~/wallpapers/city.png &"
    spawn "/usr/bin/feh --bg-fill ~/wallpapers/sunrise.jpg &"
    setWMName "HVWM"
