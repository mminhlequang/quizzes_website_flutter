part of 'subjects_bloc.dart';

abstract class SubjectsEvent extends Equatable {
  const SubjectsEvent();

  @override
  List<Object> get props => [];
}

class FetchSubjectsEvent extends SubjectsEvent {
  final int? page;
  final int? limit;
  const FetchSubjectsEvent({this.page, this.limit});
}

class InitSubjectsEvent extends SubjectsEvent {}

class ChangeLangSubjectsEvent extends SubjectsEvent {
  final Map language;
  const ChangeLangSubjectsEvent(this.language);
}


class ChangeFilterSubjectsEvent extends SubjectsEvent {
  final bool? isForKid;
  final bool? isPublic;
  const ChangeFilterSubjectsEvent({this.isForKid, this.isPublic});
}
