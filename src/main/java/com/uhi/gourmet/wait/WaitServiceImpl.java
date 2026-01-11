package com.uhi.gourmet.wait;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class WaitServiceImpl implements WaitService {

    @Autowired
    private WaitMapper wait_mapper;

    /**
     * 웨이팅 등록 로직
     * [백엔드 포인트] synchronized를 통해 아주 짧은 찰나에 발생하는 중복 번호 발급 방지
     */
    @Override
    public synchronized void register_wait(WaitVO vo) {
        // 1. 오늘 날짜의 해당 매장 최대 대기 번호 조회
        Integer max_num = wait_mapper.selectMaxWaitNum(vo.getStore_id());
        
        // 2. 새 번호 발급 (오늘 첫 팀이면 1번, 아니면 max + 1)
        int next_num = (max_num == null) ? 1 : max_num + 1;
        vo.setWait_num(next_num);
        
        // 3. DB Insert
        wait_mapper.insertWait(vo);
    }

    @Override
    public int get_current_wait_count(int store_id) {
        return wait_mapper.selectCurrentWaitCount(store_id);
    }

    @Override
    public List<WaitVO> get_my_wait_list(String user_id) {
        return wait_mapper.selectMyWaitList(user_id);
    }

    @Override
    public List<WaitVO> get_store_wait_list(int store_id) {
        return wait_mapper.selectStoreWaitList(store_id);
    }

    @Override
    public void update_wait_status(int wait_id, String status) {
        wait_mapper.updateWaitStatus(wait_id, status);
    }
}