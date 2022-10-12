{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances #-}
{-# OPTIONS_GHC -Wno-deprecations #-}
--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Layout.Fullscreen ( fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFull )
import XMonad.Layout.Spacing ( spacingRaw, Border(Border) )
import System.Exit ( exitSuccess )
import XMonad.Hooks.ManageDocks ( avoidStruts, docks, manageDocks, Direction2D(R, L, U, D) )
import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhDesktopsEventHook )
import XMonad.Hooks.ManageHelpers (doFullFloat, isFullscreen, doRectFloat)
import XMonad.Layout.NoBorders ( noBorders, smartBorders, hasBorder )
import XMonad.Layout.Gaps ( gaps, setGaps, GapMessage(DecGap, ToggleGaps, IncGap) )
import XMonad.Layout.Decoration
    ( Theme(inactiveBorderColor, activeTextColor) )
import XMonad.Layout.SimpleDecoration
    ( Theme(inactiveBorderColor, activeTextColor) )
import XMonad.Util.Types ()
import XMonad.Layout.Tabbed
    ( Direction2D(R, L, U, D),
      Theme(inactiveBorderColor, activeTextColor) )
import XMonad.Util.EZConfig ( additionalKeysP )
import Data.Ratio

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch firefox
    , ((modm,               xK_f     ), spawn "firefox")

    -- launch discord 
    , ((modm,               xK_d     ), spawn "discord")

    -- launch spotify
    , ((modm,               xK_s     ), spawn "spotify")


    -- launch rofi
    , ((modm,               xK_p     ), spawn "rofi -modi [window,run,ssh,drun] -show drun")

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
    , ((modm,               xK_Return), windows W.shiftMaster)

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

    -- Toggle the status bar
    , ((modm              , xK_b     ), spawn "polybar-msg cmd toggle")

    -- Restart xmonad
    , ((modm .|. controlMask, xK_r   ), spawn "xmonad --recompile; xmonad --restart")

    -- Power menu
    , ((modm .|. shiftMask, xK_q     ), spawn "~/launch/powermenu")

    -- Close window
    , ((modm              , xK_q     ), kill)

    -- Suspend system
    , ((modm .|. shiftMask, xK_s     ), spawn "sudo /usr/bin/systemctl suspend")
    
    -- Shutdown system
    , ((modm .|. shiftMask .|. controlMask, xK_s     ), spawn "sudo /usr/bin/shutdown now")
    
    -- Make a screenshot using flameshot
    , ((0, xK_Print ), spawn "flameshot gui")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_e, xK_w, xK_p] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    ++
    -- Media Controls
    [
           -- XF86AudioLowerVolume
      ((0            , 0x1008ff11), spawn "pamixer -d 2 -u")
    -- XF86AudioRaiseVolume
    , ((0            , 0x1008ff13), spawn "pamixer -i 2 -u")
    -- XF86AudioMute
    , ((0            , 0x1008ff12), spawn "pamixer -t")
    -- XF86AudioPlay
    , ((0            , 0x1008ff14), spawn "playerctl play-pause")
    -- XF86AudioNext
    , ((0            , 0x1008ff17), spawn "playerctl next")

    -- GAPS!!!
    , ((modm .|. shiftMask, xK_t), sendMessage $ ToggleGaps)               -- toggle all gaps
    , ((modm .|. shiftMask, xK_r), sendMessage $ setGaps myGaps) -- reset the GapSpec
    ]

-- Additonal keys
ezKeys = 
    [ ("M-<Left>"   , sendMessage $ DecGap gapDelta L)
    , ("M-S-<Left>" , sendMessage $ IncGap gapDelta L)

    , ("M-<Right>"  , sendMessage $ DecGap gapDelta R)
    , ("M-S-<Right>", sendMessage $ IncGap gapDelta R)

    , ("M-<Up>"  , sendMessage $ DecGap gapDelta U)
    , ("M-S-<Up>", sendMessage $ IncGap gapDelta U)

    , ("M-<Down>"  , sendMessage $ DecGap gapDelta D)
    , ("M-S-<Down>", sendMessage $ IncGap gapDelta D)


    ]
gapDelta = 5

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
------------------------------------------------------------------------
-- Layouts:
mySpacing = spacingRaw True                     -- False=Apply even when single window
                       (Border s s s s)         -- Screen border size top bot right left
                       True                     -- Screen border
                       (Border w w w w)         -- Window border size
                       True                     -- Window borders
    where
      s = 0
      w = 2

myGaps = [(U, 5), (D, 10), (R, 12), (L, 12)]
-- myGaps = [(U, 0), (D, 0), (R, 0), (L, 0)]

myLayout = avoidStruts $ smartBorders $ gaps myGaps $ mySpacing $ tiled  ||| Mirror tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 2/100


------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = fullscreenManageHook <+> manageDocks <+> composeAll
    [ className =? "MPlayer"            --> doFloat
    , className =? "ui2"                --> doFloat
    , className =? "Qemu-system-x86_64" --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 6) (1 % 6))
    , resource  =? "desktop_window"     --> doIgnore
    , resource  =? "kdesktop"           --> doIgnore
    , resource  =? "polybar"            --> doIgnore
    , resource  =? "Dunst"              --> hasBorder False 
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
myEventHook = ewmhDesktopsEventHook
------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook = return ()

------------------------------------------------------------------------

myStartupHook = do
    spawn "/home/linus/.screenlayout/screen.sh"
    spawn "~/.fehbg"
    -- spawn "~/launch/update_bg"
    spawn "picom"
    spawn "ntfd"
    spawn "~/launch/polybar"
    spawn "flameshot"
    spawn "~/launch/polybar"    
    spawn "~/launch/dunst"
    spawn "~/launch/redshift"
    spawn "eww -c .~/.config/eww daemon"
    spawn "setxkbmap -layout us"

------------------------------------------------------------------------

main = do
    xmonad $ fullscreenSupport $ docks $ ewmh def {
    -- simple stuff
    terminal           = "alacritty",
    focusFollowsMouse  = True,
    clickJustFocuses   = False,
    borderWidth        = 2,
    modMask            = mod4Mask,
    workspaces         = map show [1..9],
    normalBorderColor  = "#292d3e",
    focusedBorderColor = "#27C27C", -- "#007acc",

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = myLayout,
    manageHook         = myManageHook,
    handleEventHook    = myEventHook,
    logHook            = myLogHook,
    startupHook        = myStartupHook
} `additionalKeysP` ezKeys

