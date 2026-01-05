<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="../common/header.jsp" />

<div style="width: 90%; margin: 0 auto; padding: 20px;">
    <h2>🏠 내 가게 관리 (점주 전용)</h2>
    <p>매장의 영업 정보와 메뉴를 실시간으로 관리하세요.</p>

    <c:choose>
        <c:when test="${not empty store}">
            <div style="display: flex; gap: 20px;">
                <div style="flex: 1; border: 1px solid #ccc; padding: 20px; background: #fdfdfd;">
                    <div style="display: flex; justify-content: space-between;">
                        <h3>운영 정보</h3>
                        <button onclick="location.href='${pageContext.request.contextPath}/store/update'">수정</button>
                    </div>
                    <center>
                        <c:choose>
                            <c:when test="${not empty store.store_img}">
                                <img src="${pageContext.request.contextPath}/upload/${store.store_img}" width="150" height="150" style="object-fit: cover; border-radius: 10px;">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 150px; height: 150px; background: #eee; line-height: 150px;">이미지 없음</div>
                            </c:otherwise>
                        </c:choose>
                        <h4>${store.store_name}</h4>
                        <span style="border: 1px solid red; color: red; padding: 2px 5px; font-size: 12px;">${store.store_category}</span>
                    </center>
                    <table width="100%" style="margin-top: 20px; border-top: 1px solid #eee;">
                        <%-- [수정 부분] store_time 대신 open_time ~ close_time 연결 --%>
                        <tr>
                            <td>영업시간</td>
                            <td align="right">
                                <b>
                                    <c:if test="${not empty store.open_time}">
                                        ${store.open_time} ~ ${store.close_time}
                                    </c:if>
                                    <c:if test="${empty store.open_time}">미설정</c:if>
                                </b>
                            </td>
                        </tr>
                        <tr><td>예약단위</td><td align="right"><b>${store.res_unit}분</b></td></tr>
                        <tr><td>전화번호</td><td align="right"><b>${store.store_tel}</b></td></tr>
                    </table>
                    <button onclick="location.href='${pageContext.request.contextPath}/book/manage?store_id=${store.store_id}'"
                            style="width: 100%; margin-top: 20px; padding: 15px; background: #ff3d00; color: white; border: none; font-weight: bold; cursor: pointer;">
                        실시간 예약 관리
                    </button>
                </div>

                <div style="flex: 2; border: 1px solid #ccc; padding: 20px;">
                    <div style="display: flex; justify-content: space-between;">
                        <h3>메뉴 관리 (${menuList.size()})</h3>
                        <button onclick="location.href='${pageContext.request.contextPath}/store/menu/register?store_id=${store.store_id}'">메뉴 추가</button>
                    </div>
                    <table border="1" cellpadding="10" cellspacing="0" width="100%" style="border-collapse: collapse; text-align: center; margin-top: 10px;">
                        <tr bgcolor="#eee">
                            <th>이미지</th><th>메뉴명</th><th>가격</th><th>관리</th>
                        </tr>
                        <c:forEach var="menu" items="${menuList}">
                            <tr>
                                <td>
                                    <c:if test="${not empty menu.menu_img}">
                                        <img src="${pageContext.request.contextPath}/upload/${menu.menu_img}" width="50" height="50" style="object-fit: cover;">
                                    </c:if>
                                </td>
                                <td align="left"><b>${menu.menu_name}</b></td>
                                <td style="color: red;"><b><fmt:formatNumber value="${menu.menu_price}" pattern="#,###" />원</b></td>
                                <td>
                                    <button onclick="deleteMenu(${menu.menu_id})" style="color: red; border: 1px solid red; background: white; cursor: pointer;">삭제</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div style="padding: 100px; text-align: center; border: 1px dashed #ccc;">
                <h3>연결된 매장 정보가 없습니다.</h3>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
function deleteMenu(menuId) {
    if(confirm("이 메뉴를 삭제하시겠습니까?")) {
        location.href = "${pageContext.request.contextPath}/store/menu/delete?menu_id=" + menuId;
    }
}
</script>

<jsp:include page="../common/footer.jsp" />