--
-- IMPORTS
--

-- base
import Data.Kind
import qualified Data.Map as M
import Data.Maybe
import Data.Monoid
-- UTIL

-- HOOKS

-- Layout

import Data.Ratio
import Data.Semigroup
import Keys
import Layout
import Log
import StartupHook
import System.Environment
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Grid
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import qualified XMonad.StackSet as W
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.Run

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth = 2

myModMask = mod4Mask

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w ->
          focus w >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

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
myWorkspaces = ["sup", "web", "code", "term", "mus", "chat", "org", "game", "movie"]

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
myManageHook =
  composeAll
    [ className =? "MPlayer" --> doFloat,
      className =? "Gimp" --> doFloat,
      className =? "hl_linux" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      className =? "Google-chrome" --> doShift (myWorkspaces !! 0),
      title =? "Mozilla Firefox" --> doShift (myWorkspaces !! 1),
      title =? "Neovide" --> doShift (myWorkspaces !! 2),
      className =? "Spotify" --> doShift (myWorkspaces !! 4),
      className =? "discord" --> doShift (myWorkspaces !! 5),
      className =? "notion-app" --> doShift (myWorkspaces !! 6),
      className =? "notion-app-enhanced" --> doShift (myWorkspaces !! 6),
      className =? "steam" --> doShift (myWorkspaces !! 7),
      className =? "Stremio" --> doShift (myWorkspaces !! 8),
      className =? "tidal-hifi" --> doShift (myWorkspaces !! 4),
      resource =? "kdesktop" --> doIgnore
    ]

myHandleEventHook =
  dynamicPropertyChange "WM_NAME" $
    composeAll
      [ className =? "Spotify" --> doShift (myWorkspaces !! 4),
        className =? "Stremio" --> doShift (myWorkspaces !! 8)
      ]

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
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
desktopPp = do
  pipe0 <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
  pipe1 <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xmobarrc"
  return (\x -> hPutStrLn pipe0 x >> hPutStrLn pipe1 x)

laptopPp = do
  pipe <- spawnPipe "xmobar -x 0 ~/.config/xmobar/laptopxmobarrc"
  return (\x -> hPutStrLn pipe x)

getIsDesktop = do
  isDesktop <- lookupEnv "IS_DESKTOP"
  return ((fromMaybe "0" isDesktop) == "1")

getBarPipes isDesktop = do
  return
    ( case isDesktop of
        True -> desktopPp
        False -> laptopPp
    )

main = do
  isDesktop <- getIsDesktop
  barPipesFn <- getBarPipes isDesktop
  barPipes <- barPipesFn
  xmonad $
    docks $
      ewmh $
        ewmhFullscreen $
          def
            { -- simple stuff
              terminal = myTerminal,
              focusFollowsMouse = myFocusFollowsMouse,
              clickJustFocuses = myClickJustFocuses,
              borderWidth = myBorderWidth,
              modMask = myModMask,
              workspaces = myWorkspaces,
              normalBorderColor = myNormalBorderColor,
              focusedBorderColor = myFocusedBorderColor,
              -- key bindings
              keys = myKeys,
              mouseBindings = myMouseBindings,
              -- hooks, layouts
              layoutHook = avoidStruts myLayout,
              manageHook = myManageHook <+> manageDocks <+> composeOne [isFullscreen -?> doFullFloat],
              handleEventHook = myHandleEventHook,
              startupHook = myStartupHook isDesktop,
              logHook = myLogHook barPipes
            }
