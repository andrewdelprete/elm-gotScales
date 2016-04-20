module Ishizer (..) where

import Regex exposing (..)

ishizer : String -> String
ishizer str = ishMatch1 str |> ishMatch2 |> ishMatch3

-- Match is, iss, and ish
ishMatch1 = replace All (regex "(is?s)(?:h)*") (\{match} -> "ish")

-- Match it's
ishMatch2 = replace All (regex "(^|s)(it)(?:')*s") (\{match} -> "ish")

-- Match ishe (fixes things like dishguish (disguise))
ishMatch3 = replace All (regex "ishe") (\{match} -> "ise")
