import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ravn_code_challenge/core/errors/exceptions.dart';
import 'package:ravn_code_challenge/core/errors/failure.dart';
import 'package:ravn_code_challenge/data/datasources/people_remote_datasource.dart';
import 'package:ravn_code_challenge/data/models/people_response.dart';
import 'package:ravn_code_challenge/data/models/specie.dart';
import 'package:ravn_code_challenge/domain/repositories/people_repository.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  PeopleRepositoryImpl({
    required this.remoteDataSource,
  });

  final PeopleRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, PeopleResponse>> getPeople(String next) async {
    try {
      final peopleResponse = await remoteDataSource.getPeople(next);

      for (var i = 0; i < peopleResponse.results.length; i++) {
        final people = peopleResponse.results[i];
        final homeworld = await remoteDataSource.getPlanet(people.homeworld);
        final specie = people.species.isEmpty
            ? const Specie(name: 'Human')
            : await remoteDataSource.getSpecie(people.species.first);
        peopleResponse.results[i].subheader =
            '${specie.name} from ${homeworld.name}';

        final vehicles = <String>[];
        for (final url in people.vehicles) {
          final vehicle = await remoteDataSource.getVehicle(url);
          vehicles.add(vehicle.name);
        }
        peopleResponse.results[i].vehiclesList = vehicles;
      }

      return Right(peopleResponse);
    } on ServerException catch (_) {
      return Left(ServerFailure.general());
    } on TimeoutException catch (_) {
      return Left(ServerFailure.general());
    } on SocketException catch (_) {
      return Left(ServerFailure.general());
    }
  }
}
