package mes.frame.serviceinterface;

import java.lang.reflect.Method;

import org.apache.log4j.Logger;

import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.MessageDefine;
import mes.frame.util.CommonFunction;

public class EventFactory {
	
	static final Logger logger = Logger.getLogger(EventFactory.class.getName());
	
	public EventFactory(){
	}

	// 이벤트(화면ID)에 따른 화면 Class를 만듬.
	public int createSql(InoutParameter ioParam){
		int resultInt = -1;
		int eventMenu = 0;
		
		// ioParam에서 eventID를 얻어서 정의 된 이벤트인지 검증한다.
		String MenuStr = ioParam.getEventID();
		
		if(!EventDefine.isEventID(MenuStr)){
			LoggingWriter.setLogInfo(EventFactory.class.getName() ,"==== EventID is not define ====");
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			return EventDefine.E_EVENT_ID_ERROR;
		}
		
		logger.debug("Menu Str : " + MenuStr);
		
		// ioParam에서 eventMenu를 얻어서 클래스명을 완성한다.
		logger.debug(eventMenu + " MenuClass Create Success");
		
		String custID = Config.CUST_ID + 
			(ioParam.getEventCustID()).substring(0,4) + "." + ioParam.getEventCustID();

		logger.debug("cust ID : " + custID);
		
		Class menuClass = null;
		
	    try{
			menuClass = Class.forName(custID);
			Object subObj = menuClass.newInstance();
			Class[] optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			Object[] optObj = new Object[1];
			optObj[0] = ioParam;
			
			// 클래스에서 메소드(doExcute)를 생성한다. 
			// optClass에 입력 파라메타를 담아서 넘긴다.
			Method method = menuClass.getMethod("doExcute",optClass);
			logger.debug(custID + " MenuClass Create Success");
			
			// 얻은 메소드를 실행시킨다.
			Object obj = method.invoke(subObj,optObj);
			resultInt = CommonFunction.getInt(obj.toString());
	    } catch (Exception ex) {
            logger.error("MenuClass don't make Error Exeption : " + custID);
            ioParam.setMessage(MessageDefine.M_NO_CLASS);
            return EventDefine.E_EVENT_ID_ERROR;
	    }
	   
		return resultInt;
	}
}
