import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models.dart';
import 'theme.dart';
import 'ui/shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UetAssistantApp());
}

class UetAssistantApp extends StatefulWidget {
  const UetAssistantApp({super.key});

  @override
  State<UetAssistantApp> createState() => _UetAssistantAppState();
}

class _UetAssistantAppState extends State<UetAssistantApp> {
  final Future<CampusData> _data = CampusData.load();
  AppState? _state;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CampusData>(
      future: _data,
      builder: (context, snap) {
        if (snap.hasData) _state ??= AppState(snap.data!);
        final state = _state;
        return ListenableBuilder(
          listenable: state ?? ValueNotifier(0),
          builder: (context, _) => MaterialApp(
            title: 'UET Narowal Smart Assistant',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(Brightness.light),
            darkTheme: buildTheme(Brightness.dark),
            themeMode: state?.themeMode ?? ThemeMode.system,
            home: state == null
                ? _Splash(error: snap.error)
                : AppScope(state: state, child: const AppShell()),
          ),
        );
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash({this.error});
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: error != null
            ? Text('Could not load campus data:\n$error', textAlign: TextAlign.center)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
