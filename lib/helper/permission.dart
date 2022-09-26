import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class Permission {
  requestLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    return permission;
  }
}
