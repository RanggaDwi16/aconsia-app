import 'package:aconsia_app/ai/data/datasources/ai_remote_data_source.dart';
import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:dartz/dartz.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remoteDataSource;

  AiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, String>> batchCreateRecommendations({required List<AIRecommendationModel> recommendations}) async{
    try{
      final result = await remoteDataSource.batchCreateRecommendations(recommendations: recommendations);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> clearOldRecommendations({required int daysOld})  async{
    try{
      final result = await remoteDataSource.clearOldRecommendations(daysOld: daysOld);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, AIRecommendationModel>> createRecommendation({required AIRecommendationModel recommendation}) async {
    try{
      final result = await remoteDataSource.createRecommendation(recommendation: recommendation);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteAllRecommendations({required String pasienId}) async {
    try{
      final result = await remoteDataSource.deleteAllRecommendations(pasienId: pasienId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteRecommendation({required String recommendationId})  async {
    try{
      final result = await remoteDataSource.deleteRecommendation(recommendationId: recommendationId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, int>> getRecommendationCount({required String pasienId}) async {
    try{
      final result = await remoteDataSource.getRecommendationCount(pasienId: pasienId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<AIRecommendationModel>>> getRecommendationsByKeywords({required String pasienId, required List<String> keywords}) async {
    try{
      final result = await remoteDataSource.getRecommendationsByKeywords(pasienId: pasienId, keywords: keywords);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<AIRecommendationModel>>> getRecommendationsForPasien({required String pasienId, int limit = 10}) async {
    try{
      final result = await remoteDataSource.getRecommendationsForPasien(pasienId: pasienId, limit: limit);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<AIRecommendationModel>>> getUnviewedRecommendations({required String pasienId})  async{
    try{
      final result = await remoteDataSource.getUnviewedRecommendations(pasienId: pasienId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> markAsViewed({required String recommendationId}) async {
    try{
      final result = await remoteDataSource.markAsViewed(recommendationId: recommendationId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> recommendationExists({required String pasienId, required String kontenId})  async{
    try{
      final result = await remoteDataSource.recommendationExists(pasienId: pasienId, kontenId: kontenId);
      return result.fold(
        (failure) => Left(failure),
        (success) => Right(success),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}