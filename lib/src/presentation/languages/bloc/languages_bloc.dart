import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';

part 'languages_event.dart';
part 'languages_state.dart';

class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
  LanguagesBloc() : super(LanguagesState()) {
    on<FetchLanguagesEvent>(_fetch);
  }

  _fetch(FetchLanguagesEvent event, emit) async {
    state.page = event.page ?? state.page;
    state.limit = event.limit ?? state.limit;
    emit(state.update());

    if (state.items == null || state.items!.isEmpty || state.page == 1) {
      var query = await colLangs.limit(state.limit).get();
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    } else {
      var last = state.items!.last;
      emit(state.update(items: []));
      var query = await colLangs
          .startAfterDocument(last)
          .limit(state.limit)
          .get();
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    }

    if (state.count == 0) {
      AggregateQuerySnapshot query = await colLangs.count().get();
      emit(state.update(count: query.count));
    }
  }
}
