import 'package:f151/bloc/ads_bloc.dart';
import 'package:f151/components/custom_widgets.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/widgets/ad_list_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  MyAdsPageState createState() => MyAdsPageState();
}

class MyAdsPageState extends State<MyAdsPage> {
  final TextEditingController searchController = TextEditingController();
  final focusnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets.appBar(
          title: const AnimatedSwitcher(
            duration: kDefaultAnimationDuration,
            child: Text(
              'İlanlarım',
              key: ValueKey('appNameHomepage'),
            ),
          ),
        ),
        body: BlocBuilder<AdsBloc, List<AdvertisementModel>>(
            builder: (context, state) {
          final filtredAdsList = state
              .where((element) =>
                  element.userId == FirebaseAuth.instance.currentUser!.uid)
              .toList();
          return RefreshIndicator(
            onRefresh: () => context.read<AdsBloc>().refresh(),
            child: ListView.builder(
                itemCount: filtredAdsList.length,
                itemBuilder: (context, index) =>
                    AdListCard(advertisementModel: filtredAdsList[index])),
          );
        }));
  }
}
