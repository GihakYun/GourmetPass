<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<%-- 유사 서비스 UX 고도화 스타일 --%>
<style>
    .pending-review-badge { background: #ff5722; color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; margin-left: 5px; }
    .history-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; border-bottom: 2px solid #f4f4f4; padding-bottom: 10px; }
    .badge-review-needed { background-color: #fff3e0; color: #ef6c00; font-size: 11px; padding: 2px 6px; border-radius: 4px; font-weight: bold; margin-right: 8px; border: 1px solid #ffe0b2; }
    .badge-review-done { background-color: #f5f5f5; color: #9e9e9e; font-size: 11px; padding: 2px 6px; border-radius: 4px; margin-right: 8px; border: 1px solid #e0e0e0; }
    .dining-msg { font-size: 13px; color: #2e7d32; font-weight: bold; animation: pulse 2s infinite; }
    @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.6; } 100% { opacity: 1; } }
</style>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}",
        userId: "<sec:authentication property='principal.username'/>",
        role: "ROLE_USER"
    };
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div class="edit-wrapper" style="max-width: 850px;">
    <div class="edit-title">📅 나의 이용현황</div>
    
    <%-- 1. 상단 대시보드 (진행 중인 서비스) --%>
    <div class="dashboard-section">
        <div class="history-card-header">
            <h4 class="card-label" style="margin:0;">🔥 실시간 이용 중</h4>
            <div class="summary-info">
                <span style="font-size: 13px; color: #888;">리뷰 대기</span>
                <span class="pending-review-badge">${pendingReviewCount}</span>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty activeWait or not empty activeBook}">
                <div class="active-service-card">
                    <%-- 웨이팅 정보 --%>
                    <c:if test="${not empty activeWait}">
                        <div class="status-item-row ${activeWait.wait_status == 'ING' ? 'dining-mode' : ''}">
                            <div>
                                <c:choose>
                                    <c:when test="${activeWait.wait_status == 'ING'}">
                                        <span class="badge-cat ing-color">🍽️ 식사 중</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-cat">🚶 웨이팅</span>
                                    </c:otherwise>
                                </c:choose>
                                <h3 class="item-title">${activeWait.store_name}</h3>
                                <p class="item-desc">
                                    <c:choose>
                                        <c:when test="${activeWait.wait_status == 'ING'}"><span class="dining-msg">맛있는 식사 시간 되세요!</span></c:when>
                                        <c:otherwise>대기 번호: <b>${activeWait.wait_num}번</b> / ${activeWait.people_cnt}명</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div style="text-align: right;">
                                <span class="status-text-${activeWait.wait_status == 'CALLED' ? 'green' : 'blue'}">
                                    <c:choose>
                                        <c:when test="${activeWait.wait_status == 'CALLED'}">지금 입장하세요!</c:when>
                                        <c:when test="${activeWait.wait_status == 'ING'}">식사 중</c:when>
                                        <c:otherwise>대기 중</c:otherwise>
                                    </c:choose>
                                </span>
                                <c:if test="${activeWait.wait_status == 'WAITING'}">
                                    <button type="button" class="btn-danger-sm" onclick="cancelWait('${activeWait.wait_id}')">취소</button>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                    <%-- 예약 정보 --%>
                    <c:if test="${not empty activeBook}">
                        <div class="status-item-row ${activeBook.book_status == 'ING' ? 'dining-mode' : ''}">
                            <div>
                                <span class="badge-cat ${activeBook.book_status == 'ING' ? 'ing-color' : 'book-color'}" 
                                      style="${activeBook.book_status != 'ING' ? 'border-color:#e65100; color:#e65100;' : ''}">
                                    ${activeBook.book_status == 'ING' ? '🍽️ 식사 중' : '📅 확정된 예약'}
                                </span>
                                <h3 class="item-title">${activeBook.store_name}</h3>
                                <p class="item-desc">
                                    <c:choose>
                                        <c:when test="${activeBook.book_status == 'ING'}"><span class="dining-msg">맛있는 식사 시간 되세요!</span></c:when>
                                        <c:otherwise>예약 일시: <b><fmt:formatDate value="${activeBook.book_date}" pattern="MM월 dd일 HH:mm"/></b></c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div style="text-align: right;">
                                <span style="font-size: 20px; font-weight: bold; color: ${activeBook.book_status == 'ING' ? '#2e7d32' : '#e65100'};">
                                    ${activeBook.book_status == 'ING' ? '식사 중' : '방문 예정'}
                                </span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-msg">현재 진행 중인 예약이나 웨이팅이 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 2. 중앙 리뷰 섹션 (미작성 리뷰 강조) --%>
    <div class="history-section">
        <h3 class="section-title">⭐ 식사는 어떠셨나요? (리뷰 작성)</h3>
        <div class="history-list-box">
            
            <%-- [통합 로직] 미작성 리뷰 우선 노출 (유사 서비스 패턴) --%>
            <c:forEach var="item" items="${finishedWaits}">
                <div class="history-item">
                    <span>
                        <c:choose>
                            <c:when test="${item.review_id == null}"><span class="badge-review-needed">미작성</span></c:when>
                            <c:otherwise><span class="badge-review-done">작성완료</span></c:otherwise>
                        </c:choose>
                        <b>${item.store_name}</b> - <fmt:formatDate value="${item.wait_date}" pattern="MM/dd"/>
                    </span>
                    <c:choose>
                        <c:when test="${item.review_id == null}">
                            <button class="btn-wire-sm" style="background-color: #ff5722; color: #fff; border:none;" 
                                    onclick="location.href='<c:url value='/review/write?store_id=${item.store_id}&wait_id=${item.wait_id}'/>'">리뷰 쓰기</button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-disabled-sm" disabled>작성 완료</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
            
            <c:forEach var="book" items="${finishedBooks}">
                <div class="history-item">
                    <span>
                        <c:choose>
                            <c:when test="${book.review_id == null}"><span class="badge-review-needed">미작성</span></c:when>
                            <c:otherwise><span class="badge-review-done">작성완료</span></c:otherwise>
                        </c:choose>
                        <b>${book.store_name}</b> - <fmt:formatDate value="${book.book_date}" pattern="MM/dd"/>
                    </span>
                    <c:choose>
                        <c:when test="${book.review_id == null}">
                            <button class="btn-wire-sm" style="background-color: #ff5722; color: #fff; border:none;" 
                                    onclick="location.href='<c:url value='/review/write?store_id=${book.store_id}&book_id=${book.book_id}'/>'">리뷰 쓰기</button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-disabled-sm" disabled>작성 완료</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>

            <c:if test="${empty finishedWaits && empty finishedBooks}">
                <div class="empty-msg" style="padding: 20px;">최근 방문한 내역이 없습니다.</div>
            </c:if>
        </div>
    </div>

    <%-- 3. 하단 전체 히스토리 (토글) --%>
    <div style="text-align: center; margin-top: 30px;">
        <button id="history-toggle-btn" class="btn-history-toggle" onclick="toggleHistory()">전체 이용 내역 보기 ▼</button>
    </div>

    <div id="full-history-area" style="display: none; margin-top: 30px;">
        <h4 class="section-title">📜 전체 이용 내역</h4>
        <table class="edit-table">
            <thead>
                <tr>
                    <th class="w-40">가게명</th>
                    <th class="w-15">유형</th>
                    <th class="w-25">일시</th>
                    <th class="w-20">상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="w" items="${my_wait_list}">
                    <tr>
                        <td style="padding-left: 20px;">${w.store_name}</td>
                        <td align="center">웨이팅</td>
                        <td align="center"><fmt:formatDate value="${w.wait_date}" pattern="yy-MM-dd HH:mm"/></td>
                        <td align="center">${w.wait_status}</td>
                    </tr>
                </c:forEach>
                <c:forEach var="b" items="${my_book_list}">
                    <tr>
                        <td style="padding-left: 20px;">${b.store_name}</td>
                        <td align="center">예약</td>
                        <td align="center"><fmt:formatDate value="${b.book_date}" pattern="yy-MM-dd HH:mm"/></td>
                        <td align="center">${b.book_status}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />