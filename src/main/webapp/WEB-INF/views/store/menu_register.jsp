<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="../common/header.jsp" />

<h2 align="center">➕ 메뉴 등록</h2>

<form action="${pageContext.request.contextPath}/store/menu/register"
	method="post" enctype="multipart/form-data">
	<input type="hidden" name="${_csrf.parameterName}"
		value="${_csrf.token}" /> <input type="hidden" name="store_id"
		value="${param.store_id}">

	<table border="1" align="center" cellpadding="5">
		<tr>
			<td>메뉴명</td>
			<td><input type="text" name="menu_name" required></td>
		</tr>
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
			<td><input type="checkbox" name="menu_sign" value="Y">
				대표 메뉴로 설정</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><input type="submit" value="등록">
				<input type="button" value="취소" onclick="history.back()"></td>
		</tr>
	</table>
</form>