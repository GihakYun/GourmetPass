<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JSTL 코어 태그 라이브러리 추가 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 로그인</title>
</head>
<body>
    <%-- 1. 로그인 실패 시 에러 메시지 출력 (Controller에서 errorMsg를 보냈을 경우) --%>
    <c:if test="${not empty errorMsg}">
        <script>alert("${errorMsg}");</script>
    </c:if>

    <%-- 2. 로그인 폼 --%>
    <form action="${pageContext.request.contextPath}/login.do" method="post">
        <table border="1" align="center">
            <tr>
                <td colspan="2" align="center"><h3>Gourmet Pass 로그인</h3></td>
            </tr>
            <tr>
                <td>아이디:</td>
                <td><input type="text" name="user_id" required></td>
            </tr> 
            <tr>
                <td>비밀번호:</td>
                <td><input type="password" name="user_pw" required></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="로그인">
                    
                    <%-- [핵심 수정] 회원가입 버튼 클릭 시 '유형 선택 페이지'로 이동 --%>
                    <input type="button" value="회원가입" 
                           onclick="location.href='${pageContext.request.contextPath}/join/select.do'">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>