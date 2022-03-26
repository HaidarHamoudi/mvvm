import 'package:dartz/dartz.dart';
import 'package:mvvm/data/responses/responses.dart';
import '../../data/network/failure.dart';
import '../../data/request/request.dart';
import '../model/model.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, String>> forgetPassword(String email);
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest);
  Future<Either<Failure, HomeObject>> getHome();


}
