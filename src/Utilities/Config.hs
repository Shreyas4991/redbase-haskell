module Utilities.Config(
    fetchConfig
) where

data Configuration = Configuration {
    property::String,
    value::String
}




fetchConfig :: String -> String
fetchConfig prop
    | property matchingProp == prop = value matchingProp
    | otherwise = "NOT Found"
        where
            matchingProp = if (null specConfig) then Configuration{property="not found",value = "not found"} else head config
            specConfig = [x | x<-config, (property x) == prop]
            config = [  Configuration {property = "MODE",value = "DEVELOPMENT"}]
