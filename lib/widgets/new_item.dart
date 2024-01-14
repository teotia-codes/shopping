import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shopping/data/categories.dart';
import 'package:shopping/models/category.dart';


class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final formkey = GlobalKey<FormState>();
  var enteredName = '';
  var enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  void saveItem() async{
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final url = Uri.https('flutternoobie-default-rtdb.firebaseio.com','shopping.json');          //https creates a url that points to the backend server. 
    final response =  await http.post(url,headers: {
        'Content-Type':'application/json'
      },
      body: json.encode(
        {
          'name':enteredName,
          'quantity':enteredQuantity,
          'category':_selectedCategory.title,
        }
      ),);
      if(!context.mounted){
        return;
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length == 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredName = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: enteredQuantity.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            //try parse converts string to a number and return false if it fails to convert string to  number.
                            return 'Must be valid';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          enteredQuantity = int.parse(newValue!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: _selectedCategory,
                          items: [
                            for (final category in categories
                                .entries) //entries convert map to list
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 22,
                                    ),
                                    Text(category.value.title),
                                  ],
                                ),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        formkey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                        onPressed: saveItem, child: const Text('Add Item'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
