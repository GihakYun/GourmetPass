<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>점주 회원가입 - 2단계 (가게 정보)</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<%-- 카카오 지도 API: 컨트롤러에서 전달받은 kakaoJsKey 사용 --%>
<script type="text/javascript" 
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    .msg-ok { color: green; font-size: 12px; font-weight: bold; }
    .msg-no { color: red; font-size: 12px; font-weight: bold; }
    table { margin-top: 20px; border-collapse: collapse; }
    td { padding: 10px; }
    .step-info { color: #666; font-size: 14px; margin-bottom: 10px; }
</style>
</head>
<body>
    <h2 align="center">점주 회원가입 - 2단계 (가게 정보)</h2>
    <p align="center" class="step-info">사장님 계정 생성이 완료되었습니다. 이제 운영하실 <b>가게 정보</b>를 입력해주세요.</p>
    
    <form action="${pageContext.request.contextPath}/join/ownerFinal.do" method="post" id="ownerStep2Form">
        
        <%-- [중요] 가게 위치 좌표 (StoreVO의 store_lat/lon에 매핑) --%>
        <input type="hidden" name="store_lat" id="store_lat" value="0.0">
        <input type="hidden" name="store_lon" id="store_lon" value="0.0">

        <table border="1" align="center">
            <tr>
                <td width="120">가게 이름</td>
                <td>
                    <input type="text" name="store_nm" id="store_nm" placeholder="예: 구르메 식당" required size="30">
                </td>
            </tr>
            <tr>
                <td>가게 전화번호</td>
                <td>
                    <input type="text" name="store_tel" required placeholder="가게 번호를 입력하세요" 
                           maxlength="13" oninput="autoHyphen(this)">
                </td>
            </tr>
            <tr>
                <td>가게 주소</td>
                <td>
                    <input type="text" name="store_zip" id="store_zip" placeholder="우편번호" readonly>
                    <button type="button" onclick="execDaumPostcode()">가게 위치 검색</button><br>
                    <input type="text" name="store_addr1" id="store_addr1" placeholder="가게 기본주소" size="40" readonly><br>
                    <input type="text" name="store_addr2" id="store_addr2" placeholder="가게 상세주소(층, 호수 등)">
                    <div id="coordStatus" style="color: blue; font-size: 12px; margin-top: 5px;">
                        주소를 검색하면 매장 지도가 자동으로 매핑됩니다.
                    </div>
                </td>
            </tr>
            <tr>
                <td>가게 소개</td>
                <td>
                    <textarea name="store_info" rows="5" cols="40" placeholder="가게를 소개하는 문구를 입력해주세요."></textarea>
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
    // 주소 API 및 좌표 추출 (Kakao Maps Geocoder 사용)
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
                        
                        // StoreVO의 컬럼명 store_lat, store_lon에 값 할당
                        document.getElementById('store_lat').value = result.y;
                        document.getElementById('store_lon').value = result.x;
                        
                        var msg = "📍 매장 좌표 추출 완료! (위도: " + result.y + ", 경도: " + result.x + ")";
                        $("#coordStatus").html("<span class='msg-ok'>" + msg + "</span>");
                    } else {
                        $("#coordStatus").html("<span class='msg-no'>❌ 좌표 추출 실패</span>");
                    }
                });
                document.getElementById('store_addr2').focus();
            }
        }).open();
    }

    // 전화번호 자동 하이픈
    const autoHyphen = (target) => {
        target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
    }

    // 최종 폼 제출 확인
    $("#ownerStep2Form").submit(function() {
        if($("#store_lat").val() == "0.0") {
            alert("가게 주소 검색을 통해 위치를 지정해주세요.");
            return false;
        }
        return true;
    });
</script>
</body>
</html>