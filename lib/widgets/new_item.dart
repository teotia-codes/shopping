import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:shopping/data/categories.dart';
import 'package:shopping/models/category.dart';
import 'package:shopping/models/grocery_item.dart';

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
  void saveItem() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final url = Uri.https('flutternoobie-default-rtdb.firebaseio.com',
          'shopping.json'); //https creates a url that points to the backend server.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': enteredName,
          'quantity': enteredQuantity,
          'category': _selectedCategory.title,
        }),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: enteredName,
        quantity: enteredQuantity,
        category: _selectedCategory,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Add a new item!',style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold)),
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
                  decoration: InputDecoration(
                    
                    label: Text('Name',style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                  style:const TextStyle(color: Colors.black),
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
                        decoration:  InputDecoration(
                          label: Text('Quantity',style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold),),
                        ),
                        style: const TextStyle(color: Colors.black),
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
                        dropdownColor: Colors.white,
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
                                    Text(category.value.title,style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.normal)),
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
                      child: Text('Reset',style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                        onPressed: saveItem, child: Text('Add Item',style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold)))
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
