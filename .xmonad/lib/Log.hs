module Log (myLogHook) where

import qualified Data.Map as M
import Data.Monoid
import System.Exit
import XMonad
import qualified XMonad.StackSet as W

-- UTIL

import XMonad.Util.ClickableWorkspaces
import XMonad.Util.Run

-- HOOKS

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

-- Layout

import Data.Ratio
import Data.Semigroup
import XMonad.Layout.Grid
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral

import Keys

myLogHook ppOutput =
  dynamicLogWithPP $
    xmobarPP
      { -- the following variables beginning with 'pp' are settings for xmobar.
        ppOutput = ppOutput
      , ppCurrent = xmobarColor "#f1fa8c" "" . wrap "<box type=Bottom width=2 fn=3 mb=2 color=#f1fa8c>" "</box>" -- Current workspace
      , ppVisible = xmobarColor "#f1fa8c" "" -- Visible but not current workspace
      , ppHidden = xmobarColor "#8be9fd" "" . wrap "<box type=Top width=2 mt=2 color=#8be9fd>" "</box>" -- Hidden workspaces
      , ppHiddenNoWindows = xmobarColor "#8be9fd" "" -- Hidden workspaces (no windows)
      , ppTitle = xmobarColor "#50fa7b" "" . shorten 40 -- Title of active window
      , ppSep = "<fc=#666666> <fn=1>|</fn> </fc>" -- Separator character
      , ppUrgent = xmobarColor "#ff79c6" "" . wrap "!" "!" -- Urgent workspace
      , ppExtras = [windowCount] -- # of windows current workspace
      , ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t] -- order of things in xmobar
      }
