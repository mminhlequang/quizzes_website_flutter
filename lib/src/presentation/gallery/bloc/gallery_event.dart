part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

class FetchGalleryEvent extends GalleryEvent {
  final int? page;
  final int? limit;
  const FetchGalleryEvent({this.page, this.limit});
}
