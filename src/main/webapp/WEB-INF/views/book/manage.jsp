<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />
<%-- [v1.0.4] 모든 스타일은 member.css에서 통합 관리 [cite: 1] --%>
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<%-- [v1.0.5 추가] 식사중 상태를 위한 추가 스타일 --%>
<style>
    .bg-ing { background-color: #2e7d32 !important; color: white; } /* 식사중 전용 초록색 */
    .btn-ing-sm { background-color: #43a047; color: white; border: 1px solid #2e7d32; padding: 4px 8px; border-radius: 4px; font-size: 12px; cursor: pointer; }
    .action-btn-group button { margin-right: 2px; } /* 버튼 간 간격 미세 조정 */
</style>

<%-- 라이브러리 로드 --%>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    // [설정] 데이터 설정 객체
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}",
        role: "ROLE_OWNER",
        storeId: "${store.store_id}"
    };
</script>
<%-- 외부 JS 파일 로드 (스크롤 위치 유지 및 웹소켓 자동 실행 로직 포함) [cite: 1] --%>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div class="edit-wrapper" style="max-width: 950px;">
    <div class="edit-title">⚙️ 실시간 매장 관리 (테스트 모드)</div>

    <div class="dashboard-section">
        <%-- 1. 실시간 웨이팅 관리 --%>
        <h3 class="section-title wait-color">🚶 실시간 웨이팅 관리</h3>
        <table class="edit-table">
            <thead>
                <tr>
                    <th class="w-3">번호</th>
                    <th class="w-15">고객ID</th>
                    <th class="w-3">인원</th>
                    <th class="w-9">상태</th>
                    <th class="w-70">상태변경 관리 (모든 버튼 활성)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="wait" items="${store_wait_list}">
                    <tr>
                        <td align="center"><b>${wait.wait_num}번</b></td>
                        <td style="text-align: center;">${wait.user_id}</td>
                        <td align="center">${wait.people_cnt}명</td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${wait.wait_status == 'WAITING'}"><span class="badge-status bg-wait">대기중</span></c:when>
                                <c:when test="${wait.wait_status == 'CALLED'}"><span class="badge-status bg-call">호출중</span></c:when>
                                <c:when test="${wait.wait_status == 'ING'}"><span class="badge-status bg-ing">식사중</span></c:when>
                                <c:when test="${wait.wait_status == 'FINISH'}"><span class="badge-status bg-finish">방문완료</span></c:when>
                                <c:otherwise><span class="badge-status bg-cancel">취소/노쇼</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td align="center" class="p-tight">
                            <c:choose>
                                <c:when test="${not empty wait.review_id}">
                                    <span class="lock-msg">🔒 리뷰 작성됨 (수정불가)</span>
                                </c:when>
                                <c:otherwise>
                                    <form action="<c:url value='/wait/updateStatus'/>" method="post" class="action-btn-group">
                                        <input type="hidden" name="wait_id" value="${wait.wait_id}">
                                        <input type="hidden" name="user_id" value="${wait.user_id}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        
                                        <%-- [v1.0.6 테스트용] 모든 관리 버튼 상시 노출 --%>
                                        <button type="submit" name="status" value="CALLED" class="btn-primary-sm">호출</button>
                                        <button type="submit" name="status" value="ING" class="btn-ing-sm">입장확인</button>
                                        <button type="submit" name="status" value="FINISH" class="btn-success-sm">식사완료</button>
                                        <button type="submit" name="status" value="CANCELLED" class="btn-danger-sm">취소/노쇼</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty store_wait_list}">
                    <tr><td colspan="5" class="empty-msg">현재 대기 중인 고객이 없습니다.</td></tr>
                </c:if>
            </tbody>
        </table>

        <%-- 2. 오늘 예약 관리 --%>
        <h3 class="section-title book-color">📅 오늘 예약 관리</h3>
        <table class="edit-table">
            <thead>
                <tr>
                    <th class="w-8">시간</th>
                    <th class="w-16">고객ID</th>
                    <th class="w-3">인원</th>
                    <th class="w-3">상태</th>
                    <th class="w-70">상태변경 관리 (모든 버튼 활성)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${store_book_list}">
                    <tr>
                        <td align="center"><b><fmt:formatDate value="${book.book_date}" pattern="HH:mm"/></b></td>
                        <td style="text-align: center;">${book.user_id}</td>
                        <td align="center">${book.people_cnt}명</td>
                        <td align="center">
                            <c:choose>
                                <c:when test="${book.book_status == 'RESERVED'}"><span class="badge-status bg-wait">예약중</span></c:when>
                                <c:when test="${book.book_status == 'ING'}"><span class="badge-status bg-ing">식사중</span></c:when>
                                <c:when test="${book.book_status == 'FINISH'}"><span class="badge-status bg-finish">식사완료</span></c:when>
                                <c:otherwise><span class="badge-status bg-cancel">${book.book_status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td align="center" class="p-tight">
                            <c:choose>
                                <c:when test="${not empty book.review_id}">
                                    <span class="lock-msg">🔒 리뷰 작성됨 (수정불가)</span>
                                </c:when>
                                <c:otherwise>
                                    <form action="<c:url value='/book/updateStatus'/>" method="post" class="action-btn-group">
                                        <input type="hidden" name="book_id" value="${book.book_id}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        
                                        <%-- [v1.0.6 테스트용] 모든 관리 버튼 상시 노출 --%>
                                        <button type="submit" name="status" value="ING" class="btn-ing-sm">입장확인</button>
                                        <button type="submit" name="status" value="FINISH" class="btn-success-sm">식사완료</button>
                                        <button type="submit" name="status" value="NOSHOW" class="btn-danger-sm">노쇼처리</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty store_book_list}">
                    <tr><td colspan="5" class="empty-msg">오늘 예정된 예약이 없습니다.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />