import 'dart:developer';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:urban_koala/gen/colors.gen.dart';

import '../constants/app_constants.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import 'di.dart';

// need to add permisson for both android and ios

class LocationService {
  // Private static instance (Singleton pattern)
  static final LocationService _singleton = LocationService._internal();

  // Private constructor
  LocationService._internal();

  // Public factory constructor
  static LocationService get instance => _singleton;

  // Boolean variable to track location permission status
  bool isLocationPermissionGranted = false;

  // Flag to indicate if location permission has been checked
  bool isLocationPermissionChecked = false;

  // Method to initialize GetStorage and check for location permission
  Future<void> initialize() async {
    await _checkLocationPermission();
  }

  // Method to refresh location
  Future<void> refreshLocation() async {
    if (isLocationPermissionGranted) {
      if (await checkLocationService()) {
        await _updateLocation();
      }
    } else {
      await _checkLocationPermission();
    }
  }

  Future<void> checkPermissionWithDialog() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      BuildContext? context = NavigationService.context;
      if (context != null && context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 60,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Enable Location",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "We need your location permission to show nearby services and improve your experience.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        LocationPermission permission =
                            await Geolocator.checkPermission();

                        if (permission == LocationPermission.deniedForever) {
                          await Geolocator.openAppSettings();
                        } else {
                          permission = await Geolocator.requestPermission();
                          if (permission == LocationPermission.deniedForever) {
                            await Geolocator.openAppSettings();
                          }
                        }

                        // Re-check to update local state
                        permission = await Geolocator.checkPermission();
                        if (permission == LocationPermission.always ||
                            permission == LocationPermission.whileInUse) {
                          isLocationPermissionGranted = true;
                          if (await LocationService.instance
                              .checkLocationService()) {
                            await _updateLocation();
                          }
                          isLocationPermissionChecked = true;
                        }
                      },
                      child: const Text(
                        "Use Current Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      isLocationPermissionGranted = true;
      if (await checkLocationService()) {
        await _updateLocation();
      }
      isLocationPermissionChecked = true;
    }
  }

  // Method to check if location service is enabled and prompt user if not
  Future<bool> checkLocationService({BuildContext? context}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      BuildContext? ctx = context ?? NavigationService.context;
      if (ctx != null && ctx.mounted) {
        await showDialog(
          context: ctx,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_off_rounded,
                    size: 60,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Location Service Disabled",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please enable location services to use this feature.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await Geolocator.openLocationSettings();
                      },
                      child: const Text(
                        "Enable Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "No Thanks",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        // Re-check status after dialog is closed
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      }
    }
    return serviceEnabled;
  }

  // Method to check and handle location permission
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If permission is denied, update the boolean variable
        isLocationPermissionGranted = false;
        isLocationPermissionChecked = true;
        return;
      } else if (permission == LocationPermission.deniedForever) {
        // Open app settings if permission is permanently denied
        // await Geolocator.openAppSettings();
        isLocationPermissionGranted = false;
        isLocationPermissionChecked = true;
        return;
      }
    }

    // If permission is granted, update the boolean variable and fetch the current location
    isLocationPermissionGranted = true;
    if (await checkLocationService()) {
      await _updateLocation();
    }
    isLocationPermissionChecked = true;
  }

  // Method to update location and save to GetStorage
  Future<void> _updateLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high));

      // Save the latitude and longitude to GetStorage
      await appData.write(kKeySelectedLat, position.latitude);
      await appData.write(kKeySelectedLng, position.longitude);

      // Get location name from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String locationName =
            "${place.street}, ${place.administrativeArea}, ${place.country}";

        // Save location name to GetStorage
        await appData.write(kKeySelectedLocation, locationName);

        log("Location updated: Lat: ${position.latitude}, Long: ${position.longitude}, Name: $locationName");
      } else {
        log("No placemarks found");
      }
    } catch (e) {
      log("Error fetching location: $e");
    }
  }

  // Method to calculate the distance using saved lat/long and given lat/long
  String? calculateDistance(double? lat, double? long) {
    try {
      double? savedLat = appData.read(kKeySelectedLat);
      double? savedLong = appData.read(kKeySelectedLng);

      if (savedLat == null || savedLong == null) {
        log("Location data is not available in storage.");
        return null;
      }
      if (lat == null || long == null) {
        log("Location data is not provided.");
        return null;
      }

      // Calculate distance using Geolocator
      double distanceInMeters = Geolocator.distanceBetween(
        savedLat,
        savedLong,
        lat,
        long,
      );

      // Convert to a more readable format (meters or kilometers)
      if (distanceInMeters < 1000) {
        return "${distanceInMeters.toInt()}m"; // For distances less than 1 km, show in meters
      } else {
        double distanceInKilometers = distanceInMeters / 1000;
        return "${distanceInKilometers.toInt()}km"; // For distances greater than 1 km, show in kilometers
      }
    } catch (e) {
      log("Error calculating distance: $e");
      return null;
    }
  }
}

Future<String?> letLonToAddress(double? lat, double? long) async {
  try {
    if (lat == null || long == null) {
      log("Location data is not provided.");
      return null;
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String locationName =
          "${place.street}, ${place.administrativeArea}, ${place.country}";

      return locationName;
    } else {
      log("No placemarks found");
      return null;
    }
  } catch (e) {
    log("Error fetching address: $e");
    return null;
  }
}

Future<LatLng?> addressToLatLong(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);

    if (locations.isNotEmpty) {
      double latitude = locations.first.latitude;
      double longitude = locations.first.longitude;

      return LatLng(latitude, longitude);
    }
  } catch (e) {
    log("Error fetching address: $e");
    return null;
  }
  return null;
}
