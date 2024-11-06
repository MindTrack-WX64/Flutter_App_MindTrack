import 'package:mind_track_flutter_app/shared/services/base_service.dart';
import '../model/clinical_history_entity.dart';


class ClinicalHistoryService extends BaseService<ClinicalHistory> {
  ClinicalHistoryService() : super(resourceEndPoint: '/clinicalHistories');

  @override
  ClinicalHistory fromJson(Map<String, dynamic> json) {
    return ClinicalHistory.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ClinicalHistory item) {
    return item.toJson();
  }

}