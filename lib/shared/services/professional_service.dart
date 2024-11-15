import '../model/professional_entity.dart';
import 'base_service.dart';

class ProfessionalService extends BaseService<Professional> {
  ProfessionalService() : super(resourceEndpoint: '/professionals');

  @override
  Professional fromJson(Map<String, dynamic> json) {
    return Professional.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Professional item) {
    return item.toJson();
  }


}