import 'package:iqj/features/welcome/domain/welcome_panel.dart';

abstract class WelcomeEvent {}

class LoadWelcomeDataEvent extends WelcomeEvent {
  final List<WelcomePanel> welcomePanelList;

  LoadWelcomeDataEvent(this.welcomePanelList);
}

class WelcomeUserEvent extends WelcomeEvent {
  final bool isWelcomed;

  WelcomeUserEvent(this.isWelcomed);
}
