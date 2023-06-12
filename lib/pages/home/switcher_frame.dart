import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/pages/home/homepage/anasayfa.dart';
import 'package:f151/pages/home/ilanlar/ilanlar.dart';
import 'package:f151/pages/home/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SwitcherFrame extends StatefulWidget {
  const SwitcherFrame({super.key});

  @override
  State<SwitcherFrame> createState() => _SwitcherFrameState();
}

class _SwitcherFrameState extends State<SwitcherFrame> {
  final pages = [
    const Anasayfa(),
    const Ilanlar(),
    const Profile(),
  ];

  void onItemTapped(int index) {
    setState(() {
      context.read<AppInfoBloc>().setPageIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (context.read<AppInfoBloc>().state.pageIndex == 2) {
          return true;
        } else {
          onItemTapped(2);
          return false;
        }
      },
      child: Scaffold(
        body: BlocBuilder<AppInfoBloc, AppInfoState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: pages[state.pageIndex],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<AppInfoBloc, AppInfoState>(
          builder: (context, state) {
            return BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: state.pageIndex,
              onTap: (index) {
                setState(() {
                  onItemTapped(index);
                });
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Anasayfa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.listBox),
                  label: 'İlanlar',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
