<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<script type="text/javascript">
		// [3단계] 사용자에게 알림창을 보여줍니다.
		alert("성공적으로 로그아웃되었습니다.");

		// [4단계] 다시 로그인 화면으로 페이지를 이동시킵니다. 
		// [수정] login.jsp 대신 컨트롤러의 루트 주소(/)로 보냅니다.
		location.href = "${pageContext.request.contextPath}/";
	</script>
</body>
</html>