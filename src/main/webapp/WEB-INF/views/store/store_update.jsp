<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />

<div style="width: 60%; margin: 50px auto; padding: 30px; border: 1px solid #ddd; border-radius: 10px; background-color: #fff;">
    <h2 align="center">🛠️ 가게 정보 수정</h2>
    <hr style="margin-bottom: 25px;">

    <form action="${pageContext.request.contextPath}/store/update" method="post" enctype="multipart/form-data">
        <%-- [보안] CSRF 토큰 --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        <%-- [핵심] 식별자 및 기존 데이터 유지 --%>
        <input type="hidden" name="store_id" value="${store.store_id}">
        <input type="hidden" name="store_img" value="${store.store_img}">
        <input type="hidden" name="user_id" value="${store.user_id}">
        
        <%-- 좌표 정보 (주소 검색 시 자동 업데이트) --%>
        <input type="hidden" name="store_lat" id="store_lat" value="${store.store_lat}">
        <input type="hidden" name="store_lon" id="store_lon" value="${store.store_lon}">

        <table style="width: 100%; border-collapse: collapse;">
            <tr style="height: 50px;">
                <td style="width: 20%; font-weight: bold;">가게 이름</td>
                <td><input type="text" name="store_name" value="${store.store_name}" required style="width: 80%; padding: 8px;"></td>
            </tr>
            
            <tr style="height: 50px;">
                <td style="font-weight: bold;">카테고리</td>
                <td>
                    <select name="store_category" style="padding: 8px;">
                        <option value="한식" ${store.store_category == '한식' ? 'selected' : ''}>한식</option>
                        <option value="양식" ${store.store_category == '양식' ? 'selected' : ''}>양식</option>
                        <option value="일식" ${store.store_category == '일식' ? 'selected' : ''}>일식</option>
                        <option value="중식" ${store.store_category == '중식' ? 'selected' : ''}>중식</option>
                        <option value="카페" ${store.store_category == '카페' ? 'selected' : ''}>카페/디저트</option>
                    </select>
                </td>
            </tr>

            <tr style="height: 50px;">
                <td style="font-weight: bold;">가게 전화번호</td>
                <td><input type="text" name="store_tel" value="${store.store_tel}" style="width: 80%; padding: 8px;"></td>
            </tr>

            <tr style="height: 120px;">
                <td style="font-weight: bold;">가게 주소</td>
                <td>
                    <input type="text" name="store_zip" id="store_zip" value="${store.store_zip}" placeholder="우편번호" readonly style="width: 30%; padding: 8px; margin-bottom: 5px;">
                    <button type="button" onclick="searchAddress()" style="padding: 7px 15px;">주소 검색</button><br>
                    <input type="text" name="store_addr1" id="store_addr1" value="${store.store_addr1}" placeholder="기본 주소" readonly style="width: 80%; padding: 8px; margin-bottom: 5px;"><br>
                    <input type="text" name="store_addr2" id="store_addr2" value="${store.store_addr2}" placeholder="상세 주소" style="width: 80%; padding: 8px;">
                </td>
            </tr>

            <tr style="height: 50px;">
                <td style="font-weight: bold;">영업 시간</td>
                <td>
                    시작: <input type="time" name="open_time" value="${store.open_time}" style="padding: 8px;">
                    ~ 
                    종료: <input type="time" name="close_time" value="${store.close_time}" style="padding: 8px;">
                </td>
            </tr>

            <tr style="height: 50px;">
                <td style="font-weight: bold;">예약 단위</td>
                <td>
                    <select name="res_unit" style="padding: 8px;">
                        <option value="30" ${store.res_unit == 30 ? 'selected' : ''}>30분 단위</option>
                        <option value="60" ${store.res_unit == 60 ? 'selected' : ''}>1시간 단위</option>
                    </select>
                </td>
            </tr>

            <tr style="height: 150px;">
                <td style="font-weight: bold;">매장 소개</td>
                <td><textarea name="store_desc" style="width: 80%; height: 100px; padding: 8px;">${store.store_desc}</textarea></td>
            </tr>

            <tr style="height: 120px;">
                <td style="font-weight: bold;">대표 이미지</td>
                <td>
                    <c:if test="${not empty store.store_img}">
                        <div style="margin-bottom: 10px;">
                            <img src="${pageContext.request.contextPath}/upload/${store.store_img}" width="150" style="border-radius: 5px; border: 1px solid #ddd;">
                            <p style="font-size: 12px; color: gray;">현재 등록된 이미지</p>
                        </div>
                    </c:if>
                    <input type="file" name="file">
                </td>
            </tr>

            <tr style="height: 80px;">
                <td colspan="2" align="center">
                    <button type="submit" style="padding: 12px 40px; background: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold;">수정 완료</button>
                    <button type="button" onclick="history.back()" style="padding: 12px 40px; background: #f44336; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; margin-left: 10px;">취소</button>
                </td>
            </tr>
        </table>
    </form>
</div>

<%-- 카카오 주소 API 스크립트 --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%-- 위도/경도 추출을 위한 카카오 지도 API (상세 페이지와 동일 키 사용) --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>

<script>
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = data.address; // 최종 주소 변수
            document.getElementById('store_zip').value = data.zonecode;
            document.getElementById('store_addr1').value = addr;
            
            // 주소로 좌표(위도, 경도) 검색
            var geocoder = new kakao.maps.services.Geocoder();
            geocoder.addressSearch(addr, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    document.getElementById('store_lat').value = result[0].y;
                    document.getElementById('store_lon').value = result[0].x;
                }
            });
            document.getElementById('store_addr2').focus();
        }
    }).open();
}
</script>

<jsp:include page="../common/footer.jsp" />