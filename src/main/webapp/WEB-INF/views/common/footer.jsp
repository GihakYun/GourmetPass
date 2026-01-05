<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<div style="height: 100px;"></div> 

<div style="position: fixed; bottom: 0; left: 0; width: 100%; height: 70px; background-color: #f9f9f9; border-top: 2px solid #ddd; z-index: 1030;">
    
    <table style="width: 100%; height: 100%; border-collapse: collapse; table-layout: fixed;">
        <tr>
            <td style="text-align: center; border: 1px solid #eee;">
                <a href="${pageContext.request.contextPath}/" style="display: block; text-decoration: none; color: #666;">
                    <div style="font-size: 20px;">🏠</div>
                    <div style="font-size: 12px; font-weight: bold;">홈</div>
                </a>
            </td>
            
            <td style="text-align: center; border: 1px solid #eee;">
                <a href="${pageContext.request.contextPath}/store/list" style="display: block; text-decoration: none; color: #666;">
                    <div style="font-size: 20px;">🔍</div>
                    <div style="font-size: 12px; font-weight: bold;">검색</div>
                </a>
            </td>
            
            <td style="text-align: center; border: 1px solid #eee;">
                <sec:authorize access="isAnonymous()">
                    <a href="${pageContext.request.contextPath}/member/login" style="display: block; text-decoration: none; color: #666;">
                        <div style="font-size: 20px;">📅</div>
                        <div style="font-size: 12px; font-weight: bold;">이용현황</div>
                    </a>
                </sec:authorize>
                
                <sec:authorize access="isAuthenticated()">
                    <%-- [참고] 추후 wait/myStatus 컨트롤러와 연동 시 활성화 --%>
                    <a href="${pageContext.request.contextPath}/wait/myStatus" style="display: block; text-decoration: none; color: #ff3d00;">
                        <div style="font-size: 20px;">📅</div>
                        <div style="font-size: 12px; font-weight: bold;">이용현황</div>
                    </a>
                </sec:authorize>
            </td>
            
            <td style="text-align: center; border: 1px solid #eee;">
                <%-- 상황 1: 비로그인 --%>
                <sec:authorize access="isAnonymous()">
                    <a href="${pageContext.request.contextPath}/member/login" style="display: block; text-decoration: none; color: #666;">
                        <div style="font-size: 20px;">👤</div>
                        <div style="font-size: 12px; font-weight: bold;">로그인</div>
                    </a>
                </sec:authorize>
                
                <%-- 상황 2: 로그인 상태 --%>
                <sec:authorize access="isAuthenticated()">
                    
                    <%-- (A) 사장님 권한(ROLE_OWNER) --%>
                    <sec:authorize access="hasRole('ROLE_OWNER')">
                        <%-- [핵심 수정] /member/mypage_owner -> /member/mypage 로 변경 --%>
                        <a href="${pageContext.request.contextPath}/member/mypage" style="display: block; text-decoration: none; color: #d9534f;">
                            <div style="font-size: 20px;">🏪</div>
                            <div style="font-size: 12px; font-weight: bold;">매장관리</div>
                        </a>
                    </sec:authorize>
                    
                    <%-- (B) 일반유저 권한(ROLE_USER) --%>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        <a href="${pageContext.request.contextPath}/member/mypage" style="display: block; text-decoration: none; color: #333;">
                            <div style="font-size: 20px;">👤</div>
                            <div style="font-size: 12px; font-weight: bold;">MY</div>
                        </a>
                    </sec:authorize>
                </sec:authorize>
            </td>
        </tr>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>