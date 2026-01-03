<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 유형 선택</title>
<style>
    .container { text-align: center; margin-top: 100px; }
    .select-box { 
        display: inline-block; width: 250px; height: 300px; 
        border: 1px solid #ddd; margin: 20px; border-radius: 10px;
        padding: 30px; vertical-align: middle; cursor: pointer;
        transition: 0.3s;
    }
    .select-box:hover { background-color: #f9f9f9; border-color: #ff3d00; }
    .icon { font-size: 50px; margin-bottom: 20px; }
    .title { font-size: 20px; font-weight: bold; margin-bottom: 10px; }
    .desc { font-size: 14px; color: #666; }
    a { text-decoration: none; color: black; }
</style>
</head>
<body>

<div class="container">
    <h2>회원가입 유형을 선택해주세요</h2>
    <p>어떤 목적으로 Gourmet Pass를 이용하시나요?</p>
    
    <a href="${pageContext.request.contextPath}/join/general.do">
        <div class="select-box">
            <div class="icon">😊</div>
            <div class="title">일반 회원</div>
            <div class="desc">
                맛집을 예약하고<br>웨이팅을 신청하고 싶어요.
            </div>
        </div>
    </a>

    <a href="${pageContext.request.contextPath}/join/owner1.do">
        <div class="select-box">
            <div class="icon">👨‍🍳</div>
            <div class="title">점주 회원</div>
            <div class="desc">
                우리 가게를 등록하고<br>손님을 받고 싶어요.
            </div>
        </div>
    </a>
</div>

</body>
</html>