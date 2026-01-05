<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<jsp:include page="../common/header.jsp" />

<div style="width: 80%; margin: 0 auto; padding: 20px;">
	<h2>👤 마이페이지 (일반 회원)</h2>
	id
	<p>
		반갑습니다, <b>${member.user_nm}</b>님! 고메패스 회원입니다.
	</p>

	<table border="1" cellpadding="10" cellspacing="0" width="100%"
		style="border-collapse: collapse;">
		<tr bgcolor="#f9f9f9">
			<th width="20%">아이디</th>
			<td>${member.user_id}</td>
		</tr>
		<tr>
			<th>이름</th>
			<td>${member.user_nm}</td>
		</tr>
		<tr>
			<th>연락처</th>
			<td>${member.user_tel}</td>
		</tr>
	</table>
	<div style="text-align: right; margin-top: 10px;">
		<button
			onclick="location.href='${pageContext.request.contextPath}/member/edit'">정보
			수정</button>
	</div>

	<hr style="margin: 30px 0;">

	<table border="1" cellpadding="15" cellspacing="0" width="100%"
		style="text-align: center;">
		<tr>
			<td width="50%"><a
				href="${pageContext.request.contextPath}/wait/myStatus"
				style="text-decoration: none; color: black; font-weight: bold;">
					📅 내 예약·웨이팅 확인 </a></td>
			<td>
				<form action="${pageContext.request.contextPath}/logout"
					method="post" style="margin: 0;">
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
					<button type="submit"
						style="background: none; border: none; color: red; cursor: pointer; font-weight: bold;">
						🚪 로그아웃</button>
				</form>
			</td>
		</tr>
	</table>

	<div style="margin-top: 50px; text-align: right;">
		<button type="button" onclick="dropUser()"
			style="color: gray; font-size: 12px; border: none; background: none; cursor: pointer;">
			회원 탈퇴 신청</button>
	</div>
</div>

<script>
	function dropUser() {
		if (confirm("정말로 탈퇴하시겠습니까? 신청하신 내역이 모두 사라집니다.")) {
			const form = document.createElement("form");
			form.method = "POST";
			form.action = "${pageContext.request.contextPath}/member/delete";


			const idInput = document.createElement("input");
			idInput.type = "hidden";
			idInput.name = "user_id";
			idInput.value = "${member.user_id}"; // Controller에서 보낸 member 객체 사용

			const csrfInput = document.createElement("input");
			csrfInput.type = "hidden";
			csrfInput.name = "${_csrf.parameterName}";
			csrfInput.value = "${_csrf.token}";

			form.appendChild(idInput);
			form.appendChild(csrfInput);
			document.body.appendChild(form);
			form.submit();
		}
	}
</script>

<jsp:include page="../common/footer.jsp" />