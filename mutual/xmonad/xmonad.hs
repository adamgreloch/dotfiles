{-# LANGUAGE RecordWildCards #-}

import XMonad

import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras

import XMonad.Layout.ToggleLayouts
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier

import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = " | "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = white . wrap " " "" . xmobarBorder "Top" "#b58900" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppLayout          = blue . wrap "" ""
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . yellow   . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . lowWhite . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#d33682" ""
    blue     = xmobarColor "#268bd2" ""
    white    = xmobarColor "#839496" ""
    yellow   = xmobarColor "#b58900" ""
    red      = xmobarColor "#dc322f" ""
    lowWhite = xmobarColor "#586e75" ""

myLayout = toggleLayouts Full (tiled ||| Mirror tiled ||| threeCol)
  where
    threeCol = magnifiercz' 1.5 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

-- | The xmonad key bindings. Add, modify or remove key bindings here.
--
-- (The comment formatting character is used when generating the manpage)
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching and killing programs
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
    , ((modMask,               xK_p     ), spawn "dmenu_run") -- %! Launch dmenu
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun") -- %! Launch gmrun
    , ((modMask .|. shiftMask, xK_q     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    , ((modMask,               xK_f ), sendMessage ToggleLayout) -- %! Rotate through the available layout algorithms

    -- move focus up or down the window stack
    , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

    -- modifying the window order
    , ((modMask,               xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modMask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_l     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_c     ), io (exitWith ExitSuccess)) -- %! Quit xmonad
    , ((modMask              , xK_c     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [ ((0,              xF86XK_MonBrightnessDown), spawn "brightlight -p -d 5"  )
    , ((0,              xF86XK_MonBrightnessUp  ), spawn "brightlight -p -i 5"  )
    , ((shiftMask,      xF86XK_MonBrightnessDown), spawn "brightlight -p -w 1"  )
    , ((shiftMask,      xF86XK_MonBrightnessUp  ), spawn "brightlight -p -w 100")
    ]

myConfig = def
    { modMask        = mod4Mask  -- Rebind Mod to the Super key
    , terminal       = "urxvt"
    , keys           = myKeys
    , layoutHook     = myLayout
    }
    `additionalKeysP`
    [ ("M-S-f", spawn "firefox" )
    , ("M-S-m", spawn "thunderbird" )
    ]
