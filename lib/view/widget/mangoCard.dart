import 'package:flutter/material.dart';
import 'package:mangodevelopment/model/food.dart';

class MangoCard extends StatelessWidget {
  final Food food;

  const MangoCard({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return whichCard(type: 0);
  }

  Widget whichCard({required int type}) {
    switch (type) {
      case 1:
        return overCard();
      case 2:
        return dDayCard();
      case 3:
        return staleCard();
      default:
        return normalCard();
    }
  }

  Widget staleCard() {
    return ListTile(
      leading: Text('stale'),
      title: Text(food.name),
      subtitle: Text(food.number.toString()),
    );
  }

  Widget overCard() {
    return ListTile(
      leading: Text('over'),
      title: Text(food.name),
      subtitle: Text(food.number.toString()),
    );
  }

  Widget dDayCard() {
    return ListTile(
      leading: Text('d-day'),
      title: Text(food.name),
      subtitle: Text(food.number.toString()),
    );
  }

  Widget normalCard() {
    return ListTile(
      leading: Text('normal'),
      title: Text(food.name),
      subtitle: Text(food.number.toString()),
    );
  }
}
