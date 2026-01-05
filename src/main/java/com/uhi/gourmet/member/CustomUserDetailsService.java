package com.uhi.gourmet.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.uhi.gourmet.member.MemberMapper;
import com.uhi.gourmet.member.MemberVO;

import java.util.Collections;

/*
 * [핵심] UserDetailsService 란?
 * - Spring Security에게 "우리 DB에서 회원을 어떻게 찾는지" 알려주는 역할입니다.
 * - 로그인 버튼을 누르면 Security가 자동으로 이 클래스의 loadUserByUsername()을 호출합니다.
 * 
 * @Service("customUserDetailsService"):
 * - 이 이름이 아주 중요합니다! 아까 오류가 났던 이유가 이 이름표가 없어서였습니다.
 * - security-context.xml에서 <authentication-provider user-service-ref="이름"> 과 일치해야 합니다.
 */
@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberMapper memberMapper; // DB에 다녀올 심부름꾼 (Mapper)

    /*
     * [로그인 처리 핵심 메서드]
     * 1. 사용자가 로그인 화면에서 아이디(username)를 입력하고 로그인 버튼을 누름
     * 2. Spring Security가 이 메서드를 호출하면서 그 아이디를 파라미터로 넘겨줌
     * 3. 우리는 그 아이디로 DB를 조회해서 결과(UserDetails)를 리턴하면 됨
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        // 1. DB에서 회원 정보 조회
        // (사용자가 입력한 아이디 'username'으로 내 테이블인 MemberVO를 찾아옵니다)
        MemberVO vo = memberMapper.getMemberById(username); 

        // 2. 아이디가 없으면? (회원이 아님)
        if (vo == null) {
            // "그런 사람 없는데요?" 라고 예외를 던지면 Security가 알아서 "로그인 실패" 처리함
            throw new UsernameNotFoundException("해당 아이디를 찾을 수 없습니다: " + username);
        }

        /*
         * 3. [변환 작업] MemberVO -> UserDetails
         * - 중요: Security는 우리가 만든 'MemberVO'가 뭔지 모릅니다.
         * - 그래서 Security가 알아들을 수 있는 표준 포맷인 'User' 객체로 바꿔서 줘야 합니다.
         * 
         * new User(
         *    1. 아이디,
         *    2. 암호화된 비밀번호 (Security가 사용자가 입력한 비번과 자동으로 비교함),
         *    3. 권한 목록 (ROLE_USER, ROLE_OWNER 등)
         * )
         */
        return new User(
            vo.getUser_id(), // 사용자의 ID
            vo.getUser_pw(), // DB에 저장된 암호화된 비밀번호 ($2a$10$...)
            
            // 권한(Role)을 리스트 형태로 넣어줘야 함
            // SimpleGrantedAuthority: 권한을 문자열로 포장하는 객체
            Collections.singletonList(new SimpleGrantedAuthority(vo.getUser_role()))
        );
    }
}
