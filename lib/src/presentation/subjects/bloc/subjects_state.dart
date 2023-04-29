part of 'subjects_bloc.dart';

class SubjectsState {
  int count;
  int countWithFilter;
  int page;
  int limit;
  List<QueryDocumentSnapshot<Map>>? items;
  
  bool isForKid;
  bool isPublic;
  
  List<QueryDocumentSnapshot<Map>>? itemsLangs;
  Map? language;

  SubjectsState({
    this.isForKid = true,
    this.isPublic = true,
    this.count = 0,
    this.countWithFilter = 0,
    this.page = 1,
    this.limit = 20,
    this.items,
    this.language,
    this.itemsLangs,
  });

  SubjectsState update({
    bool? isForKid,
    bool? isPublic,
    int? count,
    int? countWithFilter,
    int? page,
    int? limit,
    List<QueryDocumentSnapshot<Map>>? items,
    List<QueryDocumentSnapshot<Map>>? itemsLangs,
    Map? language,
  }) {
    return SubjectsState(
      isForKid: isForKid ?? this.isForKid,
      isPublic: isPublic ?? this.isPublic,
      count: count ?? this.count,
      countWithFilter: countWithFilter ?? this.countWithFilter,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      items: items ?? this.items,
      itemsLangs: itemsLangs ?? this.itemsLangs,
      language: language ?? this.language,
    );
  }
}
