import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetai/features/profile/service/user_service.dart';
import 'package:budgetai/features/auth/login/bloc/login_bloc.dart';
import 'package:budgetai/features/auth/register/bloc/register_bloc.dart';
import 'package:budgetai/features/profile/bloc/profile_bloc.dart';
import 'package:budgetai/features/theme/bloc/theme_bloc.dart';
import 'package:budgetai/features/sms/bloc/sms_bloc.dart';
import 'package:budgetai/features/budget/bloc/budget_bloc.dart';

class CustomMultiBlocProvider extends StatelessWidget {
  final Widget child;
  final UserService userService;

  const CustomMultiBlocProvider({
    super.key,
    required this.child,
    required this.userService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(userService: userService),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(userService: userService),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(userService: userService),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => SmsBloc(),
        ),
        BlocProvider(
          create: (context) => BudgetBloc(),
        ),
      ],
      child: child,
    );
  }
}
