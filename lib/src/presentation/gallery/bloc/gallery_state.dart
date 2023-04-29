part of 'gallery_bloc.dart';

class GalleryState {
  int count;
  int page;
  int limit;
  List<QueryDocumentSnapshot<Map>>? items;

  GalleryState({
    this.count = 0,
    this.page = 1,
    this.limit = 20,
    this.items,
  });

  GalleryState update({
    int? count,
    int? page,
    int? limit,
    List<QueryDocumentSnapshot<Map>>? items,
  }) {
    return GalleryState(
      count: count ?? this.count,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      items: items ?? this.items,
    );
  }
}
