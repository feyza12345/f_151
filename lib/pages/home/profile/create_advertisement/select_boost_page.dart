import 'package:f151/enums/boosts.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/profile/create_advertisement/preview_advertisement_page.dart';
import 'package:flutter/material.dart';

class SelectBoostPage extends StatefulWidget {
  final AdvertisementModel advertisement;
  const SelectBoostPage(this.advertisement, {super.key});

  @override
  SelectBoostPageState createState() => SelectBoostPageState();
}

class SelectBoostPageState extends State<SelectBoostPage> {
  Map<Boosts, bool> boosts = {
    Boosts.values[0]: false,
    Boosts.values[1]: false,
    Boosts.values[2]: false,
    Boosts.values[3]: false,
    Boosts.values[4]: false,
  };

  List<int> selectedDuration = [1, 1, 1, 1, 1];
  List<int> durations = [1, 2, 4];

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
            leading: Checkbox(
              value: boosts[boost],
              onChanged: (value) {
                setState(() {
                  boosts[boost] = value!;
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
                    const Text('Süre: '),
                    DropdownButton<int>(
                      value: selectedDuration[index],
                      onChanged: (value) {
                        setState(() {
                          selectedDuration[index] = value!;
                        });
                      },
                      items: durations.map((duration) {
                        return DropdownMenuItem<int>(
                          value: duration,
                          child: Text('$duration hafta'),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    Text(
                        'Ücret: ₺${selectedDuration[index] * Boosts.values[index].feeForAWeek}'), // Ücret hesaplaması
                  ],
                ),
              ],
            ),
            onTap: () {
              // Boost seçildiğinde yapılacak işlemler buraya eklenebilir
              print('Seçilen boost: ${boost.title}');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PreviewAdvertisementPage(widget.advertisement))),
      ),
    );
  }
}
