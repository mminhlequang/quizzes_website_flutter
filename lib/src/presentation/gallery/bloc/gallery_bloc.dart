import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc() : super(GalleryState()) {
    on<FetchGalleryEvent>(_fetch);
  }

  _fetch(FetchGalleryEvent event, emit) async {
    state.page = event.page ?? state.page;
    state.limit = event.limit ?? state.limit;
    emit(state.update());

    if (state.items == null || state.items!.isEmpty || state.page == 1) {
      var query = await colGallery.limit(state.limit).get();
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    } else {
      var last = state.items!.last;
      emit(state.update(items: []));
      var query =
          await colGallery.startAfterDocument(last).limit(state.limit).get();
      emit(state.update(items: query.docs as List<QueryDocumentSnapshot<Map>>));
    }

    AggregateQuerySnapshot query = await colGallery.count().get();
    emit(state.update(count: query.count));
  }
}
