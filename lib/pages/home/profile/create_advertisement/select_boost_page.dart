import 'package:f151/enums/boosts.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/profile/create_advertisement/payment_page.dart';
import 'package:flutter/material.dart';

class SelectBoostPage extends StatefulWidget {
  final AdvertisementModel advertisement;
  const SelectBoostPage(this.advertisement, {super.key});

  @override
  SelectBoostPageState createState() => SelectBoostPageState();
}

class SelectBoostPageState extends State<SelectBoostPage> {
  Map<Boosts, int> boosts = {
    Boosts.values[0]: 0,
    Boosts.values[1]: 0,
    Boosts.values[2]: 0,
    Boosts.values[3]: 0,
    Boosts.values[4]: 0,
  };
  List<int> durations = [0, 1, 2, 4];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Boost Seçimi'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: Boosts.values.length,
          itemBuilder: (context, index) {
            final boost = Boosts.values[index];
            return ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: Checkbox(
                value: boosts[boost] != 0,
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      boosts[boost] = 4;
                    } else {
                      boosts[boost] = 0;
                    }
                  });
                },
              ),
              title: Text(boost.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(boost.description),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      DropdownButton<int>(
                        value: boosts[boost],
                        onChanged: (value) {
                          setState(() {
                            boosts[boost] = value!;
                          });
                        },
                        items: durations.map((duration) {
                          return DropdownMenuItem<int>(
                            value: duration,
                            child: Text(duration != 0
                                ? '$duration hafta'
                                : 'İstemiyorum'),
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      Text(
                          'Ücret: ₺${boosts[boost]! * Boosts.values[index].feeForAWeek}'), // Ücret hesaplaması
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaymentPage(
                  advertisement: widget.advertisement,
                  selectedBoosts: boosts))),
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('Devam Et'), Icon(Icons.arrow_forward)],
          ),
        ));
  }
}
