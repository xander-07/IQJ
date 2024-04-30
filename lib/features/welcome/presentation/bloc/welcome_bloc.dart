import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:iqj/features/welcome/data/welcome_data.dart';
import 'package:iqj/features/welcome/presentation/bloc/welcome_event.dart';
import 'package:iqj/features/welcome/presentation/bloc/welcome_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeInitialState());

  @override
  Stream<WelcomeState> mapEventToState(WelcomeEvent event) async* {
    if (event is LoadWelcomeDataEvent) {
      yield WelcomeLoadingState();
      try {
        final isWelcomed = await _isUserWelcomed();
        yield WelcomeLoadedState(event.welcomePanelList, isWelcomed);
      } catch (e) {
        yield WelcomeErrorState(e.toString());
      }
    } else if (event is WelcomeUserEvent) {
      await _setUserWelcomed(event.isWelcomed);
    }
  }

  Future<bool> _isUserWelcomed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notAFirstLaunch') ?? false;
  }

  Future<void> _setUserWelcomed(bool isWelcomed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notAFirstLaunch', isWelcomed);
  }
}
