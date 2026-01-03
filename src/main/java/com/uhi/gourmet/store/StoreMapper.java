package com.uhi.gourmet.store;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface StoreMapper {

    /**
     * 점주 가입 2단계: 가게 정보 등록
     * @param vo 가게 정보(상호명, 카테고리, 주소, 좌표, 점주ID 등)
     * @return 성공 시 1
     */
    public int insertStore(StoreVO vo);
    
    // 이후 조원 C가 매장 정보 수정(updateStore),
    //상세 조회(getStore) 등을 여기에 추가하게 됩니다.
}