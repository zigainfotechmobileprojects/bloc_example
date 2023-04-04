import 'package:bloc/bloc.dart';
import 'package:blocexample/counter_event.dart';
import 'package:blocexample/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(super.initialState);

  @override
  CounterState get initialState => CounterState.initial();

  @override
  Stream<CounterState> mapEventToState(
      CounterState currentState, CounterEvent event) async* {
    if (event is IncrementEvent) {
      yield currentState..counter += 1;
    }else if (event is DecrementEvent){
      yield currentState..counter -= 1;
    }
  }
}
