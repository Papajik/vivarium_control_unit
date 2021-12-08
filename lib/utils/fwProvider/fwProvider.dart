import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';

class FirmwareProvider {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<String>> get firmwareList => _databaseService.firmware().first;

  Stream<List<String>> get firmwareStream => _databaseService.firmware();
}
