package com.uhi.gourmet.store;

import lombok.Data;

@Data
public class MenuVO {
    private int menu_id; // (기본)메뉴 ID
    private int store_id; // (외래)가게 ID(1대 다 관계)
    private String menu_name; //메뉴 이름
    private int menu_price; //메뉴 가격
    private String menu_img; //메뉴 이미지
    private String menu_sign; // 대표 메뉴 여부 (Y/N)
}