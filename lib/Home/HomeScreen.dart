import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_cocktail_app/Home/rocket_details_screen.dart';
import 'package:my_flutter_cocktail_app/Home/rocket_list_tile.dart';
import 'package:my_flutter_cocktail_app/NetworkRepository/backend.dart';
import 'package:my_flutter_cocktail_app/utils/Constraints.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   bool isBottom=true;
  var data;
  final url = "https://jsonplaceholder.typicode.com/photos";
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getdata() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode}: ${response.reasonPhrase}',
        uri: Uri.tryParse(url),
      );
    }

    // Get the JSON data from the response.
    final body = response.body;

    // Convert the body, a String, into a JSON object.
    // To do this, use Dart's built-in JSON decoder.
    // We know this returns a `List`, so we type-cast it into a `List<dynamic>`.
    setState(() {
      data = json.decode(body) as List;
    });
    //print(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getListData() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(data[index]["title"]),
          subtitle: Text("ID: ${data[index]["id"]}"),
          leading: Image.network(data[index]["url"]),
        );
      },
      itemCount: data.length,
    );
  }

  getFutureBuilder() {
    return FutureBuilder(
      future: Backend('https://api.spacexdata.com/v4').getRockets(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error occurred.'),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final rockets = snapshot.data;

          return ListView(
            children: [
              for (final rocket in rockets) ...[
                RocketListTile(
                  rocket: rocket,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return RocketDetailsScreen(rocket: rocket);
                        },
                      ),
                    );
                  },
                ),
                const Divider(height: 0.0),
              ]
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: isBottom? Center(
          child: _widgetOptions.elementAt(_selectedIndex))
            :new DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            actions: <Widget>[],
            title: new TabBar(
              tabs: [
                new Tab(icon: new Icon(Icons.directions_car)),
                new Tab(icon: new Icon(Icons.directions_transit)),
                new Tab(icon: new Icon(Icons.directions_bike)),
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: new TabBarView(
            children: [
              Padding(
                child: data != null
                    ? getListData()
                    : Center(child: CircularProgressIndicator()),
                padding: EdgeInsets.all(10.0),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: getFutureBuilder()
              ),
              new Icon(
                Icons.directions_transit,
                size: 50.0,
              ),
              //  new Icon(Icons.directions_bike,size: 50.0,),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // DrawerHeader(child: Text("jitendra",
            //   style:TextStyle(color: Colors.white),),
            // decoration: BoxDecoration(color: Colors.indigo),
            // ),
            UserAccountsDrawerHeader(
              accountName: Text("Jitendra Rathore"),
              accountEmail: Text("jitendra.rathore@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_to_home_screen),
              title: Text("Home"),
              onTap: () {
                setState(() {
                  isBottom=false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.smart_button_sharp),
              title: Text("Buttom Tab bar"),
              onTap: () {
                setState(() {
                  isBottom=true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Constraints.preferences.setBool("login", false);
                Navigator.pop(context);
                Navigator.of(context).pushNamed("/Login");
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: isBottom? BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ):null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
    );
  }
}
