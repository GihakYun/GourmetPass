package com.uhi.gourmet.wait;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WaitVO {
    private int wait_id;          // 웨이팅 고유 ID
    private String user_id;       // 신청자 ID (FK)
    private int store_id;         // 가게 고유 ID (FK)
    private int people_cnt;       // 방문 인원
    private int wait_num;         // 대기 번호
    private String wait_status;   // 대기 상태 (WAITING, CALLED, CANCELLED 등)
    private Date wait_date;       // 신청 일시

    // [추가] JOIN을 통해 가져온 가게 이름을 담기 위한 필드
    // JSP의 ${wait.store_name} 호출과 매핑됩니다.
    private String store_name;
}