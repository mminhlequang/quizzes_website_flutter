part of 'quizs_bloc.dart';

abstract class QuizsEvent extends Equatable {
  const QuizsEvent();

  @override
  List<Object> get props => [];
}

class FetchQuizsEvent extends QuizsEvent {
  final int? page;
  final int? limit;
  const FetchQuizsEvent({this.page, this.limit});
}

class InitQuizsEvent extends QuizsEvent {}

class ChangeLangQuizsEvent extends QuizsEvent {
  final Map language;
  const ChangeLangQuizsEvent(this.language);
}

class ChangeSubjectQuizsEvent extends QuizsEvent {
  final Map subject;
  const ChangeSubjectQuizsEvent(this.subject);
}

class ChangeFilterQuizsEvent extends QuizsEvent {
  final bool? isForKid;
  final bool ?isPublic;
  const ChangeFilterQuizsEvent({this.isForKid, this.isPublic});
}
