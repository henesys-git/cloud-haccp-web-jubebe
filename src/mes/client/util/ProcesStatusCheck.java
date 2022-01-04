package mes.client.util;
import mes.client.comm.DBServletLink;
import mes.client.common.Common;
public class ProcesStatusCheck {

	//업무 process(Class ID) 별 
//		시작하는 Status=
//		다음 Status=
//		현 프로세스에서 데이터 수정가능한 status <=
//		현 프로세스에서 데이터 삭제가능한 status <=
	public String 
			GV_PROCESS_PREV="" ,
			GV_PROCESS_STATUS="" ,
			GV_PROCESS_NEXT="", 
			GV_PROCESS_MODIFY="", 
			GV_PROCESS_DELETE="", 
			GV_PROCESS_PLAN="", 
			GV_PROCESS_START="",
			GV_PROCESS_NAME="",
			GV_PROCESS_TABLE="",
			GV_PROCESS_NUMBER_GUBUN="",
			GV_PROCESS_GUBUN=""
			;
	DBServletLink dbServletLink = null;
	
	public ProcesStatusCheck(String Class_Name) throws Exception {
		String returnValue[] =null;
		int ColCnt=12;
		dbServletLink = new DBServletLink();
	    dbServletLink.connectURL("M000S100000E704");
	    returnValue = Common.split(dbServletLink.getMultiColumnValue(Class_Name,true,ColCnt), "\t", true);

	    if(returnValue.length >= ColCnt) {			//리턴 되는 값이 끝에 "\t"가 1개 더 추가되어 있어......
		    GV_PROCESS_PREV 	= returnValue[0];
		    GV_PROCESS_STATUS 	= returnValue[1];
		    GV_PROCESS_NEXT 	= returnValue[2];
		    GV_PROCESS_MODIFY 	= returnValue[3];
		    GV_PROCESS_DELETE 	= returnValue[4];
		    GV_PROCESS_PLAN 	= returnValue[5];
		    GV_PROCESS_START 	= returnValue[6];
		    GV_PROCESS_NAME 	= returnValue[7];
		    GV_PROCESS_TABLE 	= returnValue[8];
		    GV_PROCESS_NUMBER_GUBUN 	= returnValue[9];
		    GV_PROCESS_GUBUN 	= returnValue[11];
	    }

	}
}
