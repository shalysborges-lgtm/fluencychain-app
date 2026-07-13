import '../entities/review_card.dart';

/// Espelha as rotas `GET /srs/daily-queue` e `POST /srs/review` (Etapa 16).
abstract class ReviewRepository {
  Future<List<ReviewCard>> getDailyQueue();
  Future<void> submitGrade(String vocabularyItemId, ReviewGrade grade);
}
