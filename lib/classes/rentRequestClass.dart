import 'package:kotc/classes/availableKitchens.dart';
import 'package:kotc/classes/user.dart';

class RentRequestClass {
  UserInfoOwn? user;
  AvailableKitchens? kitchen;

  RentRequestClass({
    required this.user,
    required this.kitchen,
  });

  void setUser(UserInfoOwn u) {
    user = u;
  }

  void setKitchen(AvailableKitchens k) {
    kitchen = k;
  }
}
