import 'package:buzzchat/controller/contactController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactSearch extends StatelessWidget {
  const ContactSearch({super.key});

  @override
  Widget build(BuildContext context) {
    ContactController contactController = Get.find<ContactController>();
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              onChanged:
                  (value) => {contactController.searchUsername.value = value},
              decoration: InputDecoration(
                hintText: "Search contact",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
