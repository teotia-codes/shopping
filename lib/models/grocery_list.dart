import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/data/categories.dart';
import 'package:shopping/models/grocery_item.dart';
import 'package:shopping/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryitem = [];
  @override
  void initState() {
    super.initState();
    loadItems();
  }
void loadItems() async{
   final url =  Uri.https('flutternoobie-default-rtdb.firebaseio.com','shopping.json');
 final response = await http.get(url);
 
 if(response.body == 'null'){
  return;
 }
 final Map<String,dynamic> listData =json.decode(response.body);
 final List<GroceryItem> loadedItems= [];
 for( final item in listData.entries) {
  final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']).value;
loadedItems.add(GroceryItem(id: item.key, name: item.value['name'], quantity: item.value['quantity'], category: category),);
 }
 setState(() {
   _groceryitem = loadedItems;
 });
}
  void _addItem() async {
  final newItem=  await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    ); 
if(newItem == null) {
  return;
}
setState(() {
  _groceryitem.add(newItem);
});
  }

void removeItem(item) {
  final url =  Uri.https('flutternoobie-default-rtdb.firebaseio.com','shopping/${item.id}.json');
 http.delete(url);
  setState(() {
    _groceryitem.remove(item);
  });
}
  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text('No items added till now!',style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold,),));
   if(_groceryitem.isNotEmpty){
    content =  ListView.builder(
        itemCount: _groceryitem.length,
        itemBuilder: (ctx, index) => Dismissible(
key: ValueKey(_groceryitem[index].id),
onDismissed: (direction) {
  removeItem(_groceryitem[index],);
},
          child: ListTile(
            title: Text(_groceryitem[index].name,style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.normal)),
            leading: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
               color: _groceryitem[index].category.color),
            ),
            trailing: Text(_groceryitem[index].quantity.toString(),style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
        ),
      ));
   }
    return Scaffold(
      appBar: AppBar(
        title:  Text('Your Groceries!',style: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.bold,)),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add,color: Colors.black,),
          ),
        ],
      ),
      body:content
    );
  }
}
