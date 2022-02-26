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
					.append(":bell: �Ѱ� ��Ż\n")
					.append("������:" + limitOutAlarmMsg.getSensorName() + "\n")
					.append("������:" + limitOutAlarmMsg.getProcessName() + "\n")
					.append("�̺�Ʈ:" + limitOutAlarmMsg.getEventName() + "\n")
					.append("�ּҰ�:" + limitOutAlarmMsg.getMinValue() + "\n")
					.append("�ִ밪:" + limitOutAlarmMsg.getMaxValue() + "\n")
					.append("��Ż��:" + value + "\n\n")
					.append("HACCP���� -> ��Ż�����Ͱ��� �޴����� ���� ��ġ�� ���ּ��� :slightly_smiling_face:")
					.toString();
			
			AlarmService alarmService = new AlarmServiceSlack();
			Boolean alertResult = alarmService.alert(msg);
			
			if(!alertResult) {
				logger.error("[OnPacketReceiveController] �˶� ���� ����");
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
