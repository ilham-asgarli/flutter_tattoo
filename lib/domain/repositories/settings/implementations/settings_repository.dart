import 'package:tattoo/backend/features/settings/implementations/backend_settings.dart';
import 'package:tattoo/backend/features/settings/interfaces/backend_settings_interface.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/settings/settings_model.dart';

class SettingsRepository extends SettingsInterface {
  BackendSettings backendSettings = BackendSettings();

  @override
  Stream<BaseResponse<SettingsModel>> getDesignRequestsSettingsStream() {
    Stream<BaseResponse<SettingsModel>> stream =
        backendSettings.getDesignRequestsSettingsStream();
    return stream;
  }
}
