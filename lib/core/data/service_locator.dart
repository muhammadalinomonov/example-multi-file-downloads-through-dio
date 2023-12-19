import 'package:example_app/core/data/dio_settings.dart';
import 'package:example_app/features/journal/data/data_source/journal_datasource.dart';
import 'package:example_app/features/journal/data/data_source/sqlite_service.dart';
import 'package:example_app/features/journal/data/repositories/journal_repository_impl.dart';
import 'package:example_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  serviceLocator.registerLazySingleton(() => DioSettings());
  serviceLocator.registerLazySingleton(() => SqliteService()..initializeDB());
  serviceLocator.registerLazySingleton<JournalDataSource>(
    () => JournalDataSourceImpl(
      dio: serviceLocator.call<DioSettings>().dio,
      sqliteService: serviceLocator.call(),
    ),
  );
  serviceLocator.registerLazySingleton<JournalRepository>(
    () => JournalRepositoryImpl(
      journalDataSource: serviceLocator.call(),
      sqliteService: serviceLocator.call(),
    ),
  );
}
