import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_it_now/shared/layout/main_layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalCupertinoLocalizations, GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'core/config/theme.dart';
import 'core/network/dio_client.dart';
import 'core/storage/local_storage.dart';
import 'features/authentication/data/repositories/auth_repository.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/network/dio_client.dart';
import 'core/storage/local_storage.dart';
import 'features/authentication/data/repositories/auth_repository.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/authentication/presentation/screens/login_screen.dart';
import 'features/tracking/data/repositories/activity_repository.dart';
import 'features/tracking/presentation/cubit/activity_cubit.dart';
import 'shared/layout/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(sharedPreferences);

  // Initialize Dio client
  final dioClient = DioClient();

  // Initialize repositories
  final authRepository = AuthRepository(dioClient, localStorage);
  final activityRepository = ActivityRepository(dioClient, localStorage);

  runApp(MyApp(
    localStorage: localStorage,
    authRepository: authRepository,
    activityRepository: activityRepository,
  ));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;
  final AuthRepository authRepository;
  final ActivityRepository activityRepository;

  const MyApp({
    Key? key,
    required this.localStorage,
    required this.authRepository,
    required this.activityRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository)..checkAuthStatus(),
        ),
        BlocProvider<ActivityCubit>(
          create: (context) => ActivityCubit(activityRepository),
        ),
      ],
      child: MaterialApp(
        title: 'تڕاک ئیت ناو',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        // Note: We're using ar locale but our texts are in Kurdish
        locale: const Locale('ar'),  // Using Arabic locale for RTL and localization support
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar'),  // Arabic for RTL and localization support
        ],
        builder: (context, child) {
          return Directionality(
            // Set text direction to RTL for Kurdish
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const MainLayout();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}




