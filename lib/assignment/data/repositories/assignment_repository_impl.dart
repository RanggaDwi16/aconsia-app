import 'package:aconsia_app/assignment/data/datasources/assignment_remote_data_source.dart';
import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:dartz/dartz.dart';

class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentRemoteDataSource remoteDataSource;

  AssignmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, KontenAssignmentModel>> createAssignment({required KontenAssignmentModel assignment})  async{
    try{
      final result = await remoteDataSource.createAssignment(assignment: assignment);
      return result.fold(
        (failure) => Left(failure),
        (assignment) => Right(assignment),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteAssignment({required String assignmentId}) async {
    try{
      final result = await remoteDataSource.deleteAssignment(assignmentId: assignmentId);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, KontenAssignmentModel>> getAssignmentById({required String assignmentId})  async{
    try{
      final result = await remoteDataSource.getAssignmentById(assignmentId: assignmentId);
      return result.fold(
        (failure) => Left(failure),
        (assignment) => Right(assignment),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<KontenAssignmentModel>>> getAssignmentsByPasien({required String pasienId}) async {
    try{
      final result =  await remoteDataSource.getAssignmentsByPasien(pasienId: pasienId);
      return result.fold(
        (failure) => Left(failure),
        (assignments) => Right(assignments),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, double>> getCompletionPercentage({required String pasienId})  async{
    try{
      final result = await remoteDataSource.getCompletionPercentage(pasienId: pasienId);
      return result.fold(
        (failure) => Left(failure),
        (percentage) => Right(percentage),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<KontenAssignmentModel>>> getIncompleteAssignments({required String pasienId}) async {
    try{
      final result = await remoteDataSource.getIncompleteAssignments(pasienId: pasienId);
      return result.fold(
        (failure) => Left(failure),
        (assignments) => Right(assignments),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> isKontenAssigned({required String pasienId, required String kontenId})  async{
    try{
      final result = await remoteDataSource.isKontenAssigned(pasienId: pasienId, kontenId: kontenId);
      return result.fold(
        (failure) => Left(failure),
        (isAssigned) => Right(isAssigned),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> markAsCompleted({required String assignmentId}) async {
    try{
      final result = await remoteDataSource.markAsCompleted(assignmentId: assignmentId);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> updateCurrentBagian({required String assignmentId, required int bagianNumber})  async{
    try{
      final result = await remoteDataSource.updateCurrentBagian(assignmentId: assignmentId, bagianNumber: bagianNumber);
      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
