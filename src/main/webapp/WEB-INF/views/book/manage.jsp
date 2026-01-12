<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/member.css'/>">

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    const APP_CONFIG = {
        contextPath: "${pageContext.request.contextPath}",
        csrfName: "${_csrf.parameterName}",
        csrfToken: "${_csrf.token}",
        role: "ROLE_OWNER",
        storeId: "${store.store_id}"
    };
    document.addEventListener("DOMContentLoaded", function() {
        if(typeof initMyPageWebSocket === 'function') {
            initMyPageWebSocket(null, APP_CONFIG.role, APP_CONFIG.storeId);
        }
    });
</script>
<script src="<c:url value='/resources/js/member-mypage.js'/>"></script>

<div class="edit-wrapper" style="max-width: 900px;">
    <div class="edit-title">⚙️ 실시간 매장 관리</div>

    <div class="dashboard-section">
        <h3 class="section-title wait-color">🚶 실시간 웨이팅 관리</h3>
        <table class="edit-table">
            <thead>
                <tr>
                    <%-- [v1.0.4] 열 너비 최적화 배분 --%>
                    <th class="w-10">번호</th>
                    <th class="w-20">고객ID</th>
                    <th class="w-10">인원</th>
                    <th class="w-20">현재상태</th>
                    <th class="w-40">상태변경 관리</th>
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
                                <c:when test="${wait.wait_status == 'WAITING'}"><span class="msg-ok">대기중</span></c:when>
                                <c:when test="${wait.wait_status == 'CALLED'}"><span style="color:blue; font-weight:bold;">호출중</span></c:when>
                                <c:when test="${wait.wait_status == 'FINISH'}">방문완료</c:when>
                                <c:otherwise>${wait.wait_status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td align="center">
                            <form action="<c:url value='/wait/updateStatus'/>" method="post" style="display: flex; gap: 5px; justify-content: center;">
                                <input type="hidden" name="wait_id" value="${wait.wait_id}">
                                <input type="hidden" name="user_id" value="${wait.user_id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                
                                <c:if test="${wait.wait_status == 'WAITING'}">
                                    <button type="submit" name="status" value="CALLED" class="btn-primary-sm">호출</button>
                                </c:if>
                                <c:if test="${wait.wait_status == 'CALLED' or wait.wait_status == 'WAITING'}">
                                    <button type="submit" name="status" value="FINISH" class="btn-success-sm">방문완료</button>
                                    <button type="submit" name="status" value="CANCELLED" class="btn-danger-sm">취소</button>
                                </c:if>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty store_wait_list}">
                    <tr><td colspan="5" class="empty-msg">현재 대기 중인 고객이 없습니다.</td></tr>
                </c:if>
            </tbody>
        </table>

        <h3 class="section-title book-color">📅 오늘 예약 관리</h3>
        <table class="edit-table">
            <thead>
                <tr>
                    <%-- [v1.0.4] 예약 테이블 열 너비 배분 --%>
                    <th class="w-15">시간</th>
                    <th class="w-25">고객ID</th>
                    <th class="w-15">인원</th>
                    <th class="w-20">현재상태</th>
                    <th class="w-25">방문확인</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${store_book_list}">
                    <tr>
                        <td align="center"><b><fmt:formatDate value="${book.book_date}" pattern="HH:mm"/></b></td>
                        <td style="text-align: center;">${book.user_id}</td>
                        <td align="center">${book.people_cnt}명</td>
                        <td align="center">${book.book_status}</td>
                        <td align="center">
                            <c:if test="${book.book_status == 'RESERVED'}">
                                <form action="<c:url value='/book/updateStatus'/>" method="post" style="display: flex; gap: 5px; justify-content: center;">
                                    <input type="hidden" name="book_id" value="${book.book_id}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" name="status" value="FINISH" class="btn-success-sm">방문확인</button>
                                    <button type="submit" name="status" value="NOSHOW" class="btn-danger-sm">노쇼</button>
                                </form>
                            </c:if>
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