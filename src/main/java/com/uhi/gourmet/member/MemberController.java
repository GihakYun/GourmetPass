package com.uhi.gourmet.member;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.uhi.gourmet.store.StoreMapper;
import com.uhi.gourmet.store.StoreVO;

@Controller
public class MemberController {

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private StoreMapper storeMapper;

    @Autowired
    private BCryptPasswordEncoder pwEncoder;

    // api.properties에서 카카오 API 키 주입
    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    /**
     * [0] 공통: 회원가입 페이지에 카카오 키 전달을 위한 헬퍼 메서드
     * 여러 가입 페이지에서 공통으로 사용하기 위해 추출함
     */
    private void addKakaoKeyToModel(Model model) {
        System.out.println(">>> Kakao Key Load Check: " + kakaoJsKey);
        model.addAttribute("kakaoJsKey", kakaoJsKey);
    }

    // [1] 메인/로그인 화면
    @RequestMapping(value = { "/", "/login.do" }, method = RequestMethod.GET)
    public String index() {
        return "member/login";
    }

    // [2] 로그인 처리
    @RequestMapping(value = "/login.do", method = RequestMethod.POST)
    public String login(MemberVO vo, HttpSession session) {
        String dbPw = memberMapper.getPassword(vo.getUser_id());

        if (dbPw != null && pwEncoder.matches(vo.getUser_pw(), dbPw)) {
            session.setAttribute("loginID", vo.getUser_id());
            return "member/main";
        } else {
            return "redirect:/?error=true";
        }
    }

    // [3] 로그아웃
    @RequestMapping(value = "/logout.do", method = RequestMethod.GET)
    public String logout(HttpSession session) {
        session.invalidate();
        return "member/logoutMsg";
    }

    // ================= [회원가입 공통/일반] =================

    // [4-1] 회원가입 유형 선택 페이지
    @RequestMapping(value = "/join/select.do", method = RequestMethod.GET)
    public String joinSelect() {
        return "member/signup_select";
    }

    // [4-2] 일반 회원가입 페이지 이동 (카카오 키 전달 포함)
    @RequestMapping(value = "/join/general.do", method = RequestMethod.GET)
    public String joinGeneralPage(Model model) {
        addKakaoKeyToModel(model); // 카카오 키 주입
        return "member/signup_general";
    }

    // [4-3] 일반 회원가입 처리 (암호화 + 좌표 저장)
    @RequestMapping(value = "/joinProcess.do", method = RequestMethod.POST)
    public String joinProcess(MemberVO vo) {
        String encodePw = pwEncoder.encode(vo.getUser_pw());
        vo.setUser_pw(encodePw);
        memberMapper.join(vo);
        return "redirect:/";
    }

    // ================= [점주 회원가입: 멀티 페이지 방식] =================

    // [5-1] 점주 가입 1단계: 사장님 개인 정보 입력 페이지 (카카오 키 전달 포함)
    @RequestMapping(value = "/join/owner1.do", method = RequestMethod.GET)
    public String ownerStep1(Model model) {
        addKakaoKeyToModel(model); // 카카오 키 주입
        return "member/signup_owner1";
    }

    // [5-2] 1단계 데이터 처리: 세션 저장 및 2단계 이동
    @RequestMapping(value = "/join/ownerStep1.do", method = RequestMethod.POST)
    public String ownerStep1Process(MemberVO memberVo, HttpSession session) {
        session.setAttribute("tempMember", memberVo);
        return "redirect:/join/owner2.do";
    }

    // [5-3] 점주 가입 2단계: 가게 정보 입력 페이지 (카카오 키 전달 포함)
    @RequestMapping(value = "/join/owner2.do", method = RequestMethod.GET)
    public String ownerStep2(HttpSession session, Model model) {
        if (session.getAttribute("tempMember") == null) {
            return "redirect:/join/owner1.do";
        }
        addKakaoKeyToModel(model); // 카카오 키 주입
        return "member/signup_owner2";
    }

    // [5-4] 최종 가입 처리: 세션 데이터(회원) + 폼 데이터(가게) 합쳐서 DB 저장
    @RequestMapping(value = "/join/ownerFinal.do", method = RequestMethod.POST)
    public String ownerFinalProcess(StoreVO storeVo, HttpSession session) {
        MemberVO memberVo = (MemberVO) session.getAttribute("tempMember");
        if (memberVo == null) return "redirect:/join/owner1.do";

        String encodePw = pwEncoder.encode(memberVo.getUser_pw());
        memberVo.setUser_pw(encodePw);
        memberVo.setUser_role("ROLE_OWNER");

        memberMapper.join(memberVo);

        storeVo.setUser_id(memberVo.getUser_id());
        storeMapper.insertStore(storeVo);

        session.removeAttribute("tempMember");
        return "redirect:/login.do";
    }

    // ================= [공통 기능] =================

    // [6] 아이디 중복 확인 (AJAX)
    @RequestMapping(value = "/idCheck.do", method = RequestMethod.POST)
    @ResponseBody
    public String idCheck(@RequestParam("user_id") String user_id) {
        int count = memberMapper.idCheck(user_id);
        return (count > 0) ? "fail" : "success";
    }
}