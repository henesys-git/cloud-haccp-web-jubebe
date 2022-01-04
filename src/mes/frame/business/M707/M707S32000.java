package mes.frame.business.M707;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;

/* 관련테이블
-- AS접수대장
CREATE TABLE TB_AS_REQLIST (
       REQ_DATE             VARCHAR(10) NOT NULL,	-- 접수일자
       REQ_SEQNO            INTEGER(15) NOT NULL,	-- 일련번호
       REQ_TIME             VARCHAR(8) NULL,		-- 접수시간
       USER_ID              VARCHAR(30) NULL,		-- 사용자ID
       REQ_CHANNEL          VARCHAR(7) NULL,		-- 접수채널
       REQ_MAN_NAME         VARCHAR(100) NULL,		-- AS신청자
       REQ_CONTENTS         VARCHAR(2000) NULL,		-- AS신청내용
       WORK_HOPE_DATE       VARCHAR(10) NULL,		-- 처리희망일자
       OT_ID                VARCHAR(30) NOT NULL,	-- 기장ID
       GEORAESA_CD          VARCHAR(20) NULL,		-- 거래처코드
       GIGONG_CD           	VARCHAR(50) NULL		-- 기종코드
);
ALTER TABLE TB_AS_REQLIST
       ADD  ( PRIMARY KEY (REQ_DATE, REQ_SEQNO) ) ;

-- 거래처별기계정보
CREATE TABLE TB_GEORAESA_PROD_INFO (
       GEORAESA_CD          VARCHAR(20) NOT NULL,	-- 거래처코드
       PRODUCT_SERIAL_NO    VARCHAR(30) NOT NULL,	-- 제품일련번호
       GIJONG_CD           	VARCHAR(20) NULL,		-- 기종코드
       PROD_MODEL        	VARCHAR(20) NULL,		-- 제품모델
       DELIVERY_DT        	VARCHAR(10) NULL,		-- 출고일자
       BELT_CODE            VARCHAR(7)  NULL,		-- 권역코드
       LATITUDE             VARCHAR(30) NULL,		-- 위도
       LONGITUDE            VARCHAR(30) NULL		-- 경도
);
ALTER TABLE TB_GEORAESA_PROD_INFO
       ADD  ( PRIMARY KEY (GEORAESA_CD, PRODUCT_SERIAL_NO) ) ;


-- 원부자재교체이력
CREATE TABLE TB_CHANGE_PARTHIST (
       REQ_DATE             VARCHAR(10) NOT NULL,	-- 접수일자
       REQ_SEQNO            INTEGER NOT NULL,		-- 일련번호
       REQ_TASK_SEQNO       INTEGER NOT NULL,		-- AS업무일련번호
       PART_CODE            VARCHAR(56) NOT NULL,	-- 원부자재코드
       SURYANG              DECIMAL(15,2) NULL,		-- 수량
       REAL_DANGA           DECIMAL(15,2) NULL,		-- 단가
       REAL_GONGIM          DECIMAL(15,2) NULL,		-- 공임
       BIGO                 VARCHAR(2000) NULL		-- 비고
);
ALTER TABLE TB_CHANGE_PARTHIST
       ADD  ( PRIMARY KEY (REQ_DATE, REQ_SEQNO, REQ_TASK_SEQNO, PART_CODE) ) ;


-- 처리결과이력
CREATE TABLE TB_REQ_TASKHIST (
       REQ_DATE             VARCHAR(10) NOT NULL,	-- 접수일자
       REQ_SEQNO            INTEGER NOT NULL,		-- 일련번호
       REQ_TASK_SEQNO       INTEGER NOT NULL,		-- AS작업진행일련번호
       TASK_START_DATE      VARCHAR(10) NULL,		-- 작업시작일자
       TASK_START_TIME      VARCHAR(8) NULL,		-- 작업시작시간
       TASK_CONTENTS        VARCHAR(2000) NULL,		-- 작업내용
       PROC_DAMDANG_MAN     VARCHAR(30) NULL,		-- 처리담당자
       PAY_OR_NOPAY         VARCHAR(7) NULL,		-- 비용유무구분코드
       IGWAN_MAN            VARCHAR(30) NULL,		-- 업무이관자
       B_L_NO               VARCHAR(30) NULL,		-- 
       INVOICE_NO           VARCHAR(30) NULL,		-- 
       SERIAL_NO            VARCHAR(30) NULL,		-- 기계일련번호[FK]
       COWORK_CODE          VARCHAR(7) NULL,		-- 협조코드
       PROC_STATUS_CODE     VARCHAR(7) NULL,		-- 진행상태코드
       TASK_TYPE_CODE       VARCHAR(7) NULL,		-- 업무유형
       TASK_TEAM_CODE       VARCHAR(7) NULL,		-- 처리팀코드
       TASK_END_DATE        VARCHAR(10) NULL,		-- 작업종료일자
       TASK_END_TIME        VARCHAR(8) NULL			-- 작업종료시간
);
ALTER TABLE TB_REQ_TASKHIST
       ADD  ( PRIMARY KEY (REQ_DATE, REQ_SEQNO, REQ_TASK_SEQNO) ) ;
*/

public class M707S32000 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S32000(){
	}
	
	/**
	 * 사용자가 정의해서 파라메터 검증하는 method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql){
		int paramInt = 0;
		return paramInt;
	}
	/**
	 * 입력파라메타가 2차원 구조인경우 파라메터 검증하는 method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql){
		v_paramArray = super.getParamCheck(ioParam,p_sql);
		return v_paramArray[0].length;
	}
	/**
	 * 입력파라메타에서 이벤트ID별로 메소드 호출하는 method.
	 * @param	ioParam
	 * @return the desired integer.
	 */
	public  int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M707S32000.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M707S32000.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M707S32000.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M707S32000.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M707S32000.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	public int E001(InoutParameter ioParam){ // 	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			
			sql = new StringBuffer();
			sql.append(" insert into TB_REQ_TASKHIST ( 	\n");
			sql.append("		REQ_DATE				\n");
			sql.append("		,REQ_SEQNO				\n");
			sql.append("		,REQ_TASK_SEQNO			\n");
			sql.append("		,task_start_date		\n");
			sql.append("		,task_end_date			\n");
			sql.append("		,proc_damdang_man		\n");
			sql.append("		,task_contents			\n");
			sql.append("		,task_start_time		\n");
			sql.append("		,task_end_time			\n");
			sql.append("		,serial_no				\n");
			sql.append("		,pay_or_nopay			\n");
			sql.append("		,task_team_code			\n");
			sql.append("		,task_type_code			\n");
			sql.append("		,proc_status_code		\n");
			sql.append("		,cowork_code			\n");
			sql.append("		,igwan_man				\n");
			sql.append("		,b_l_no					\n");
			sql.append("		,invoice_no				\n");
			sql.append(" 	) values ( \n");
			sql.append(" 		'" + c_paramArray[0][0] + "' \n"); //REQ_DATE
			sql.append(" 		,'" + c_paramArray[0][1] + "' \n"); //REQ_SEQNO
			sql.append(" 		,(select coalesce(max(REQ_TASK_SEQNO),0)+1 from TB_REQ_TASKHIST where REQ_DATE='" + c_paramArray[0][0] + "' and REQ_SEQNO='" + c_paramArray[0][1] + "') \n");
			sql.append(" 		,'" + c_paramArray[0][2] + "' \n"); //task_start_date
			sql.append(" 		,'" + c_paramArray[0][3] + "' \n"); //task_end_date
			sql.append(" 		,'" + c_paramArray[0][4] + "' \n"); //proc_damdang_man
			sql.append(" 		,'" + c_paramArray[0][5] + "' \n"); //task_contents
			sql.append(" 		,'" + c_paramArray[0][6] + "' \n"); //task_start_time
			sql.append(" 		,'" + c_paramArray[0][7] + "' \n"); //task_end_time
			sql.append(" 		,'" + c_paramArray[0][8] + "' \n"); //serial_no
			sql.append(" 		,'" + c_paramArray[0][9] + "' \n"); //pay_or_nopay
			sql.append(" 		,'" + c_paramArray[0][10] + "' \n"); //task_team_code
			sql.append(" 		,'" + c_paramArray[0][11] + "' \n"); //task_type_code
			sql.append(" 		,'" + c_paramArray[0][12] + "' \n"); //proc_status_code
			sql.append(" 		,'" + c_paramArray[0][13] + "' \n"); //cowork_code
			sql.append(" 		,'" + c_paramArray[0][14] + "' \n"); //igwan_man
			sql.append(" 		,'" + c_paramArray[0][15] + "' \n"); //b_l_no
			sql.append(" 		,'" + c_paramArray[0][16] + "' \n"); //invoice_no
			sql.append(" 	) \n");
			// System.out.println(sql.toString());

			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배령에 담아 보낸면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M707S32000E001()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32000E001()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E002(InoutParameter ioParam){ // 	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.

			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			/*
			sql.append("		,task_start_date		\n");3
			sql.append("		,task_end_date			\n");4
			sql.append("		,proc_damdang_man		\n");5
			sql.append("		,task_contents			\n");6
			sql.append("		,task_start_time		\n");7
			sql.append("		,task_end_time			\n");8
			sql.append("		,serial_no				\n");9
			sql.append("		,pay_or_nopay			\n");10
			sql.append("		,task_team_code			\n");11
			sql.append("		,task_type_code			\n");12
			sql.append("		,proc_status_code		\n");13
			sql.append("		,cowork_code			\n");14
			sql.append("		,igwan_man				\n");15
			sql.append("		,b_l_no					\n");16
			sql.append("		,invoice_no				\n");17
	    	if (jobGubun == Config.OPEN) {
	    		retParam += asreqDateText.getText().trim() + "|" + m07s32000.GV_REQ_SEQNO + "|" + m07s32000.GV_REQ_TASK_SEQNO + "|";
	    	} else {
	    		retParam += asreqDateText.getText().trim() + "|" + m07s32000.GV_REQ_SEQNO + "|";
	    	}
	    	retParam += taskStartText.getText().trim() + "|" + taskEndText.getText().trim() + "|";
	    	retParam += GV_TASK_USER_ID + "|" + contentsArea.getText() + "|";
	    	retParam += taskStartTimeText.getText().trim() + "|" + taskEndTimeText.getText().trim() + "|";
	    	retParam += GV_PRODUCT_SERNO + "|" + "P" + "|";
	    	retParam += "TEAM" + "|" + "TYPE" + "|" + "STATUS" + "|" + "COWORK" + "|" + "IGWAN" + "|" + "BL" + "|" + "INVO" + "|";
	    	*/

			sql = new StringBuffer();
			sql.append(" update TB_REQ_TASKHIST set 								\n");
			sql.append("		task_start_date = '" + c_paramArray[0][3] + "' 		\n");
			sql.append("		,task_end_date = '" + c_paramArray[0][4] + "' 		\n");
			sql.append("		,proc_damdang_man = '" + c_paramArray[0][5] + "' 	\n");
			sql.append("		,task_contents = '" + c_paramArray[0][6] + "' 		\n");
			sql.append("		,task_start_time = '" + c_paramArray[0][7] + "' 	\n");
			sql.append("		,task_end_time = '" + c_paramArray[0][8] + "' 		\n");
			sql.append("		,serial_no = '" + c_paramArray[0][9] + "' 			\n");
			sql.append("		,pay_or_nopay = '" + c_paramArray[0][10] + "' 		\n");
			sql.append("		,task_team_code = '" + c_paramArray[0][11] + "' 	\n");
			sql.append("		,task_type_code = '" + c_paramArray[0][12] + "' 	\n");
			sql.append("		,proc_status_code = '" + c_paramArray[0][13] + "' 	\n");
			sql.append("		,cowork_code = '" + c_paramArray[0][14] + "' 		\n");
			sql.append("		,igwan_man = '" + c_paramArray[0][15] + "' 			\n");
			sql.append("		,b_l_no = '" + c_paramArray[0][16] + "' 			\n");
			sql.append("		,invoice_no = '" + c_paramArray[0][17] + "' 		\n");
			sql.append(" where REQ_DATE = '" + c_paramArray[0][0] + "' 				\n");
			sql.append(" 	and REQ_SEQNO = '" + c_paramArray[0][1] + "' 			\n");
			sql.append(" 	and REQ_TASK_SEQNO = '" + c_paramArray[0][2] + "' 		\n");
			// System.out.println(sql.toString());

			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배열에 담아 보내면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M707S32000E002()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32000E002()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E003(InoutParameter ioParam){ // 	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			sql = new StringBuffer();
			sql.append(" delete from TB_REQ_TASKHIST \n");
			sql.append(" where REQ_DATE = '" + c_paramArray[0][0] + "' 				\n");
			sql.append(" 	and REQ_SEQNO = '" + c_paramArray[0][1] + "' 				\n");
			sql.append(" 	and REQ_TASK_SEQNO = '" + c_paramArray[0][2] + "' 				\n");

			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배령에 담아 보낸면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			resultInt = super.excuteUpdate(con, sql.toString());
			if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return resultInt;
			}else{
				sql = new StringBuffer();
				sql.append(" delete from TB_CHANGE_PARTHIST \n");
				sql.append(" where REQ_DATE = '" + c_paramArray[0][0] + "' 				\n");
				sql.append(" 	and REQ_SEQNO = '" + c_paramArray[0][1] + "' 				\n");
				sql.append(" 	and REQ_TASK_SEQNO = '" + c_paramArray[0][2] + "' 				\n");
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return resultInt;
				}
				con.commit();
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}

		} catch(Exception e) {
			LoggingWriter.setLogError("M707S32000E003()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32000E003()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E004(InoutParameter ioParam){ // 	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			//{"고객사", "제품모델", "접수일자", "처리희망일자", "처리상태", "AS신청인", 
			// 	"접수방법", "접수자", "AS요청내용", "REQ_SEQNO", "GEORAESA_CD", "PRODUCT_CD", "USER_ID", "AS_STATUS_CD", "REQ_CHANNEL", "REQ_TIME" };
			
//			sql = new StringBuffer();
//			sql.append("	select	\n"); 
//			sql.append("		(select CUST_NM from vtbm_customer where CUST_CD=QL.GEORAESA_CD) as CUST_NM,	\n"); 
//			sql.append("		(select 	\n"); 
//			sql.append("				(SELECT CODE_NAME FROM tbm_code_book WHERE CODE_CD=gpi.GIJONG_CD) ||'.'||PROD_MODEL	\n"); 
//			sql.append("			from TB_GEORAESA_PROD_INFO gpi where PRODUCT_SERIAL_NO=QL.PRODUCT_CD ) as PRODUCT_MODEL,	\n"); 
//			sql.append("		REQ_DATE,	\n"); 
//			sql.append("		WORK_HOPE_DATE,	\n"); 
//			sql.append("		(select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.AS_STATUS_CD) as WORK_STATUS,	\n"); 
//			sql.append("		REQ_MAN_NAME,	\n"); 
//			sql.append("		(select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.REQ_CHANNEL) as CHANNEL_NM,	\n"); 
//			sql.append("		(select USER_NM from tbm_users where USER_ID=QL.USER_ID) as USER_NM,	\n"); 
//			sql.append("		REQ_CONTENTS,	\n"); 
//			sql.append("		REQ_SEQNO,	\n"); 
//			sql.append("		GEORAESA_CD,	\n"); 
//			sql.append("		PRODUCT_CD,	\n"); 
//			sql.append("		USER_ID,	\n"); 
//			sql.append("		AS_STATUS_CD,	\n"); 
//			sql.append("		REQ_CHANNEL,	\n"); 
//			sql.append("		REQ_TIME	\n"); 
//			sql.append("	from	\n"); 
//			sql.append("		TB_AS_REQLIST QL	\n"); 
//			sql.append("	where	1=1	\n"); 
//			sql.append(" 		and REQ_DATE >= '" + c_paramArray[0][0] + "' \n"); 
//			sql.append(" 		and REQ_DATE <= '" + c_paramArray[0][1] + "' \n"); 
			String sql = new StringBuilder()
					.append("select\n")
					.append("                (select CUST_NM from vtbm_customer where CUST_CD=QL.GEORAESA_CD) as CUST_NM,\n")
					.append("                (select\n")
					.append("                	(SELECT CODE_NAME FROM tbm_code_book WHERE CODE_CD=gpi.GIJONG_CD) ||'.'||PROD_MODEL\n")
					.append("                        from TB_GEORAESA_PROD_INFO gpi \n")
					.append("                        where PRODUCT_SERIAL_NO=QL.PRODUCT_CD \n")
					.append("                        AND georaesa_cd = QL.georaesa_cd\n")
					.append("                        ORDER BY seqno DESC \n")
					.append("                        LIMIT 1\n")
					.append("                ) as PRODUCT_MODEL,\n")
					.append("                REQ_DATE,\n")
					.append("                WORK_HOPE_DATE,\n")
					.append("                (select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.AS_STATUS_CD) as WORK_STATUS,\n")
					.append("                REQ_MAN_NAME,\n")
					.append("                (select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.REQ_CHANNEL) as CHANNEL_NM,\n")
					.append("                (select USER_NM from tbm_users where USER_ID=QL.USER_ID) as USER_NM,\n")
					.append("                REQ_CONTENTS,\n")
					.append("                REQ_SEQNO,\n")
					.append("                GEORAESA_CD,\n")
					.append("                PRODUCT_CD,\n")
					.append("                USER_ID,\n")
					.append("                AS_STATUS_CD,\n")
					.append("                REQ_CHANNEL,\n")
					.append("                REQ_TIME\n")
					.append("        from\n")
					.append("                TB_AS_REQLIST QL\n")
					.append("	where	1=1	\n") 
					.append(" 		and REQ_DATE >= '" + c_paramArray[0][0] + "' \n") 
					.append(" 		and REQ_DATE <= '" + c_paramArray[0][1] + "' \n") 
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S32000E004()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32000E004()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	public int E014(InoutParameter ioParam){ // 	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			//{"고객사", "제품모델", "접수일자", "처리희망일자", "처리상태", "AS신청인", 
			// 	"접수방법", "접수자", "AS요청내용", "REQ_SEQNO", "GEORAESA_CD", "PRODUCT_CD", "USER_ID", "AS_STATUS_CD", "REQ_CHANNEL", "REQ_TIME" };
			
			sql = new StringBuffer();
			sql.append("	select	\n"); 
			sql.append("		(select CUST_NM from vtbm_customer where CUST_CD=QL.GEORAESA_CD) as CUST_NM,	\n"); 
			sql.append("		(select 	\n"); 
			sql.append("				(SELECT CODE_NAME FROM tbm_code_book WHERE CODE_CD=gpi.GIJONG_CD) ||'.'||PROD_MODEL	\n"); 
			sql.append("			from TB_GEORAESA_PROD_INFO gpi where PRODUCT_SERIAL_NO=QL.PRODUCT_CD ) as PRODUCT_MODEL,	\n"); 
			sql.append("		REQ_DATE,	\n"); 
			sql.append("		WORK_HOPE_DATE,	\n"); 
			sql.append("		(select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.AS_STATUS_CD) as WORK_STATUS,	\n"); 
			sql.append("		REQ_MAN_NAME,	\n"); 
			sql.append("		(select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.REQ_CHANNEL) as CHANNEL_NM,	\n"); 
			sql.append("		(select USER_NM from tbm_users where USER_ID=QL.USER_ID) as USER_NM,	\n"); 
			sql.append("		REQ_CONTENTS,	\n"); 
			sql.append("		REQ_SEQNO,	\n"); 
			sql.append("		GEORAESA_CD,	\n"); 
			sql.append("		PRODUCT_CD,	\n"); 
			sql.append("		USER_ID,	\n"); 
			sql.append("		AS_STATUS_CD,	\n"); 
			sql.append("		REQ_CHANNEL,	\n"); 
			sql.append("		REQ_TIME	\n"); 
			sql.append("	from	\n"); 
			sql.append("		TB_AS_REQLIST QL	\n"); 
			sql.append("	where	1=1	\n"); 
			sql.append(" 		and GEORAESA_CD = '" + c_paramArray[0][0] + "' \n"); 
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S32000E014()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32000E014()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	/*
	{"기종","제품일련번호", "제품모델","출고일자", "GIJONG_CD", "MODEL_NO"};
	*/
	public int E024(InoutParameter ioParam){ // 	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			//{"기종","제품일련번호", "제품모델","출고일자", "GIJONG_CD", "MODEL_NO"};

			sql = new StringBuffer();
			sql.append(" select	\n"); 
			sql.append(" 	gijong_cd	\n"); 
			sql.append(" 	,product_serial_no	\n"); 
			sql.append(" 	,prod_model	\n"); 
			sql.append(" 	,delivery_dt	\n"); 
			sql.append(" 	,gijong_cd	\n"); 
			sql.append(" 	,prod_model	\n"); 
			sql.append(" from TB_GEORAESA_PROD_INFO	\n"); 
			sql.append(" where 1=1			\n"); 	
			sql.append(" 	and GEORAESA_CD = '" + c_paramArray[0][0] + "'	\n"); 	
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S32000E024()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32000E024()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E034(InoutParameter ioParam){ // 	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			//{"기종","제품일련번호", "작업담당자","작업시작일", "작업시작시간", "작업종료일", "작업종료시간", "작업내용", "REQ_TASK_SEQNO"};

			sql = new StringBuffer();
			sql.append(" select	\n"); 
			sql.append("	(select 	\n"); 
			sql.append("		(SELECT CODE_NAME FROM tbm_code_book WHERE CODE_CD=gpi.GIJONG_CD) ||'.'||PROD_MODEL	\n"); 
			sql.append("			from TB_GEORAESA_PROD_INFO gpi where PRODUCT_SERIAL_NO=RT.SERIAL_NO ) as PRODUCT_MODEL	\n"); 
			sql.append("	,SERIAL_NO 				\n"); //	-- 기계일련번호[FK]
			sql.append(" 	,(select USER_NM from tbm_users where USER_ID = trim(PROC_DAMDANG_MAN)) as PROC_DAMDANG_MAN_NAME	\n"); // 처리담당자
			sql.append("	,TASK_START_DATE 		\n"); //	-- 작업시작일자
			sql.append("	,TASK_START_TIME 		\n"); //	-- 작업시작시간
			sql.append("	,TASK_END_DATE 			\n"); //	-- 작업종료일자
			sql.append("	,TASK_END_TIME 			\n"); //	-- 작업종료시간
			sql.append("	,TASK_CONTENTS 			\n"); //	-- 작업내용
			sql.append("	,REQ_TASK_SEQNO 			\n"); //	-- AS작업진행일련번호
			sql.append("	,proc_damdang_man 			\n"); //	-- 작업자
			sql.append(" from TB_REQ_TASKHIST RT	\n"); 
			sql.append(" where 1=1	\n"); 	
			sql.append(" 	and SERIAL_NO = '" + c_paramArray[0][0] + "'	\n"); 	
//			sql.append(" where REQ_DATE = '" + c_paramArray[0][0] + "'	\n"); 	
//			sql.append(" 	and REQ_SEQNO = '" + c_paramArray[0][1] + "'	\n"); 	
			sql.append(" order by REQ_DATE desc, REQ_SEQNO desc, REQ_TASK_SEQNO desc	\n"); 	
		       /*
		       PAY_OR_NOPAY         VARCHAR(7) NULL,		-- 비용유무구분코드
		       IGWAN_MAN            VARCHAR(30) NULL,		-- 업무이관자
		       B_L_NO               VARCHAR(30) NULL,		-- 
		       INVOICE_NO           VARCHAR(30) NULL,		-- 
		       COWORK_CODE          VARCHAR(7) NULL,		-- 협조코드
		       PROC_STATUS_CODE     VARCHAR(7) NULL,		-- 진행상태코드
		       TASK_TYPE_CODE       VARCHAR(7) NULL,		-- 업무유형
		       TASK_TEAM_CODE       VARCHAR(7) NULL,		-- 처리팀코드
		       */
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S32000E034()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32000E034()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E044(InoutParameter ioParam){ // 	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			//{"원부자재명", "원부자재코드", "수량", "단가", "공임", "비고", "OLD_PART_CODE" };

			String sql = new StringBuilder()
					.append("select			\n")
					.append("	(select PART_NM from TB_PARTLIST where PART_CD = CP.PART_CODE) as PART_NAME	\n")
					.append("	,PART_CODE	\n")
					.append("	,suryang				\n")
					.append("	,real_danga				\n")
					.append("	,real_gongim			\n")
					.append("	,bigo					\n")
					.append("	,(select PART_NM from TB_PARTLIST where PART_CD = CP.PART_CODE) as OLD_PARTCODE		\n")
					.append("from 						\n")
					.append("	TB_CHANGE_PARTHIST CP	\n")
					.append("where						\n")
					.append("	req_date = '" + c_paramArray[0][0] + "'	\n")
					.append("	AND req_seqno = '" + c_paramArray[0][1] + "'	\n")
					//.append("	AND req_task_seqno = '" + c_paramArray[0][2] + "'	\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S32000E044()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32000E044()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
}

