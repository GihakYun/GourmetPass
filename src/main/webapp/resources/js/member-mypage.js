/**
 * 마이페이지 공통 스크립트 (일반 회원 / 점주 공용) [v1.0.4]
 * 기능: 회원 탈퇴, 메뉴 삭제, 웨이팅 취소, 내역 토글, 실시간 웹소켓 알림
 */

// 1. 회원 탈퇴 요청
function dropUser(userId) {
    if (!confirm("정말로 탈퇴하시겠습니까? 모든 정보가 삭제됩니다.")) return;

    fetch(APP_CONFIG.contextPath + '/member/delete', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            [APP_CONFIG.csrfName]: APP_CONFIG.csrfToken
        },
        body: "user_id=" + encodeURIComponent(userId)
    })
    .then(response => {
        if (response.redirected) {
            alert("정상적으로 탈퇴되었습니다.");
            location.href = response.url;
            return;
        }
        return response.text();
    })
    .catch(error => console.error('Error:', error));
}

// 2. 메뉴 삭제 요청 (점주용)
function deleteMenu(menuId) {
    if (!confirm("이 메뉴를 삭제하시겠습니까?")) return;

    const form = document.createElement('form');
    form.method = 'POST';
    form.action = APP_CONFIG.contextPath + '/store/menu/delete';
    
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'menu_id';
    input.value = menuId;
    
    const csrf = document.createElement('input');
    csrf.type = 'hidden';
    csrf.name = APP_CONFIG.csrfName;
    csrf.value = APP_CONFIG.csrfToken;
    
    form.appendChild(input);
    form.appendChild(csrf);
    document.body.appendChild(form);
    form.submit();
}

// 3. [v1.0.4 추가] 웨이팅 취소 함수 (myStatus.jsp 전용)
function cancelWait(waitId) {
    if(!confirm("웨이팅을 취소하시겠습니까?")) return;
    
    const form = document.createElement("form");
    form.method = "POST";
    form.action = APP_CONFIG.contextPath + "/wait/cancel";
    
    const inputId = document.createElement("input");
    inputId.type = "hidden"; 
    inputId.name = "wait_id"; 
    inputId.value = waitId;
    
    const inputCsrf = document.createElement("input");
    inputCsrf.type = "hidden"; 
    inputCsrf.name = APP_CONFIG.csrfName; 
    inputCsrf.value = APP_CONFIG.csrfToken;
    
    form.appendChild(inputId);
    form.appendChild(inputCsrf);
    document.body.appendChild(form);
    form.submit();
}

// 4. [v1.0.4 추가] 전체 내역 토글 함수 (myStatus.jsp 전용)
function toggleHistory() {
    const area = document.getElementById('full-history-area');
    const btn = document.getElementById('history-toggle-btn');
    
    if(area.style.display === 'none') {
        area.style.display = 'block';
        btn.innerText = '내역 닫기 ▲';
    } else {
        area.style.display = 'none';
        btn.innerText = '전체 이용 내역 보기 ▼';
    }
}

// 5. 웹소켓 실시간 알림 설정
let stompClient = null;

function initMyPageWebSocket(userId, role, storeId) {
    const socket = new SockJS(APP_CONFIG.contextPath + '/ws_waiting');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
        console.log('WebSocket Connected: ' + frame);

        if (role === 'ROLE_USER') {
            stompClient.subscribe('/topic/wait/' + userId, function (message) {
                showNotification("🔔 알림: " + message.body);
            });
        }

        if (role === 'ROLE_OWNER' && storeId) {
            stompClient.subscribe('/topic/store/' + storeId, function (message) {
                showNotification("📩 새 주문: " + message.body);
            });
        }
    });
}

function showNotification(message) {
    alert(message);
    location.reload();
}