"use strict";

var react = require('react');
var leaflet = require('react-leaflet');

exports.getCenter = function (leafletElement) {
  return function () {
    return leafletElement.getCenter();
  };
};

exports.getZoom = function (leafletElement) {
  return function () {
    return leafletElement.getZoom();
  };
};

exports.leafletGeoJSON = leaflet.GeoJSON;
exports.leafletMap = leaflet.Map;
exports.leafletTileLayer = leaflet.TileLayer;

exports.myMap = function (props) {
  var ref = react.createRef();
  var listeners =
    Object
      .keys(props)
      .filter(function (i) { return i.match(/^on[A-Z]/) !== null; })
      .map(function (key) { return { key: key, value: props[key] }; })
      .reduce(function (a, i) {
        a[i.key] = function () {
          var e = ref.current;
          if (e !== null) {
            i.value(e.leafletElement)();
          }
        };
        return a;
      }, {});
  return react.createElement(
    leaflet.Map,
    Object.assign({}, props, listeners, { ref: ref })
  );
};
