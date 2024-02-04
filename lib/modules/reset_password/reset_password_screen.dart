import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/translations/locale_keys.g.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              LocaleKeys.reset_password.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  defaultTextFormField(
                    controller: emailController,
                    type: TextInputType.text,
                    prefixIcon: Icons.email_outlined,
                    context: context,
                    obscureText: false,
                    label: LocaleKeys.email_address.tr(),
                    hintText: LocaleKeys.email_address.tr(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: defaultColor,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        UserCubit.get(context).resetPassword(
                          email: emailController.text,
                        );
                        showToast(
                          message: 'Please Check your Mail',
                          state: ToastStates.success,
                        );
                      }
                    },
                    child: Text(
                      LocaleKeys.confirm.tr(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
