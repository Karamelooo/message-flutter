import "package:geolocator/geolocator.dart";

class PermissionGPS {
  Future <Position> init() async {
    bool serviceActived = await Geolocator.isLocationServiceEnabled();
    if(!serviceActived) {
      return Future.error("Le gps n'est pas activé");
    }
    else {
      LocationPermission permission = await Geolocator.checkPermission();
      return checkPermission(permission);
    }
  }
  checkPermission(LocationPermission permission) {
    switch(permission) {
      case LocationPermission.deniedForever : Future.error("L'accès est toujours refusé");
      case LocationPermission.denied : Geolocator.requestPermission().then((value) => checkPermission(value));
      case LocationPermission.unableToDetermine : Geolocator.requestPermission().then((value) => checkPermission(value));
      case LocationPermission.whileInUse : return Geolocator.getCurrentPosition();
      case LocationPermission.always : return Geolocator.getCurrentPosition();
      default : return Future.error("error");
    }
  }
}