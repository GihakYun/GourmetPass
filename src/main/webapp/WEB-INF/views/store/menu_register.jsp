<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<h2 align="center">➕ 메뉴 등록</h2>

<%-- 
    [수정 포인트] 
    enctype="multipart/form-data" 사용 시, 
    CSRF 필터가 파라미터를 읽을 수 있도록 action URL 뒤에 직접 토큰을 붙여줍니다. 
--%>
<form action="${pageContext.request.contextPath}/store/menu/register?${_csrf.parameterName}=${_csrf.token}"
      method="post"
      enctype="multipart/form-data">

    <%-- 기존 hidden 토큰은 유지 (브라우저 호환성 및 안정성 대비) --%>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

    <input type="hidden" name="store_id" value="${param.store_id}">

    <table border="1" align="center" cellpadding="5">
        <tr>
            <td>메뉴명</td>
            <td><input type="text" name="menu_name" required></td>
        </tr>
        <tr>
            <td>가격</td>
            <td><input type="number" name="menu_price" required></td>
        </tr>
        <tr>
            <td>이미지</td>
            <td><input type="file" name="file"></td>
        </tr>
        <tr>
            <td>대표메뉴</td>
            <td>
                <input type="checkbox" name="menu_sign" value="Y"> 대표 메뉴로 설정
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="등록">
                <input type="button" value="취소" onclick="history.back()">
            </td>
        </tr>
    </table>
</form>

<jsp:include page="../common/footer.jsp" />