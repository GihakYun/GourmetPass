package com.uhi.gourmet.store;

import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface StoreMapper {
	// 메인 페이지용 인기 맛집 조회
	List<StoreVO> selectPopularStore();

	// 맛집 리스트 (카테고리, 지역 필터)
	List<StoreVO> getListStore(@Param("category") String category, @Param("region") String region);

	// 가게 상세 정보
	StoreVO getStoreDetail(int store_id);

	// 가게에 등록된 메뉴 리스트 가져오기
	List<MenuVO> getMenuList(int store_id);

	// 조회수 올리기
	void updateViewCount(int store_id);

	// 점주 가입 시 가게 정보를 등록하는 메서드
	void insertStore(StoreVO store);
	
	// user_id로 내 가게 정보 찾기 (점주 마이페이지용)
    StoreVO getStoreByUserId(String user_id);

    // [추가] 가게 정보 수정
    void updateStore(StoreVO store);

    // [추가] 메뉴 등록
    void insertMenu(MenuVO menu);

    // [추가] 메뉴 삭제
    void deleteMenu(int menu_id);

    // [추가] 메뉴 수정 (이름, 가격, 대표메뉴 여부 등)
    void updateMenu(MenuVO menu);
    
    // [추가] 메뉴 단건 조회 (수정 화면용)
    MenuVO getMenuDetail(int menu_id);
}