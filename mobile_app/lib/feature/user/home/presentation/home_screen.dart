import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:urban_koala/common_widgets/platform_map.dart';
import 'package:urban_koala/feature/user/home/model/map_data_model.dart';
import 'package:urban_koala/feature/user/home/widget/custom_marker.dart';
import 'package:urban_koala/feature/user/home/widget/home_app_bar.dart';
import 'package:urban_koala/feature/user/home/widget/single_item_bottom_sheet.dart';
import 'package:urban_koala/gen/colors.gen.dart';
import 'package:urban_koala/gen/assets.gen.dart';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/location_service.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'package:urban_koala/providers/all_providers.dart';
import 'package:provider/provider.dart';
import 'package:urban_koala/helpers/boundary_helper.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../networks/api_access.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TextEditingController searchController = TextEditingController();
  PlatformMapController? mapController;
  PlatformBitmapDescriptor? customIcon;

  final ValueNotifier<Set<PlatformMarker>> _markersNotifier = ValueNotifier({});
  final ValueNotifier<Set<Polygon>> _polygonsNotifier = ValueNotifier({});
  final ValueNotifier<int?> _tappedMarkerIdNotifier = ValueNotifier(null);

  final Map<int, PlatformBitmapDescriptor> _defaultIconsCache = {};
  final Map<int, PlatformBitmapDescriptor> _selectedIconsCache = {};
  bool isSearchData = false;

  List<int>? _lastDataIds;
  AllProviders? _allProviders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allProviders = context.read<AllProviders>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LocationService.instance.checkPermissionWithDialog();
    LocationService.instance.initialize().then((onValue) {
      if (!mounted) return;
      final provider = context.read<AllProviders>();
      postMapDataRxOBJ.post(infoType: provider.selectedInfoType);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LocationService.instance.checkPermissionWithDialog();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _markersNotifier.dispose();
    _polygonsNotifier.dispose();
    _tappedMarkerIdNotifier.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _allProviders?.setInfoType(-1);
    });
    super.dispose();
  }

  Future<void> _createMarkers(List<MapDataModel> data) async {
    if (!mounted) return;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final currentIds = data.map((e) => e.id ?? 0).toList();

    // Ensure images are cached before trying to render them to bytes
    await _precacheImages();

    if (_lastDataIds != null &&
        _lastDataIds!.length == currentIds.length &&
        _lastDataIds!.every((id) => currentIds.contains(id)) &&
        _tappedMarkerIdNotifier.value == null &&
        _markersNotifier.value.isNotEmpty) {
      return;
    }

    Set<PlatformMarker> markers = {};
    final currentTappedId = _tappedMarkerIdNotifier.value;

    for (var e in data) {
      final markerId = e.id ?? UniqueKey().hashCode;
      final isSelected = markerId == currentTappedId;

      PlatformBitmapDescriptor icon;
      PlatformBitmapDescriptor colorIcon;

      if (_defaultIconsCache.containsKey(markerId) &&
          _selectedIconsCache.containsKey(markerId)) {
        icon = _defaultIconsCache[markerId]!;
        colorIcon = _selectedIconsCache[markerId]!;
      } else {
        final iconBytes = await widgetToBytes(CustomMarker(
          type: e.listingType,
          rating: e.averageRating?.toStringAsFixed(1) ?? "0.0",
        ));
        icon = PlatformBitmapDescriptor.fromBytes(
          iconBytes,
          imagePixelRatio: pixelRatio,
        );

        final colorIconBytes = await widgetToBytes(CustomMarker(
          type: e.listingType,
          rating: e.averageRating?.toStringAsFixed(1) ?? "0.0",
          color: Colors.red,
        ));
        colorIcon = PlatformBitmapDescriptor.fromBytes(
          colorIconBytes,
          imagePixelRatio: pixelRatio,
        );

        _defaultIconsCache[markerId] = icon;
        _selectedIconsCache[markerId] = colorIcon;
      }

      markers.add(
        PlatformMarker(
          markerId: MarkerId('$markerId'),
          position: LatLng(e.latitude ?? 0, e.longitude ?? 0),
          // Dynamic Icon Selection
          icon: isSelected ? colorIcon : icon,
          onTap: () async {
            // Capture context before any await to safely use it later
            final sheetContext = context;
            // A. Update the Tapped ID Notifier
            _tappedMarkerIdNotifier.value = markerId;

            // B. Rebuild markers using the new ID (This is now fast due to caching)
            final mapDataRes = MapDataRes.fromJson(
              postMapDataRxOBJ.fileData.value,
            );
            if (mapDataRes.data != null) {
              await _createMarkers(mapDataRes.data!);
            }

            // Show the bottom sheet and wait for it to close
            if (sheetContext.mounted) {
              await showModalBottomSheet(
                backgroundColor: AppColors.cFFFFFF,
                context: sheetContext,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return SingleItemBottomSheet(listId: e.id);
                },
              );
            }

            // C. Reset the selected marker ID and trigger revert
            if (_tappedMarkerIdNotifier.value == markerId) {
              _tappedMarkerIdNotifier.value = null;
              if (mapDataRes.data != null) {
                _createMarkers(mapDataRes.data!);
              }
            }
          },
        ),
      );
    }

    if (mounted) {
      _markersNotifier.value = markers;
      _lastDataIds = currentIds;
    }
  }

  Future<void> _precacheImages() async {
    if (!mounted) return;
    await precacheImage(
      AssetImage(Assets.icons.locationView.path),
      context,
    );
    if (!mounted) return;
    await precacheImage(
      AssetImage(Assets.icons.locationViewRed.path),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllProviders>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: postMapDataRxOBJ.fileData,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!asyncSnapshot.hasError && asyncSnapshot.data != null) {
            MapDataRes? mapDataRes = MapDataRes.fromJson(asyncSnapshot.data);

            // Initial Load/Data Stream Update: Load markers asynchronously.
            if (mapDataRes.data != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _createMarkers(mapDataRes.data!);
              });
            }

            return Column(
              children: [
                HomeAppBar(
                  controller: searchController,
                  notificationTap: () {
                    NavigationService.navigateTo(Routes.notificationList);
                  },
                  onFieldSubmitted: (value) async {
                    // 2. Geocode the address and move the map camera
                    if (value.isNotEmpty) {
                      // Clear previous polygons immediately
                      _polygonsNotifier.value = {};

                      try {
                        // 1. Step 1: Fast Camera Move (Geocoding)
                        List<Location> locations =
                            await locationFromAddress(value);
                        if (locations.isNotEmpty && mapController != null) {
                          final location = locations.first;
                          mapController!.animateCamera(
                            PlatformCameraUpdate.newLatLngZoom(
                              LatLng(location.latitude, location.longitude),
                              10, // General City/Country zoom
                            ),
                          );
                        }

                        // 2. Step 2: Async Boundary Fetch (Background)
                        BoundaryHelper.getBoundaryPoints(value)
                            .then((boundaries) {
                          if (!mounted) return;

                          if (boundaries.isNotEmpty) {
                            Set<Polygon> polygons = {};
                            LatLngBounds? bounds;

                            for (int i = 0; i < boundaries.length; i++) {
                              polygons.add(
                                Polygon(
                                  polygonId: PolygonId('boundary_$i'),
                                  points: boundaries[i],
                                  strokeWidth: 2,
                                  strokeColor: Colors.red,
                                  fillColor: Colors.red.withAlpha(25),
                                ),
                              );

                              // Calculate bounds
                              for (var point in boundaries[i]) {
                                if (bounds == null) {
                                  bounds = LatLngBounds(
                                      southwest: point, northeast: point);
                                } else {
                                  bounds = LatLngBounds(
                                    southwest: LatLng(
                                      point.latitude < bounds.southwest.latitude
                                          ? point.latitude
                                          : bounds.southwest.latitude,
                                      point.longitude <
                                              bounds.southwest.longitude
                                          ? point.longitude
                                          : bounds.southwest.longitude,
                                    ),
                                    northeast: LatLng(
                                      point.latitude > bounds.northeast.latitude
                                          ? point.latitude
                                          : bounds.northeast.latitude,
                                      point.longitude >
                                              bounds.northeast.longitude
                                          ? point.longitude
                                          : bounds.northeast.longitude,
                                    ),
                                  );
                                }
                              }
                            }

                            _polygonsNotifier.value = polygons;

                            // Optional: Re-adjust camera to fit exact bounds
                            if (bounds != null && mapController != null) {
                              mapController!.animateCamera(
                                PlatformCameraUpdate.newLatLngBounds(
                                    bounds, 50),
                              );
                            }
                          }
                        });
                      } catch (e) {
                        debugPrint("Error finding location: $e");
                      }
                    }
                  },
                  selectedIndex: provider.selectedInfoTypeIndex,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Note: This onTap is for the whole screen/GestureDetector
                      showModalBottomSheet(
                        backgroundColor: AppColors.cFFFFFF,
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return const SingleItemBottomSheet();
                        },
                      );
                    },
                    child: ValueListenableBuilder<Set<PlatformMarker>>(
                      valueListenable: _markersNotifier,
                      builder: (context, markers, child) {
                        return ValueListenableBuilder<Set<Polygon>>(
                          valueListenable: _polygonsNotifier,
                          builder: (context, polygons, child) {
                            return PlatformMap(
                              polygons: polygons,
                              onMapCreated: (controller) {
                                mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  appData.read(kKeySelectedLat) ?? 37.7749,
                                  appData.read(kKeySelectedLng) ?? -122.4194,
                                ),
                                zoom: 13,
                              ),
                              myLocationEnabled: true,
                              zoomControlsEnabled: true,
                              mapType: MapType.normal,
                              myLocationButtonEnabled: true,
                              // Use the markers from the ValueNotifier
                              markers: markers,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Error: ${asyncSnapshot.error}'));
          }
        },
      ),
    );
  }
}
