// state is the data that determines  what your application displays.
// 1. User Action(add,updates, or delete)
// 2. Bloc(receives event and execute the business logic)
// 3. repository(services )(read /write)
// 4. new ui state (rebuild the relevant ui)

// bloc architecture
// 1. event---> describes the user want to do
// 2. bloc-----> receives events, performs logic, calls services and emit states
// 3 state-----> represent the current ui condition

// BlocProvider---> creates and provides bloc
//BlocBuilder-=---> rebuilds ui when state changes
// BlocListener-----> handles one-off effects, such as naviagtion or snackbars
//Blocconsumer------>combines building ui and listening for the effects
//BlocSelecter ------->rebuilds only when a selected value changes
// context.read<T>()-------> access a bloc without subscribing  to its state
// context.watch<T>() -----> subscribes to changes to changes through a provider

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:noteapp/core/common/error_model/error_model.dart';
import 'package:noteapp/features/note/bloc/note_event.dart';
import 'package:noteapp/features/note/bloc/note_state.dart';
import 'package:noteapp/features/note/services/note_services.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitialState()) {
    final noteService = GetIt.instance.get<NoteService>();

    on<NoteEvent>((event, emit) async {
      if (event is NoteInitialEvent) {
        emit(NoteInitialState());
      } else if (event is NoteGetEvent) {
        var result = await noteService.getNotes();
        result.fold(
          (l) {
            emit(GetNoteSuccessState(response: l));
          },
          (r) {
            emit(
              GetNoteErrorState(
                error: ErrorModel(code: r.code, message: r.message),
              ),
            );
          },
        );
      } else if (event is NoteUpdateEvent) {
        var result = await noteService.updateNote(formData: event.formData);
        result.fold(
          (l) {
            emit(UpdateNoteSuccessState(response: l));
          },
          (r) {
            emit(
              UpdateNoteErrorState(
                error: ErrorModel(code: r.code, message: r.message),
              ),
            );
          },
        );
      } else if (event is NoteDeleteEvent) {
        var result = await noteService.deleteNote(formData: event.formData['']);
        result.fold(
          (l) {
            emit(DeleteNoteSuccessState(response: l));
          },
          (r) {
            emit(
              DeleteNoteErrorState(
                error: ErrorModel(code: r.code, message: r.message),
              ),
            );
          },
        );
      }
    });
  }
}
