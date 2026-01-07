package com.uhi.gourmet.store;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.io.File;
import java.io.IOException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/store")
public class StoreController {

    @Autowired
    private StoreMapper storeMapper;

    // api.properties에서 카카오 JS 키 로드
    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    // 1. 맛집 목록 조회
    @GetMapping("/list")
    public String storeList(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "region", required = false) String region,
            Model model) {
        
        List<StoreVO> storeList = storeMapper.getListStore(category, region);
        
        model.addAttribute("storeList", storeList); 
        model.addAttribute("category", category);
        model.addAttribute("region", region);
        
        return "store/store_list";
    }

    // 2. 맛집 상세 정보 조회
    @GetMapping("/detail")
    public String storeDetail(@RequestParam("storeId") int storeId, Model model) {
        storeMapper.updateViewCount(storeId);
        StoreVO store = storeMapper.getStoreDetail(storeId);
        List<MenuVO> menuList = storeMapper.getMenuList(storeId);
        
        model.addAttribute("store", store);
        model.addAttribute("menuList", menuList);
        model.addAttribute("kakaoJsKey", kakaoJsKey);
        
        return "store/store_detail";
    }
    
    // 3. [AJAX] 예약 타임슬롯 생성
    @GetMapping(value = "/api/timeSlots", produces = "application/json; charset=UTF-8")
    @ResponseBody 
    public List<String> getTimeSlots(@RequestParam("store_id") int storeId) {
        List<String> slots = new ArrayList<>();
        try {
            StoreVO store = storeMapper.getStoreDetail(storeId);
            if (store == null || store.getOpen_time() == null || store.getClose_time() == null) {
                return slots;
            }

            LocalTime open = LocalTime.parse(store.getOpen_time());
            LocalTime close = LocalTime.parse(store.getClose_time());
            int unit = store.getRes_unit() == 0 ? 30 : store.getRes_unit();

            LocalTime current = open;
            while (current.isBefore(close)) {
                slots.add(current.toString());
                current = current.plusMinutes(unit);
            }
        } catch (Exception e) {
            System.err.println("타임슬롯 생성 에러: " + e.getMessage());
        }
        return slots; 
    }
    
    // ================= [가게 정보 관리] =================

    // 1. 가게 수정 페이지 이동
    @GetMapping("/update")
    public String updateStorePage(@RequestParam("store_id") int storeId, Model model) {
        StoreVO store = storeMapper.getStoreDetail(storeId);
        model.addAttribute("store", store);
        return "store/store_update";
    }

    // 2. 가게 수정 처리
    @PostMapping("/update")
    public String updateStoreProcess(@ModelAttribute StoreVO vo, 
                                     @RequestParam(value="file", required=false) MultipartFile file, 
                                     HttpServletRequest request) {
        if (file != null && !file.isEmpty()) {
            String savedName = uploadFile(file, request);
            vo.setStore_img(savedName);
        }
        storeMapper.updateStore(vo);
        return "redirect:/member/mypage";
    }

    // ================= [메뉴 관리 (CRUD)] =================

    // 1. 메뉴 등록 페이지 이동
    @GetMapping("/menu/register")
    public String menuRegisterPage(@RequestParam("store_id") int storeId, Model model) {
        model.addAttribute("store_id", storeId);
        return "store/menu_register";
    }

    // 2. 메뉴 등록 처리
    @PostMapping("/menu/register")
    public String menuRegisterProcess(@ModelAttribute("menuVO") MenuVO menuVO, 
                                      @RequestParam(value="file", required=false) MultipartFile file,
                                      HttpServletRequest request) {
        
        System.out.println(">>> 등록 메뉴: " + menuVO.getMenu_name() + ", 가게ID: " + menuVO.getStore_id());

        if (file != null && !file.isEmpty()) {
            String savedName = uploadFile(file, request);
            menuVO.setMenu_img(savedName);
        }
        
        if (menuVO.getMenu_sign() == null) menuVO.setMenu_sign("N");
        
        storeMapper.insertMenu(menuVO);
        return "redirect:/member/mypage"; 
    }

    // 3. 메뉴 삭제 처리
    @GetMapping("/menu/delete")
    public String deleteMenu(@RequestParam("menu_id") int menuId) {
        storeMapper.deleteMenu(menuId);
        return "redirect:/member/mypage";
    }
    
    // 4. 메뉴 수정 페이지 이동
    @GetMapping("/menu/update")
    public String menuUpdatePage(@RequestParam("menu_id") int menuId, Model model) {
        MenuVO menu = storeMapper.getMenuDetail(menuId);
        model.addAttribute("menu", menu);
        return "store/menu_update";
    }
    
    // 5. 메뉴 수정 처리
    @PostMapping("/menu/update")
    public String menuUpdateProcess(@ModelAttribute("vo") MenuVO vo, 
                                    @RequestParam(value="file", required=false) MultipartFile file,
                                    HttpServletRequest request) {
        if (file != null && !file.isEmpty()) {
            String savedName = uploadFile(file, request);
            vo.setMenu_img(savedName);
        }
        
        if (vo.getMenu_sign() == null) vo.setMenu_sign("N");
        
        storeMapper.updateMenu(vo);
        return "redirect:/member/mypage";
    }

    // [공통] 파일 업로드 로직
    private String uploadFile(MultipartFile file, HttpServletRequest request) {
        String uploadPath = request.getSession().getServletContext().getRealPath("/resources/upload");
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        String savedName = System.currentTimeMillis() + "_" + originalName;

        try {
            file.transferTo(new File(uploadPath, savedName));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return savedName;
    }
}