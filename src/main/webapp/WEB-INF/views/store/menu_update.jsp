<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="../common/header.jsp" />

<div style="width: 50%; margin: 50px auto; padding: 30px; border: 1px solid #ddd; border-radius: 10px;">
    <h2 align="center">✏️ 메뉴 정보 수정</h2>
    
    <%-- 
        [수정 포인트] 
        enctype="multipart/form-data" 사용 시 CSRF 필터가 파라미터를 읽을 수 있도록 
        action URL 뒤에 직접 토큰을 쿼리 스트링으로 포함시킵니다. 
    --%>
    <form action="${pageContext.request.contextPath}/store/menu/update?${_csrf.parameterName}=${_csrf.token}" 
          method="post" 
          enctype="multipart/form-data">
          
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        <input type="hidden" name="menu_id" value="${menu.menu_id}">
        <input type="hidden" name="store_id" value="${menu.store_id}">
        <input type="hidden" name="menu_img" value="${menu.menu_img}"> 
        
        <div style="margin-bottom: 15px;">
            <label>메뉴명</label>
            <input type="text" name="menu_name" value="${menu.menu_name}" required style="width: 100%; padding: 8px;">
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>가격</label>
            <input type="number" name="menu_price" value="${menu.menu_price}" required style="width: 100%; padding: 8px;">
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>메뉴 이미지 (교체 시 선택)</label><br>
            <c:if test="${not empty menu.menu_img}">
                <img src="${pageContext.request.contextPath}/resources/upload/${menu.menu_img}" width="100" style="margin-bottom:10px;"><br>
            </c:if>
            <input type="file" name="file">
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>대표메뉴 여부</label>
            <input type="checkbox" name="menu_sign" value="Y" ${menu.menu_sign == 'Y' ? 'checked' : ''}> 대표 메뉴로 설정
        </div>
        
        <div style="text-align: center; margin-top: 25px;">
            <button type="submit" style="padding: 10px 30px; background: #ff9800; color: white; border: none; border-radius: 5px; cursor: pointer;">수정 완료</button>
            <button type="button" onclick="history.back()" style="padding: 10px 30px; border-radius: 5px;">취소</button>
        </div>
    </form>
</div>
<jsp:include page="../common/footer.jsp" />