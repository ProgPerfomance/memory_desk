import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_desk/core/vectors.dart';
import 'package:memory_desk/presentation/create_desk/step_1_view.dart';
import 'package:memory_desk/presentation/desk_list/desk_list_view.dart';
import 'package:memory_desk/presentation/love/love_view.dart';
import 'package:memory_desk/presentation/my_invites/my_invites_view.dart';
import 'package:memory_desk/presentation/navigation/main_navigation_view_model.dart';
import 'package:memory_desk/presentation/profile/profile_view.dart';
import 'package:provider/provider.dart';

List<Widget> screens = [
  BoardsListView(),
  MyInvitesView(),
  Scaffold(),
  LoveView(),
  ProfileView(),
];

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MainNavigationViewModel>(context);
    return Scaffold(
      backgroundColor: Color(0xffAD6E53),
      body: screens[vm.index],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 94,
          decoration: BoxDecoration(color: Color(0xffAD6E53)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    vm.selectIndex(0);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 54,
                    child: Center(child: SvgPicture.asset(AppVectors.video)),
                  ),
                ),
                GestureDetector(
                  child: SvgPicture.asset(AppVectors.people),
                  onTap: () {
                    vm.selectIndex(1);
                  },
                ),
                CreateButton(),
                GestureDetector(
                  child: SvgPicture.asset(AppVectors.heard),
                  onTap: () {
                    vm.selectIndex(3);
                  },
                ),
                ProfileButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MainNavigationViewModel>(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        vm.selectIndex(4);
      },
      child: SizedBox(
        height: 54,
        width: 54,
        child: Stack(
          children: [
            Center(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 8.7, sigmaY: 8.7),
                child: Container(
                  height: 44,
                  width: 44,
                  color: Color(0xffFFB265),
                ),
              ),
            ),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Color(0xffFFB265), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://i.pinimg.com/736x/bd/68/11/bd681155d2bd24325d2746b9c9ba690d.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Step1View()),
        );
      },
      child: SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          children: [
            Center(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 8.7, sigmaY: 8.7),
                child: Container(
                  height: 48,
                  width: 48,
                  color: Color(0xffFFB265),
                ),
              ),
            ),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Color(0xffFFB265), width: 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xffFFD5A5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
