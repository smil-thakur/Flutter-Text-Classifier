import 'dart:isolate';

import 'package:face_detection/methods/classifier.dart';
import 'package:face_detection/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

List<String> statements = [];
List<List<double>> ans = [
  [0.0, 0.0]
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLutter NLP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _controller = TextEditingController();
  Classifier classifier = Classifier();
  bool isloading = true;
  loadModel() async {
    await classifier.loadModel();
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
    statements.clear();
    ans.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flutter ❤️ TensorFlow",
          style: GoogleFonts.inter(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "This is a Flutter App that can classify a Text into a positive or a negative statement, Using the TensorFLowLite flutter package and a tflite model",
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                statements.isNotEmpty && ans.isNotEmpty
                    ? Container(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: statements.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ans[(statements.length - 1) - index]
                                                [0] >
                                            ans[(statements.length - 1) - index]
                                                [1]
                                        ? const Color.fromARGB(255, 235, 93, 83)
                                        : const Color.fromARGB(
                                            255, 125, 240, 129),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          " Statement: ${statements[(statements.length - 1) - index]}",
                                          style: GoogleFonts.inter(
                                            height: 1.5,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          " Degree of positive: ${ans[(statements.length - 1) - index][1].toStringAsPrecision(10)}",
                                          style: GoogleFonts.inter(
                                            height: 1.5,
                                          ),
                                        ),
                                        Text(
                                          " Degree of negative: ${ans[(statements.length - 1) - index][0].toStringAsPrecision(10)}",
                                          style: GoogleFonts.inter(
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : Container(),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter your statement",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                isloading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (_controller.text.isNotEmpty) {
                            List<List<double>> temp =
                                await classifier.classify(_controller.text);
                            ans.add([temp[0][0], temp[0][1]]);
                            statements.add(_controller.text);
                            _controller.text = "";
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(milliseconds: 500),
                                content: Text(
                                  "Enter Statement",
                                  style: GoogleFonts.inter(),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Classify",
                          style: GoogleFonts.inter(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          statements.clear();
          ans.clear();
          setState(() {});
        },
        child: const Icon(Icons.clear),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          heightFactor: 1,
          child: Text(
            "Developed by Smil, using Flutter",
            style: GoogleFonts.inter(),
          ),
        ),
      ),
    );
  }
}
