package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import dao.AlarmMessageDaoImpl;
import dao.EventInfoDaoImpl;
import model.EventInfo;
import model.LimitOutAlarmMessage;
import service.AlarmMessageService;
import service.AlarmService;
import service.AlarmServiceSlack;
import service.EventInfoService;


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
		String code = req.getParameter("code");
		double value = Double.parseDouble(req.getParameter("value"));
		
		EventInfoService eventInfoService = new EventInfoService(new EventInfoDaoImpl(), bizNo);
		EventInfo eventInfo = eventInfoService.getEventInfoByCode(code);
		boolean isLimitOut = eventInfoService.isLimitOut(eventInfo, value);
		eventInfo.setIsLimitOut(isLimitOut);
		
		if(isLimitOut) {
			AlarmMessageService alarmMsgService = new AlarmMessageService(new AlarmMessageDaoImpl());
			LimitOutAlarmMessage limitOutAlarmMsg = alarmMsgService.getMessage(bizNo, code, deviceId);
			
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
			
			AlarmService alarmService = new AlarmServiceSlack();
			Boolean alertResult = alarmService.alert(msg);
			
			if(!alertResult) {
				logger.error("[OnPacketReceiveController] 알람 전송 실패");
			}
//			res.setContentType("application/json; charset=UTF-8");
//			PrintWriter out = res.getWriter();
//			
//			out.print( alertResult.toString() );
		}
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		logger.error("post request not supported");
	}
}
