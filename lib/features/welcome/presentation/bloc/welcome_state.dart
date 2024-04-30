import 'package:iqj/features/welcome/domain/welcome_panel.dart';

abstract class WelcomeState {}

class WelcomeInitialState extends WelcomeState {}

class WelcomeLoadingState extends WelcomeState {}

class WelcomeLoadedState extends WelcomeState {
  final List<WelcomePanel> welcomePanelList;
  final bool isWelcomed;

  WelcomeLoadedState(this.welcomePanelList, this.isWelcomed);
}

class WelcomeErrorState extends WelcomeState {
  final String message;

  WelcomeErrorState(this.message);
}
