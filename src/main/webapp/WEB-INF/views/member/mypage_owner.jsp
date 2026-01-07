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
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                        <h3 style="margin: 0;">운영 정보</h3>
                        <%-- [수정] store_id 파라미터를 추가하여 400 에러를 방지합니다. --%>
                        <button onclick="location.href='${pageContext.request.contextPath}/store/update?store_id=${store.store_id}'" 
                                style="padding: 5px 15px; background: #333; color: white; border: none; cursor: pointer; border-radius: 3px;">
                            수정
                        </button>
                    </div>
                    
                    <center>
                        <c:choose>
                            <c:when test="${not empty store.store_img}">
                                <img src="${pageContext.request.contextPath}/upload/${store.store_img}" width="150" height="150" style="object-fit: cover; border-radius: 10px; border: 1px solid #eee;">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 150px; height: 150px; background: #eee; line-height: 150px; border-radius: 10px;">이미지 없음</div>
                            </c:otherwise>
                        </c:choose>
                        <h4 style="margin: 15px 0 5px;">${store.store_name}</h4>
                        <span style="border: 1px solid #ff3d00; color: #ff3d00; padding: 2px 8px; font-size: 12px; border-radius: 10px;">${store.store_category}</span>
                    </center>

                    <table width="100%" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 10px;">
                        <tr>
                            <td style="padding: 5px 0; color: #666;">영업시간</td>
                            <td align="right">
                                <b>
                                    <c:if test="${not empty store.open_time}">${store.open_time} ~ ${store.close_time}</c:if>
                                    <c:if test="${empty store.open_time}">미설정</c:if>
                                </b>
                            </td>
                        </tr>
                        <tr><td style="padding: 5px 0; color: #666;">예약단위</td><td align="right"><b>${store.res_unit}분</b></td></tr>
                        <tr><td style="padding: 5px 0; color: #666;">전화번호</td><td align="right"><b>${store.store_tel}</b></td></tr>
                    </table>

                    <button onclick="location.href='${pageContext.request.contextPath}/book/manage?store_id=${store.store_id}'"
                            style="width: 100%; margin-top: 20px; padding: 15px; background: #ff3d00; color: white; border: none; font-weight: bold; cursor: pointer; border-radius: 5px;">
                        실시간 예약 관리
                    </button>
                </div>

                <div style="flex: 2; border: 1px solid #ccc; padding: 20px; background: #fff;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h3>메뉴 관리 (${menuList.size()})</h3>
                        <button onclick="location.href='${pageContext.request.contextPath}/store/menu/register?store_id=${store.store_id}'"
                                style="padding: 8px 15px; background: #4CAF50; color: white; border: none; cursor: pointer; border-radius: 3px; font-weight: bold;">
                            + 메뉴 추가
                        </button>
                    </div>

                    <table border="1" cellpadding="10" cellspacing="0" width="100%" style="border-collapse: collapse; text-align: center; margin-top: 15px; border: 1px solid #eee;">
                        <tr bgcolor="#f9f9f9">
                            <th>이미지</th><th>메뉴명</th><th>가격</th><th>관리</th>
                        </tr>
                        <c:forEach var="menu" items="${menuList}">
                            <tr>
                                <td>
                                    <c:if test="${not empty menu.menu_img}">
                                        <img src="${pageContext.request.contextPath}/upload/${menu.menu_img}" width="50" height="50" style="object-fit: cover; border-radius: 5px;">
                                    </c:if>
                                </td>
                                <td align="left">
                                    <b>${menu.menu_name}</b>
                                    <c:if test="${menu.menu_sign == 'Y'}">
                                        <span style="font-size: 10px; background: #FFD700; padding: 2px 4px; border-radius: 3px; margin-left: 5px;">대표</span>
                                    </c:if>
                                </td>
                                <td style="color: #d32f2f;"><b><fmt:formatNumber value="${menu.menu_price}" pattern="#,###" />원</b></td>
                                <td>
                                    <%-- [추가] 메뉴 수정 버튼 --%>
                                    <button onclick="location.href='${pageContext.request.contextPath}/store/menu/update?menu_id=${menu.menu_id}'" 
                                            style="padding: 3px 8px; font-size: 12px; background: #2196F3; color: white; border: none; cursor: pointer; border-radius: 3px;">
                                        수정
                                    </button>
                                    <button onclick="deleteMenu(${menu.menu_id})" 
                                            style="padding: 3px 8px; font-size: 12px; color: red; border: 1px solid red; background: white; cursor: pointer; border-radius: 3px; margin-left: 3px;">
                                        삭제
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty menuList}">
                            <tr><td colspan="4" style="padding: 50px; color: gray;">등록된 메뉴가 없습니다.</td></tr>
                        </c:if>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div style="padding: 100px; text-align: center; border: 1px dashed #ccc; background: #fafafa;">
                <h3 style="color: #666;">연결된 매장 정보가 없습니다.</h3>
                <p>가게를 먼저 등록해 주세요.</p>
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