import 'base_service.dart';
import '../model/patient_entity.dart';

class PatientService extends BaseService<Patient> {
  PatientService() : super(resourceEndPoint: '/patients');

  @override
  Patient fromJson(Map<String, dynamic> json) {
    return Patient.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Patient item) {
    return item.toJson();
  }
}