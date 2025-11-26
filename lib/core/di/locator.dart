import 'package:get_it/get_it.dart';
import 'package:universal_video_downloader/core/services/navigation_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}
