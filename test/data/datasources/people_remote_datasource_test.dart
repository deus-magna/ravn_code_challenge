import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:ravn_code_challenge/core/errors/exceptions.dart';
import 'package:ravn_code_challenge/data/datasources/people_remote_datasource.dart';
import 'package:ravn_code_challenge/data/models/people_response.dart';
import 'package:ravn_code_challenge/data/models/planet.dart';
import 'package:ravn_code_challenge/data/models/specie.dart';
import 'package:ravn_code_challenge/data/models/vehicle.dart';

import '../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late PeopleRemoteDataSource dataSource;

  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = PeopleRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(String url, String json) {
    when(() =>
            mockHttpClient.get(Uri.parse(url), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture(json), 200));
  }

  void setUpMockHttpClientSuccess404(String url) {
    when(() =>
            mockHttpClient.get(Uri.parse(url), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getPeople', () {
    const tUrl = 'https://swapi.dev/api/people';
    final tPeopleResponse = peopleFromJson(fixture('people_response.json'));

    setUp(() {
      setUpMockHttpClientSuccess200(tUrl, 'people_response.json');
    });
    test(
      'Should perform a GET request on a URL',
      () async {
        // act
        await dataSource.getPeople(tUrl);
        // assert
        verify(() => mockHttpClient.get(Uri.parse(tUrl)));
      },
    );

    test(
      'Should return PeopleResponse when the response code is 200 (success) ',
      () async {
        // act
        final result = await dataSource.getPeople(tUrl);
        // assert
        expect(result, equals(tPeopleResponse));
      },
    );

    test(
      'Should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientSuccess404(tUrl);
        // act
        final call = dataSource.getPeople(tUrl);
        // assert
        expect(() => call, throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getPlanet', () {
    const tUrl = 'https://swapi.dev/api/planets/1';
    final tPlanetResponse = planetFromJson(fixture('planet_response.json'));

    setUp(() {
      setUpMockHttpClientSuccess200(tUrl, 'planet_response.json');
    });
    test(
      'Should perform a GET request on a URL',
      () async {
        // act
        await dataSource.getPlanet(tUrl);
        // assert
        verify(() => mockHttpClient.get(Uri.parse(tUrl)));
      },
    );

    test(
      'Should return Planet when the response code is 200 (success) ',
      () async {
        // act
        final result = await dataSource.getPlanet(tUrl);
        // assert
        expect(result, equals(tPlanetResponse));
      },
    );

    test(
      'Should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientSuccess404(tUrl);
        // act
        final call = dataSource.getPlanet(tUrl);
        // assert
        expect(() => call, throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getSpecie', () {
    const tUrl = 'https://swapi.dev/api/species/1';
    final tSpecieResponse = specieFromJson(fixture('specie_response.json'));

    setUp(() {
      setUpMockHttpClientSuccess200(tUrl, 'specie_response.json');
    });
    test(
      'Should perform a GET request on a URL',
      () async {
        // act
        await dataSource.getSpecie(tUrl);
        // assert
        verify(() => mockHttpClient.get(Uri.parse(tUrl)));
      },
    );

    test(
      'Should return Specie when the response code is 200 (success) ',
      () async {
        // act
        final result = await dataSource.getSpecie(tUrl);
        // assert
        expect(result, equals(tSpecieResponse));
      },
    );

    test(
      'Should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientSuccess404(tUrl);
        // act
        final call = dataSource.getSpecie(tUrl);
        // assert
        expect(() => call, throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getVehicle', () {
    const tUrl = 'https://swapi.dev/api/vehicles/4';
    final tVehicleResponse = vehicleFromJson(fixture('vehicle_response.json'));

    setUp(() {
      setUpMockHttpClientSuccess200(tUrl, 'vehicle_response.json');
    });
    test(
      'Should perform a GET request on a URL',
      () async {
        // act
        await dataSource.getVehicle(tUrl);
        // assert
        verify(() => mockHttpClient.get(Uri.parse(tUrl)));
      },
    );

    test(
      'Should return Vehicle when the response code is 200 (success) ',
      () async {
        // act
        final result = await dataSource.getVehicle(tUrl);
        // assert
        expect(result, equals(tVehicleResponse));
      },
    );

    test(
      'Should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientSuccess404(tUrl);
        // act
        final call = dataSource.getVehicle(tUrl);
        // assert
        expect(() => call, throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
