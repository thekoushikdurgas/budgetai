import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:budgetai/core/utils/router/routes.dart';
import 'package:budgetai/features/auth/login/bloc/login_bloc.dart';
import 'package:budgetai/features/auth/login/bloc/login_event.dart';
import 'package:budgetai/features/auth/login/bloc/login_state.dart';
import 'package:budgetai/features/auth/register/bloc/register_bloc.dart';
import 'package:budgetai/features/auth/register/bloc/register_event.dart';
import 'package:budgetai/features/profile/bloc/profile_bloc.dart';
import 'package:budgetai/features/profile/bloc/profile_event.dart';
import 'package:budgetai/core/constants/app_constants.dart';
import 'package:budgetai/generated/codegen_loader.g.dart';
import 'package:budgetai/common/helpers/app_helper.dart';
import 'package:budgetai/features/profile/model/user_model.dart';
import 'package:budgetai/features/profile/service/user_service.dart';
part "splash_view_mixin.dart";

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SplashViewMixin {
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    final RegisterBloc registerBloc = BlocProvider.of<RegisterBloc>(context);
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    return CupertinoPageScaffold(
      child: FutureBuilder(
        future: _future(context),
        builder: (context, snapshot) {
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (snapshot.hasData) {
                _listener(
                  state,
                  loginBloc: loginBloc,
                  profileBloc: profileBloc,
                  registerBloc: registerBloc,
                );
              }
            },
            child: const Center(child: CupertinoActivityIndicator()),
          );
        },
      ),
    );
  }
}
