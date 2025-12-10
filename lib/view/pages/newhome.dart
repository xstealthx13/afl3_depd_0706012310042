import 'package:flutter/material.dart';

class Newhome extends StatefulWidget {
  const Newhome({super.key});

  @override
  State<Newhome> createState() => _NewhomeState();
}

class _NewhomeState extends State<Newhome> {
  bool isClicked = false;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  bool islight = false;
  Color favcolor = Colors.pinkAccent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // ----------------------------
        // CUSTOM HEADER (REPLACES APPBAR)
        // ----------------------------
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue,
          child: const Text(
            "Third Page",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // ----------------------------
        // ORIGINAL PAGE CONTENT
        // ----------------------------
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  // TOP RIGHT BUTTON
                  Flexible(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            islight = !islight;
                            favcolor = islight
                                ? Colors.deepOrangeAccent
                                : Colors.indigoAccent;
                          });
                        },
                        backgroundColor: Colors.amberAccent,
                        child: Icon(Icons.favorite, color: favcolor),
                      ),
                    ),
                  ),

                  // MAIN IMAGE
                  Flexible(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      color: Colors.indigo,
                      child: Image.asset(
                        'assets/images/one.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // ROW OF IMAGES
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/arizona_campus.png', width: 70),
                        Image.asset('assets/images/one.jpeg', width: 70),
                        Image.asset('assets/images/foto.jpeg', width: 70),
                        Image.asset('assets/images/arizona.jpeg', width: 70),
                      ],
                    ),
                  ),

                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.purple,
                      alignment: Alignment.center,
                      child: const Text(
                        "arizona state university",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  // LONG TEXT
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.cyanAccent,
                      child: const SingleChildScrollView(
                        child: Text(
                          'welcome to The College of Liberal Arts and Sciences, '
                          'the academic heart of Arizona State University...'
                          '(your text continues)',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
