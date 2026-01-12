<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">
<script src="<c:url value='/resources/js/common.js'/>"></script>
<script src="<c:url value='/resources/js/address-api.js'/>"></script>
<script src="<c:url value='/resources/js/member-signup.js'/>"></script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<div class="edit-wrapper">
    <div class="edit-title">⚙️ 회원 정보 수정</div>

    <form action="<c:url value='/member/updateProcess'/>" method="post" id="joinForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="user_lat" id="user_lat" value="${member.user_lat}">
        <input type="hidden" name="user_lon" id="user_lon" value="${member.user_lon}">

        <table class="edit-table">
            <tr>
                <th>아이디</th>
                <td><input type="text" name="user_id" id="user_id" value="${member.user_id}" readonly></td>
            </tr>
            <tr>
                <th>새 비밀번호</th>
                <td><input type="password" name="user_pw" id="user_pw" placeholder="변경 시에만 입력하세요"></td>
            </tr>
            <tr>
                <th>비밀번호 확인</th>
                <td>
                    <input type="password" id="user_pw_confirm" placeholder="비밀번호 재입력">
                    <div id="pwCheckMsg"></div>
                </td>
            </tr>
            <tr>
                <th>성명</th>
                <td><input type="text" name="user_nm" value="${member.user_nm}" required></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td><input type="text" name="user_tel" value="${member.user_tel}" required oninput="autoHyphen(this)" maxlength="13"></td>
            </tr>
            <tr>
                <th>주소</th>
                <td>
                    <div class="input-row" style="display: flex; gap: 10px; margin-bottom: 8px;">
                        <input type="text" name="user_zip" id="user_zip" value="${member.user_zip}" style="width: 120px; flex: none;" readonly>
                        <button type="button" onclick="execDaumPostcode('user')" class="btn-action">주소검색</button>
                    </div>
                    <input type="text" name="user_addr1" id="user_addr1" value="${member.user_addr1}" style="margin-bottom:8px;" readonly>
                    <input type="text" name="user_addr2" id="user_addr2" value="${member.user_addr2}" placeholder="상세 주소 입력">
                    <div id="coordStatus" class="msg-ok">주소 변경 시 좌표가 자동 갱신됩니다.</div>
                </td>
            </tr>
        </table>

        <%-- 하단 버튼 배치: 2:1 비율 및 v1.0.4 와이어프레임 디자인 적용 --%>
        <div class="btn-group">
            <button type="submit" class="btn-submit">정보 수정 완료</button>
            <a href="<c:url value='/member/mypage'/>" class="btn-cancel">취소</a>
        </div>
    </form>

    <div class="withdraw-section">
        <button type="button" class="btn-link-withdraw" onclick="dropUser('${member.user_id}')">회원 탈퇴하기</button>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />