import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/usecases/advice_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advicer_state.dart';

class AdvicerCubit extends Cubit<AdvicerCubitState> {
  final AdviceUseCases adviceUseCases;

  AdvicerCubit({required this.adviceUseCases}) : super(AdvicerInitial());

  void adviceRequested() async {
    emit(AdvicerStateLoading());

    Either<Failure, AdviceEntity> failureOrAdvice =
        await adviceUseCases.getAdvice();
    failureOrAdvice.fold(
      (failure) =>
          emit(AdvicerStateError(message: _mapFailureToMessage(failure))),
      (advice) => emit(AdvicerStateLoaded(advice: advice.advice)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Ups, API Error. Please try again!';
      case CacheFailure:
        return 'Ups, Chache failed. Please try again!';
      default:
        return 'Ups, Something gone wrong. Please try again!';
    }
  }
}
