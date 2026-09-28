import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:rsrvd_service_provider/app.dart';
import 'package:rsrvd_service_provider/core/localization/localization_service.dart';
import 'package:rsrvd_service_provider/core/services/storage_service.dart';
import 'package:rsrvd_service_provider/data/repositories/user_repository.dart';

class _FakePathProvider extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    PathProviderPlatform.instance = _FakePathProvider();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() async {
    Get.reset();
    await GetStorage.init();
    Get.put(StorageService(), permanent: true);
    Get.put(UserRepository(), permanent: true);
    Get.put(LocalizationService(), permanent: true);
  });

  tearDown(Get.reset);

  testWidgets('Splash shows app name', (WidgetTester tester) async {
    await tester.pumpWidget(const RsrvdServiceProviderApp());
    await tester.pump();
    expect(find.text('RSRVD PROVIDER'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });
}
