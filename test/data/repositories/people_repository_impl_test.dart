import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ravn_code_challenge/core/errors/exceptions.dart';
import 'package:ravn_code_challenge/core/errors/failure.dart';
import 'package:ravn_code_challenge/data/datasources/people_remote_datasource.dart';
import 'package:ravn_code_challenge/data/models/people_response.dart';
import 'package:ravn_code_challenge/data/models/planet.dart';
import 'package:ravn_code_challenge/data/models/specie.dart';
import 'package:ravn_code_challenge/data/models/vehicle.dart';
import 'package:ravn_code_challenge/data/repositories/people_repository_impl.dart';

import '../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements PeopleRemoteDataSource {}

void main() {
  late PeopleRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repositoryImpl =
        PeopleRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getPeople', () {
    const tUrl = 'https://swapi.dev/api/people';
    final tPeopleResponse =
        peopleResponseFromJson(fixture('people_response.json'));
    final tPlanetResponse = planetFromJson(fixture('planet_response.json'));
    final tSpecieResponse = specieFromJson(fixture('specie_response.json'));
    final tVehicleResponse = vehicleFromJson(fixture('vehicle_response.json'));
    final tServerFailure = ServerFailure.general();

    setUp(() {
      when(() => mockRemoteDataSource.getPeople(tUrl))
          .thenAnswer((_) async => tPeopleResponse);
      when(() => mockRemoteDataSource.getPlanet(any()))
          .thenAnswer((_) async => tPlanetResponse);
      when(() => mockRemoteDataSource.getSpecie(any()))
          .thenAnswer((_) async => tSpecieResponse);
      when(() => mockRemoteDataSource.getVehicle(any()))
          .thenAnswer((_) async => tVehicleResponse);
    });
    // arrange

    test('''
Should return remote data when call the remote data source is seccesful''',
        () async {
      // act
      final result = await repositoryImpl.getPeople(tUrl);
      // assert
      verify(() => mockRemoteDataSource.getPeople(tUrl));
      expect(result, equals(Right(tPeopleResponse)));
    });

    test('Should get the specie when call the remote data source is seccesful',
        () async {
      // act
      await repositoryImpl.getPeople(tUrl);
      // assert
      verify(() => mockRemoteDataSource.getPeople(tUrl));
      verify(() => mockRemoteDataSource.getSpecie(any()));
    });

    test('Should get the planet when call the remote data source is seccesful',
        () async {
      // act
      await repositoryImpl.getPeople(tUrl);
      // assert
      verify(() => mockRemoteDataSource.getPeople(tUrl));
      verify(() => mockRemoteDataSource.getPlanet(any()));
    });

    test(
        'Should get the vehicles when call the remote data source is seccesful',
        () async {
      // act
      await repositoryImpl.getPeople(tUrl);
      // assert
      verify(() => mockRemoteDataSource.getPeople(tUrl));
      verify(() => mockRemoteDataSource.getVehicle(any()));
    });

    test('''
Should return Server failure when call the remote data source is unseccessful''',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPeople(tUrl))
          .thenThrow(ServerException('Failed to Load Data', 'Error'));
      // act
      final result = await repositoryImpl.getPeople(tUrl);
      // assert
      verify(() => mockRemoteDataSource.getPeople(tUrl));
      verifyNoMoreInteractions(mockRemoteDataSource);
      expect(result, equals(Left(tServerFailure)));
    });

    test('Should return Server failure when getPlanet is unseccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPeople(tUrl))
          .thenAnswer((_) async => tPeopleResponse);
      when(() => mockRemoteDataSource.getPlanet(any()))
          .thenThrow(ServerException('Failed to Load Data', 'Error'));
      // act
      final result = await repositoryImpl.getPeople(tUrl);
      // assert
      verify(() => mockRemoteDataSource.getPeople(tUrl));
      verify(() => mockRemoteDataSource.getPlanet(any()));
      verifyNoMoreInteractions(mockRemoteDataSource);
      expect(result, equals(Left(tServerFailure)));
    });

    test('Should return Server failure when getSpecie is unseccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPeople(tUrl))
          .thenAnswer((_) async => tPeopleResponse);
      when(() => mockRemoteDataSource.getPlanet(any()))
          .thenAnswer((_) async => tPlanetResponse);
      when(() => mockRemoteDataSource.getSpecie(any()))
          .thenThrow(ServerException('Failed to Load Data', 'Error'));
      // act
      final result = await repositoryImpl.getPeople(tUrl);
      // assert
      verify(() => mockRemoteDataSource.getPeople(tUrl));
      verify(() => mockRemoteDataSource.getPlanet(any()));
      verify(() => mockRemoteDataSource.getSpecie(any()));
      expect(result, equals(Left(tServerFailure)));
    });

    test('Should return Server failure when getVehicle is unseccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPeople(tUrl))
          .thenAnswer((_) async => tPeopleResponse);
      when(() => mockRemoteDataSource.getPlanet(any()))
          .thenAnswer((_) async => tPlanetResponse);
      when(() => mockRemoteDataSource.getSpecie(any()))
          .thenAnswer((_) async => tSpecieResponse);
      when(() => mockRemoteDataSource.getVehicle(any()))
          .thenThrow(ServerException('Failed to Load Data', 'Error'));
      // act
      final result = await repositoryImpl.getPeople(tUrl);
      // assert
      verify(() => mockRemoteDataSource.getPeople(tUrl));
      verify(() => mockRemoteDataSource.getPlanet(any()));
      verify(() => mockRemoteDataSource.getVehicle(any()));
      expect(result, equals(Left(tServerFailure)));
    });
  });
}
