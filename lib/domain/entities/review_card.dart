enum ReviewGrade { again, hard, good, easy }

/// Item pronto para exibição no flashcard de revisão (Etapa 7, Fluxo 3).
class ReviewCard {
  const ReviewCard({
    required this.vocabularyItemId,
    required this.termEn,
    required this.termPt,
    required this.ipa,
  });

  final String vocabularyItemId;
  final String termEn;
  final String termPt;
  final String ipa;
}

class ReviewSummary {
  const ReviewSummary({required this.reviewedCount, required this.masteredCount, required this.xpEarned});
  final int reviewedCount;
  final int masteredCount;
  final int xpEarned;
}
