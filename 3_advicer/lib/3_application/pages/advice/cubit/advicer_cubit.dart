import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/usecases/advice_usecase.dart';
import 'package:advicer/3_application/pages/advice/bloc/advicer_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advicer_state.dart';

class AdvicerCubit extends Cubit<AdvicerCubitState> {
  AdvicerCubit() : super(AdvicerInitial());

  final AdviceUseCases adviceUseCases = AdviceUseCases();

  void adviceRequested() async {
    emit(AdvicerStateLoading());
    final AdviceEntity advice = await adviceUseCases.getAdvice();
    emit(AdvicerStateLoaded(advice: advice.advice));
    // emit(const AdvicerStateError(message: 'error message'));
  }
}
