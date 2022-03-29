import 'package:dartz/dartz.dart';
import 'package:mvvm/data/network/failure.dart';
import 'package:mvvm/domain/repository/repository.dart';
import 'package:mvvm/domain/usecase/base_usecase.dart';

class ForgetPasswordUseCase implements BaseUseCase<String, String> {
  final Repository _repository;

  ForgetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, String>> execute(String input) async{
    return await _repository.forgetPassword(input);
  }
}
