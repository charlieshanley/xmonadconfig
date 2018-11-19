import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Actions.Volume
import System.IO
import Graphics.X11.ExtraTypes.XF86

main :: IO ()
main = do
    -- TODO interpolate nix derivation
    spawn "feh --bg-center /home/charlie/Downloads/footerBG.jpg"
    xmobarProc <- spawnPipe "xmobar /home/charlie/.xmonad/xmobarrc"
    xmonad $ docks def
        { manageHook = manageDocks <+> manageHook def
        , layoutHook = mySpace . smartBorders . avoidStruts . layoutHook $ def
        , logHook    = dynamicLogWithPP $ xmobarPP
            { ppOutput = hPutStrLn xmobarProc
            , ppTitle = (>> "")
            }
        , modMask    = mod4Mask
        , terminal   = "urxvt"
        , borderWidth        = 2
        , focusedBorderColor = "#cd8b00"
        } `additionalKeys`
        -- TODO interpolate nix derivation
        [ ((mod4Mask .|. shiftMask, xK_f), spawn "firefox")
        , ((controlMask, xK_Print),        spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print),                  spawn "scrot")
        , ((0, xF86XK_AudioLowerVolume),   lowerVolume 5 >>= showVolume)
        , ((0, xF86XK_AudioRaiseVolume),   raiseVolume 5 >>= showVolume)
        ]

mySpace = spacingRaw True (Border 0 0 0 0) False (Border 5 5 5 5) True

showVolume :: MonadIO m => Double -> m ()
showVolume n = osdCat n $
    const " --align=center --pos=middle --delay=1 --outline=3 --color=cyan"
