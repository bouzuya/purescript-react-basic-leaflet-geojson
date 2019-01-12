module Component.App
  ( app
  ) where

import Prelude

import Bouzuya.Data.GeoJSON (GeoJSON)
import Component.LeafletMap as LeafletMap
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number as Number
import Math as Math
import React.Basic (Component, JSX, Self, StateUpdate(..), capture, createComponent, make, send)
import React.Basic.DOM as H
import React.Basic.DOM.Events (targetValue)
import Simple.JSON as SimpleJSON

type Props =
  {}

type State =
  { lat :: Number
  , lng :: Number
  , zoom :: Number
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
  { lat: 35.000001
  , lng: 135.000001
  , geoJson: Nothing
  , geoJsonText: ""
  , zoom: 10.0
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
          , step: "0.000001"
          , type: "number"
          , value: show self.state.lat
          }
        , H.input
          { onChange:
              capture
                self
                targetValue
                (\v -> EditLng (fromMaybe "" v))
          , step: "0.000001"
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
          , onCenterChanged: \center -> do
              send self (EditLat (show center.lat))
              send self (EditLng (show center.lng))
          , onZoomChanged: \zoom -> send self (EditZoom (show zoom))
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
    Just n -> Update self.state { lat = (Math.floor (n * 1000000.0)) / 1000000.0 }
update self (EditLng s) =
  case Number.fromString s of
    Nothing -> NoUpdate
    Just n -> Update self.state { lng = (Math.floor (n * 1000000.0)) / 1000000.0 }
update self (EditZoom s) =
  case Number.fromString s of
    Nothing -> NoUpdate
    Just n -> Update self.state { zoom = n }
