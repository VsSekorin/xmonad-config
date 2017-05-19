-- Core
import XMonad
import qualified XMonad.StackSet as W
import System.Exit (exitSuccess)
import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
import System.IO

-- Utilities
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SpawnOnce
import XMonad.Util.Run


-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

--Layouts
import XMonad.Layout.Fullscreen
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps

-- Settings
myBorderWidth  = 3
myModMask      = mod4Mask
myTerminal     = "xfce4-terminal"
myFocusedColor = "#444444"

myWorkspaces :: [String]
myWorkspaces = [" 一", "二", "三", "四"]

--Some layouts
myLayoutHook = gaps [(U,6),(L,6),(R,6)] (spacing 4 (lessBorders OnlyFloat (tiled))) ||| noBorders (fullscreenFull Full)
	where
	tiled   = Tall nmaster delta ratio
	nmaster = 1
	ratio   = 1/2
	delta   = 3/100

-- Autostart
myStartUp = do
          spawn "~/.fehbg &"
          spawn "gxkb &"
          spawn "xfce4-power-manager &"
          setWMName "LG3D"
 
-- Main
main = do
    xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
    xmonad $ defaultConfig
        {
        terminal        = myTerminal
        , modMask       = myModMask
        , workspaces    = myWorkspaces
        , startupHook   = myStartUp
        , layoutHook    = myLayoutHook
        , logHook = dynamicLogWithPP $ xmobarPP
            { ppOutput  = hPutStrLn xmproc
            , ppCurrent = xmobarColor "#d0d0d0" "#151515"
            , ppUrgent  = xmobarColor "#202020" "#ac4142"
            , ppVisible = xmobarColor "#90a959" "#151515"
            , ppSep     = " ~ "
            , ppOrder   = \(ws:_:t:_) -> [ws,t]
            , ppTitle   = xmobarColor "#d0d0d0" "" . shorten 140
            }
        , focusedBorderColor = myFocusedColor
        , borderWidth = myBorderWidth
        } `additionalKeys`
		[ ((0 , xF86XK_AudioLowerVolume), spawn "pactl set-sink-mute 0 false ; pactl -- set-sink-volume 0 -5%"),
		  ((0 , xF86XK_AudioRaiseVolume), spawn "pactl set-sink-mute 0 false ; pactl set-sink-volume 0 +5%"),
		  ((0 , xF86XK_AudioMute), spawn "pactl set-sink-mute 0 toggle")
		]
