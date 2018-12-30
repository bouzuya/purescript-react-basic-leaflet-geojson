module Component.App
  ( app
  ) where

import Bouzuya.Data.GeoJSON (GeoJSON)
import Component.LeafletMap as LeafletMap
import Data.Maybe (Maybe(..), fromMaybe)
import React.Basic (Component, JSX, Self, StateUpdate(..), capture, createComponent, make)
import React.Basic.DOM as H
import React.Basic.DOM.Events (targetValue)
import Simple.JSON as SimpleJSON

type Props =
  {}

type State =
  { geoJson :: Maybe GeoJSON
  , geoJsonText :: String
  }

data Action
  = EditJSON String

component :: Component Props
component = createComponent "App"

app :: JSX
app = make component { initialState, render, update } {}

initialState :: State
initialState =
  { geoJson: Nothing
  , geoJsonText: ""
  }

render :: Self Props State Action -> JSX
render self =
  H.div
  { className: "app"
  , children:
    [ H.div
      { className: "header"
      , children:
        [ H.h1_
          [ H.text "App" ]
        ]
      }
    , H.div
      { className: "body"
      , children:
        [ H.textarea
          { onChange:
              capture
                self
                targetValue
                (\v -> EditJSON (fromMaybe "" v))
          , value: self.state.geoJsonText }
        , LeafletMap.map { geoJson: self.state.geoJson }
        ]
      }
    , H.div
      { className: "footer" }
    ]
  }

update :: Self Props State Action -> Action -> StateUpdate Props State Action
update self (EditJSON s) =
  Update
    self.state
      { geoJson = SimpleJSON.readJSON_ s
      , geoJsonText = s
      }
