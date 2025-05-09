import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/singleton/QueueService.dart';
import 'package:fyp_mobile/property/singleton/RestuarantService.dart';
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
  final Restuarantservice service = Restuarantservice();
  final QueueService queueService = QueueService();

  Future<Widget> gettable(String objectid) async {
    Restaurant abc = await service.getrestaurant(objectid);

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

  Future<List<Tabledb>> gettableinfo(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/table/$name'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return Tabledb.listFromJson(data['table']);
  }

  Future<dynamic> updatetablestatus(
      String option, String objectid, String type) async {
    Map<String, dynamic> data = {'status': option, 'type': type};
    try {
      var response = await http.put(
          Uri.parse('http://10.0.2.2:3000/api/table/$objectid/occupied'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      return (response.statusCode);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<dynamic> updatefree(
      String option, String objectid, String type) async {
    Map<String, dynamic> data = {'status': option, 'type': type};
    try {
      var response = await http.put(
          Uri.parse('http://10.0.2.2:3000/api/table/$objectid/free'),
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
    final List<String> type = [
      '1-2 people',
      '3-4 people',
      '5-6 people',
      '7+ people',
    ];
    String? selectedtype = db.type;

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
                  DropdownButton<String>(
                    value: selectedtype,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedtype = newValue; // Update selected status
                      });
                    },
                    items: type.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
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
                    if (selectedStatus != null && selectedStatus == "in used") {
                      await updatetablestatus(
                          selectedStatus!, db.id, selectedtype!);
                      // Refresh table data after updating status

                      Navigator.of(context).pop();
                      this.setState(() {
                        counter++;
                        print(counter);
                      });
                    } // Close dialog
                    else if (selectedStatus != null &&
                        selectedStatus == "available") {
                      await updatefree(selectedStatus!, db.id, selectedtype!);
                      Navigator.of(context).pop();
                      this.setState(() {
                        counter++;
                        print(counter);
                      });
                    }
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
                  fontFamily: 'Source Sans Pro',
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

      // Wrap each row in a Padding widget to add spacing between rows
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rowItems,
        ),
      ));
    }

    // Return a column containing all the rows plus additional widgets if necessary
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rows,
        ),
        //need to fix bug
        buttondecide(data[0].belong),
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
        future: queueService.checkqueue(name),
        builder: (context, tableSnapshot) {
          if (tableSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (tableSnapshot.hasError) {
            return Center(child: Text('Error: ${tableSnapshot.error}'));
          } else {
            if (tableSnapshot.data == true || full == false) {
              return Column(
                children: [disablebutton(), Custom(name)],
              );
            } else {
              return Column(
                children: [
                  ablebutton(name),
                  disableCustom(),
                ],
              );
            }
          }
        });
  }

  Widget disableCustom() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF4A75A5)
            .withOpacity(0.5), // Background color with opacity
        elevation: 0, // No shadow
      ),
      child: const Text(
        "Queue Condition",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Source Sans Pro',
          fontWeight: FontWeight.w600,
          height: 1.19, // Line height (19px / 16px)
        ),
      ),
    );
  }

  Widget disablebutton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF4A75A5)
            .withOpacity(0.5), // Background color with opacity
        elevation: 0, // No shadow
      ),
      child: const Text(
        "Create a queue",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Source Sans Pro',
          fontWeight: FontWeight.w600,
          height: 1.19, // Line height (19px / 16px)
        ),
      ),
    );
  }

  Widget ablebutton(String name) {
    return ElevatedButton(
      onPressed: () async {
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
          fontFamily: 'Source Sans Pro',
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

  Widget Custom(String name) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .pushNamed('/condition', arguments: name)
            .then((result) {
          if (result == true) {
            // Refresh state after queue closure
            setState(() {
              counter++; // Trigger UI update
            });
          }
        });
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
            children: [token()],
          ),
        ));
  }
}
