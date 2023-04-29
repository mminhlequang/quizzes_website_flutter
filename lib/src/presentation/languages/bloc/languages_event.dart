part of 'languages_bloc.dart';

abstract class LanguagesEvent extends Equatable {
  const LanguagesEvent();

  @override
  List<Object> get props => [];
}

class FetchLanguagesEvent extends LanguagesEvent {
  final int? page;
  final int? limit;
  const FetchLanguagesEvent({this.page, this.limit});
}
