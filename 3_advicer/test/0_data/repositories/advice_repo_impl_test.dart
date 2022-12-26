import 'dart:io';

import 'package:advicer/0_data/datasources/advice_remote_datasource.dart';
import 'package:advicer/0_data/exceptions/exception.dart';
import 'package:advicer/0_data/models/advice_model.dart';
import 'package:advicer/0_data/repositories/advice_repo_impl.dart';
import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'advice_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRemoteDatasource>()])
void main() {
  group('AdviceRepoImpl', () {
    group('should return AdviceEntity', () {
      test('when AdviceRemoteDatasource return a AdviceModel', () async {
        final mockAdviceRemoteDataSource = MockAdviceRemoteDatasource();
        final adviceRepoImplUnderTest =
            AdviceRepoImpl(adviceRemoteDatasource: mockAdviceRemoteDataSource);

        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).thenAnswer(
            (realInvocation) =>
                Future.value(AdviceModel(advice: 'test', id: 42)));

        final result = await adviceRepoImplUnderTest.getAdviceFromDatasource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(result,
            Right<Failure, AdviceEntity>(AdviceModel(advice: 'test', id: 42)));
        verify(mockAdviceRemoteDataSource.getRandomAdviceFromApi()).called(1);
        verifyNoMoreInteractions(mockAdviceRemoteDataSource);
      });
    });

    group('should return left with', () {
      test('a ServerFailure when a ServerException occurs', () async {
        final mockAdviceRemoteDataSource = MockAdviceRemoteDatasource();
        final adviceRepoImplUnderTest =
            AdviceRepoImpl(adviceRemoteDatasource: mockAdviceRemoteDataSource);

        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi())
            .thenThrow(ServerException());

        final result = await adviceRepoImplUnderTest.getAdviceFromDatasource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
      });

      test('a GeneralFailure on all other Exception occurs', () async {
        final mockAdviceRemoteDataSource = MockAdviceRemoteDatasource();
        final adviceRepoImplUnderTest =
            AdviceRepoImpl(adviceRemoteDatasource: mockAdviceRemoteDataSource);

        when(mockAdviceRemoteDataSource.getRandomAdviceFromApi())
            .thenThrow(const SocketException('test'));

        final result = await adviceRepoImplUnderTest.getAdviceFromDatasource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(GeneralFailure()));
      });
    });
  });
}
