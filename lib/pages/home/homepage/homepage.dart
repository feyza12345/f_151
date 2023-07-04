import 'package:f151/bloc/ads_bloc.dart';
import 'package:f151/components/custom_widgets.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/widgets/ad_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final TextEditingController searchController = TextEditingController();
  final focusnode = FocusNode();
  List<String> searchResults = []; // Arama sonuçları
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets.appBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo/logo.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          title: AnimatedSwitcher(
            duration: kDefaultAnimationDuration,
            child: isSearching
                ? TextField(
                    controller: searchController,
                    focusNode: focusnode,
                    key: const ValueKey('searchbar'),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: 'Ders ara',
                        filled: true,
                        fillColor: Colors.white),
                  )
                : const Text(
                    kAppName,
                    key: ValueKey('appNameHomepage'),
                  ),
          ),
          actions: [
            AnimatedSwitcher(
              duration: kDefaultAnimationDuration,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: isSearching
                  ? IconButton(
                      key: const ValueKey('closeicon'),
                      onPressed: () => setState(() {
                            isSearching = false;
                            searchController
                                .clear(); // TextEditingController'ı temizle
                            FocusScope.of(context).unfocus(); // Klavyeyi kapat
                          }),
                      icon: const Icon(Icons.close))
                  : IconButton(
                      key: const ValueKey('searchicon'),
                      onPressed: () => setState(() {
                            focusnode.requestFocus();
                            isSearching = true;
                          }),
                      icon: const Icon(Icons.search)),
            )
          ],
        ),
        body: BlocBuilder<AdsBloc, List<AdvertisementModel>>(
            builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<AdsBloc>().refresh(),
            child: ListView.builder(
                itemCount: state.length,
                itemBuilder: (context, index) =>
                    AdListCard(advertisementModel: state[index])),
          );
        }));
  }
}
