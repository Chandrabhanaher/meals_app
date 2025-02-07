import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key})

@override
  State<FilterScreen> createState() {
    return _FilterScreenState();
  }
}

class _FilterScreenState extends State<FilterScreen>{
  var _glutenFreeFilterSet = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your filters..'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: _glutenFreeFilterSet, 
            onChanged: (isChecked){
              setState(() {
                  _glutenFreeFilterSet = isChecked;
              });
            },
            title: Text(
              'Gluten-free',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
            ),
            subtitle: Text(
              'Onlu include gluten-free meals',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
            ),
            activeColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left :34, right :22),
          ),
        ],
      ),
    );
  }
}