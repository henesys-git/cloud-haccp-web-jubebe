package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import dao.AlarmInfoDaoImpl;
import dao.AlarmMessageDaoImpl;
import dao.CCPLimitDaoImpl;
import model.AlarmInfo;
import model.CCPLimit;
import model.LimitOutAlarmMessage;
import service.AlarmInfoService;
import service.AlarmMessageService;
import service.AlarmService;
import service.AlarmServiceSlack;
import service.CCPLimitService;


@WebServlet("/rpi/value/judge")
public class OnPacketReceiveController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(OnPacketReceiveController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		if(bizNo == null) {
			bizNo = req.getParameter("bizNo");
		}
		
		String deviceId = req.getParameter("deviceId");
		String eventCode = req.getParameter("eventCode");
		String productId = req.getParameter("productId");
		double value = Double.parseDouble(req.getParameter("value"));
		
		CCPLimitService ccpLimitService = new CCPLimitService(new CCPLimitDaoImpl(), bizNo);
		CCPLimit ccpLimit = ccpLimitService.getCCPLimitByCode(eventCode, productId);
		
		if(ifError(ccpLimit)) {
			String errMsg = new StringBuilder()
					.append("\n")
					.append("[OnPacketReceiveController] null in CCPLimit" + "\n")
					.append("[OnPacketReceiveController] bizNo:" + bizNo + "\n")
					.append("[OnPacketReceiveController] deviceId:" + deviceId + "\n")
					.append("[OnPacketReceiveController] eventCode:" + eventCode + "\n")
					.append("[OnPacketReceiveController] productId:" + productId + "\n")
					.toString();
			logger.error(errMsg);
			return;
		}
		
		boolean isLimitOut = ccpLimitService.isLimitOut(ccpLimit, value);
		
		if(isLimitOut) {
			AlarmMessageService alarmMsgService = new AlarmMessageService(new AlarmMessageDaoImpl());
			LimitOutAlarmMessage limitOutAlarmMsg = alarmMsgService.getMessage(bizNo, eventCode, deviceId, productId);
			
			if(ifError(limitOutAlarmMsg)) {
				String errMsg = new StringBuilder()
						.append("\n")
						.append("[OnPacketReceiveController] null in LimitOutAlarmMessage" + "\n")
						.append("[OnPacketReceiveController] please check getLimitOutAlarmMessage()" + "\n")
						.append("[OnPacketReceiveController] bizNo:" + bizNo + "\n")
						.append("[OnPacketReceiveController] deviceId:" + deviceId + "\n")
						.append("[OnPacketReceiveController] eventCode:" + eventCode + "\n")
						.append("[OnPacketReceiveController] productId:" + productId + "\n")
						.toString();
				logger.error(errMsg);
				return;
			}
			
			String msg = new StringBuilder()
					.append(":bell: 한계 이탈\n")
					.append("센서명:" + limitOutAlarmMsg.getSensorName() + "\n")
					.append("공정명:" + limitOutAlarmMsg.getProcessName() + "\n")
					.append("이벤트:" + limitOutAlarmMsg.getEventName() + "\n")
					.append("최소값:" + limitOutAlarmMsg.getMinValue() + "\n")
					.append("최대값:" + limitOutAlarmMsg.getMaxValue() + "\n")
					.append("이탈값:" + value + "\n\n")
					.append("HACCP관리 -> 이탈데이터관리 메뉴에서 개선 조치를 해주세요 :slightly_smiling_face:")
					.toString();
			
			AlarmInfoService aiService = new AlarmInfoService(new AlarmInfoDaoImpl());
			AlarmInfo alarmInfo = aiService.getAlarmInfo(bizNo);
			
			AlarmService alarmService = new AlarmServiceSlack(alarmInfo.getChannelId(), alarmInfo.getApiToken());
			Boolean alertResult = alarmService.alert(msg);
			
			if(!alertResult) {
				logger.error("[OnPacketReceiveController] 알람 전송 실패");
			}
		}
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		logger.error("post request not supported");
	}
	
	private boolean ifError(CCPLimit cl) {
		if(cl.getEventCode() == null || cl.getProductId() == null) {
			return true;
		}
		
		return false;
	}
	
	private boolean ifError(LimitOutAlarmMessage msg) {
		if(msg.getEventName() == null || msg.getProcessName() == null) {
			return true;
		}
		
		return false;
	}
}
