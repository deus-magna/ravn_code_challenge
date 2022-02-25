import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ravn_code_challenge/core/errors/failure.dart';
import 'package:ravn_code_challenge/data/models/people_response.dart';
import 'package:ravn_code_challenge/domain/repositories/people_repository.dart';
import 'package:ravn_code_challenge/domain/use_cases/get_people_from_server.dart';

import '../../fixtures/fixture_reader.dart';

class MockPeopleRepository extends Mock implements PeopleRepository {}

void main() {
  late GetPeopleFromServer usecase;
  late MockPeopleRepository mockPeopleRepository;

  setUp(() {
    mockPeopleRepository = MockPeopleRepository();
    usecase = GetPeopleFromServer(mockPeopleRepository);
  });

  final tPeopleResponse = peopleFromJson(fixture('people_response.json'));
  final tServerFailure = ServerFailure.general();

  test('should get People from the repository', () async {
    // arrange
    when(() => mockPeopleRepository.getPeople(any()))
        .thenAnswer((_) async => Right(tPeopleResponse));

    // act
    final result = await usecase(next: 'https://swapi.dev/api/people');

    // assert
    expect(result, Right(tPeopleResponse));
    verify(() => mockPeopleRepository.getPeople(any()));
    verifyNoMoreInteractions(mockPeopleRepository);
  });

  test('should get ServerFailure from the repository', () async {
    // arrange
    when(() => mockPeopleRepository.getPeople(any()))
        .thenAnswer((_) async => Left(tServerFailure));

    // act
    final result = await usecase(next: 'https://swapi.dev/api/people');

    // assert
    expect(result, Left(tServerFailure));
    verify(() => mockPeopleRepository.getPeople(any()));
    verifyNoMoreInteractions(mockPeopleRepository);
  });
}
