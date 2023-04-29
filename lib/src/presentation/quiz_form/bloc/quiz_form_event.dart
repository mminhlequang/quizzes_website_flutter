part of 'quiz_form_bloc.dart';

abstract class QuizFormEvent extends Equatable {
  const QuizFormEvent();

  @override
  List<Object> get props => [];
}

class InitQuizFormEvent extends QuizFormEvent {}

class ChangeLangQuizFormEvent extends QuizFormEvent {
  final Map language;
  const ChangeLangQuizFormEvent(this.language);
}

class ChangeSubjectQuizFormEvent extends QuizFormEvent {
  final Map subject;
  const ChangeSubjectQuizFormEvent(this.subject);
}

class ChangeFilterQuizFormEvent extends QuizFormEvent {
  final bool? isForKid;
  const ChangeFilterQuizFormEvent({this.isForKid});
}
