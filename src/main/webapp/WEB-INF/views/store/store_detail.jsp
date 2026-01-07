<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<style>
    /* 1. 예약 시스템 관련 스타일 */
    .time-btn {
        padding: 8px 15px; margin: 5px; border: 1px solid #ccc;
        background-color: #f9f9f9; cursor: pointer; border-radius: 5px;
        transition: 0.2s; width: 85px;
    }
    .time-btn:hover:not(:disabled) { background-color: #e0e0e0; }
    .time-btn.active { background-color: #ff3d00; color: white; border-color: #ff3d00; font-weight: bold; }
    .time-btn:disabled { background-color: #eee; color: #bbb; cursor: not-allowed; border-color: #ddd; }
    .step-title { font-weight: bold; margin-bottom: 10px; display: block; }

    /* 2. 메뉴 섹션 그리드 레이아웃 */
    .menu-section { margin: 40px 0; }
    .menu-group-title { 
        font-size: 20px; font-weight: bold; margin-bottom: 20px; 
        padding-left: 12px; border-left: 5px solid #ff3d00; 
    }
    
    .menu-grid { 
        display: grid; 
        grid-template-columns: 1fr 1fr; /* 2열 정렬 */
        gap: 20px; 
    }

    .menu-card { 
        display: flex; align-items: center; padding: 15px; 
        border: 1px solid #eee; border-radius: 12px; 
        background: #fff; transition: 0.2s; box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .menu-card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }

    .menu-card img, .menu-card .no-img { 
        width: 100px; height: 100px; object-fit: cover; 
        border-radius: 10px; margin-right: 15px; background: #f5f5f5;
    }
    
    .menu-details { flex: 1; }
    .menu-name { font-size: 17px; font-weight: bold; color: #333; margin-bottom: 8px; }
    .menu-price { font-size: 18px; color: #ff3d00; font-weight: bold; }
    
    .best-label { 
        font-size: 10px; background: #ff3d00; color: #fff; 
        padding: 2px 6px; border-radius: 4px; margin-left: 6px; vertical-align: middle; 
    }

    /* 3. 토글 버튼 스타일 */
    .toggle-wrapper { text-align: center; margin: 30px 0; }
    .btn-toggle {
        padding: 12px 60px; background: #fff; border: 1px solid #ddd;
        border-radius: 30px; color: #555; font-weight: bold; cursor: pointer;
        transition: 0.3s; font-size: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }
    .btn-toggle:hover { background: #fdfdfd; border-color: #ff3d00; color: #ff3d00; }

    /* 모바일 환경 1열 처리 */
    @media (max-width: 768px) { .menu-grid { grid-template-columns: 1fr; } }
</style>

<div style="padding: 20px; max-width: 1000px; margin: auto;">
    <h1>🏠 ${store.store_name} <small style="font-size:15px; color:gray;">(${store.store_category})</small></h1>
    
    <table border="0" cellpadding="10" cellspacing="0" width="100%" style="border: 1px solid #ddd; border-radius: 12px; overflow: hidden; background: #fff;">
        <tr>
            <td width="350" align="center" bgcolor="#fafafa" style="border-right: 1px solid #ddd;">
                <c:choose>
                    <c:when test="${not empty store.store_img}">
                        <img src="${pageContext.request.contextPath}/upload/${store.store_img}" width="320" style="border-radius: 10px; box-shadow: 2px 2px 10px rgba(0,0,0,0.1);">
                    </c:when>
                    <c:otherwise><div style="width:320px; height:200px; background:#eee; line-height:200px; border-radius:10px; color:#aaa;">이미지 준비중</div></c:otherwise>
                </c:choose>
            </td>
            <td valign="top" style="padding: 25px;">
                <p style="margin-bottom:15px;"><b>📍 주소:</b> ${store.store_addr1} ${store.store_addr2}</p>
                <p style="margin-bottom:15px;"><b>📞 전화:</b> ${store.store_tel}</p>
                <p style="margin-bottom:15px;"><b>⏰ 영업:</b> ${store.open_time} ~ ${store.close_time} (${store.res_unit}분 단위)</p>
                <p style="margin-bottom:15px;"><b>📝 소개:</b> ${store.store_desc}</p>
                <p><b>👀 조회:</b> <fmt:formatNumber value="${store.store_cnt}" />회</p>
            </td>
        </tr>
    </table>

    <div class="menu-section">
        <div class="menu-group-title">📋 대표 메뉴</div>
        <div class="menu-grid">
            <c:forEach var="menu" items="${menuList}">
                <c:if test="${menu.menu_sign == 'Y'}">
                    <div class="menu-card">
                        <c:choose>
                            <c:when test="${not empty menu.menu_img}">
                                <img src="${pageContext.request.contextPath}/upload/${menu.menu_img}">
                            </c:when>
                            <c:otherwise><div class="no-img" style="line-height:100px; text-align:center; color:#ccc; font-size:12px;">No Image</div></c:otherwise>
                        </c:choose>
                        <div class="menu-details">
                            <div class="menu-name">${menu.menu_name}<span class="best-label">BEST</span></div>
                            <div class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/>원</div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <c:set var="hasOtherMenu" value="false" />
        <c:forEach var="m" items="${menuList}"><c:if test="${m.menu_sign == 'N'}"><c:set var="hasOtherMenu" value="true" /></c:if></c:forEach>
        
        <c:if test="${hasOtherMenu}">
            <div class="toggle-wrapper">
                <button type="button" class="btn-toggle" id="menu-toggle-btn" onclick="toggleMenus()">
                    전체 메뉴 보기 ↓
                </button>
            </div>
        </c:if>

        <div id="other-menu-area" style="display: none; margin-top: 30px;">
            <div class="menu-group-title" style="border-left-color: #999;">🍴 일반 메뉴</div>
            <div class="menu-grid">
                <c:forEach var="menu" items="${menuList}">
                    <c:if test="${menu.menu_sign == 'N'}">
                        <div class="menu-card">
                            <c:choose>
                                <c:when test="${not empty menu.menu_img}">
                                    <img src="${pageContext.request.contextPath}/upload/${menu.menu_img}">
                                </c:when>
                                <c:otherwise><div class="no-img" style="line-height:100px; text-align:center; color:#ccc; font-size:12px;">No Image</div></c:otherwise>
                            </c:choose>
                            <div class="menu-details">
                                <div class="menu-name">${menu.menu_name}</div>
                                <div class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/>원</div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>

    <hr style="margin: 40px 0; border: 0; border-top: 1px solid #eee;">

    <h3>🗺️ 찾아오시는 길</h3>
    <div id="map" style="width:100%; height:380px; border-radius: 12px; border:1px solid #ddd; margin-bottom:40px;"></div>

    <div style="background-color: #fffaf0; padding: 35px; border: 1px solid #ffe0b2; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
        <h3 style="color: #e65100; margin-top:0;">📅 당일 예약하기</h3>
        
        <sec:authorize access="isAnonymous()">
            <div style="text-align: center; padding: 30px;">
                <p style="margin-bottom:20px;"><b>로그인 후 맛있는 한 끼를 예약해 보세요!</b></p>
                <a href="${pageContext.request.contextPath}/member/login" style="padding: 12px 30px; background: #ff3d00; color: white; border-radius: 30px; text-decoration: none; font-weight: bold;">로그인</a>
            </div>
        </sec:authorize>

        <sec:authorize access="isAuthenticated()">
            <form action="${pageContext.request.contextPath}/book/register" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="storeId" value="${store.store_id}">
                <sec:authentication property="principal.username" var="loginId"/>
                <input type="hidden" name="userId" value="${loginId}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <div style="display: flex; gap: 40px; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 250px;">
                        <label class="step-title">Step 1. 날짜</label>
                        <input type="text" id="bookDate" name="bookDate" readonly style="padding: 12px; width: 100%; border: 1px solid #ddd; border-radius: 8px; background: #f5f5f5; color:#777;">
                        
                        <label class="step-title" style="margin-top: 25px;">Step 2. 인원</label>
                        <select name="peopleCnt" style="padding: 12px; width: 100%; border: 1px solid #ddd; border-radius: 8px; cursor: pointer;">
                            <c:forEach var="i" begin="1" end="10"><option value="${i}">${i}명</option></c:forEach>
                        </select>
                    </div>

                    <div style="flex: 2; min-width: 300px; border-left: 1px dashed #ffccbc; padding-left: 40px;">
                        <label class="step-title">Step 3. 시간 선택</label>
                        <div id="timeSlotContainer" style="display: flex; flex-wrap: wrap;"></div>
                        <input type="hidden" name="bookTime" id="selectedTime" required>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 40px;">
                    <button type="submit" style="padding: 18px 70px; font-size: 18px; font-weight: bold; background: #ff3d00; color: white; border: none; border-radius: 40px; cursor: pointer; box-shadow: 0 6px 20px rgba(255,61,0,0.3);">
                        🚀 예약 확정하기
                    </button>
                </div>
            </form>
        </sec:authorize>
    </div>
    
    <div style="margin-top: 30px; text-align: center;">
        <a href="list" style="color: #999; text-decoration: none; font-size:14px;">목록으로 돌아가기</a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}"></script>

<script>
    let isExpanded = false;

    // 메뉴 토글 로직
    function toggleMenus() {
        const area = $("#other-menu-area");
        const btn = $("#menu-toggle-btn");
        if (!isExpanded) {
            area.slideDown(400);
            btn.text("메뉴 접기 ↑");
            isExpanded = true;
        } else {
            area.slideUp(400);
            btn.text("전체 메뉴 보기 ↓");
            isExpanded = false;
        }
    }

    $(document).ready(function() {
        // 1. 지도 초기화
        if (${not empty store.store_lat}) {
            var container = document.getElementById('map');
            var options = { center: new kakao.maps.LatLng(${store.store_lat}, ${store.store_lon}), level: 3 };
            var map = new kakao.maps.Map(container, options);
            new kakao.maps.Marker({ position: options.center }).setMap(map);
        }

        // 2. 날짜 설정
        var now = new Date();
        $("#bookDate").val(now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, '0') + "-" + String(now.getDate()).padStart(2, '0'));

        // 3. 타임슬롯 로드
        loadSlots();
    });

    function loadSlots() {
        const open = "${store.open_time}" || "09:00";
        const close = "${store.close_time}" || "22:00";
        const unit = parseInt("${store.res_unit}") || 30;
        const container = $("#timeSlotContainer");

        const toMin = (t) => { let p = t.split(':'); return parseInt(p[0]) * 60 + parseInt(p[1]); };
        const toStr = (m) => { let h = Math.floor(m / 60); let min = m % 60; return (h < 10 ? "0"+h : h) + ":" + (min < 10 ? "0"+min : min); };

        const start = toMin(open);
        const end = toMin(close);
        const nowMin = (new Date().getHours() * 60) + new Date().getMinutes();

        let html = "";
        for (let m = start; m < end; m += unit) {
            let s = toStr(m);
            let dis = m < (nowMin + 10) ? "disabled" : "";
            html += '<button type="button" class="time-btn" ' + dis + ' onclick="setTime(this, \'' + s + '\')">' + s + '</button>';
        }
        container.append(html || "<p style='color:gray;'>가능한 시간이 없습니다.</p>");
    }

    function setTime(btn, t) {
        $(".time-btn").removeClass("active");
        $(btn).addClass("active");
        $("#selectedTime").val(t);
    }

    function validateForm() {
        if(!$("#selectedTime").val()) { alert("시간을 선택해주세요!"); return false; }
        return confirm($("#selectedTime").val() + "시에 예약하시겠습니까?");
    }
</script>

<jsp:include page="../common/footer.jsp" />