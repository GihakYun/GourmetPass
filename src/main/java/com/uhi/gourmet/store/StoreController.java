package com.uhi.gourmet.store;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.io.File;
import java.io.IOException;
import java.security.Principal;

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

import com.uhi.gourmet.wait.WaitService;

@Controller
@RequestMapping("/store")
public class StoreController {

    @Autowired
    private StoreService storeService;

    @Autowired
    private WaitService waitService;

    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    // 1. 맛집 목록 조회
    @GetMapping("/list")
    public String storeList(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "region", required = false) String region,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {
        
        List<StoreVO> storeList = storeService.getStoreList(category, region, keyword);
        model.addAttribute("storeList", storeList); 
        model.addAttribute("category", category);
        model.addAttribute("region", region);
        model.addAttribute("keyword", keyword);
        
        return "store/store_list";
    }

    // 2. 맛집 상세 정보 조회
    @GetMapping("/detail")
    public String storeDetail(@RequestParam("storeId") int storeId, Model model) {
        storeService.plusViewCount(storeId);
        
        StoreVO store = storeService.getStoreDetail(storeId);
        List<MenuVO> menuList = storeService.getMenuList(storeId);
        
        int currentWaitCount = waitService.get_current_wait_count(storeId);
        model.addAttribute("currentWaitCount", currentWaitCount);

        if (store != null) {
            List<String> timeSlots = generateTimeSlots(store);
            model.addAttribute("timeSlots", timeSlots);
        }

        model.addAttribute("store", store);
        model.addAttribute("menuList", menuList);
        model.addAttribute("kakaoJsKey", kakaoJsKey);
        
        return "store/store_detail";
    }
    
    @GetMapping(value = "/api/timeSlots", produces = "application/json; charset=UTF-8")
    @ResponseBody 
    public List<String> getTimeSlots(@RequestParam("store_id") int storeId) {
        StoreVO store = storeService.getStoreDetail(storeId);
        return generateTimeSlots(store);
    }

    // ================= [가게 정보 관리] =================

    @GetMapping("/register")
    public String registerStorePage() {
        return "store/store_register";
    }

    @PostMapping("/register")
    public String registerStoreProcess(@ModelAttribute StoreVO vo, 
                                     @RequestParam(value="file", required=false) MultipartFile file,
                                     HttpServletRequest request,
                                     Principal principal) {
        if (file != null && !file.isEmpty()) {
            vo.setStore_img(uploadFile(file, request));
        }
        storeService.registerStore(vo, principal.getName());
        return "redirect:/member/mypage";
    }

    @GetMapping("/update")
    public String updateStorePage(@RequestParam("store_id") int storeId, Model model, Principal principal) {
        StoreVO store = storeService.getMyStore(storeId, principal.getName());
        if (store == null) return "redirect:/member/mypage";
        
        model.addAttribute("store", store);
        return "store/store_update";
    }

    @PostMapping("/update")
    public String updateStoreProcess(@ModelAttribute StoreVO vo, 
                                     @RequestParam(value="file", required=false) MultipartFile file, 
                                     HttpServletRequest request,
                                     Principal principal) {
        if (file != null && !file.isEmpty()) {
            vo.setStore_img(uploadFile(file, request));
        }
        storeService.modifyStore(vo, principal.getName());
        return "redirect:/member/mypage";
    }

    // ================= [메뉴 관리] =================

    @GetMapping("/menu/register")
    public String menuRegisterPage(@RequestParam("store_id") int storeId, Model model, Principal principal) {
        StoreVO store = storeService.getMyStore(storeId, principal.getName());
        if (store == null) return "redirect:/member/mypage";
        
        model.addAttribute("store_id", storeId);
        return "store/menu_register";
    }

    @PostMapping("/menu/register")
    public String menuRegisterProcess(@ModelAttribute MenuVO menuVO, 
                                      @RequestParam(value="file", required=false) MultipartFile file,
                                      HttpServletRequest request,
                                      Principal principal) {
        if (file != null && !file.isEmpty()) {
            menuVO.setMenu_img(uploadFile(file, request));
        }
        storeService.addMenu(menuVO, principal.getName());
        return "redirect:/member/mypage"; 
    }

    @GetMapping("/menu/delete")
    public String deleteMenu(@RequestParam("menu_id") int menuId, Principal principal) {
        storeService.removeMenu(menuId, principal.getName());
        return "redirect:/member/mypage";
    }
    
    @GetMapping("/menu/update")
    public String menuUpdatePage(@RequestParam("menu_id") int menuId, Model model, Principal principal) {
        MenuVO menu = storeService.getMenuDetail(menuId, principal.getName());
        if (menu == null) return "redirect:/member/mypage";
        
        model.addAttribute("menu", menu);
        return "store/menu_update";
    }
    
    @PostMapping("/menu/update")
    public String menuUpdateProcess(@ModelAttribute MenuVO vo, 
                                    @RequestParam(value="file", required=false) MultipartFile file,
                                    HttpServletRequest request,
                                    Principal principal) {
        if (file != null && !file.isEmpty()) {
            vo.setMenu_img(uploadFile(file, request));
        }
        storeService.modifyMenu(vo, principal.getName());
        return "redirect:/member/mypage";
    }

    // ================= [Private Helpers] =================

    private List<String> generateTimeSlots(StoreVO store) {
        List<String> slots = new ArrayList<>();
        if (store == null || store.getOpen_time() == null || store.getClose_time() == null) {
            return slots;
        }

        try {
            DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("HH:mm[:ss]");
            DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("HH:mm");

            LocalTime open = LocalTime.parse(store.getOpen_time(), inputFormatter);
            LocalTime close = LocalTime.parse(store.getClose_time(), inputFormatter);
            int unit = (store.getRes_unit() <= 0) ? 30 : store.getRes_unit();

            LocalTime current = open;
            while (current.isBefore(close)) {
                slots.add(current.format(outputFormatter));
                current = current.plusMinutes(unit);
            }
        } catch (Exception e) {
            System.err.println("TimeSlot Generation Error: " + e.getMessage());
        }
        return slots;
    }

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