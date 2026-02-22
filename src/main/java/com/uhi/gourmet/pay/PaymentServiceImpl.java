package com.uhi.gourmet.pay;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.request.CancelData;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;

import lombok.extern.slf4j.Slf4j;


@Service
public class PaymentServiceImpl implements PaymentService{
	
	@Autowired
	private PaymentMapper mapper;
	
	private final IamportClient iamportClient;

    // 생성자 파라미터에 직접 @Value를 작성합니다.
    public PaymentServiceImpl(
            @Value("${portone.api.key}") String apiKey,
            @Value("${portone.api.secret}") String apiSecret) {
        
        // 이제 apiKey와 apiSecret은 null이 아닙니다!
        System.out.println("생성자 주입 확인: " + apiKey);
        System.out.println("생성자 주입 확인: " + apiSecret);
        this.iamportClient = new IamportClient(apiKey, apiSecret);
    }
	
	
	
	
	
	// 예약금 가격과 결제되는 가격 비교 로직
	@Override
	public boolean paymentVal(String imp_Uid) throws IamportResponseException, IOException{
		
		System.out.println("PaymentServiceImpl paymentVal()............");
		
//		IamportClient iamportclient = new IamportClient(apiKey, apiSecret);	// IamportClient 클래스 활성화(apiKey, apiSecret 설정)
		IamportResponse<Payment> response = iamportClient.paymentByImpUid(imp_Uid);	// impUid로 결제 특정
		Payment payment = response.getResponse();	// pay 결제 특정
		int amount = (payment.getAmount()).intValue();	// 값 비교를 위한 BigDecimal -> int 형 변환
		
		
		// 예약금 가격이 같을 경우	( 추후 DB 사용할지 생각
		int price = 1;
		// 예약금 가격이 다를경우
//		int price = 2;	
		
		System.out.println("결제된 가격 : " + payment.getAmount());
		
		if(amount == price) {		// 가격이 같은지 비교 
			System.out.println("가격이 같습니다.............");
			// 가격이 같으면 DB에 pay 정보 넣는 로직 실행
			PayVO vo = new PayVO();
			vo.setImp_uid(imp_Uid);	// impUid 설정
			vo.setAmount(price);	// amount(가격) 설정
			
			mapper.insertPayment(vo);	// DB에 pay 정보 저장
			System.out.println("pay 정보 DB에 저장.....");
			return true;
			
		} else {
			System.out.println("가격이 다릅니다............");
			System.out.println("가격 다른 경우의 환불로직 실행............");
			
			CancelData cancel = new CancelData(imp_Uid, true);	// CancelData에 impUid 값 적용
			response = iamportClient.cancelPaymentByImpUid(cancel);	// CancelData로 iamportclient에 환불 기능특정
			
			
			if(response.getResponse() != null) {	// 환불 로직 실행
				System.out.println("환불 성공............");
			} else {
				System.out.println("환불 실패............");
				
			}
			// DB에도 저장 안됨
			return false;
		}
		
		
	}

	@Override
	public boolean refund(String imp_Uid) throws IamportResponseException, IOException {
		
		IamportResponse<Payment> response;
		// CancelDataにimp_uidを設定
		CancelData cancel = new CancelData(imp_Uid, true);
		// CancelDataを用いてiamportClientの返金機能を呼び出し
		response = iamportClient.cancelPaymentByImpUid(cancel);
		
		if(response.getResponse() != null) {	// 返金機能を実行
	        System.out.println("返金成功処理を完了しました。");
			return true;
			
		} else {
			System.out.println("返金処理に失敗しました。");
			return false;
		}
		
	}

	
	
	// pay_id로 PayVO 하나 가져오기
	@Override
	public PayVO getPayById(int pay_id) {
		System.out.println("Service() getPayById()............");

		return mapper.getPayById(pay_id);
	}


	@Override
	public int deletePayById(int pay_id) {
		System.out.println("Service() getPayById()............");
		
		return mapper.deletePayById(pay_id);
	}


	@Override
	public int getPayIdByImpUid(String impUid) {
		System.out.println("Service() getPayByIdImpUid()............");
		
		return mapper.getPayIdByImpUid(impUid);
	}
	
	

}
