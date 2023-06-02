import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bright Tiger',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true),
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: "assets/Bright Tiger.png",
            nextScreen: const MyHomePage(title: "Bright Tiger"),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController inAppWebViewController;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
  }

  double progressBar = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await inAppWebViewController.canGoBack();
        if (isLastPage) {
          inAppWebViewController.goBack();

          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    supportZoom: false,
                    clearCache: true,
                    preferredContentMode: UserPreferredContentMode.MOBILE),
                android: AndroidInAppWebViewOptions(
                  allowFileAccess: true,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                ),
              ),
              initialUrlRequest: URLRequest(
                url: Uri.parse("https://www.brighttiger.in/"),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                inAppWebViewController = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progressbar) {
                setState(() {
                  progressBar = progressbar / 100;
                });
              },
            ),
            progressBar < 1
                ? Container(
                    child: LinearProgressIndicator(
                      value: progressBar,
                    ),
                  )
                : const SizedBox()
          ],
        )),
      ),
    );
  }
}
