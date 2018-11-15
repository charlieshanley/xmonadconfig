import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import System.IO

main :: IO ()
main = do
    -- TODO interpolate nix derivation
    xmobarProc <- spawnPipe "xmobar /home/charlie/.xmonad/xmobarrc"
    xmonad $ docks def
        { manageHook = manageDocks <+> manageHook def
        , layoutHook = avoidStruts  $  layoutHook def
        , logHook    = dynamicLogWithPP $ xmobarPP
            { ppOutput = hPutStrLn xmobarProc
            -- , ppTitle  = xmobarColor "green" "" . shorten 50
            , ppTitle = (>> "")
            }
        , modMask    = mod4Mask
        , terminal   = "urxvt"
        , borderWidth        = 2
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#cd8b00"
        } `additionalKeys`
        -- TODO interpolate nix derivation
        [ ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
