<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />

<%-- 맛집 목록 전용 스타일 및 스크립트 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/store_list.css'/>">
<%-- main.css의 카드 스타일을 공유하기 위해 추가 연결 --%>
<link rel="stylesheet" href="<c:url value='/resources/css/main.css'/>">
<script src="<c:url value='/resources/js/store_list.js'/>"></script>

<div class="list-wrapper">
    <%-- 상단 필터 섹션 --%>
    <div class="filter-card">
        <form id="filterForm" action="${pageContext.request.contextPath}/store/list" method="get">
            <div class="filter-row">
                <div class="filter-item">
                    <label>📍 지역</label>
                    <select name="region" onchange="submitFilter()" class="wire-select">
                        <option value="">전체 지역</option>
                        <option value="서울" ${region == '서울' ? 'selected' : ''}>서울</option>
                        <option value="경기" ${region == '경기' ? 'selected' : ''}>경기</option>
                        <option value="부산" ${region == '부산' ? 'selected' : ''}>부산</option>
                    </select>
                </div>

                <div class="filter-item">
                    <label>📂 카테고리</label>
                    <input type="hidden" name="category" id="selectedCategory" value="${category}">
                    <div class="chip-group">
                        <%-- [v1.0.4 수정] onclick 이벤트 내의 역슬래시(\) 제거 --%>
                        <div class="cat-chip ${empty category ? 'active' : ''}" onclick="selectCategory('')">전체</div>
                        <div class="cat-chip ${category == '한식' ? 'active' : ''}" onclick="selectCategory('한식')">한식</div>
                        <div class="cat-chip ${category == '일식' ? 'active' : ''}" onclick="selectCategory('일식')">일식</div>
                        <div class="cat-chip ${category == '중식' ? 'active' : ''}" onclick="selectCategory('중식')">중식</div>
                        <div class="cat-chip ${category == '양식' ? 'active' : ''}" onclick="selectCategory('양식')">양식</div>
                        <div class="cat-chip ${category == '카페' ? 'active' : ''}" onclick="selectCategory('카페')">카페</div>
                    </div>
                </div>
            </div>

            <div class="search-row-box">
                <input type="text" name="keyword" value="${keyword}" class="wire-input" placeholder="찾으시는 맛집 이름을 입력하세요">
                <button type="button" onclick="submitFilter()" class="btn-wire-search">검색</button>
            </div>
        </form>
    </div>

    <%-- 맛집 그리드 섹션 --%>
    <div class="store-grid">
        <c:choose>
            <c:when test="${not empty storeList}">
                <c:forEach var="store" items="${storeList}">
                    <%-- main.jsp와 카드 구조 통일 --%>
                    <div class="store-card" onclick="location.href='detail?storeId=${store.store_id}'">
                        <div class="store-img-box">
                            <c:choose>
                                <c:when test="${not empty store.store_img}">
                                    <img src="${pageContext.request.contextPath}/resources/upload/${store.store_img}">
                                </c:when>
                                <c:otherwise><span class="no-img-text">No Image</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="store-info">
                            <div class="store-cat">${store.store_category}</div>
                            <div class="store-name-row">
                                <h3 class="store-name">${store.store_name}</h3>
                                <c:if test="${store.store_cnt >= 100}"><span class="hot-badge">HOT</span></c:if>
                            </div>
                            <p class="store-addr">${store.store_addr1}</p>
                            
                            <%-- 통계 정보 한 줄에 배치 (별점, 리뷰수 포함) --%>
                            <div class="store-stats">
                                <span>⭐ ${store.avg_rating} (${store.review_cnt})</span>
                                <span class="view-cnt">👀 조회 ${store.store_cnt}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-msg-box">
                    <p>검색 결과가 없습니다. 😢</p>
                    <button onclick="location.href='list'" class="btn-reset">필터 초기화</button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />