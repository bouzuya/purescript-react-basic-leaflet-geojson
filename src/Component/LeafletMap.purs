module Component.LeafletMap
  ( map
  ) where

import React.Basic (Component, JSX, ReactComponent, Self, StateUpdate(..), createComponent, element, make)
import React.Basic.DOM as H

foreign import leafletGeoJSON :: forall props. ReactComponent { | props }
foreign import leafletMap :: forall props. ReactComponent { | props }
foreign import leafletTileLayer :: forall props. ReactComponent { | props }

type Props =
  { geojson :: String }

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
            leafletMap
            { center: [35.0, 135.0]
            , zoom: 10.0
            , children:
              [ element
                  leafletTileLayer
                  { attribution: "&copy; <a href=\"http://osm.org/copyright\">OpenStreetMap</a> contributors"
                  , url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                  }
              , element
                  leafletGeoJSON
                  { data: -- TODO
                    {
                      "type": "Feature",
                      "properties": {
                          "name": "Busch Field",
                          "show_on_map": true
                      },
                      "geometry": {
                          "type": "Point",
                          "coordinates": [135.0, 35.0]
                      }
                    }
                  }
              ]
            }
        ]
      }
    , H.div
      { className: "footer" }
    ]
  }

update :: Self Props State Action -> Action -> StateUpdate Props State Action
update self Noop = NoUpdate
