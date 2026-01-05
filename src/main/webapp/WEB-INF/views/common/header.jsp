<%-- 
    [1] 페이지 설정 지시어
    - contentType: 브라우저에게 "이건 HTML이고 한글(UTF-8)이야"라고 알려줌
    - taglib (c): JSTL 코어 (if문, 반복문 등 사용)
    - taglib (sec): Spring Security 태그 (로그인 여부 확인용) - 이게 핵심입니다!
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gourmet Pass (Basic)</title>
<!-- jQuery 라이브러리: 나중에 AJAX 등을 쓸 때 필요해서 미리 로딩해둠 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
/* 
       [2] CSS 스타일 (디자인)
       - 실제 프로젝트에서는 .css 파일로 따로 빼는 게 좋지만, 
         교육용 예제라 한눈에 보이기 위해 여기에 적었습니다.
    */
body {
	text-align: center; /* 전체 가운데 정렬 */
	font-family: sans-serif; /* 고딕체 계열 폰트 사용 */
}

table {
	margin: 0 auto; /* 테이블 자체를 화면 가운데로 */
	width: 80%; /* 화면 너비의 80%만 차지 */
	border-collapse: collapse; /* 테두리 겹침 방지 (깔끔하게) */
}

th, td {
	padding: 10px; /* 칸 안쪽 여백 */
	border: 1px solid #ccc; /* 옅은 회색 테두리 */
}

a {
	text-decoration: none; /* 링크 밑줄 제거 */
	color: black; /* 글자색 검정 */
	font-weight: bold; /* 글자 굵게 */
}

a:hover {
	color: red; /* 마우스 올리면 빨간색으로 변신 */
}

.nav-bar {
	background-color: #eee; /* 메뉴바 배경: 연한 회색 */
	padding: 10px;
	margin-bottom: 20px; /* 본문과 간격 띄움 */
	border-bottom: 2px solid #ddd; /* 메뉴바 아래에 줄 긋기 */
}
</style>
</head>
<body>

	<!-- [3] 상단 네비게이션 바 (메뉴) 시작 -->
	<div class="nav-bar">
		<!-- 메뉴 배치를 위해 테이블 사용 (왼쪽: 로고 / 오른쪽: 메뉴) -->
		<table style="border: none; width: 100%;">
			<tr style="border: none;">

				<!-- [왼쪽] 로고 영역 -->
				<td style="border: none; text-align: left; width: 30%;">
					<!-- 클릭하면 메인 페이지(/)로 이동 -->
					<h2 style="margin: 0;">
						<a href="${pageContext.request.contextPath}/">Gourmet Pass</a>
					</h2>
				</td>

				<!-- [오른쪽] 메뉴 버튼 영역 -->
				<td style="border: none; text-align: right;">
					<!-- 누구나 볼 수 있는 메뉴 --> <a
					href="${pageContext.request.contextPath}/store/list">[맛집 검색]</a> <%-- 
                    [Security 핵심 1] 비로그인 상태일 때 (isAnonymous)
                    - 로그인 안 한 사람한테만 이 부분이 보입니다.
                --%> <sec:authorize access="isAnonymous()">
                    | <a
							href="${pageContext.request.contextPath}/member/login">로그인</a>
                    | <a
							href="${pageContext.request.contextPath}/member/signup/select">회원가입</a>
					</sec:authorize> <%-- 
                    [Security 핵심 2] 로그인 상태일 때 (isAuthenticated)
                    - 로그인 성공한 사람한테만 이 부분이 보입니다.
                --%> <sec:authorize access="isAuthenticated()">

						<%-- 
                        [정보 꺼내기] principal
                        - Security가 보관 중인 '현재 로그인한 사용자 정보'를 꺼내서 'user' 변수에 담음
                        - ${user.username} : 로그인한 아이디 출력
                    --%>
						<sec:authentication property="principal" var="user" />
                    | <span><b>${user.username}</b>님</span>

						<%-- 
                        [권한 분기 1] 점주님(ROLE_OWNER)만 보이는 메뉴
                        - hasRole('ROLE_OWNER') : 권한 체크 함수
                    --%>
						<sec:authorize access="hasRole('ROLE_OWNER')">
							<%-- [수정] /mypage_owner -> /mypage 로 변경 (컨트롤러가 내부에서 분기함) --%>
    | <a href="${pageContext.request.contextPath}/member/mypage"
								style="color: blue;">[매장관리]</a>
						</sec:authorize>

						<%-- 
                        [권한 분기 2] 일반회원(ROLE_USER)만 보이는 메뉴
                    --%>
						<sec:authorize access="hasRole('ROLE_USER')">
                        | <a
								href="${pageContext.request.contextPath}/member/mypage">[마이페이지]</a>
						</sec:authorize>
                    
                    | 
                    <%-- 
                        [로그아웃 처리]
                        - Security에서는 로그아웃도 POST 방식으로 보내야 안전합니다. (CSRF 토큰 때문)
                        - 그래서 <a> 태그 대신 <form> 태그를 사용했습니다.
                    --%>
						<form action="${pageContext.request.contextPath}/logout"
							method="post" style="display: inline;">
							<input type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}" />
							<button type="submit">로그아웃</button>
						</form>
					</sec:authorize>
				</td>
			</tr>
		</table>
	</div>
	<!-- 헤더 끝 (</body> 태그 없음: 이 파일은 다른 파일에 끼워질 부품이니까요!) -->