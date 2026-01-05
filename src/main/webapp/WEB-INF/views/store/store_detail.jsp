<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<style>
    .time-btn {
        padding: 8px 15px; 
        margin: 5px; 
        border: 1px solid #ccc; 
        background-color: #f9f9f9; 
        cursor: pointer; 
        border-radius: 5px;
        transition: 0.2s;
    }
    .time-btn:hover { background-color: #e0e0e0; }
    .time-btn.active { 
        background-color: #ff3d00; 
        color: white; 
        border-color: #ff3d00; 
        font-weight: bold;
    }
</style>

<div style="padding: 20px;">
    <h1>🏠 ${store.store_name} <small style="font-size:15px; color:gray;">(${store.store_category})</small></h1>
    
    <table border="1" cellpadding="10" cellspacing="0" width="100%">
        <tr>
            <td width="300" align="center" bgcolor="#f0f0f0">
                <c:choose>
                    <c:when test="${not empty store.store_img}">
                        <img src="/upload/${store.store_img}" width="280" style="border-radius: 10px;">
                    </c:when>
                    <c:otherwise>이미지 준비중</c:otherwise>
                </c:choose>
            </td>
            <td valign="top">
                <p><b>📍 주소:</b> ${store.store_addr1} ${store.store_addr2}</p>
                <p><b>📞 전화:</b> ${store.store_tel}</p>
                <p><b>⏰ 영업시간:</b> ${store.open_time} ~ ${store.close_time}</p>
                <p><b>📝 소개:</b> ${store.store_desc}</p>
                <p><b>👀 조회수:</b> ${store.store_cnt}</p>
            </td>
        </tr>
    </table>

    <hr>

    <h3>📋 대표 메뉴</h3>
    <ul>
        <c:forEach var="menu" items="${menuList}">
            <li>
                <b>${menu.menu_name}</b> 
                - <span style="color:red;"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/>원</span>
            </li>
        </c:forEach>
        <c:if test="${empty menuList}">
            <li>등록된 메뉴가 없습니다.</li>
        </c:if>
    </ul>

    <hr>

    <h3>🗺️ 찾아오시는 길</h3>
    <div id="map" style="width:100%; height:300px; border:1px solid black;"></div>

    <hr>

    <div style="background-color: #fff8e1; padding: 20px; border: 2px dashed orange; border-radius: 10px;">
        <h3>📅 예약하기 / 웨이팅 (당일 예약 전용)</h3>
        
        <sec:authorize access="isAnonymous()">
            <p><b>⚠️ 예약하려면 로그인이 필요합니다.</b> <a href="${pageContext.request.contextPath}/member/login">[로그인하러 가기]</a></p>
        </sec:authorize>

        <sec:authorize access="isAuthenticated()">
            <form action="${pageContext.request.contextPath}/book/register" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="storeId" value="${store.store_id}">
                
                <sec:authentication property="principal.username" var="loginId"/>
                <input type="hidden" name="userId" value="${loginId}">
                
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <table width="100%">
                    <tr>
                        <td width="50%" valign="top">
                            <p><b>Step 1. 날짜 확인</b></p>
                            <input type="date" name="bookDate" id="bookDate" required 
                                   style="padding: 5px; width: 200px; background-color: #eee;" readonly>
                            
                            <p style="margin-top: 20px;"><b>Step 2. 인원 선택</b></p>
                            <select name="peopleCnt" style="padding: 5px; width: 200px;">
                                <option value="2">2명</option>
                                <option value="3">3명</option>
                                <option value="4">4명</option>
                                <option value="5">5명</option>
                                <option value="6">6명 (단체)</option>
                            </select>
                        </td>
                        <td valign="top" style="padding-left: 20px; border-left: 1px solid #ccc;">
                            <p><b>Step 3. 시간 선택</b> <span style="font-size: 12px; color: gray;">(예약 가능 시간)</span></p>
                            
                            <div id="timeSlotContainer">
                                <span style="color:gray; font-size:13px;">불러오는 중...</span>
                            </div>
                            
                            <input type="hidden" name="bookTime" id="selectedTime" required>
                        </td>
                    </tr>
                </table>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" style="padding: 10px 30px; font-size: 16px; font-weight: bold; background: #ff3d00; color: white; border: none; border-radius: 5px; cursor: pointer;">
                        예약 신청하기
                    </button>
                </div>
            </form>
        </sec:authorize>
    </div>
    
    <br>
    <a href="list">[목록으로 돌아가기]</a>
</div>

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}"></script>
<script>
    // 1. 지도 생성 로직
    window.onload = function() {
        if (${store.store_lat} && ${store.store_lon}) {
            var mapContainer = document.getElementById('map'), 
                mapOption = { center: new kakao.maps.LatLng(${store.store_lat}, ${store.store_lon}), level: 3 };
            var map = new kakao.maps.Map(mapContainer, mapOption);
            var marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(${store.store_lat}, ${store.store_lon}) });
            marker.setMap(map);
        }
        
        // 당일만 선택 가능하게 설정
        var today = new Date().toISOString().split('T')[0];
        var dateInput = document.getElementById("bookDate");
        dateInput.setAttribute('min', today);
        dateInput.setAttribute('max', today);
        dateInput.value = today;
        
        // 페이지 로드 시 즉시 시간표 불러오기
        loadTimeSlots();
    };

    // 2. [AJAX] 시간표 불러오기
    function loadTimeSlots() {
    var storeId = "${store.store_id}";
    // 절대 경로 대신 현재 도메인 기준 경로로 테스트
    var url = "${pageContext.request.contextPath}/store/api/timeSlots";
    
    console.log("요청 주소:", url); // 콘솔에서 주소가 맞는지 확인용

    $.ajax({
        url: url,
        type: "GET",
        data: { store_id: storeId },
        success: function(slots) {
            var html = "";
            if(!slots || slots.length === 0) {
                html = "<span style='color:red;'>영업시간 정보가 없습니다.</span>";
            } else {
                for(var i=0; i<slots.length; i++) {
                    html += '<button type="button" class="time-btn" onclick="selectTime(this, \'' + slots[i] + '\')">' + slots[i] + '</button> ';
                }
            }
            $("#timeSlotContainer").html(html);
        },
        error: function(xhr) {
            console.log("에러 코드:", xhr.status); // 404인지 500인지 출력됨
            $("#timeSlotContainer").html("<span style='color:red;'>데이터 로딩 실패 (에러코드: " + xhr.status + ")</span>");
        }
    });
}

    function selectTime(btn, time) {
        $(".time-btn").removeClass("active");
        $(btn).addClass("active");
        $("#selectedTime").val(time);
    }

    function validateForm() {
        var time = $("#selectedTime").val();
        if(!time) {
            alert("방문 시간을 선택해주세요.");
            return false;
        }
        return true;
    }
</script>

<jsp:include page="../common/footer.jsp" />