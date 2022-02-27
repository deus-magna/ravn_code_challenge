import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ravn_code_challenge/core/errors/failure.dart';
import 'package:ravn_code_challenge/data/models/people_response.dart';
import 'package:ravn_code_challenge/domain/use_cases/get_people_from_server.dart';
import 'package:ravn_code_challenge/presentation/bloc/people_cubit.dart';

import '../../fixtures/fixture_reader.dart';

class MockGetPeopleFromServer extends Mock implements GetPeopleFromServer {}

void main() {
  late MockGetPeopleFromServer mockGetPeopleFromServer;
  late PeopleCubit peopleCubit;

  setUp(() {
    mockGetPeopleFromServer = MockGetPeopleFromServer();
    peopleCubit = PeopleCubit(getPeopleFromServer: mockGetPeopleFromServer);
  });
  group('PeopleCubit', () {
    final tPeopleResponse =
        peopleResponseFromJson(fixture('people_response.json'));
    final tPeopleResponse2 =
        peopleResponseFromJson(fixture('people_twice_response.json'));
    final tPeople = tPeopleResponse.results;
    final tPeople2 = tPeopleResponse2.results;

    blocTest<PeopleCubit, PeopleState>(
      'emits [PeopleFirstLoading, PeopleLoaded] when load people first time',
      setUp: () {
        when(() =>
                mockGetPeopleFromServer(next: 'https://swapi.dev/api/people'))
            .thenAnswer((_) async => Right(tPeopleResponse));
      },
      build: () => peopleCubit,
      act: (cubit) => cubit.loadPeopleListFromServer(),
      expect: () => [PeopleFirstLoading(), PeopleLoaded(results: tPeople)],
      verify: (_) {
        verify(() =>
            mockGetPeopleFromServer.call(next: 'https://swapi.dev/api/people'));
      },
    );

    blocTest<PeopleCubit, PeopleState>(
      'emits [PeopleLoading, PeopleLoaded] when load people second time',
      setUp: () {
        when(() => mockGetPeopleFromServer(next: any(named: 'next')))
            .thenAnswer((_) async => Right(tPeopleResponse));
      },
      build: () => peopleCubit,
      act: (cubit) async {
        await cubit.loadPeopleListFromServer();
        await cubit.loadPeopleListFromServer();
      },
      skip: 2,
      expect: () => [
        PeopleLoading(results: tPeople2),
        PeopleLoaded(results: tPeople2),
      ],
      verify: (_) {
        verify(() => mockGetPeopleFromServer.call(
            next: 'https://swapi.dev/api/people/?page=2'));
      },
    );

    final tServerError = ServerFailure.general();

    blocTest<PeopleCubit, PeopleState>(
      'emits [PeopleFirstLoading, PeopleError] when loading data fails',
      setUp: () {
        when(() =>
                mockGetPeopleFromServer(next: 'https://swapi.dev/api/people'))
            .thenAnswer((_) async => Left(tServerError));
      },
      build: () => peopleCubit,
      act: (cubit) => cubit.loadPeopleListFromServer(),
      expect: () => [PeopleFirstLoading(), PeopleError(tServerError.message)],
      verify: (_) {
        verify(() =>
            mockGetPeopleFromServer.call(next: 'https://swapi.dev/api/people'));
      },
    );
  });
}
