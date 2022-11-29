module Keys (
    myKeys
  , myNormalBorderColor
  , windowCount
  , myFocusedBorderColor
) where
  import XMonad
  import Data.Monoid
  import System.Exit
  import qualified XMonad.StackSet as W
  import qualified Data.Map        as M

  -- UTIL
  import XMonad.Util.Run
  import XMonad.Util.ClickableWorkspaces

  -- HOOKS
  import XMonad.Hooks.ManageDocks
  import XMonad.Hooks.DynamicLog
  import XMonad.Hooks.EwmhDesktops
  import XMonad.Hooks.ManageHelpers
  import XMonad.Hooks.DynamicProperty

  -- Layout
  import XMonad.Layout.Spiral
  import Data.Ratio
  import Data.Semigroup
  import XMonad.Layout.Grid
  import XMonad.Layout.Spacing
  import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)

  import Layout
  import StartupHook


  -- modMask lets you specify which modkey you want to use. The default
  -- is mod1Mask ("left alt").  You may also consider using mod3Mask
  -- ("right alt"), which does not conflict with emacs keybindings. The
  -- "windows key" is usually mod4Mask.
  --
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
      , ((modm              , xK_f     ), sendMessage (Toggle "Full"))

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
