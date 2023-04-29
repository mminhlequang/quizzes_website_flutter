part of 'quiz_form_bloc.dart';

class QuizFormState {
  List<QueryDocumentSnapshot<Map>>? itemsLangs;
  Map? language;
  bool isForKid;
  List<QueryDocumentSnapshot<Map>>? itemsSubjects;
  Map? subject;

  QuizFormState({
    this.subject,
    this.language,
    this.itemsLangs,
    this.isForKid = false,
    this.itemsSubjects,
  });

  QuizFormState update({
    Map? subject,
    Map? language,
    List<QueryDocumentSnapshot<Map>>? itemsSubjects,
    bool? isForKid,
    List<QueryDocumentSnapshot<Map>>? itemsLangs,
  }) {
    return QuizFormState(
      subject: subject ?? this.subject,
      language: language ?? this.language,
      itemsSubjects: itemsSubjects ?? this.itemsSubjects,
      isForKid: isForKid ?? this.isForKid,
      itemsLangs: itemsLangs ?? this.itemsLangs,
    );
  }
}
