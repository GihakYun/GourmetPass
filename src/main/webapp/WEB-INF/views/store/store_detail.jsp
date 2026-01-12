<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<%-- [교정] 관심사 분리: 전용 스타일 및 스크립트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/store_detail.css'/>">

<div class="detail-wrapper">
    <div class="detail-header">
        <h1 class="store-main-title">🏠 ${store.store_name}</h1>
        <div class="store-meta-info">
            <span class="badge-cat">${store.store_category}</span>
            <span class="rating-box">⭐ ${store.avg_rating} <small>(${store.review_cnt}개의 리뷰)</small></span>
        </div>
    </div>
    
    <div class="info-main-card">
        <div class="store-img-section">
            <c:choose>
                <c:when test="${not empty store.store_img}">
                    <img src="<c:url value='/upload/${store.store_img}'/>" class="main-thumb">
                </c:when>
                <c:otherwise><div class="no-img-placeholder">이미지 준비중</div></c:otherwise>
            </c:choose>
        </div>
        <div class="store-text-section">
            <p><b>📍 주소:</b> ${store.store_addr1} ${store.store_addr2}</p>
            <p><b>📞 전화:</b> ${store.store_tel}</p>
            <p><b>⏰ 영업:</b> ${store.open_time} ~ ${store.close_time} (${store.res_unit}분 단위)</p>
            <p><b>🚶 실시간 웨이팅:</b> <span class="wait-count-text">현재 ${currentWaitCount}팀 대기 중</span></p>
            <p class="store-desc-text"><b>📝 소개:</b> ${store.store_desc}</p>
            <div class="view-stats">👀 조회: <fmt:formatNumber value="${store.store_cnt}" />회</div>
        </div>
    </div>

    <div class="menu-section">
        <h3 class="section-title">📋 메뉴 안내</h3>
        <div class="menu-grid">
            <c:forEach var="menu" items="${menuList}">
                <c:if test="${menu.menu_sign == 'Y'}">
                    <div class="menu-wire-card best-item">
                        <div class="menu-img-box">
                            <c:if test="${not empty menu.menu_img}"><img src="<c:url value='/upload/${menu.menu_img}'/>"></c:if>
                        </div>
                        <div class="menu-details">
                            <div class="menu-name">${menu.menu_name}<span class="best-tag">BEST</span></div>
                            <div class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/>원</div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <c:if test="${has_other_menu}">
            <div class="toggle-wrapper">
                <button type="button" class="btn-toggle-wire" id="menu-toggle-btn" onclick="toggleMenus()">전체 메뉴 보기 ↓</button>
            </div>
        </c:if>

        <div id="other-menu-area" style="display: none; margin-top: 20px;">
            <div class="menu-grid">
                <c:forEach var="menu" items="${menuList}"><c:if test="${m.menu_sign == 'N'}">
                    <div class="menu-wire-card">
                        <div class="menu-details">
                            <div class="menu-name">${menu.menu_name}</div>
                            <div class="menu-price"><fmt:formatNumber value="${menu.menu_price}" pattern="#,###"/>원</div>
                        </div>
                    </div>
                </c:if></c:forEach>
            </div>
        </div>
    </div>

    <hr class="wire-hr">

    <h3 class="section-title">🗺️ 찾아오시는 길</h3>
    <div id="map" class="map-wire-box"></div>

    <div class="detail-action-group">
        <button type="button" class="btn-main-wire btn-booking" onclick="showInteraction('booking')">📅 예약하기</button>
        <button type="button" class="btn-main-wire btn-waiting" onclick="showInteraction('waiting')">🚶 웨이팅하기</button>
    </div>

    <div id="booking-area" class="interaction-card" style="display: none;">
        <h3 class="form-title">📅 당일 예약하기</h3>
        <sec:authorize access="isAuthenticated()">
            <form id="bookForm" action="${pageContext.request.contextPath}/book/register" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="step-container">
                    <div class="step-box">
                        <label class="step-label">Step 1. 날짜</label>
                        <input type="text" id="bookDate" name="book_date" readonly class="wire-input-readonly">
                        <label class="step-label" style="margin-top:20px;">Step 2. 인원</label>
                        <select name="people_cnt" class="wire-input">
                            <c:forEach var="i" begin="1" end="10"><option value="${i}">${i}명</option></c:forEach>
                        </select>
                    </div>
                    <div class="step-box time-box">
                        <label class="step-label">Step 3. 시간 선택</label>
                        <div id="timeSlotContainer" class="time-grid"></div>
                        <input type="hidden" name="book_time" id="selectedTime" required>
                    </div>
                </div>
                <button type="submit" class="btn-submit-wire">🚀 예약 확정</button>
            </form>
        </sec:authorize>
    </div>

    <div id="waiting-area" class="interaction-card" style="display: none;">
        <h3 class="form-title">🚶 실시간 웨이팅</h3>
        <p class="wait-info-msg">📢 현재 내 앞에 ${currentWaitCount}팀이 대기하고 있습니다.</p>
        <sec:authorize access="isAuthenticated()">
            <form action="${pageContext.request.contextPath}/wait/register" method="post">
                <input type="hidden" name="store_id" value="${store.store_id}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="wait-form-inner">
                    <label class="step-label">방문 인원 선택</label>
                    <select name="people_cnt" class="wire-input">
                        <c:forEach var="i" begin="1" end="10"><option value="${i}">${i}명</option></c:forEach>
                    </select>
                    <button type="submit" class="btn-submit-wire dark-btn">줄서기 신청</button>
                </div>
            </form>
        </sec:authorize>
    </div>

    <hr class="wire-hr bold-hr">

    <div id="review-section">
        <h3 class="section-title">💬 고객 리뷰 (${store.review_cnt})</h3>
        <div class="review-list-container">
            <c:choose>
                <c:when test="${not empty reviewList}">
                    <c:forEach var="review" items="${reviewList}">
                        <div class="detail-review-card">
                            <div class="review-header">
                                <strong>${review.user_nm}님</strong>
                                <span class="review-date"><fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd" /></span>
                            </div>
                            <div class="review-rating-stars">
                                <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                            </div>
                            <p class="review-body-text">${review.content}</p>
                            <c:if test="${not empty review.img_url}">
                                <img src="<c:url value='/upload/${review.img_url}'/>" class="review-attach-img">
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise><div class="empty-msg">아직 작성된 리뷰가 없습니다.</div></c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%-- [교정] 기초 설정 데이터 전달 (JS에서 사용) --%>
<script>
    const STORE_CONF = {
        lat: "${store.store_lat}", lng: "${store.store_lon}",
        storeName: "${store.store_name}",
        openTime: "${store.open_time}", closeTime: "${store.close_time}",
        resUnit: "${store.res_unit}", contextPath: "${pageContext.request.contextPath}"
    };
</script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="<c:url value='/resources/js/store_detail.js'/>"></script>

<jsp:include page="../common/footer.jsp" />