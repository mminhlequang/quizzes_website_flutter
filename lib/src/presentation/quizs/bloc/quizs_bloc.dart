import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';

part 'quizs_event.dart';
part 'quizs_state.dart';

class QuizsBloc extends Bloc<QuizsEvent, QuizsState> {
  bool _needRefresh = true;
  
  void needRefresh(){
    _needRefresh = false;
  }

  QuizsBloc() : super(QuizsState()) {
    on<FetchQuizsEvent>(_fetch);
    on<InitQuizsEvent>(_init);
    on<ChangeLangQuizsEvent>(_changeLang);
    on<ChangeSubjectQuizsEvent>(_changeSubject);
    on<ChangeFilterQuizsEvent>(_changeFilter);
  }

  _fetch(FetchQuizsEvent event, emit) async {
    state.page = event.page ?? state.page;
    state.limit = event.limit ?? state.limit;
    emit(state.update());

    if (state.items == null || state.items!.isEmpty || state.page == 1) {
      var query = await colQuizs
          .limit(state.limit)
          .where(kdb_isForKid, isEqualTo: state.isForKid)
          .where(kdb_isPublic, isEqualTo: state.isPublic)
          .where(kdb_subjectId, isEqualTo: state.subject![kdb_id])
          .get();
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    } else {
      var last = state.items!.last;
      emit(state.update(items: []));
      var query = await colQuizs
          .where(kdb_isForKid, isEqualTo: state.isForKid)
          .where(kdb_isPublic, isEqualTo: state.isPublic)
          .where(kdb_subjectId, isEqualTo: state.subject![kdb_id])
          .startAfterDocument(last)
          .limit(state.limit)
          .get();
      query.docs;
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    }

    AggregateQuerySnapshot querycount = await colQuizs.count().get();
    var count = querycount.count;
    AggregateQuerySnapshot querycountWithFilter = await colQuizs
        .where(kdb_isForKid, isEqualTo: state.isForKid)
        .where(kdb_isPublic, isEqualTo: state.isPublic)
        .where(kdb_subjectId, isEqualTo: state.subject![kdb_id])
        .count()
        .get();
    var countWithFilter = querycountWithFilter.count;
    emit(state.update(count: count, countWithFilter: countWithFilter));
  }

  _init(event, emit) async {
    if (state.itemsLangs != null &&
        state.itemsLangs!.isNotEmpty &&
        !_needRefresh) return;
    _needRefresh = false;
    var query = await colLangs.get();
    emit(state.update(
        itemsLangs: query.docs as List<QueryDocumentSnapshot<Map>>));
    if (query.docs.isNotEmpty) {
      add(ChangeLangQuizsEvent(state.itemsLangs!.first.data()));
    }
  }

  _changeLang(ChangeLangQuizsEvent event, emit) async {
    emit(state.update(language: event.language));
    var query = await colSubjects
        .where(kdb_languageCode, isEqualTo: state.language![kdb_languageCode])
        .get();
    emit(state.update(
        itemsSubjects: query.docs as List<QueryDocumentSnapshot<Map>>));
    if (query.docs.isNotEmpty) {
      add(ChangeSubjectQuizsEvent(state.itemsSubjects!.first.data()));
    }
  }

  _changeSubject(ChangeSubjectQuizsEvent event, emit) async {
    emit(state.update(subject: event.subject));
    add(const FetchQuizsEvent(page: 1));
  }

  _changeFilter(ChangeFilterQuizsEvent event, emit) async {
    emit(state.update(isForKid: event.isForKid, isPublic: event.isPublic));
    add(const FetchQuizsEvent(page: 1));
  }
}
