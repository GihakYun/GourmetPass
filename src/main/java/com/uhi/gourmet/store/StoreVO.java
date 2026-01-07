package com.uhi.gourmet.store;

import lombok.Data;

@Data
public class StoreVO {
    private int store_id;           // 가게 고유번호 (PK)
    private String user_id;         // 점주 아이디 (FK)
    private String store_name;      // 상호명
    private String store_category;  // 카테고리 (한식, 중식...)
    private String store_tel;       // 가게 전화번호
    private String store_zip;       // 가게 우편번호
    private String store_addr1;     // 가게 주소
    private String store_addr2;     // 가게 상세주소
    private Double store_lat;       // 위도
    private Double store_lon;       // 경도
    private int store_cnt;          // 조회수 (기본 0)
    private String store_desc;      // 설명
    private String store_img;       // 이미지 경로
    
    //예약 시간 설정용 필드
    private String open_time;  // 예: "11:00"
    private String close_time; // 예: "22:00"
    private int res_unit;           // 예약 단위 (분,30 or 60으로 제한해야 할 듯)

}