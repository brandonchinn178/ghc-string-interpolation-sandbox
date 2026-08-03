{-# LANGUAGE RequiredTypeArguments #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Data.Ascii where

import Data.Kind (Constraint)
import Data.Proxy (Proxy (..))
import Data.Type.Bool (type (&&))
import GHC.TypeLits
import GHC.TypeNats (type (<=?))

fromString :: forall (s :: Symbol) -> (KnownSymbol s, AsciiOnly s) => String
fromString s = symbolVal (Proxy @s)

interpolateRaw :: forall (s :: Symbol) -> (KnownSymbol s, AsciiOnly s) => String
interpolateRaw = fromString

interpolateValue :: InterpolateAscii a => a -> String
interpolateValue = interpolateAscii

interpolateAppend :: String -> String -> String
interpolateAppend = (<>)

interpolateEmpty :: String
interpolateEmpty = ""

interpolateFinalize :: String -> String
interpolateFinalize = id

class InterpolateAscii a where
  interpolateAscii :: a -> String
instance InterpolateAscii Int where
  interpolateAscii = show

-- | A usable constraint that raises a nice TypeError on failure.
type AsciiOnly :: Symbol -> Constraint
type family AsciiOnly s where
  AsciiOnly s = Unless (IsAscii s) (
      TypeError ('Text "Symbol " ':<>: 'ShowType s ':<>: 'Text " is not ASCII-only")
    )

type Unless :: Bool -> Constraint -> Constraint
type family Unless s b where
  Unless 'True _ = ()
  Unless 'False c = c

-- | Walk the Symbol one Char at a time via UnconsSymbol.
type IsAscii :: Symbol -> Bool
type family IsAscii s where
  IsAscii s = IsAsciiGo (UnconsSymbol s)

type IsAsciiGo :: Maybe (Char, Symbol) -> Bool
type family IsAsciiGo m where
  IsAsciiGo 'Nothing            = 'True
  IsAsciiGo ('Just '(c, rest))  = (CharToNat c <=? 127) && IsAscii rest
