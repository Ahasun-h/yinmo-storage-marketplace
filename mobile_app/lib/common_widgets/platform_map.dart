import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple_maps;

class PlatformMap extends StatelessWidget {
  final google_maps.CameraPosition initialCameraPosition;
  final Set<PlatformMarker> markers;
  final Set<google_maps.Polygon> polygons;
  final bool zoomControlsEnabled;
  final bool myLocationButtonEnabled;
  final bool myLocationEnabled;
  final google_maps.MapType mapType;
  final Function(google_maps.LatLng)? onTap;
  final Function(PlatformMapController)? onMapCreated;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  const PlatformMap({
    super.key,
    required this.initialCameraPosition,
    this.markers = const {},
    this.polygons = const {},
    this.zoomControlsEnabled = true,
    this.myLocationButtonEnabled = true,
    this.myLocationEnabled = false,
    this.mapType = google_maps.MapType.normal,
    this.onTap,
    this.onMapCreated,
    this.gestureRecognizers,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return FutureBuilder<Set<apple_maps.Annotation>>(
        future: _createAppleAnnotations(),
        builder: (context, snapshotMarkers) {
          return FutureBuilder<Set<apple_maps.Polygon>>(
              future: _createApplePolygons(),
              builder: (context, snapshotPolygons) {
                if (!snapshotMarkers.hasData || !snapshotPolygons.hasData) {
                  return const SizedBox();
                }
                return apple_maps.AppleMap(
                  initialCameraPosition:
                      _toAppleCameraPosition(initialCameraPosition),
                  mapType: _toAppleMapType(mapType),
                  annotations: snapshotMarkers.data!,
                  polygons: snapshotPolygons.data!,
                  myLocationEnabled: myLocationEnabled,
                  myLocationButtonEnabled: myLocationButtonEnabled,
                  gestureRecognizers: gestureRecognizers ?? {},
                  onTap: onTap != null
                      ? (latLng) => onTap!(
                          google_maps.LatLng(latLng.latitude, latLng.longitude))
                      : null,
                  onMapCreated: (controller) {
                    onMapCreated
                        ?.call(PlatformMapController.fromApple(controller));
                  },
                );
              });
        },
      );
    } else {
      return FutureBuilder<Set<google_maps.Marker>>(
        future: _createGoogleMarkers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          return google_maps.GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: snapshot.data!,
            polygons: polygons,
            zoomControlsEnabled: zoomControlsEnabled,
            myLocationButtonEnabled: myLocationButtonEnabled,
            myLocationEnabled: myLocationEnabled,
            mapType: mapType,
            gestureRecognizers: gestureRecognizers ?? {},
            onTap: onTap,
            onMapCreated: (controller) {
              onMapCreated?.call(PlatformMapController.fromGoogle(controller));
            },
          );
        },
      );
    }
  }

  Future<Set<apple_maps.Polygon>> _createApplePolygons() async {
    final applePolygons = <apple_maps.Polygon>{};
    for (final poly in polygons) {
      applePolygons.add(apple_maps.Polygon(
        polygonId: apple_maps.PolygonId(poly.polygonId.value),
        points: poly.points
            .map((e) => apple_maps.LatLng(e.latitude, e.longitude))
            .toList(),
        fillColor: poly.fillColor,
        strokeColor: poly.strokeColor,
        strokeWidth: poly.strokeWidth,
        visible: poly.visible,
      ));
    }
    return applePolygons;
  }

  Future<Set<apple_maps.Annotation>> _createAppleAnnotations() async {
    final annotations = <apple_maps.Annotation>{};
    for (final marker in markers) {
      final icon = await marker.icon.toAppleMaps();
      annotations.add(apple_maps.Annotation(
        annotationId: apple_maps.AnnotationId(marker.markerId.value),
        position: apple_maps.LatLng(
            marker.position.latitude, marker.position.longitude),
        icon: icon,
        infoWindow: apple_maps.InfoWindow(
          title: marker.infoWindow.title,
          snippet: marker.infoWindow.snippet,
        ),
        onTap: marker.onTap,
      ));
    }
    return annotations;
  }

  Future<Set<google_maps.Marker>> _createGoogleMarkers() async {
    final googleMarkers = <google_maps.Marker>{};
    for (final marker in markers) {
      final icon = await marker.icon.toGoogleMaps();
      googleMarkers.add(google_maps.Marker(
        markerId: marker.markerId,
        position: marker.position,
        icon: icon,
        infoWindow: marker.infoWindow,
        onTap: marker.onTap,
      ));
    }
    return googleMarkers;
  }

  apple_maps.CameraPosition _toAppleCameraPosition(
      google_maps.CameraPosition pos) {
    return apple_maps.CameraPosition(
      target: apple_maps.LatLng(pos.target.latitude, pos.target.longitude),
      zoom: pos.zoom,
      heading: pos.bearing,
      pitch: pos.tilt,
    );
  }

  apple_maps.MapType _toAppleMapType(google_maps.MapType type) {
    switch (type) {
      case google_maps.MapType.normal:
        return apple_maps.MapType.standard;
      case google_maps.MapType.satellite:
        return apple_maps.MapType.satellite;
      case google_maps.MapType.hybrid:
        return apple_maps.MapType.hybrid;
      default:
        return apple_maps.MapType.standard;
    }
  }
}

class PlatformMarker {
  final google_maps.MarkerId markerId;
  final google_maps.LatLng position;
  final PlatformBitmapDescriptor icon;
  final google_maps.InfoWindow infoWindow;
  final VoidCallback? onTap;

  PlatformMarker({
    required this.markerId,
    required this.position,
    required this.icon,
    this.infoWindow = const google_maps.InfoWindow(),
    this.onTap,
  });
}

abstract class PlatformBitmapDescriptor {
  Future<google_maps.BitmapDescriptor> toGoogleMaps();
  Future<apple_maps.BitmapDescriptor> toAppleMaps();

  static PlatformBitmapDescriptor fromBytes(Uint8List bytes,
          {double? imagePixelRatio}) =>
      _BytesPlatformBitmapDescriptor(bytes, imagePixelRatio: imagePixelRatio);
  static PlatformBitmapDescriptor defaultMarker() =>
      _DefaultPlatformBitmapDescriptor();
}

class _BytesPlatformBitmapDescriptor extends PlatformBitmapDescriptor {
  final Uint8List bytes;
  final double? imagePixelRatio;

  _BytesPlatformBitmapDescriptor(this.bytes, {this.imagePixelRatio});

  @override
  Future<google_maps.BitmapDescriptor> toGoogleMaps() async {
    return google_maps.BitmapDescriptor.bytes(bytes,
        imagePixelRatio: imagePixelRatio);
  }

  @override
  Future<apple_maps.BitmapDescriptor> toAppleMaps() async {
    return apple_maps.BitmapDescriptor.fromBytes(bytes);
  }
}

class _DefaultPlatformBitmapDescriptor extends PlatformBitmapDescriptor {
  @override
  Future<google_maps.BitmapDescriptor> toGoogleMaps() async {
    return google_maps.BitmapDescriptor.defaultMarker;
  }

  @override
  Future<apple_maps.BitmapDescriptor> toAppleMaps() async {
    return apple_maps.BitmapDescriptor.defaultAnnotation;
  }
}

class PlatformMapController {
  final google_maps.GoogleMapController? googleController;
  final apple_maps.AppleMapController? appleController;

  PlatformMapController.fromGoogle(this.googleController)
      : appleController = null;
  PlatformMapController.fromApple(this.appleController)
      : googleController = null;

  Future<void> animateCamera(PlatformCameraUpdate update) async {
    if (googleController != null) {
      await googleController!.animateCamera(update.toGoogle());
    } else if (appleController != null) {
      await appleController!.animateCamera(update.toApple());
    }
  }
}

class PlatformCameraUpdate {
  final dynamic _data;
  final String _type;

  PlatformCameraUpdate._(this._data, this._type);

  static PlatformCameraUpdate newLatLngZoom(
      google_maps.LatLng latLng, double zoom) {
    return PlatformCameraUpdate._(
        {'latLng': latLng, 'zoom': zoom}, 'newLatLngZoom');
  }

  static PlatformCameraUpdate newLatLngBounds(
      google_maps.LatLngBounds bounds, double padding) {
    return PlatformCameraUpdate._(
        {'bounds': bounds, 'padding': padding}, 'newLatLngBounds');
  }

  google_maps.CameraUpdate toGoogle() {
    switch (_type) {
      case 'newLatLngZoom':
        return google_maps.CameraUpdate.newLatLngZoom(
          _data['latLng'],
          _data['zoom'],
        );
      case 'newLatLngBounds':
        return google_maps.CameraUpdate.newLatLngBounds(
          _data['bounds'],
          _data['padding'],
        );
      default:
        throw UnimplementedError('CameraUpdate type $_type not implemented');
    }
  }

  apple_maps.CameraUpdate toApple() {
    switch (_type) {
      case 'newLatLngZoom':
        final latLng = _data['latLng'] as google_maps.LatLng;
        return apple_maps.CameraUpdate.newLatLngZoom(
          apple_maps.LatLng(latLng.latitude, latLng.longitude),
          _data['zoom'],
        );
      case 'newLatLngBounds':
        final bounds = _data['bounds'] as google_maps.LatLngBounds;
        return apple_maps.CameraUpdate.newLatLngBounds(
          apple_maps.LatLngBounds(
            southwest: apple_maps.LatLng(
                bounds.southwest.latitude, bounds.southwest.longitude),
            northeast: apple_maps.LatLng(
                bounds.northeast.latitude, bounds.northeast.longitude),
          ),
          _data['padding'],
        );
      default:
        throw UnimplementedError('CameraUpdate type $_type not implemented');
    }
  }
}

Future<Uint8List> widgetToBytes(Widget widget) async {
  final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final RenderView renderView = RenderView(
    view: view,
    child: RenderPositionedBox(
        alignment: Alignment.center, child: repaintBoundary),
    configuration: ViewConfiguration.fromView(view),
  );

  final PipelineOwner pipelineOwner = PipelineOwner();
  final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager.instance);

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  final RenderObjectToWidgetElement<RenderBox> rootElement =
      RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.transparent,
        child: widget,
      ),
    ),
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  final ui.Image image =
      await repaintBoundary.toImage(pixelRatio: view.devicePixelRatio);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}
