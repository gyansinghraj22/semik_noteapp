import 'package:flutter/material.dart';
import 'package:noteapp/core/common/error_model/error_model.dart';

@immutable
abstract class NoteState {}

class NoteInitialState extends NoteState {}

class GetNoteSuccessState extends NoteState {
  final Map<String, dynamic> response;
  GetNoteSuccessState({required this.response});
}

class GetNoteErrorState extends NoteState {
  final ErrorModel error;
  GetNoteErrorState({required this.error});
}

class GetNoteByIdSuccessState extends NoteState {
  final dynamic response;
  GetNoteByIdSuccessState({required this.response});
}

class GetNoteByIdErrorState extends NoteState {
  final ErrorModel error;
  GetNoteByIdErrorState({required this.error});
}

class CreateNoteSuccessState extends NoteState {
  final dynamic response;
  CreateNoteSuccessState({required this.response});
}

class CreateNoteErrorState extends NoteState {
  final ErrorModel error;
  CreateNoteErrorState({required this.error});
}

class UpdateNoteSuccessState extends NoteState {
  final dynamic response;
  UpdateNoteSuccessState({required this.response});
}

class UpdateNoteErrorState extends NoteState {
  final ErrorModel error;
  UpdateNoteErrorState({required this.error});
}

class DeleteNoteSuccessState extends NoteState {
  final dynamic response;
  DeleteNoteSuccessState({required this.response});
}

class DeleteNoteErrorState extends NoteState {
  final ErrorModel error;
  DeleteNoteErrorState({required this.error});
}
