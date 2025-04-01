import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:budgetai/features/auth/register/bloc/register_bloc.dart';
import 'package:budgetai/features/auth/register/bloc/register_event.dart';
import 'package:budgetai/features/auth/register/bloc/register_state.dart';
import 'package:budgetai/features/theme/bloc/theme_bloc.dart';
import 'package:budgetai/features/theme/bloc/theme_state.dart';
import 'package:budgetai/common/components/custom_trailing.dart';
import 'package:budgetai/generated/codegen_loader.g.dart';
import 'package:budgetai/common/helpers/app_helper.dart';
import 'package:budgetai/core/models/http_response_model.dart';
import 'package:budgetai/common/widgets/custom_scaffold.dart';
import 'package:budgetai/common/components/custom_text_field.dart';
part "forgot_password_view_mixin.dart";

class ForgotPasswordView extends StatelessWidget with ForgotPasswordViewMixin {
  final TextEditingController textEditingController;
  final void Function(RegisterState registerState) forgotPasswordListener;
  const ForgotPasswordView({
    super.key,
    required this.textEditingController,
    required this.forgotPasswordListener,
  });

  @override
  Widget build(BuildContext context) {
    final RegisterBloc registerBloc = BlocProvider.of<RegisterBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            return BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                forgotPasswordListener(state);
              },
              child: SafeArea(
                bottom: false,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: PopScope(
                    canPop: !registerState.isLoading,
                    child: CustomScaffold(
                      title: LocaleKeys.forgot_password,
                      trailing: CustomTrailing(
                        text: LocaleKeys.cancel,
                        isLoading: registerState.isLoading,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      automaticallyImplyLeading: false,
                      children: [
                        const Text(LocaleKeys.forgot_password_text).tr(),
                        const SizedBox(height: 10),
                        CustomTextField(
                          enabled: !registerState.isLoading,
                          textEditingController: textEditingController,
                          placeholder: LocaleKeys.email.tr(),
                          prefixIcon: CupertinoIcons.mail,
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (p0) {
                            _onSubmit(
                              context,
                              textEditingController,
                              registerBloc,
                            );
                          },
                          suffix: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _onSubmit(
                                context,
                                textEditingController,
                                registerBloc,
                              );
                            },
                            child: !registerState.isLoading
                                ? const Icon(
                                    CupertinoIcons.arrow_right_circle,
                                  )
                                : const CupertinoActivityIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
