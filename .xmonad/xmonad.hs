--
-- IMPORTS
--

-- base
import XMonad
import Data.Monoid
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- UTIL
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- HOOKS
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

-- Layout
import XMonad.Layout.Spiral
import Data.Ratio
import XMonad.Layout.Grid
import XMonad.Layout.Spacing

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask


decGap = do
  decWindowSpacing 4 
  decScreenSpacing 4

incGap = do
  incWindowSpacing 4 
  incScreenSpacing 4

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#282828"
myFocusedBorderColor = "#5c4f6a"
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch rofi
    , ((modm,               xK_d     ), spawn "rofi -modi drun,run -show drun -show-icons")
    , ((modm .|. shiftMask, xK_d     ), spawn "~/.local/bin/d_kill")

    -- screenshot current workspace
    , ((modm,               xK_Print ), spawn "flameshot screen -c")
    , ((modm .|. shiftMask, xK_Print ), spawn "flameshot screen -p ~/Pictures")

    -- screenshot crop mode
    , ((modm .|. shiftMask, xK_s     ), spawn "flameshot gui")

    -- close focused window
    , ((modm .|. shiftMask, xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    , ((modm .|.   controlMask, xK_l), decGap)
    , ((modm .|.   controlMask, xK_h), incGap)
    , ((modm .|.   controlMask, xK_b), sendMessage $ ModifySmartBorder (\x -> not x))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_e     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    {-
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    -}


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.

border = (Border 4 4 4 4)
myLayout = avoidStruts $ spacingRaw False border True border True $ layoutTall ||| layoutSpiral ||| layoutGrid ||| layoutMirror ||| layoutFull

  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     layoutTall = Tall 1 (3/100) (1/2)
     layoutSpiral = spiral (125 % 146)
     layoutGrid = Grid
     layoutMirror = Mirror (Tall 1 (3/100) (3/5))
     layoutFull = Full

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["supp", "www", "code", "term", "mus", "chat"] ++ map show [7..9]

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particu0lar
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "hl_linux"       --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , className =? "Spotify"        --> doShift ( myWorkspaces !! 4 )
    , title =? "Mozilla Firefox"    --> doShift ( myWorkspaces !! 1 )
    , title =? "Discord"            --> doShift ( myWorkspaces !! 5 )
    , title =? "Neovide"            --> doShift ( myWorkspaces !! 2 )
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  spawnOnce "xrandr --output DVI-D-0 --off --output HDMI-0 --mode 2560x1080 --pos 0x0 --rotate normal --output DP-0 --primary --mode 1920x1080 --pos 2560x0 --rotate normal --output DP-1 --off &"
  spawnOnce "picom &"
  spawnOnce "xscreensaver -no-splash &"
  spawn "/usr/bin/feh --bg-fill ~/wallpapers/city.png &"
  setWMName "LG3D"



------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  barpipe0 <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
  barpipe1 <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xmobarrc"
  xmonad $ docks $ ewmh $ def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = avoidStruts myLayout,
        manageHook         = myManageHook <+> manageDocks <+> composeOne [isFullscreen -?> doFullFloat],
        handleEventHook    = docksEventHook <+> handleEventHook def <+> fullscreenEventHook,
        startupHook        = myStartupHook,
        logHook = dynamicLogWithPP $ xmobarPP
                -- the following variables beginning with 'pp' are settings for xmobar.
                { ppOutput = \x ->
                  hPutStrLn barpipe0 x                          -- xmobar on monitor 1
                  >> hPutStrLn barpipe1 x                          -- xmobar on monitor 2

                , ppCurrent = xmobarColor "#f1fa8c" "" . wrap "<box type=Bottom width=2 fn=3 mb=2 color=#f1fa8c>" "</box>"         -- Current workspace
                , ppVisible = xmobarColor "#f1fa8c" ""                          -- Visible but not current workspace
                , ppHidden = xmobarColor "#8be9fd" "" . wrap "<box type=Top width=2 mt=2 color=#8be9fd>" "</box>"  -- Hidden workspaces
                , ppHiddenNoWindows = xmobarColor "#8be9fd" ""                  -- Hidden workspaces (no windows)
                , ppTitle = xmobarColor "#50fa7b" "" . shorten 60               -- Title of active window
                , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
                , ppUrgent = xmobarColor "#ff79c6" "" . wrap "!" "!"            -- Urgent workspace
                , ppExtras  = [windowCount]                                     -- # of windows current workspace
                , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
                }

    }
