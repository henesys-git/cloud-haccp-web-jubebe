package mes.frame.serviceinterface;

import org.apache.log4j.Logger;

import mes.frame.common.MessageDefine;

public class ServiceDelegator {

	private static ServiceDelegator m_objSelf = null;
	
	static final Logger logger = Logger.getLogger(ServiceDelegator.class.getName());
	
	public ServiceDelegator() {
	}
	
	/**
	* 클라이언트에서 서버에 서비스를 요청하기 위하여 취득해야 할 SingleTon Instance.
	* @return ServiceDelegator
	*/
	public static ServiceDelegator getInstance() {
		logger.debug("##################### Service Delegator START #####################:");
		if (null == ServiceDelegator.m_objSelf)	{
			ServiceDelegator.m_objSelf = new ServiceDelegator();
			logger.debug("Create ServiceDelegator");
		} else {
			logger.debug("Reuse ServiceDelegator");
		}
		return ServiceDelegator.m_objSelf;
	}
	/**
	* html에서 이벤트를 셋팅하고 이 메소드를 호출한다.
	* 이벤트에 따라 처리를 담당할 메인 메소드를 호출한다.
	* @param  ioParam
	* @return the desired integer. 성공하면 0 이상 , 실패하면 -1
	* @exception  Exception  모든exception에 대하여 예외처리 EventID Not define
	*/
	public int doService(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		ioParam.setMessage(MessageDefine.M_UNDEFINED_MESSAGE);
		int returnResultValue = -1;

		try	{
			logger.debug("doService Start");
			logger.debug("Menu Cust ID : " + ioParam.getEventCustID());
			/**
			 * EventFactory 를 생성하고 입력Parameter 를 넘겨준다. 
			 * @return the desired integer. 성공하면 0이상, 실패하면 -1 
			 */
			EventFactory eventFactory = new EventFactory();
			returnResultValue = eventFactory.createSql(ioParam); 
			
			logger.debug("Message : " + ioParam.getMessage());
			logger.debug("doService End");
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("수행시간  : " + runningTime + " ms");
		logger.debug("##################### Service Delegator END #######################\n");
		
		return returnResultValue;
	}
}
