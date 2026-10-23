import 'package:flutter/material.dart';

@immutable
abstract class NoteEvent {}

class NoteInitialEvent extends NoteEvent {}

class NoteGetEvent extends NoteEvent {
  final Map<String, dynamic> formData;
  NoteGetEvent({required this.formData});
}

class NoteGeEventById extends NoteEvent {
  final Map<String, dynamic> formData;
  NoteGeEventById({required this.formData});
}

class NoteUpdateEvent extends NoteEvent {
  final Map<String, dynamic> formData;
  NoteUpdateEvent({required this.formData});
}

class NoteCreateEvent extends NoteEvent {
  final Map<String, dynamic> formData;
  NoteCreateEvent({required this.formData});
}

class NoteDeleteEvent extends NoteEvent {
  final Map<String, dynamic> formData;
  NoteDeleteEvent({required this.formData});
}
