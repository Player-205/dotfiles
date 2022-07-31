{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications    #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Main (main) where

import qualified Data.Map as M
import Data.List (sortBy)
import Data.Function (on)
import Control.Monad (forM_, join, replicateM_)

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Operations (windows)

import XMonad.Util.EZConfig (mkKeymap)
import XMonad.Util.Ungrab (unGrab)
import XMonad.Util.SpawnOnce (spawnOnce, spawnOnOnce)
import XMonad.Util.Run (safeSpawn, safeSpawnProg, safeRunInTerm)
import XMonad.Util.NamedWindows (getName)

import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.StatusBar
-- import XMonad.Hooks.StatusBar.PP

-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders

import XMonad.Actions.Minimize
import XMonad.Actions.Navigation2D
import XMonad.Actions.Search

import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch (fuzzyMatch, fuzzySort)
import XMonad.Prompt.Input
import XMonad.Prompt.Shell
import Data.Foldable
import XMonad.Layout.Tabbed

main :: IO ()
main = do
  xmonad
     . withNavigation2DConfig def
     . ewmhFullscreen
     . ewmh
     . docks
--     . withSB mySB
     $ myXConfig

myXConfig = def
  { terminal           = "alacritty"
  , modMask            = mod4Mask
  , workspaces         = myWorkspaces

  , borderWidth        = 0
  , normalBorderColor  = "#928374"
  , focusedBorderColor = "#b16286"

  , keys               = \c -> mkKeymap c (myKeymap c)

  , startupHook        = myStartupHook
  , layoutHook         = myLayoutHook
  , manageHook         = manageHook def <+> myManageHook
  --, logHook = myLogHook dbus
  }

myXPConfig = def
  { bgColor           = "#282828"
  , fgColor           = "#ebdbb2"
  , bgHLight          = "#ebdbb2"
  , fgHLight          = "#282828"
  , borderColor       = "#928374"
  , promptBorderWidth = 2
  , height            = 30
  , searchPredicate   = fuzzyMatch
  , sorter            = fuzzySort
  }

myWorkspaces = digitKeys -- ["\63083", "\63288", "\63306", "\61723", "\63107", "\63601", "\63391", "\61713", "\61884"]

myKeymap c = fold
  [ appKeys c
  , windowsFocus
  , windowsSwap
  , layoutKeys
  , workspaceKeys
  , screenshotKeys
  , promptKeys
  , popupKeys
  , audioKeys
  , lightLeys
  ]

windowsFocus =
  [ ("M-<Tab>"  , windows W.focusDown)
  , ("M-S-<Tab>", windows W.focusUp)
  , ("M-<Left>"  , windowGo L True)
  , ("M-<Down>"  , windowGo D True)
  , ("M-<Up>"    , windowGo U True)
  , ("M-<Right>" , windowGo R True)
  ]

windowsSwap =
  [ ("M-C-<Tab>", windows W.swapDown)
  , ("M-C-<Tab>", windows W.swapUp)
  , ("M-C-<Left>"  , windowSwap L True)
  , ("M-C-<Down>"  , windowSwap D True)
  , ("M-C-<Up>"    , windowSwap U True)
  , ("M-C-<Right>" , windowSwap R True)
  ]

layoutKeys =
  [ ("M-S-<Up>"    , withFocused (sendMessage . maximizeRestore))
  , ("M-S-<Down>"  , withFocused minimizeWindow                 )
  , ("M-S-<Down>", withLastMinimized maximizeWindowAndFocus   )
  , ("M-t"       , withFocused $ windows . W.sink             )
  , ("M-l"       , sendMessage NextLayout                     )
  ] <>
  [("M-C-" <> k, sendMessage $ JumpToLayout l)
  | (k, l) <- zip digitKeys [ "Tall", "ThreeCol", "Tabbed", "Grid", "Full"]
  ]

workspaceKeys =
  [ ("M-" <> m <> k, windows $ f i)
  | (i, k) <- zip myWorkspaces digitKeys
  , (f, m) <- [(W.greedyView, ""), (W.shift, "S-")]
  ]

appKeys c =
  [ ("M-S-c"       , kill              )
  , ("M-S-<Return>", spawn $ terminal c)
  , ("M-e"         , safeSpawnProg "nautilus"  )
  , ("M-f"         , spawn "firefox"   )
  , ("M-w"         , spawn "code" )
  ]

screenshotKeys :: [(String, X ())]
screenshotKeys =
  [ ("<Print>"    , spawn "flameshot gui -c")
  , ("S-<Print>"  , spawn "flameshot full -c")
  , ("C-<Print>"  , spawn "flameshot screen -c")

  -- , ("M-<Print>"  , spawn $ "spectacle -rb" <> toFile)
  -- , ("M-S-<Print>", spawn $ "spectacle -fb" <> toFile)
  -- , ("M-C-<Print>", spawn $ "spectacle -ab" <> toFile)
  ]
 -- where
  --  toFile = "--output ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

popupKeys :: [(String, X ())]
popupKeys =
  [ ("M-o"  , shellPrompt myXPConfig )
  , ("M-q"  , spawn "xmonad --recompile; xmonad --restart")
  , ("M-S-q", spawn "~/bin/powermenu.sh")
  , ("M-v"  , spawn clipboard)
  , ("M-b"  , sendMessage ToggleStruts)
  ]
  where
    clipboard = "rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'" -- -theme ~/.config/rofi/launcher/style.rasi

audioKeys :: [(String, X ())]
audioKeys =
  [ ("<XF86AudioRaiseVolume>", spawn "amixer -D pulse sset Master 5%+" )
  , ("<XF86AudioLowerVolume>", spawn "amixer -D pulse sset Master 5%-" )
  , ("<XF86AudioMute>", spawn "amixer -D pulse sset Master toggle" )
  ]

lightLeys :: [(String, X ())]
lightLeys =
  [ ("<XF86MonBrightnessUp>", spawn "light -A 10")
  , ("<XF86MonBrightnessDown>", spawn "light -U 10")
  ]

promptKeys :: [(String, X ())]
promptKeys =
  [ ("M-x"    , shellPrompt myXPConfig)
  , ("M-S-x n", buildPrompt @RunScript)
  , ("M-S-x s", searchPrompt          )
  ]

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "polybar -r -c ~/.xmonad/polybar/polybar top"
  spawnOnce "feh --bg-center ~/wallpapers/wp-arcane.png"
  spawnOnce "greenclip daemon"
  spawnOnOnce (head myWorkspaces) "alacritty"
  spawnOnOnce (myWorkspaces !! 1) "firefox"
  spawnOnOnce (myWorkspaces !! 8) "pavucontrol"
  traverse_ spawnOnce (messengers <> workMessengers)

messengers :: [String]
messengers =
  [ "nheko"
  , "discord"
  , "telegram-desktop"
  ]

workMessengers :: [String]
workMessengers =
  [ "slack"
  , "thunderbird"
  ]

myLayoutHook = avoidStruts
             $ smartBorders
             $ minimize
             $ maximizeWithPadding 0 layout
  where
    layout = tiled
         ||| threeColMid
         ||| tabbed shrinkText tabConfig
         ||| Grid
         ||| Full

    tiled = Tall nmaster delta ratio
    threeColMid = ThreeColMid nmaster delta ratio
    tabConfig = def
      { inactiveBorderColor = "#FF0000"
      , activeTextColor = "#00FF00"
      }
    nmaster = 1
    ratio = 1 / 2
    delta = 5 / 100

myManageHook :: ManageHook
myManageHook = composeAll $
  [ isDialog  --> doCenterFloat
  , className =? "Polybar" --> doLower
  , moveWinTo 8 "pavucontrol"
  ]
  <> map (moveWinTo 2) messengers
  <> map (moveWinTo 4) workMessengers
  where
    moveWinTo n window = className =? window --> moveTo n

moveTo :: Int -> ManageHook
moveTo n = doF $ W.shift (myWorkspaces !! n)

digitKeys :: [String]
digitKeys = map (show @Int) [1..9]

class MyPrompt a where
  name    :: String
  compl   :: [String]
  handler :: String -> X ()

buildPrompt :: forall a. MyPrompt a => X ()
buildPrompt = inputPromptWithCompl myXPConfig (name @a) promptCompl ?+ (handler @a)
  where
    promptCompl = mkComplFunFromList' myXPConfig (compl @a)

searchPrompt :: X ()
searchPrompt = promptSearchBrowser myXPConfig "firefox" google

data RunScript

instance MyPrompt RunScript where
  name  = "Run nixpkgs app"
  compl = ["element-desktop"]

  handler = spawn . nixApp

nixApp = ("nix run nixpkgs#" <>)
