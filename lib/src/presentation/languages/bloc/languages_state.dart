part of 'languages_bloc.dart';

class LanguagesState {
  int count;
  int page;
  int limit;
  List<QueryDocumentSnapshot<Map>>? items;

  LanguagesState({
    this.count = 0,
    this.page = 1,
    this.limit = 20,
    this.items,
  });

  LanguagesState update({
    int? count,
    int? page,
    int? limit,
    List<QueryDocumentSnapshot<Map>>? items,
  }) {
    return LanguagesState(
      count: count ?? this.count,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      items: items ?? this.items,
    );
  }
}
