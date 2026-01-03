package com.uhi.gourmet.member;

import org.apache.ibatis.annotations.Param;

import com.uhi.gourmet.store.StoreVO;

public interface MemberMapper {
    
    // [로그인용] 암호화된 비밀번호 가져오기
    String getPassword(@Param("user_id") String user_id);
    
    // [회원가입용] 회원 정보 저장하기
    void join(MemberVO vo);
    // [회원가입용] 아이디 중복확인
    int idCheck(String user_id);
	/*
	 * // [점주가입용] 가게 정보 저장하기 
	 * void insertStore(StoreVO vo);
	 */
}