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

	// �̺�Ʈ(ȭ��ID)�� ���� ȭ�� Class�� ����.
	public int createSql(InoutParameter ioParam){
		int resultInt = -1;
		int eventMenu = 0;
		
		// ioParam���� eventID�� �� ���� �� �̺�Ʈ���� �����Ѵ�.
		String MenuStr = ioParam.getEventID();
		
		if(!EventDefine.isEventID(MenuStr)){
			LoggingWriter.setLogInfo(EventFactory.class.getName() ,"==== EventID is not define ====");
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			return EventDefine.E_EVENT_ID_ERROR;
		}
		
		logger.debug("Menu Str : " + MenuStr);
		
		// ioParam���� eventMenu�� �� Ŭ�������� �ϼ��Ѵ�.
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
			
			// Ŭ�������� �޼ҵ�(doExcute)�� �����Ѵ�. 
			// optClass�� �Է� �Ķ��Ÿ�� ��Ƽ� �ѱ��.
			Method method = menuClass.getMethod("doExcute",optClass);
			logger.debug(custID + " MenuClass Create Success");
			
			// ���� �޼ҵ带 �����Ų��.
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
