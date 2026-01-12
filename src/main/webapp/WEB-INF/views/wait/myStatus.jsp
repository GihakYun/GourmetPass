<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

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
    document.addEventListener("DOMContentLoaded", function() {
        if(typeof initMyPageWebSocket === 'function') {
            initMyPageWebSocket(APP_CONFIG.userId, APP_CONFIG.role);
        }
    });
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div class="edit-wrapper" style="max-width: 850px;">
    <div class="edit-title">📅 나의 이용현황</div>
    
    <div class="dashboard-section">
        <c:choose>
            <c:when test="${not empty activeWait or not empty activeBook}">
                <div class="active-service-card">
                    <h4 class="card-label">🔥 현재 이용 중인 서비스</h4>
                    
                    <c:if test="${not empty activeWait}">
                        <div class="status-item-row underline">
                            <div>
                                <span class="badge-cat">실시간 웨이팅</span>
                                <h3 class="item-title">${activeWait.store_name}</h3>
                                <p class="item-desc">대기 번호: <b>${activeWait.wait_num}번</b> / ${activeWait.people_cnt}명</p>
                            </div>
                            <div style="text-align: right;">
                                <span class="status-text-green">
                                    <c:choose>
                                        <c:when test="${activeWait.wait_status == 'CALLED'}">지금 입장하세요!</c:when>
                                        <c:otherwise>대기 중</c:otherwise>
                                    </c:choose>
                                </span>
                                <button type="button" class="btn-danger-sm" onclick="cancelWait('${activeWait.wait_id}')">취소하기</button>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty activeBook}">
                        <div class="status-item-row">
                            <div>
                                <span class="badge-cat book-color" style="border-color:#e65100; color:#e65100;">확정된 예약</span>
                                <h3 class="item-title">${activeBook.store_name}</h3>
                                <p class="item-desc">예약 일시: <b><fmt:formatDate value="${activeBook.book_date}" pattern="MM월 dd일 HH:mm"/></b> / ${activeBook.people_cnt}명</p>
                            </div>
                            <div style="text-align: right;">
                                <span style="font-size: 20px; font-weight: bold; color: #e65100;">방문 예정</span>
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

    <div class="history-section">
        <h3 class="section-title">✅ 최근 방문 완료</h3>
        <div class="history-list-box">
            <c:forEach var="item" items="${finishedWaits}">
                <div class="history-item">
                    <span><b>${item.store_name}</b> (웨이팅) - <fmt:formatDate value="${item.wait_date}" pattern="MM/dd"/></span>
                    <c:choose>
                        <c:when test="${item.review_id == null}">
                            <button class="btn-wire-sm" onclick="location.href='<c:url value='/review/write?store_id=${item.store_id}&wait_id=${item.wait_id}'/>'">리뷰 쓰기</button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-disabled-sm" disabled>작성 완료</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </div>
    </div>

    <div style="text-align: center; margin-top: 30px;">
        <button id="history-toggle-btn" class="btn-history-toggle" onclick="toggleHistory()">전체 이용 내역 보기 ▼</button>
    </div>

    <div id="full-history-area" style="display: none; margin-top: 30px;">
        <h4 class="section-title">📜 전체 히스토리</h4>
        <table class="edit-table">
            <thead>
                <tr>
                    <%-- [v1.0.4] 히스토리 테이블 열 너비 최적화 --%>
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