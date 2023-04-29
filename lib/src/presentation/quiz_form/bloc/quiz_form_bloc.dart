import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzes/src/firestore_resources/constants.dart';
import 'package:quizzes/src/firestore_resources/instances.dart';

part 'quiz_form_event.dart';
part 'quiz_form_state.dart';

class QuizFormBloc extends Bloc<QuizFormEvent, QuizFormState> {
  QuizFormBloc() : super(QuizFormState()) {
    on<InitQuizFormEvent>(_init);
    on<ChangeLangQuizFormEvent>(_changeLang);
    on<ChangeSubjectQuizFormEvent>(_changeSubject);
    on<ChangeFilterQuizFormEvent>(_changeFilter);
  }

  _init(event, emit) async {
    if (state.itemsLangs != null && state.itemsLangs!.isNotEmpty) return;
    var query = await colLangs.get();
    emit(state.update(
        itemsLangs: query.docs as List<QueryDocumentSnapshot<Map>>));
    if (query.docs.isNotEmpty) {
      add(ChangeLangQuizFormEvent(state.itemsLangs!.first.data()));
    }
  }

  _changeLang(ChangeLangQuizFormEvent event, emit) async {
    emit(state.update(language: event.language));
    var query = await colSubjects
        .where(kdb_isForKid, isEqualTo: state.isForKid)
        .where(kdb_languageCode, isEqualTo: state.language![kdb_languageCode])
        .get();
    emit(state.update(
        itemsSubjects: query.docs as List<QueryDocumentSnapshot<Map>>));
    if (query.docs.isNotEmpty) {
      add(ChangeSubjectQuizFormEvent(state.itemsSubjects!.first.data()));
    }
  }

  _changeFilter(ChangeFilterQuizFormEvent event, emit) async {
    emit(state.update(isForKid: event.isForKid));
    var query = await colSubjects
        .where(kdb_isForKid, isEqualTo: state.isForKid)
        .where(kdb_languageCode, isEqualTo: state.language![kdb_languageCode])
        .get();
    emit(state.update(
        itemsSubjects: query.docs as List<QueryDocumentSnapshot<Map>>));
    if (query.docs.isNotEmpty) {
      add(ChangeSubjectQuizFormEvent(state.itemsSubjects!.first.data()));
    }
  }

  _changeSubject(ChangeSubjectQuizFormEvent event, emit) async {
    emit(state.update(subject: event.subject));
  }
}
