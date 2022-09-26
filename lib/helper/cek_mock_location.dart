import 'package:trust_location/trust_location.dart';

class CekMockLocation {
  bool _isMockLocation = false;
  bool get isMockLocation => this._isMockLocation;

  runCekMockLocation() async {
    TrustLocation.start(5);

    /// the stream getter where others can listen to.
    TrustLocation.onChange.listen((values) => {
          _isMockLocation = values.isMockLocation!,
          print(
              '${values.latitude} ${values.longitude} ${values.isMockLocation}')
        });
    // bool isMockLocation = await TrustLocation.isMockLocation;
    // print(isMockLocation);
  }

  Future<bool> getValueMockLocation() async {
    _isMockLocation = await TrustLocation.isMockLocation;
    print('ini hasil cek mock location $_isMockLocation <<<<=====');
    return _isMockLocation;
  }

  bool valueMockLocation() {
    return _isMockLocation;
  }
}
