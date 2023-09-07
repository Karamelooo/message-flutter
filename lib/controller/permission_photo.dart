import 'package:permission_handler/permission_handler.dart';

class PermissionPhoto {

  init() async {
  PermissionStatus permissionStatus = await Permission.photos.status;
  checkPermission(permissionStatus);

  }

  Future<PermissionStatus> checkPermission(PermissionStatus status) {
    switch(status) {
      case PermissionStatus.permanentlyDenied : return Future.error("L'utilisateur ne souhaite pas");
      case PermissionStatus.denied : return Permission.photos.request().then((value) => checkPermission(value));
      case PermissionStatus.restricted : return Permission.photos.request().then((value) => checkPermission(value));
      case PermissionStatus.provisional : return Permission.photos.request().then((value) => checkPermission(value));
      case PermissionStatus.limited : return Permission.photos.request().then((value) => checkPermission(value));
      case PermissionStatus.granted : return Permission.photos.request().then((value) => checkPermission(value));
    }
  }
}