package com.uhi.gourmet.member;

import java.io.IOException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        // 1. 사용자가 가진 모든 권한 정보를 가져옵니다.
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        // 2. 권한 정보를 확인하여 리다이렉트 경로를 결정합니다.
        for (GrantedAuthority authority : authorities) {
            // 점주일 경우 매장 관리(마이페이지)로 이동
            if (authority.getAuthority().equals("ROLE_OWNER")) {
                response.sendRedirect(request.getContextPath() + "/member/mypage");
                return;
            }
        }

        // 점주가 아닐 경우(일반 회원 등) 메인 페이지로 이동
        response.sendRedirect(request.getContextPath() + "/");
    }
}