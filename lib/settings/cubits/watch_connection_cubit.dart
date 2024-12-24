import 'package:flutter_bloc/flutter_bloc.dart';

enum WatchConnectionState { unknown, loading, connected, disconnected }

class WatchConnectionCubit extends Cubit<WatchConnectionState> {
  WatchConnectionCubit() : super(WatchConnectionState.unknown);

  void connect() async {
    emit(WatchConnectionState.loading);

    await Future.delayed(Duration(seconds: 3));

    emit(WatchConnectionState.connected);
  }

  void disconnect() async {
    emit(WatchConnectionState.loading);

    await Future.delayed(Duration(seconds: 3));

    emit(WatchConnectionState.disconnected);
  }
}
