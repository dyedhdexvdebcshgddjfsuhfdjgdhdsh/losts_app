import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/translations/locale_keys.g.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = UserCubit.get(context).userModel;
        nameController.text = model!.name;
        bioController.text = model.bio!;
        phoneController.text = model.phone!;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: LocaleKeys.edit_profile.tr(),
            actions: [
              TextButton(
                onPressed: () async {
                  await UserCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                child: Text(
                  LocaleKeys.update.tr(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is UserUpdateUserLoadingState)
                    const LinearProgressIndicator(),
                  if (state is UserUpdateUserLoadingState)
                    const SizedBox(
                      height: 20.0,
                    ),
                  SizedBox(
                    height: 230.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 180.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: UserCubit.get(context).coverImage ==
                                            null
                                        ? Image.network('${model.cover}').image
                                        : FileImage(
                                            UserCubit.get(context).coverImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 20.0,
                                backgroundColor: defaultColor,
                                child: PopupMenuButton(
                                  icon: const Icon(Icons.camera_alt_outlined),
                                  onSelected: (String value) {
                                    if (value == 'Camera') {
                                      UserCubit.get(context)
                                          .getCoverImageByCamera();
                                    } else if (value == 'Gallery') {
                                      UserCubit.get(context).getCoverImage();
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'Camera',
                                      child: Text(LocaleKeys.camera.tr()),
                                    ),
                                    PopupMenuItem(
                                      value: 'Gallery',
                                      child: Text(LocaleKeys.gallery.tr()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 64.0,
                              child: CircleAvatar(
                                backgroundImage: UserCubit.get(context)
                                            .profileImage ==
                                        null
                                    ? Image.network('${model.image}').image
                                    : FileImage(
                                        UserCubit.get(context).profileImage!),
                                radius: 60.0,
                              ),
                            ),
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor: defaultColor,
                              child: PopupMenuButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onSelected: (String value) {
                                  if (value == 'Camera') {
                                    UserCubit.get(context)
                                        .getProfileImageByCamera();
                                  } else if (value == 'Gallery') {
                                    UserCubit.get(context).getProfileImage();
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'Camera',
                                    child: Text(LocaleKeys.camera.tr()),
                                  ),
                                  PopupMenuItem(
                                    value: 'Gallery',
                                    child: Text(LocaleKeys.gallery.tr()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  if (UserCubit.get(context).profileImage != null ||
                      UserCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (UserCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultMaterialButton(
                                  color: defaultColor,
                                  function: () {
                                    UserCubit.get(context).updateProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                  text: LocaleKeys.upload_profile.tr(),
                                ),
                                if (state is UserUpdateUserLoadingState)
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is UserUpdateUserLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (UserCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultMaterialButton(
                                  color: defaultColor,
                                  function: () {
                                    UserCubit.get(context).updateCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                  text: LocaleKeys.upload_cover.tr(),
                                ),
                                if (state is UserUpdateUserLoadingState)
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is UserUpdateUserLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (UserCubit.get(context).profileImage != null ||
                      UserCubit.get(context).coverImage != null)
                    const SizedBox(
                      height: 20.0,
                    ),
                  defaultTextFormField(
                    maxLength: 24,
                    context: context,
                    controller: nameController,
                    type: TextInputType.name,
                    prefixIcon: Icons.person,
                    obscureText: false,
                    label: LocaleKeys.user_name.tr(),
                    hintText: LocaleKeys.update_your_name.tr(),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  defaultTextFormField(
                    maxLength: 40,
                    context: context,
                    controller: bioController,
                    type: TextInputType.text,
                    prefixIcon: Icons.info_outline,
                    obscureText: false,
                    label: LocaleKeys.bio.tr(),
                    hintText: LocaleKeys.update_your_bio.tr(),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  defaultTextFormField(
                    maxLength: 11,
                    context: context,
                    controller: phoneController,
                    type: TextInputType.number,
                    prefixIcon: Icons.call,
                    obscureText: false,
                    label: LocaleKeys.phone.tr(),
                    hintText: LocaleKeys.update_your_phone.tr(),
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
