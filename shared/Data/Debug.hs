{-# LANGUAGE TemplateHaskell #-}

module Data.Debug (
  interpolateRaw,
  interpolateValue,
  interpolateAppend,
  interpolateEmpty,
  interpolateFinalize,
) where

import Data.String.Interpolate.Experimental qualified as S
import Language.Haskell.TH
import Language.Haskell.TH.Syntax

interpolateRaw :: String -> ExpQ
interpolateRaw = lift

interpolateValue :: ExpQ -> ExpQ
interpolateValue expq = do
  exp <- expq
  let expStr = pprint exp
  [| expStr <> " = " <> S.interpolate $(expq) |]

interpolateAppend :: ExpQ -> ExpQ -> ExpQ
interpolateAppend l r = [| $(l) <> $(r) |]

interpolateEmpty :: ExpQ
interpolateEmpty = [| mempty |]

interpolateFinalize :: ExpQ -> ExpQ
interpolateFinalize = id
