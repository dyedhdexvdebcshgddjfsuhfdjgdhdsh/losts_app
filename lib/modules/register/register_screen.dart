import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/translations/locale_keys.g.dart';

import '../../cubit/register_cubit/register_cubit.dart';
import '../../cubit/register_cubit/register_states.dart';
import '../../layout/app_layout.dart';
import '../../network/local/cache_helper.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class AppRegister extends StatelessWidget {
  const AppRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocProvider(
      create: (context) => AppRegisterCubit(),
      child: BlocConsumer<AppRegisterCubit, AppRegisterStates>(
        listener: (context, state) {
          if (state is AppRegisterErrorState) {
            showToast(
              message: state.error,
              state: ToastStates.error,
            );
          }
          if (state is AppCreateUserSuccessState) {
            showToast(
              message: 'register Success',
              state: ToastStates.success,
            );
            uId = state.uId;
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              navigateAndFinish(
                context,
                const AppLayout(),
              );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    LocaleKeys.back.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/logo.jpg'),
                              height: 200.0,
                              width: 200.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          LocaleKeys.register.tr(),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 32.0,
                                  ),
                        ),
                        Text(
                          LocaleKeys.hi_register.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultTextFormField(
                          maxLength: 24,
                          context: context,
                          label: LocaleKeys.user_name.tr(),
                          prefixIcon: Icons.person,
                          type: TextInputType.name,
                          controller: nameController,
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          maxLength: 30,
                          context: context,
                          label: LocaleKeys.email_address.tr(),
                          prefixIcon: Icons.email_outlined,
                          type: TextInputType.text,
                          controller: emailController,
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                            maxLength: 30,
                            context: context,
                            label: LocaleKeys.password.tr(),
                            prefixIcon: Icons.lock_outline,
                            type: TextInputType.visiblePassword,
                            controller: passwordController,
                            obscureText:
                                AppRegisterCubit.get(context).isPassword,
                            suffixIcon: AppRegisterCubit.get(context).suffix,
                            function: () {
                              AppRegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                AppRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            }),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultTextFormField(
                          maxLength: 11,
                          context: context,
                          label: LocaleKeys.phone.tr(),
                          prefixIcon: Icons.phone,
                          type: TextInputType.phone,
                          controller: phoneController,
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! AppRegisterLoadingState,
                          builder: (context) => Container(
                            height: 60.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: defaultColor,
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  AppRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              child: Text(
                                LocaleKeys.register.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
