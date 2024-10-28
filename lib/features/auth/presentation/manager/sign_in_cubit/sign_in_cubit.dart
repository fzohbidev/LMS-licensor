// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:lms/features/auth/domain/use_case/login_use_case.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

var userRole = '';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this.loginUseCase,
  ) : super(SignInInitial());
  final LoginUseCase loginUseCase;
  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    emit(SignInLoading());
    var result = await loginUseCase.call(un: username, pw: password);

    result.fold((failure) {
      emit(SignInFailure(failure.message));
    }, (user) {
      emit(
        // SignInSuccess(
        //   result['jwtToken'], result['username'], result['roles']));
        SignInSuccess(user),
      );
    });
  }
}
