package com.uhi.gourmet.wait;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface WaitMapper {
    // 1. 웨이팅 등록 (WaitServiceImpl에서 호출)
    void insertWait(WaitVO vo);

    // 2. 현재 매장의 가장 높은 대기 번호 조회 (새 번호 발급용)
    Integer selectMaxWaitNum(int store_id);

    // 3. 매장별 현재 대기 팀수 조회 (오늘 기준)
    int selectCurrentWaitCount(int store_id);

    // 4. 일반 회원: 내 웨이팅 내역 조회 (MemberController 마이페이지용)
    List<WaitVO> selectMyWaitList(String user_id);

    // 5. 점주: 특정 매장의 전체 웨이팅 목록 조회 (BookController/manage용)
    List<WaitVO> selectStoreWaitList(int store_id);
    
    // 6. 웨이팅 상태 업데이트 (호출, 입장완료, 취소 등)
    void updateWaitStatus(@Param("wait_id") int wait_id, @Param("status") String status);
}