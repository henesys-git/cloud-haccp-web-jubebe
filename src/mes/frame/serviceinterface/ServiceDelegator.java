package mes.frame.serviceinterface;

import org.apache.log4j.Logger;

import mes.frame.common.MessageDefine;

public class ServiceDelegator {

	private static ServiceDelegator m_objSelf = null;
	
	static final Logger logger = Logger.getLogger(ServiceDelegator.class.getName());
	
	public ServiceDelegator() {
	}
	
	/**
	* Ŭ���̾�Ʈ���� ������ ���񽺸� ��û�ϱ� ���Ͽ� ����ؾ� �� SingleTon Instance.
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
	* html���� �̺�Ʈ�� �����ϰ� �� �޼ҵ带 ȣ���Ѵ�.
	* �̺�Ʈ�� ���� ó���� ����� ���� �޼ҵ带 ȣ���Ѵ�.
	* @param  ioParam
	* @return the desired integer. �����ϸ� 0 �̻� , �����ϸ� -1
	* @exception  Exception  ���exception�� ���Ͽ� ����ó�� EventID Not define
	*/
	public int doService(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		ioParam.setMessage(MessageDefine.M_UNDEFINED_MESSAGE);
		int returnResultValue = -1;

		try	{
			logger.debug("doService Start");
			logger.debug("Menu Cust ID : " + ioParam.getEventCustID());
			/**
			 * EventFactory �� �����ϰ� �Է�Parameter �� �Ѱ��ش�. 
			 * @return the desired integer. �����ϸ� 0�̻�, �����ϸ� -1 
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
		logger.debug("����ð�  : " + runningTime + " ms");
		logger.debug("##################### Service Delegator END #######################\n");
		
		return returnResultValue;
	}
}
