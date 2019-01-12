module Component.App
  ( app
  ) where

import Prelude

import Bouzuya.Data.GeoJSON (GeoJSON)
import Component.LeafletMap as LeafletMap
import Data.Int as Int
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number as Number
import React.Basic (Component, JSX, Self, StateUpdate(..), capture, createComponent, make)
import React.Basic.DOM as H
import React.Basic.DOM.Events (targetValue)
import Simple.JSON as SimpleJSON

type Props =
  {}

type State =
  { lat :: Number
  , lng :: Number
  , zoom :: Int
  , geoJson :: Maybe GeoJSON
  , geoJsonText :: String
  }

data Action
  = EditJSON String
  | EditLat String
  | EditLng String
  | EditZoom String

component :: Component Props
component = createComponent "App"

app :: JSX
app = make component { initialState, render, update } {}

initialState :: State
initialState =
  { lat: 35.0
  , lng: 135.0
  , geoJson: Nothing
  , geoJsonText: ""
  , zoom: 10
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
        [ H.input
          { onChange:
              capture
                self
                targetValue
                (\v -> EditLat (fromMaybe "" v))
          , step: "0.1"
          , type: "number"
          , value: show self.state.lat
          }
        , H.input
          { onChange:
              capture
                self
                targetValue
                (\v -> EditLng (fromMaybe "" v))
          , step: "0.1"
          , type: "number"
          , value: show self.state.lng
          }
        , H.input
          { onChange:
              capture
                self
                targetValue
                (\v -> EditZoom (fromMaybe "" v))
          , type: "number"
          , value: show self.state.zoom
          }
        , H.br {}
        , H.textarea
          { onChange:
              capture
                self
                targetValue
                (\v -> EditJSON (fromMaybe "" v))
          , value: self.state.geoJsonText
          }
        , H.span
          { style: H.css { whiteSpace: "pre" }
          , children:
            [ H.text """
{
  "type": "Feature",
  "properties": null,
  "geometry": {
      "type": "Point",
      "coordinates": [135.0, 35.0]
  }
}
              """
            ]
          }
        , LeafletMap.map
          { centerLatitude: self.state.lat
          , centerLongitude: self.state.lng
          , geoJson: self.state.geoJson
          , zoom: self.state.zoom
          }
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
update self (EditLat s) =
  case Number.fromString s of
    Nothing -> NoUpdate
    Just n -> Update self.state { lat = n }
update self (EditLng s) =
  case Number.fromString s of
    Nothing -> NoUpdate
    Just n -> Update self.state { lng = n }
update self (EditZoom s) =
  case Int.fromString s of
    Nothing -> NoUpdate
    Just n -> Update self.state { zoom = n }
