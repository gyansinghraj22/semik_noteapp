import 'package:get_it/get_it.dart';
import 'package:noteapp/core/common/loading_overlay/loading_overlay.dart';
import 'package:noteapp/core/network/dio_client.dart';
import 'package:noteapp/features/auth/bloc/login_bloc.dart';
import 'package:noteapp/features/auth/services/login_service.dart';
import 'package:noteapp/features/note/bloc/note_bloc.dart';
import 'package:noteapp/features/note/services/note_services.dart';

final getIt = GetIt.instance;
Future<void> setUpDi(String baseUrl) async {
  getIt.registerLazySingleton<DioClient>(() => DioClient(baseUrl: baseUrl));

  getIt.registerLazySingleton<LoginService>(() => LoginService(getIt()));
  getIt.registerLazySingleton<NoteService>(() => NoteService(getIt()));

  //bloc
  getIt.registerFactory<NoteBloc>(() => NoteBloc());
  getIt.registerFactory<LoginBloc>(() => LoginBloc());
   getIt.registerSingleton<LoadingOverlay>(LoadingOverlay());
}
