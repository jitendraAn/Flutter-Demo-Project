import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String>{
var data=<String>[];

  DataSearch();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){close(context, null);}, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
   return IconButton(onPressed: (){close(context, null);},
       icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,
     progress: transitionAnimation,));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList=query.isEmpty?data:data.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();
    // TODO: implement buildSuggestions
    return ListView.builder(itemBuilder: (context,index){
      return ListTile(
        title: Text(suggestionList[index]),
      );
    },itemCount: suggestionList.length,);
  }

}