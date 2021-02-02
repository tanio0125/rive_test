import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TestViewModel(),
          ),
        ],
        child: Test(),
      ),
    );
  }
}

//ViewModel
class TestViewModel extends ChangeNotifier {
  Artboard artBoard;

  TestViewModel() {
    this._loadRiveFile();
  }

// Riveファイルを読み込む
  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/rive/marty_v6.riv');
    final file = RiveFile();

    if (file.import(bytes)) {
      // ファイルの読み込みに成功
      artBoard = file.mainArtboard;
      artBoard.animations.forEach((element) {
        print(element.name);
      });

      artBoard.addController(
        SimpleAnimation('Animation1'),
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//View
class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TestViewModel vm = context.watch<TestViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Riveテスト'),
      ),
      body: Container(
        child: Center(
          child: vm.artBoard != null
              ? Rive(
                  artboard: vm.artBoard,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )
              : Container(),
        ),
      ),
    );
  }
}
