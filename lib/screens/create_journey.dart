import 'package:bucket_map/widgets/country_input_field.dart';
import 'package:flutter/material.dart';

class CreateJourneyScreen extends StatefulWidget {
  @override
  State createState() => _CreateJourneyScreenState();
}

class _CreateJourneyScreenState extends State<CreateJourneyScreen> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Reise hinzufügen'),
        actions: [
          TextButton(
            child: Text("Speichern"),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
            ),
            SizedBox(height: 16),
            CountryInputField(controller: countryController,),
            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
