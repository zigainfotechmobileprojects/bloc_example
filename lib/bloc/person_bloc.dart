import 'package:flutter_bloc/flutter_bloc.dart';

extension IsEqualToIgnoringOrder<T> on Iterable<T> {
  bool isEqualToIgnoringOrder(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Persons>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      if (event is NetworkErrorAction) {
        emit(const FetchResult(
            persons: [], isRetrievedFromCache: false, isNetworkErr: true));
      } else {
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cachedPersons = _cache[url]!;
          final result =
              FetchResult(persons: cachedPersons, isRetrievedFromCache: true);
          emit(result);
        } else {
          final persons = await getPersons(url.urlString);
          _cache[url] = persons;
          final result =
              FetchResult(persons: persons, isRetrievedFromCache: false);
          emit(result);
        }
      }
    });

    on<NetworkErrorAction>(
      (event, emit) {
        emit(const FetchResult(
            persons: [], isRetrievedFromCache: false, isNetworkErr: true));
      },
    );
  }
}
