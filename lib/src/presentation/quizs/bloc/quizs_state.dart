part of 'quizs_bloc.dart';

class QuizsState {
  int count;
  int countWithFilter;
  int page;
  int limit;
  List<QueryDocumentSnapshot<Map>>? items;

  bool isForKid;
  bool isPublic;

  List<QueryDocumentSnapshot<Map>>? itemsLangs;
  Map? language;
  List<QueryDocumentSnapshot<Map>>? itemsSubjects;
  Map? subject;

  QuizsState({
    this.isForKid = false,
    this.isPublic = true,
    this.count = 0,
    this.countWithFilter = 0,
    this.page = 1,
    this.limit = 20,
    this.items,
    this.subject,
    this.language,
    this.itemsLangs,
    this.itemsSubjects,
  });

  QuizsState update({
    bool? isForKid,
    bool? isPublic,
    int? count,
    int? countWithFilter,
    int? page,
    int? limit,
    List<QueryDocumentSnapshot<Map>>? items,
    Map? subject,
    List<QueryDocumentSnapshot<Map>>? itemsSubjects,
    List<QueryDocumentSnapshot<Map>>? itemsLangs,
    Map? language,
  }) {
    return QuizsState(
      isForKid: isForKid ?? this.isForKid,
      isPublic: isPublic ?? this.isPublic,
      count: count ?? this.count,
      countWithFilter: countWithFilter ?? this.countWithFilter,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      items: items ?? this.items,
      subject: subject ?? this.subject,
      itemsSubjects: itemsSubjects ?? this.itemsSubjects,
      itemsLangs: itemsLangs ?? this.itemsLangs,
      language: language ?? this.language,
    );
  }
}
