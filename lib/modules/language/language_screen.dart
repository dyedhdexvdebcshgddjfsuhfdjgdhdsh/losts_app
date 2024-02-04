import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_states.dart';
import 'package:social_app/translations/locale_keys.g.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              LocaleKeys.language.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  LocaleKeys.select_your_language.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      UserCubit.get(context).setEnglish(context: context);
                    },
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              'https://as1.ftcdn.net/v2/jpg/02/70/24/98/1000_F_270249859_mf1Kyad7MO3Gb1BGvBahbB9SNttnVZO7.jpg',
                          height: 40.0,
                          width: 40.0,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          LocaleKeys.english.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        UserCubit.get(context).isEnglish
                            ? const CircleAvatar(
                                radius: 15.0,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      UserCubit.get(context).setArabic(context: context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              'https://as2.ftcdn.net/v2/jpg/04/85/06/45/1000_F_485064580_nAzxr60edcRlLgEVwGp5gDdBexZhdp38.jpg',
                          height: 35.0,
                          width: 35.0,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          LocaleKeys.arabic.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        UserCubit.get(context).isEnglish
                            ? const SizedBox()
                            : const CircleAvatar(
                                radius: 15.0,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
