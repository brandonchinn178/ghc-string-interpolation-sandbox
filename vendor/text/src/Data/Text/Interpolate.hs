{-# LANGUAGE RankNTypes #-}

module Data.Text.Interpolate (
  module X,
  interpolateFinalize,
) where

import Data.String (IsString, fromString)
import Data.String.Experimental as X hiding (interpolateFinalize)
import qualified Data.String.Experimental as S
import Data.Text (Text)

interpolateFinalize :: (forall s. (IsString s, Monoid s) => s) -> Text
interpolateFinalize x = fromString (S.interpolateFinalize x)
{-# INLINE interpolateFinalize #-}
