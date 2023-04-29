import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';

part 'subjects_event.dart';
part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectsBloc() : super(SubjectsState()) {
    on<FetchSubjectsEvent>(_fetch);
    on<InitSubjectsEvent>(_init);
    on<ChangeLangSubjectsEvent>(_changeLang);
    on<ChangeFilterSubjectsEvent>(_changeFilter);
  }

  _fetch(FetchSubjectsEvent event, emit) async {
    state.page = event.page ?? state.page;
    state.limit = event.limit ?? state.limit;
    emit(state.update());

    if (state.items == null || state.items!.isEmpty || state.page == 1) {
      var query = await colSubjects
          .where(kdb_isForKid, isEqualTo: state.isForKid)
          .where(kdb_isPublic, isEqualTo: state.isPublic)
          .where(kdb_languageCode, isEqualTo: state.language![kdb_languageCode])
          .limit(state.limit)
          .get();
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    } else {
      var last = state.items!.last;
      emit(state.update(items: []));
      var query = await colSubjects
          .where(kdb_isForKid, isEqualTo: state.isForKid)
          .where(kdb_isPublic, isEqualTo: state.isPublic)
          .where(kdb_languageCode, isEqualTo: state.language![kdb_languageCode])
          .startAfterDocument(last)
          .limit(state.limit)
          .get();
      query.docs;
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    }

    AggregateQuerySnapshot querycount = await colSubjects.count().get();
    var count = querycount.count;
    AggregateQuerySnapshot querycountWithFilter = await colSubjects
        .where(kdb_isForKid, isEqualTo: state.isForKid)
        .where(kdb_isPublic, isEqualTo: state.isPublic)
        .where(kdb_languageCode, isEqualTo: state.language![kdb_languageCode])
        .count()
        .get();
    var countWithFilter = querycountWithFilter.count;
    emit(state.update(count: count, countWithFilter: countWithFilter));
  }

  _init(event, emit) async {
    if (state.itemsLangs != null && state.itemsLangs!.isNotEmpty) return;
    var query = await colLangs.get();
    emit(state.update(
        itemsLangs: query.docs as List<QueryDocumentSnapshot<Map>>));
    if (query.docs.isNotEmpty) {
      add(ChangeLangSubjectsEvent(state.itemsLangs!
          .firstWhere((e) => e.data()[kdb_languageCode] == 'vi')
          .data()));
    }
  }

  _changeLang(ChangeLangSubjectsEvent event, emit) async {
    emit(state.update(language: event.language));

    add(const FetchSubjectsEvent(page: 1));
  }

  _changeFilter(ChangeFilterSubjectsEvent event, emit) async {
    emit(state.update(isForKid: event.isForKid, isPublic: event.isPublic));
    add(const FetchSubjectsEvent(page: 1));
  }
}
