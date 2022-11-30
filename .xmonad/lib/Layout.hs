------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
module Layout (myLayout) where

  import XMonad

  import XMonad.Layout.Spiral
  import Data.Ratio
  import Data.Semigroup
  import XMonad.Layout.Grid
  import XMonad.Layout.Spacing
  import XMonad.Layout.NoBorders (noBorders, smartBorders)
  import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)


  border = (Border 4 4 4 4)
  myLayout = smartBorders $ toggleLayouts (noBorders Full) (spacingRaw False border True border True $ layoutTall ||| layoutSpiral ||| layoutGrid ||| layoutMirror ||| layoutFull)

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
