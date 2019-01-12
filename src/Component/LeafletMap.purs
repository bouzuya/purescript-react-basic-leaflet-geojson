module Component.LeafletMap
  ( map
  ) where

import Prelude

import Bouzuya.Data.GeoJSON (GeoJSON)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import React.Basic (Component, JSX, ReactComponent, Self, StateUpdate(..), createComponent, element, make, send)
import React.Basic.DOM as H
import Simple.JSON as SimpleJSON

data LeafletElement

foreign import getZoom :: LeafletElement -> Effect Number
foreign import leafletGeoJSON :: forall props. ReactComponent { | props }
foreign import leafletMap :: forall props. ReactComponent { | props }
foreign import leafletTileLayer :: forall props. ReactComponent { | props }
foreign import myMap :: forall props. ReactComponent { | props }

type Props =
  { centerLatitude :: Number
  , centerLongitude :: Number
  , geoJson :: Maybe GeoJSON
  , onZoomChanged :: Number -> Effect Unit
  , zoom :: Number
  }

type State =
  {}

data Action
  = Noop

component :: Component Props
component = createComponent "App"

map :: Props -> JSX
map = make component { initialState, render, update }

initialState :: State
initialState =
  {}

render :: Self Props State Action -> JSX
render self =
  H.div
  { className: "leaflet-map"
  , children:
    [ H.div
      { className: "header"
      , children:
        [ H.h1_
          [ H.text "Leaflet Map" ]
        ]
      }
    , H.div
      { className: "body"
      , children:
        [ element
            myMap
            { center: [self.props.centerLatitude, self.props.centerLongitude]
            , zoom: self.props.zoom
            , children:
              [ element
                  leafletTileLayer
                  { attribution: "&copy; <a href=\"http://osm.org/copyright\">OpenStreetMap</a> contributors"
                  , url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                  }
              ] <>
              case self.props.geoJson of
                Nothing -> []
                Just geoJson ->
                  [ element leafletGeoJSON { data: SimpleJSON.write geoJson }
                  ]
            , onZoom:
                \leafletElement -> do
                  zoom <- getZoom leafletElement
                  self.props.onZoomChanged zoom
            }
        ]
      }
    , H.div
      { className: "footer" }
    ]
  }

update :: Self Props State Action -> Action -> StateUpdate Props State Action
update self Noop = NoUpdate
