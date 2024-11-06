import 'base_service.dart';
import '../model/professional_entity.dart';

class ProfessionalService extends BaseService<Professional> {
  ProfessionalService() : super(resourceEndPoint: '/profiles/professionals');

  @override
  Professional fromJson(Map<String, dynamic> json) {
    return Professional.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Professional item) {
    return item.toJson();
  }


}