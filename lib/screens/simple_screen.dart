import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class AppContext {
  static late BuildContext appContext;
}

class SimpleScreen extends StatefulWidget {
  const SimpleScreen({Key? key}) : super(key: key);

  @override
  State<SimpleScreen> createState() => _SimpleScreenState();
}

class _SimpleScreenState extends State<SimpleScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  UnityWidgetController? _unityWidgetController;
  double _sliderValue = 0.0;
  late BuildContext contexts;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context, String name) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        contexts = context;
        return Container(
          height: 400, // Customize the height as needed
          child: Column(
            children: [
              ListTile(
                title: Text(name + " Unity"),
                onTap: () {
                  // Add your action here for Option 1
                  Navigator.of(context).pop();
                },
              ),
              // ListTile(
              //   title: Text('Option 2'),
              //   onTap: () {
              //     // Add your action here for Option 2
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppContext.appContext = context;
    final scaffoldContext = _scaffoldKey.currentContext;
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: const Text('Simple Screen'),
      // ),
      floatingActionButton: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            top: 100, // Adjust the position as needed
            child: FloatingActionButton.small(
              onPressed: () {
                _showBottomSheet(context, "Flutter");
                // Add your action here
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              splashColor: Colors.transparent,
            ),
          ),
          Positioned(
            top: 150, // Adjust the position as needed
            child: FloatingActionButton.small(
              onPressed: () {
                // Add your action here
              },
              child: Icon(
                Icons.star,
                color: Colors.white,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              splashColor: Colors.transparent,
            ),
          ),
          Positioned(
            top: 200, // Adjust the position as needed
            child: FloatingActionButton.small(
              onPressed: () {
                // Add your action here
              },
              child: Icon(Icons.share),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              splashColor: Colors.transparent,
            ),
          ),
          Positioned(
            top: 250, // Adjust the position as needed
            child: FloatingActionButton.small(
              onPressed: () {
                // Add your action here
              },
              child: Icon(Icons.more_vert),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              splashColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: Card(
          margin: const EdgeInsets.all(0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              UnityWidget(
                onUnityCreated: _onUnityCreated,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
                useAndroidViewSurface: false,
                borderRadius: const BorderRadius.all(Radius.circular(70)),
              ),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: PointerInterceptor(
              //     child: Card(
              //       elevation: 10,
              //       child: Column(
              //         children: <Widget>[
              //           const Padding(
              //             padding: EdgeInsets.only(top: 20),
              //             child: Text("Rotation speed:"),
              //           ),
              //           Slider(
              //             onChanged: (value) {
              //               setState(() {
              //                 _sliderValue = value;
              //               });
              //               setRotationSpeed(value.toString());
              //             },
              //             value: _sliderValue,
              //             min: 0.0,
              //             max: 1.0,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          )),
    );
  }

  void setRotationSpeed(String speed) {
    _unityWidgetController?.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  void loadData(String speed) {
    _unityWidgetController?.postMessage(
        "Camera", 'loadData', "Hello Dari Flutter Load");
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
    print(message.toString());
    final msg = message.toString().contains("_showBottomSheet");
    final obj = message.toString().replaceFirst("_showBottomSheet", '');
    print(obj);
    print(msg.toString() + 'mamamam');
    if (msg) {
      _showBottomSheet(AppContext.appContext, obj);
    }
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      print('Received scene loaded from unity: ${scene.name}');
      print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
      _unityWidgetController?.postMessage(
          "Camera", 'loadData', "Hello Dari Flutter Loaded");
    } else {
      print('Received scene loaded from unity: null');
    }
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
    _unityWidgetController?.postMessage("Camera", 'loadData', "100000");
  }
}
