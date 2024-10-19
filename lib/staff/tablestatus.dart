import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/table.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Tablestatus extends StatefulWidget {
  const Tablestatus({super.key});

  @override
  State<Tablestatus> createState() => _Tablestate();
}

class _Tablestate extends State<Tablestatus> {
  int counter = 0;
  late Future<String?> _tokenValue;

  Future<Restaurant> getrestaurant(String objectid) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/$objectid/get'),
        headers: {'Content-Type': 'application/json'});
    return parseRestaurant(response.body);
  }

  Future<Widget> gettable(String objectid) async {
    Restaurant abc = await getrestaurant(objectid);
    List<Tabledb> tables = await gettableinfo(abc.name);
    return TableList(tables);
  }

  Future<dynamic> createqueue(String name) async {
    Map<String, dynamic> data = {
      'restaurant': name,
    };
    try {
      var response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/queue/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      print(response.body);
      setState(() {
        counter++;
      });
      return (response.statusCode);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<bool> gettablestatus(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/table/$name/status'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return data['status'];
  }

  Future<bool> getqueue(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/check/$name'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return data['exists'];
  }

  Future<List<Tabledb>> gettableinfo(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/table/$name'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return Tabledb.listFromJson(data['table']);
  }

  Future<dynamic> updatetablestatus(String option, String objectid) async {
    Map<String, dynamic> data = {
      'status': option,
    };
    try {
      var response = await http.put(
          Uri.parse('http://10.0.2.2:3000/api/table/$objectid'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      return (response.statusCode);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  void _showUpdateDialog(BuildContext context, Tabledb db) {
    String? selectedStatus = db.status; // Start with the current status
    final List<String> statusOptions = ['available', 'in used'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Update Table Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue; // Update selected status
                      });
                    },
                    items: statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedStatus != null) {
                      await updatetablestatus(selectedStatus!, db.id);
                      // Refresh table data after updating status

                      Navigator.of(context).pop();
                      this.setState(() {
                        counter++;
                        print(counter);
                      });
                    } // Close dialog
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget TableCard(Tabledb db) {
    return GestureDetector(
      onTap: () => _showUpdateDialog(context, db), // Show dialog on tap(
      child: Container(
          width: 100,
          height: 108,
          decoration: BoxDecoration(
            color: Color(0xFFF1F1F1), // Light grey color
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Text(
                "Table ${db.tableNum}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              greenorred(db.status),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                db.status,
                style: const TextStyle(
                  color: Color(0xFF919191), // Similar to '#919191'
                  fontSize: 14, // Font size in pixels
                  fontFamily:
                      'Source Sans Pro', // Ensure this font is included in your project
                  height: 1.14, // Line height (16px / 14px)
                ),
              )
            ],
          )),
    );
  }

  Widget TableList(List<Tabledb> data) {
    List<Widget> menulistcard = [];

    // Populate the menulistcard with TableCard widgets for each Tabledb item
    for (var menu in data) {
      menulistcard.add(TableCard(menu));
    }

    // Create a list to hold rows of TableCard widgets
    List<Widget> rows = [];

    // Create rows with a maximum of 3 TableCard widgets each
    for (int i = 0; i < menulistcard.length; i += 3) {
      // Get the next three items for the current row
      int endIndex =
          (i + 3 < menulistcard.length) ? i + 3 : menulistcard.length;
      List<Widget> rowItems = menulistcard.sublist(i, endIndex);

      // Create a row with the current batch of items
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // Adjust alignment as needed
        children: rowItems,
      ));
    }

    // Return a column containing all the rows
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rows,
        ),
        buttondecide(data[0].belong)
      ],
    );
  }

  Widget greenorred(String status) {
    if (status == "available") {
      return GreenLight();
    } else {
      return Redlight();
    }
  }

  Widget Redlight() {
    return Stack(
      alignment: Alignment.center, // Center the circle within the card
      children: [
        // Small circle child
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: Color(0xFFEF4444), // Green color
            shape: BoxShape.circle, // Makes it a circle
          ),
        ),
        // If you want to keep the greenorred function, you can call it here
        // greenorred(),
      ],
    );
  }

  Widget GreenLight() {
    return Stack(
      alignment: Alignment.center, // Center the circle within the card
      children: [
        // Small circle child
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: Color(0xFF22C55E), // Green color
            shape: BoxShape.circle, // Makes it a circle
          ),
        ),
        // If you want to keep the greenorred function, you can call it here
        // greenorred(),
      ],
    );
  }

  Widget buttondecide(String name) {
    return FutureBuilder(
        future: gettablestatus(name),
        builder: (context, tableSnapshot) {
          if (tableSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (tableSnapshot.hasError) {
            return Center(child: Text('Error: ${tableSnapshot.error}'));
          } else {
            return twocondition(tableSnapshot.data!, name);
          }
        });
  }

  Widget twocondition(bool full, String name) {
    return FutureBuilder(
        future: getqueue(name),
        builder: (context, tableSnapshot) {
          if (tableSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (tableSnapshot.hasError) {
            print("hghghg");
            return Center(child: Text('Error: ${tableSnapshot.error}'));
          } else {
            if (tableSnapshot.data == true || full == false) {
              return disablebutton();
            } else {
              return ablebutton(name);
            }
          }
        });
  }

  Widget disablebutton() {
    return ElevatedButton(
      onPressed: () {
        // Add your onPressed logic here
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF4A75A5)
            .withOpacity(0.5), // Background color with opacity
        elevation: 0, // No shadow
      ),
      child: Text(
        "Create a queue",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily:
              'Source Sans Pro', // Ensure this font is added in your pubspec.yaml
          fontWeight: FontWeight.w600,
          height: 1.19, // Line height (19px / 16px)
        ),
      ),
    );
  }

  Widget ablebutton(String name) {
    return ElevatedButton(
      onPressed: () async {
        // Add your onPressed logic here
        createqueue(name);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor:
            const Color(0xFF1578E6), // Background color with opacity
        elevation: 0, // No shadow
      ),
      child: Text(
        "Create a queue",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily:
              'Source Sans Pro', // Ensure this font is added in your pubspec.yaml
          fontWeight: FontWeight.w600,
          height: 1.19, // Line height (19px / 16px)
        ),
      ),
    );
  }

  Widget token() {
    return FutureBuilder(
      future: _tokenValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/update');
              },
              child: const Text("Update"),
            ),
          );
        } else if (snapshot.hasError) {
          print("hi there is the error occur");
          print(snapshot.error);
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, dynamic> decodedToken =
              JwtDecoder.decode(snapshot.data as String);
          String oid = decodedToken["_id"].toString();
          return FutureBuilder<Widget>(
            future: gettable(oid), // Call gettable here
            builder: (context, tableSnapshot) {
              if (tableSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (tableSnapshot.hasError) {
                print("hghghg");
                return Center(child: Text('Error: ${tableSnapshot.error}'));
              } else {
                return tableSnapshot.data ??
                    Container(); // Return the table widget
              }
            },
          );
        }
      },
    );
  }

  Widget Custom() {
    return ElevatedButton(
      onPressed: () {
        // Define what happens when the button is pressed
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: const Color(0xFF1578E6), // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Rounded corners
        ),
      ),
      child: Text(
        "Queue Condition",
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
          color: Colors.white, // Text color
        ),
      ),
    );
  }

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Topbar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [token(), Custom()],
          ),
        ));
  }
}
