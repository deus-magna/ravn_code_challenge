import 'package:dartz/dartz.dart';
import 'package:ravn_code_challenge/core/errors/failure.dart';
import 'package:ravn_code_challenge/data/models/people_response.dart';

abstract class PeopleRepository {
  Future<Either<Failure, PeopleResponse>> getPeople(String next);
}
