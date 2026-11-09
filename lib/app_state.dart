import 'package:flutter/material.dart';

import 'models.dart';
import 'services/chat_service.dart';

/// Small app-wide state: current tab, theme mode, and cross-tab requests
/// ("show this building on the map", "ask the chatbot this question").
class AppState extends ChangeNotifier {
  AppState(this.data) : chat = ChatService(data.faq);

  final CampusData data;
  final ChatService chat;

  int tab = 0;
  ThemeMode themeMode = ThemeMode.system;

  /// Building the map should focus next (consumed by the map screen).
  final focusBuilding = ValueNotifier<String?>(null);

  /// Question the chat screen should send next (consumed by the chat screen).
  final pendingQuestion = ValueNotifier<String?>(null);

  void goTo(int index) {
    tab = index;
    notifyListeners();
  }

  void showOnMap(String buildingId) {
    focusBuilding.value = buildingId;
    goTo(1);
  }

  void ask(String question) {
    pendingQuestion.value = question;
    goTo(2);
  }

  void toggleTheme(Brightness current) {
    themeMode = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
