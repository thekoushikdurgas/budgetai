import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:budgetai/core/services/shared_preferences_service.dart';
import 'package:budgetai/core/utils/bloc/custom_multi_bloc_provider.dart';
import 'package:budgetai/core/utils/localization/localization_manager.dart';
import 'package:budgetai/core/utils/router/router_manager.dart';
import 'package:budgetai/features/theme/bloc/theme_bloc.dart';
import 'package:budgetai/features/theme/bloc/theme_state.dart';
// import 'package:budgetai/firebase_options.dart';
import 'package:budgetai/common/helpers/ui_helper.dart';
import 'package:budgetai/core/services/theme_service.dart';
import 'package:budgetai/features/profile/service/user_service.dart';

void main() async {
  await dotenv.load();
  await SharedPreferencesService.instance.init();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  ThemeService.getTheme();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final userService = UserService();

  runApp(
    CustomMultiBlocProvider(
      userService: userService,
      child: LocalizationManager(child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    ThemeService.initialize(context);
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    ThemeService.autoChangeTheme(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    UIHelper.initialize(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return CupertinoApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Template App',
          theme: ThemeService.buildTheme(themeState),
          debugShowCheckedModeBanner: false,
          routerConfig: RouterManager.router,
        );
      },
    );
  }
}
