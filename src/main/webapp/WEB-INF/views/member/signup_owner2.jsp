<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> <%-- 숫자 포맷팅(09:00)을 위해 추가 --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>점주 회원가입 - 2단계 (가게 정보)</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    .msg-ok { color: green; font-size: 12px; font-weight: bold; }
    .msg-no { color: red; font-size: 12px; font-weight: bold; }
    table { margin-top: 20px; border-collapse: collapse; }
    td { padding: 10px; }
    select { padding: 5px; } /* 드롭다운 스타일 추가 */
</style>
</head>
<body>
    <h2 align="center">점주 회원가입 - 2단계 (가게 정보)</h2>
    <p align="center">사장님 계정 생성이 완료되었습니다. 운영하실 <b>가게 정보</b>를 입력해주세요.</p>
    
    <form action="${pageContext.request.contextPath}/member/signup/ownerFinal" method="post" id="ownerStep2Form">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        <input type="hidden" name="store_lat" id="store_lat" value="0.0">
        <input type="hidden" name="store_lon" id="store_lon" value="0.0">

        <table border="1" align="center">
            <tr>
                <td width="120">가게 이름</td>
                <td>
                    <input type="text" name="store_name" id="store_name" placeholder="예: 구르메 식당" required size="30">
                </td>
            </tr>
            <tr>
                <td>가게 전화번호</td>
                <td>
                    <input type="text" name="store_tel" required placeholder="02-123-4567" maxlength="13" oninput="autoHyphen(this)">
                </td>
            </tr>
            <tr>
                <td>가게 주소</td>
                <td>
                    <input type="text" name="store_zip" id="store_zip" placeholder="우편번호" readonly>
                    <button type="button" onclick="execDaumPostcode()">가게 위치 검색</button><br>
                    <input type="text" name="store_addr1" id="store_addr1" placeholder="가게 기본주소" size="40" readonly><br>
                    <input type="text" name="store_addr2" id="store_addr2" placeholder="상세주소">
                    <div id="coordStatus" style="color: blue; font-size: 12px; margin-top: 5px;">주소를 검색해주세요.</div>
                </td>
            </tr>
            
            <%-- [추가] 영업 시간 설정 (기존 텍스트 입력 -> 드롭다운 변경) --%>
            <tr>
                <td>영업 시간</td>
                <td>
                    <select name="open_time">
                        <c:forEach var="i" begin="0" end="23">
                            <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                            <option value="${hour}:00" ${i==9 ? 'selected':''}>${hour}:00</option>
                            <option value="${hour}:30">${hour}:30</option>
                        </c:forEach>
                    </select>
                    &nbsp;부터&nbsp;
                    
                    <select name="close_time">
                        <c:forEach var="i" begin="0" end="23">
                            <fmt:formatNumber var="hour" value="${i}" pattern="00"/>
                            <option value="${hour}:00" ${i==22 ? 'selected':''}>${hour}:00</option>
                            <option value="${hour}:30">${hour}:30</option>
                        </c:forEach>
                    </select>
                    &nbsp;까지
                </td>
            </tr>

            <%-- [추가] 예약 단위 설정 (30분/1시간) --%>
            <tr>
                <td>예약 단위</td>
                <td>
                    <select name="res_unit">
                        <option value="30">30분 단위</option>
                        <option value="60">1시간 단위</option>
                    </select>
                </td>
            </tr>
            
            <%-- [변경] 이미지 업로드는 삭제됨 (마이페이지에서 등록) --%>

            <tr>
                <td>가게 소개</td>
                <td>
                    <textarea name="store_desc" rows="5" cols="40" placeholder="가게 소개를 입력해주세요."></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="최종 가입 완료">
                    <input type="button" value="이전으로" onclick="history.back();">
                </td>
            </tr>
        </table>
    </form>

<script>
    const geocoder = new kakao.maps.services.Geocoder();

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                document.getElementById('store_zip').value = data.zonecode;
                document.getElementById('store_addr1').value = addr;

                geocoder.addressSearch(addr, function(results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var result = results[0];
                        document.getElementById('store_lat').value = result.y;
                        document.getElementById('store_lon').value = result.x;
                        $("#coordStatus").html("<span class='msg-ok'>📍 좌표 추출 완료</span>");
                    }
                });
                document.getElementById('store_addr2').focus();
            }
        }).open();
    }

    const autoHyphen = (target) => {
        target.value = target.value.replace(/[^0-9]/g, '').replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
    }

    $("#ownerStep2Form").submit(function() {
        if($("#store_lat").val() == "0.0") {
            alert("주소 검색을 통해 위치를 지정해주세요.");
            return false;
        }
        return true;
    });
</script>
</body>
</html>