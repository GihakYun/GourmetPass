package com.uhi.gourmet.review;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ReviewMapper {
    // 1. 리뷰 등록
    void insertReview(ReviewVO vo);

    // 2. 특정 가게의 리뷰 목록 조회 (작성자 이름 포함)
    List<ReviewVO> selectStoreReviews(int store_id);

    // 3. 내가 작성한 리뷰 목록 조회 (가게 이름 포함)
    List<ReviewVO> selectMyReviews(String user_id);

    // 4. 가게별 리뷰 통계 (평균 별점, 총 리뷰 수 [_cnt 규칙 적용])
    // 리턴되는 Map의 Key는 XML의 Alias에 따라 "review_cnt", "avg_rating"이 됩니다.
    Map<String, Object> selectReviewStats(int store_id);
    
    // 5. 리뷰 삭제
    void deleteReview(int review_id);

    // [v1.0.4 수정] 방문 완료(예약 또는 웨이팅) 횟수 조회 
    // XML의 Alias도 이에 맞춰 total_cnt로 변경하는 것을 권장합니다.
    int countFinishedVisits(@Param("user_id") String user_id, @Param("store_id") int store_id);
}