module Utilities.Config(
    fetchConfig
) where

data Configuration = Configuration {
    property::String,
    value::String
}

config :: [Configuration]
config = [  Configuration {property = "MODE",value = "DEVELOPMENT"}]

fetchConfigValue :: [Configuration] -> String -> String
fetchConfigValue [] _ = "Invalid"
fetchConfigValue (x:xs) prop
    | property x == prop = value x
    | otherwise = fetchConfigValue xs prop

fetchConfig :: String -> String
fetchConfig prop = fetchConfigValue config prop
