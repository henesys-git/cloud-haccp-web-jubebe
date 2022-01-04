package mes.frame.business.M101;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;

public class M101S030100 extends SqlAdapter {
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	QueueProcessing Queue = new QueueProcessing();
	
	public M101S030100() {
		// TODO Auto-generated constructor stub
	}

	@Override
	protected int custParamCheck(InoutParameter ioParam, StringBuffer p_sql) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public  int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M101S030100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M101S030100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M101S030100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M101S030100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M101S030100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	public int E111(InoutParameter ioParam){
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		
			con.setAutoCommit(false);
			    		
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer 써비스 객체 생성 이후
//			System.out.println(rcvData);
			
			for(int i=0; i<jjArray.size(); i++) {  
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
				
				sql = new StringBuilder()
					.append("MERGE INTO tbi_order_bomlist mm     \n")
					.append("USING (SELECT     \n")
					.append(" 		'" + jjjArray.get("proc_plan_no") 	+ "' AS proc_plan_no, 		\n") //proc_plan_no
					.append(" 		'" + jjjArray.get("order_no") 		+ "' AS order_no, 		\n") //order_no
					.append(" 		'" + jjjArray.get("bom_cd") 		+ "' AS bom_cd, 		\n") //bom_cd
					.append(" 		'" + jjjArray.get("bom_cd_rev") 	+ "' AS bom_cd_rev, 	\n") //bom_cd_rev			
					.append(" 		'" + jjjArray.get("bom_name") 		+ "' AS bom_name, 		\n") //bom_name
					.append(" 		'" + jjjArray.get("lotno") 			+ "' AS lotno, 			\n") //lotno	
					.append(" 		'" + jjjArray.get("last_no") 		+ "' AS last_no, 		\n") //last_no
					.append(" 		'" + jjjArray.get("type_no") 		+ "' AS type_no, 		\n") //type_no	
					.append(" 		'" + jjjArray.get("geukyongpoommok") + "' AS geukyongpoommok, \n") //geukyongpoommok 
					.append(" 		'" + jjjArray.get("dept_code") 		+ "' AS dept_code, 		\n") //dept_code
					.append(" 		TO_DATE('" + jjjArray.get("approval_date") + "','YYYY-MM-DD') AS approval_date, \n") //approval_date
					.append(" 		'" + jjjArray.get("approval") 		+ "' AS approval, 		\n") //approval
					.append(" 		'" + jjjArray.get("sys_bom_id") 	+ "' AS sys_bom_id,		\n") //sys_bom_id
					.append(" 		'" + jjjArray.get("part_cd") 		+ "' AS part_cd, 		\n") //part_cd				
					.append(" 		'" + jjjArray.get("part_cd_rev") 	+ "' AS part_cd_rev, 	\n") //part_cd_rev
					.append(" 		'" + jjjArray.get("part_cnt") 		+ "' AS part_cnt,		\n") //part_cnt
					.append(" 		'" + jjjArray.get("mesu") 			+ "' AS mesu, 			\n") //mesu
					.append(" 		'" + jjjArray.get("gubun") 			+ "' AS gubun, 			\n") //gubun
					.append(" 		'" + jjjArray.get("qar") 			+ "' AS qar, 			\n") //qar
					.append(" 		'" + jjjArray.get("inspect_selbi") 	+ "' AS inspect_selbi,  \n") //inspect_selbi
					.append(" 		'" + jjjArray.get("packing_jaryo") 	+ "' AS packing_jaryo, 	\n") //packing_jaryo
					.append(" 		'" + jjjArray.get("modify_note") 	+ "' AS modify_note,	\n") //modify_note
					.append(" 		'" + jjjArray.get("cust_code") 		+ "' AS cust_code, 		\n") //cust_code
					.append(" 		'" + jjjArray.get("cust_rev") 		+ "' AS cust_rev, 		\n") //cust_rev
					.append(" 		'" + jjjArray.get("bigo") 			+ "' AS bigo, 			\n") //bigo
					.append(" 		'" + jjjArray.get("login_id") 		+ "' AS create_user_id,	\n") //create_user_id
					.append(" 		'" + jjjArray.get("member_key") 	+ "' AS member_key	 	\n") //member_key
					.append("	  )  mQ    \n")						
					.append("ON (mm.proc_plan_no = mQ.proc_plan_no AND mm.bom_cd = mQ.bom_cd AND mm.bom_cd_rev = mQ.bom_cd_rev  AND mm.sys_bom_id = mQ.sys_bom_id AND mm.member_key=mQ.member_key )    \n")
					.append("WHEN MATCHED THEN     \n")
					.append("	UPDATE SET     \n")
					.append(  "mm.proc_plan_no = mQ.proc_plan_no, mm.order_no = mQ.order_no, 		mm.lotno = mQ.lotno, "
							+ "mm.bom_cd = mQ.bom_cd, 			mm.bom_cd_rev = mQ.bom_cd_rev, "
							+ "mm.bom_name = mQ.bom_name, 		mm.last_no = mQ.last_no, 		mm.sys_bom_id = mQ.sys_bom_id, "
							+ "mm.type_no = mQ.type_no, 		mm.geukyongpoommok = mQ.geukyongpoommok, mm.dept_code = mQ.dept_code, "
							+ "mm.approval_date = mQ.approval_date, mm.approval = mQ.approval, "
							+ "mm.part_cd = mQ.part_cd, 	mm.part_cd_rev = mQ.part_cd_rev,"
							+ "mm.part_cnt = mQ.part_cnt, 		mm.mesu = mQ.mesu, mm.gubun = mQ.gubun, "
							+ "mm.qar = mQ.qar, 				mm.inspect_selbi = mQ.inspect_selbi, mm.packing_jaryo = mQ.packing_jaryo, "
							+ "mm.modify_note = mQ.modify_note, mm.cust_code = mQ.cust_code, 	mm.cust_rev = mQ.cust_rev, "
							+ "mm.bigo = mQ.bigo, 				mm.create_user_id = mQ.create_user_id, mm.member_key=mQ.member_key \n")
					.append("WHEN NOT MATCHED THEN     \n")
					.append("	INSERT  ( \n")
					.append(  "mm.proc_plan_no, mm.order_no, mm.lotno, 	mm.bom_cd,	mm.bom_cd_rev,	mm.bom_name,"
							+ "mm.last_no,	mm.sys_bom_id,			mm.type_no,		mm.geukyongpoommok,	mm.dept_code,	mm.approval_date,"
							+ "mm.approval,	mm.part_cd,		mm.part_cd_rev,	"
							+ "mm.part_cnt,	mm.mesu,mm.gubun,		mm.qar,			mm.inspect_selbi,	mm.packing_jaryo,mm.modify_note,"
							+ "mm.cust_code,mm.cust_rev,			mm.bigo,		mm.create_user_id, mm.member_key\n")
					.append(") \n")
					.append(" VALUES  ( \n")
					.append(  "mQ.proc_plan_no, mQ.order_no, mQ.lotno,	mQ.bom_cd,	mQ.bom_cd_rev,	mQ.bom_name,"
							+ "mQ.last_no,	mQ.sys_bom_id,			mQ.type_no,		mQ.geukyongpoommok,	mQ.dept_code,	mQ.approval_date,"
							+ "mQ.approval,	mQ.part_cd,				mQ.part_cd_rev,"
							+ "mQ.part_cnt,	mQ.mesu,mQ.gubun,		mQ.qar,			mQ.inspect_selbi,	mQ.packing_jaryo,mQ.modify_note,"
							+ "mQ.cust_code,mQ.cust_rev,			mQ.bigo,		mQ.create_user_id, mQ.member_key \n")
					.append("); ")
					.toString();
				
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}

//				System.out.println("sql.toString()");
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S030100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E111()","==== finally ===="+ e.getMessage());
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
	
	// S101S030111.jsp 행삭제
	public int E113(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();

			con.setAutoCommit(false);
			    		
			
			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		JSONArray jjArray = (JSONArray)jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
    		
			String sql = new StringBuilder()
					.append("DELETE FROM tbi_order_bomlist\n")
					.append("WHERE proc_plan_no = '"+ jjjArray.get("proc_plan_no") 		+ "'\n")
//					.append("	AND order_no 	= '"+ jjjArray.get("order_no") 		+ "'\n")
//					.append("	AND lotno 		= '"+ jjjArray.get("lotno") 		+ "'\n")
					.append("	AND bom_cd 		= '"+ jjjArray.get("bom_cd") 		+ "'\n")
					.append("	AND bom_cd_rev 	= '"+ jjjArray.get("bom_cd_rev") 	+ "'\n")
					.append("	AND sys_bom_id 	= '"+ jjjArray.get("sys_bom_id") 	+ "'\n")
					.append("	AND part_cd 	= '"+ jjjArray.get("part_cd") 		+ "'\n")
					.append("	AND part_cd_rev = '"+ jjjArray.get("part_cd_rev") 	+ "'\n")
					.append("	AND member_key 	= '"+ jjjArray.get("member_key") 	+ "'\n")
					.toString();
			
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}

			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S030100E113()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E113()","==== finally ===="+ e.getMessage());
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


	public int E121(InoutParameter ioParam){ 
			resultInt = EventDefine.E_DOEXCUTE_INIT;

			String sql ="";

			ApprovalActionNo ActionNo;
			String order_check_no="";
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
	    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
	    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
	    		JSONArray jjArray = (JSONArray) jArray.get("param");
	    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0);
				
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
				con.setAutoCommit(false);
				
	    		String jspPage = (String)jArrayHead.get("jsp_page");
	    		String user_id = (String)jArrayHead.get("login_id");
	    		String prefix = (String)jArrayHead.get("num_gubun");
	    		String actionGubun = "Regist";
	    		String detail_seq 	= (String)jArrayHead.get("detail_seq");
	    		String member_key 	= (String)jjjArray0.get("member_key");
	    		
				ActionNo = new ApprovalActionNo();

				order_check_no= ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);
				
		    	for(int i=0; i<jjArray.size(); i++) {
		    		JSONObject jjjArray = (JSONObject)jjArray.get(i);
		    		sql = new StringBuilder()
//	    				.append("INSERT INTO\n")
//	    				.append("	tbi_order_process_checklist (\n")
//	    				.append("		lotno,\n")
//	    				.append("		order_no,\n")
//	    				.append("		order_check_no,\n")
//	    				.append("		qar,\n")
//	    				.append("		spec_approval,\n")
//	    				.append("		spec_approval_rev,\n")
//	    				.append("		std_dwg,\n")
//	    				.append("		std_dwg_rev,\n")
//	    				.append("		program_rev,\n")
//	    				.append("		job_guide,\n")
//	    				.append("		job_guide_rev,\n")
//	    				.append("		proc_cd,\n")
//	    				.append("		proc_rev,\n")
//	    				.append("		checklist_cd,\n")
//	    				.append("		checklist_seq,\n")
//	    				.append("		checklist_rev,\n")
//	    				.append("		standard_guide,\n")
//	    				.append("		standard_value,\n")
//	    				.append("		tools,\n")
//	    				.append("		check_note,\n")
//	    				.append("		start_date,\n")
//	    				.append("		create_date,\n")
//	    				.append("		create_user_id\n")
//	    				.append("	)\n")
//	    				.append("VALUES	(\n")
//						.append(" 		'" + c_paramArray_Detail[i][4] + "'		\n") //lotno
//						.append(" 		,'" + c_paramArray_Detail[i][3] + "'	\n") //order_no
//						.append(" 		,'"  + order_check_no + "' \n") 			//order_check_no
//						.append(" 		,'" + c_paramArray_Detail[i][5] + "'	\n") //qar
//						.append(" 		,'" + c_paramArray_Detail[i][6] + "' 	\n") //spec_approval			
//						.append(" 		,'" + c_paramArray_Detail[i][7] + "'	\n") //spec_approval_rev
//						.append(" 		,'" + c_paramArray_Detail[i][8] + "'	\n") //std_dwg	
//						.append(" 		,'" + c_paramArray_Detail[i][9] + "'	\n") //std_dwg_rev
//						.append(" 		,'" + c_paramArray_Detail[i][10] + "'	\n") //program_rev	
//						.append(" 		,'" + c_paramArray_Detail[i][11] + "'	\n") //job_guide 
//						.append(" 		,'" + c_paramArray_Detail[i][12] + "'	\n") //job_guide_rev
//						.append(" 		,'" + c_paramArray_Detail[i][13] + "' 	\n") //proc_cd
//						.append(" 		,'" + c_paramArray_Detail[i][14] + "' 	\n") //proc_rev
//						.append(" 		,'" + c_paramArray_Detail[i][15] + "'	\n") //checklist_cd
//						.append(" 		,'" + c_paramArray_Detail[i][16] + "'	\n") //checklist_seq	
//						.append(" 		,'" + c_paramArray_Detail[i][17] + "'	\n") //checklist_rev 
//						.append(" 		,'" + c_paramArray_Detail[i][18] + "'	\n") //standard_guide
//						.append(" 		,'" + c_paramArray_Detail[i][19] + "'	\n") //standard_value
//						.append(" 		,'" + c_paramArray_Detail[i][20] + "' 	\n") //tools
//						.append(" 		,'" + c_paramArray_Detail[i][21] + "' 	\n") //check_note
//						.append(" 		, to_char(sysdate,'YYYY-MM-DD') 		\n") //start_date
//						.append(" 		, SYSDATETIME 							\n") //create_date
//						.append(" 		,'" + c_paramArray_Detail[i][1] + "' 	\n") //create_user_id
//	    				.append("	);\n")
	    				.append("MERGE INTO tbi_order_process_checklist mm\n")
    					.append("	USING ( \n")
    					.append("SELECT \n")
    					.append(" 		'" + jjjArray.get("lotno") + "'AS lotno,		\n") //lotno
						.append(" 		'" + jjjArray.get("order_no") + "'AS order_no,	\n") //order_no
						.append(" 		'"  + order_check_no + "'AS order_check_no, 	\n") //order_check_no
						.append(" 		'" + jjjArray.get("qar") + "'AS qar,			\n") //qar
						.append(" 		'" + jjjArray.get("spec_approval") + "'AS spec_approval, \n") //spec_approval			
						.append(" 		'" + jjjArray.get("std_dwg") + "'AS std_dwg,	\n") //std_dwg	
						.append(" 		'" + jjjArray.get("program_rev") + "'AS program_rev, \n") //program_rev	
						.append(" 		'" + jjjArray.get("job_guide") + "'AS job_guide,\n") //job_guide 
						.append(" 		'" + jjjArray.get("proc_cd") + "'AS proc_cd, 	\n") //proc_cd
						.append(" 		'" + jjjArray.get("proc_rev") + "'AS proc_rev, 	\n") //proc_rev
						.append(" 		'" + jjjArray.get("checklist_cd") + "'AS checklist_cd,		\n") //checklist_cd
						.append(" 		'" + jjjArray.get("checklist_seq") + "'AS checklist_seq,	\n") //checklist_seq	
						.append(" 		'" + jjjArray.get("checklist_rev") + "'AS checklist_rev,	\n") //checklist_rev 
						.append(" 		'" + jjjArray.get("standard_guide") + "'AS standard_guide,	\n") //standard_guide
						.append(" 		'" + jjjArray.get("standard_value") + "'AS standard_value,	\n") //standard_value
						.append(" 		'" + jjjArray.get("tools") + "'AS tools, 		\n") //tools
						.append(" 		'" + jjjArray.get("check_note") + "'AS check_note,	\n") //check_note
						.append(" 		'" + jjjArray.get("member_key") + "'AS member_key,	\n") 
						.append(" 		TO_CHAR(sysdate,'YYYY-MM-DD') AS start_date, \n") //start_date
						.append(" 		SYSDATETIME AS create_date,						\n") //create_date
						.append(" 		'" + jjjArray.get("order_no") + "'AS create_user_id \n") //create_user_id
						.append(" 		'" + jjjArray.get("member_key") + "'AS member_key \n") //member_key
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.order_no=mQ.order_no\n")
						.append("	AND mm.lotno=mQ.lotno\n")
						.append("	AND mm.order_check_no=mQ.order_check_no\n")
						.append("	AND mm.proc_cd=mQ.proc_cd\n")
						.append("	AND mm.proc_rev=mQ.proc_rev\n")
						.append("	AND mm.checklist_cd=mQ.checklist_cd\n")
						.append("	AND mm.checklist_seq=mQ.checklist_seq\n")
						.append("	AND mm.checklist_rev=mQ.checklist_rev\n")
						.append("	AND mm.member_key=mQ.member_key\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.lotno=mQ.lotno,\n")
						.append("		mm.order_no=mQ.order_no,\n")
						.append("		mm.order_check_no=mQ.order_check_no,\n")
						.append("		mm.qar=mQ.qar,\n")
						.append("		mm.spec_approval=mQ.spec_approval,\n")
						.append("		mm.std_dwg=mQ.std_dwg,\n")
						.append("		mm.program_rev=mQ.program_rev,\n")
						.append("		mm.job_guide=mQ.job_guide,\n")
						.append("		mm.proc_cd=mQ.proc_cd,\n")
						.append("		mm.proc_rev=mQ.proc_rev,\n")
						.append("		mm.checklist_cd=mQ.checklist_cd,\n")
						.append("		mm.checklist_seq=mQ.checklist_seq,\n")
						.append("		mm.checklist_rev=mQ.checklist_rev,\n")
						.append("		mm.standard_guide=mQ.standard_guide,\n")
						.append("		mm.standard_value=mQ.standard_value,\n")
						.append("		mm.tools=mQ.tools,\n")
						.append("		mm.check_note=mQ.check_note,\n")
						.append("		mm.start_date=mQ.start_date,\n")
						.append("		mm.create_date=mQ.create_date,\n")
						.append("		mm.create_user_id=mQ.create_user_id,\n")
						.append("		mm.member_key=mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.lotno,\n")
						.append("		mm.order_no,\n")
						.append("		mm.order_check_no,\n")
						.append("		mm.qar,\n")
						.append("		mm.spec_approval,\n")
						.append("		mm.std_dwg,\n")
						.append("		mm.program_rev,\n")
						.append("		mm.job_guide,\n")
						.append("		mm.proc_cd,\n")
						.append("		mm.proc_rev,\n")
						.append("		mm.checklist_cd,\n")
						.append("		mm.checklist_seq,\n")
						.append("		mm.checklist_rev,\n")
						.append("		mm.standard_guide,\n")
						.append("		mm.standard_value,\n")
						.append("		mm.tools,\n")
						.append("		mm.check_note,\n")
						.append("		mm.start_date,\n")
						.append("		mm.create_date,\n")
						.append("		mm.create_user_id,\n")
						.append("		mm.member_key\n")
						.append("	) VALUES (\n")
						.append("		mQ.lotno,\n")
						.append("		mQ.order_no,\n")
						.append("		mQ.order_check_no,\n")
						.append("		mQ.qar,\n")
						.append("		mQ.spec_approval,\n")
						.append("		mQ.std_dwg,\n")
						.append("		mQ.program_rev,\n")
						.append("		mQ.job_guide,\n")
						.append("		mQ.proc_cd,\n")
						.append("		mQ.proc_rev,\n")
						.append("		mQ.checklist_cd,\n")
						.append("		mQ.checklist_seq,\n")
						.append("		mQ.checklist_rev,\n")
						.append("		mQ.standard_guide,\n")
						.append("		mQ.standard_value,\n")
						.append("		mQ.tools,\n")
						.append("		mQ.check_note,\n")
						.append("		mQ.start_date,\n")
						.append("		mQ.create_date,\n")
						.append("		mQ.create_user_id,\n")
						.append("		mQ.member_key\n")
						.append("	)\n")
	    				.toString();

		    		System.out.println(jjjArray.size()+ "sql.toString()============"+i);
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
		    	}
				
				con.commit();
				
			} catch(Exception e) {
				LoggingWriter.setLogError("M101S030100E121()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M101S030100E121()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
	}	


	public int E131(InoutParameter ioParam){ 
			resultInt = EventDefine.E_DOEXCUTE_INIT;

			String sql ="";

			ApprovalActionNo ActionNo;
			String order_check_no="";
			
			try {
				con = JDBCConnectionPool.getConnection();
				JSONObject jArray = new JSONObject();
	    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
	    		JSONArray jjArray = (JSONArray) jArray.get("param");
	    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0);
				
				con.setAutoCommit(false);
				
	    		String jspPage = (String)jjjArray0.get("jsp_page");
	    		String user_id = (String)jjjArray0.get("login_id");
	    		String prefix = (String)jjjArray0.get("num_gubun");
	    		String actionGubun = "Regist";
	    		String detail_seq 	= "";
	    		String member_key = (String)jjjArray0.get("member_key");
	    		
	    		String vorder_check_no = (String)jjjArray0.get("order_check_no");
	    		
	    		if(vorder_check_no.length() < 1) {
					ActionNo = new ApprovalActionNo();
					order_check_no = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key); //order_check_no
	    		}
	    		else {
	    			order_check_no = vorder_check_no;
	    		}
		    	for(int i=0; i<jjArray.size(); i++) {
		    		JSONObject jjjArray = (JSONObject)jjArray.get(i);
		    		
//		    		String vorder_check_seq= (String)jjjArray.get("order_check_seq");
		    		sql = new StringBuilder()
//	    				.append("INSERT INTO\n")
//	    				.append("	tbi_order_product_inspect_checklist (\n")
//	    				.append("		order_no,\n")
//	    				.append("		order_detail_seq,\n")
//	    				.append("		order_check_no,\n")
//	    				.append("		order_check_seq,\n")
//	    				.append("		prod_cd,\n")
//	    				.append("		prod_rev,\n")
//	    				.append("		checklist_cd,\n")
//	    				.append("		checklist_seq,\n")
//	    				.append("		checklist_rev,\n")
//	    				.append("		standard_guide,\n")
//	    				.append("		standard_value,\n")
//	    				.append("		check_note,\n")
//	    				.append("		inspect_gubun,\n")
//	    				.append("		start_date,\n")
//	    				.append("		create_user_id\n")
//	    				.append("	)\n")
//	    				.append("VALUES ( \n")
//						.append(" 		'" + c_paramArray_Detail[i][3] + "'		\n") //order_no
//						.append(" 		,'" + c_paramArray_Detail[i][4] + "'	\n") //order_detail_seq
//						.append(" 		,'"  + order_check_no 			+ "' 	\n") //order_check_no
//						.append(" 		,'"  + i 			+ "' 	\n") //order_check_no
//						.append(" 		,'" + c_paramArray_Detail[i][5] + "'	\n") //prod_cd
//						.append(" 		,'" + c_paramArray_Detail[i][6] + "' 	\n") //prod_rev			
//						.append(" 		,'" + c_paramArray_Detail[i][7] + "'	\n") //checklist_cd
//						.append(" 		,'" + c_paramArray_Detail[i][8] + "'	\n") //checklist_seq	
//						.append(" 		,'" + c_paramArray_Detail[i][9] + "'	\n") //checklist_rev
//						.append(" 		,'" + c_paramArray_Detail[i][10] + "'	\n") //standard_guide	
//						.append(" 		,'" + c_paramArray_Detail[i][11] + "'	\n") //standard_value 
//						.append(" 		,'" + c_paramArray_Detail[i][12] + "'	\n") //check_note
//						.append(" 		,'" + c_paramArray_Detail[i][13] + "' 	\n") //inspect_gubun
//						.append(" 		, to_char(sysdate,'YYYY-MM-DD') 		\n") //start_date
//						.append(" 		,'" + c_paramArray_Detail[i][1] + "' 	\n") //create_user_id
//	    				.append("	);\n")
	    				.append("MERGE INTO tbi_order_product_inspect_checklist mm\n")
    					.append("	USING ( \n")
    					.append("SELECT \n")
		    			.append("	'" + jjjArray.get("order_no")  + "'AS order_no, \n")
						.append("	'" + jjjArray.get("lotno")  + "'AS lotno, \n")
						.append("	'" + order_check_no 			+ "'AS order_check_no, \n")
		                .append("	'" + i + "'AS order_check_seq, \n")
						.append("	'" + jjjArray.get("prod_cd") + "'AS prod_cd, \n")
						.append("	'" + jjjArray.get("prod_rev") + "'AS prod_rev, \n")
						.append("	'" + jjjArray.get("checklist_cd") + "'AS checklist_cd, \n")
						.append("	'" + jjjArray.get("checklist_seq") + "'AS checklist_seq, \n")
						.append("	'" + jjjArray.get("checklist_rev") + "'AS checklist_rev, \n")
						.append("	'" + jjjArray.get("standard_guide") + "'AS standard_guide, \n")
						.append("	'" + jjjArray.get("standard_value") + "'AS standard_value, \n")
						.append("	'" + jjjArray.get("check_note") + "'AS check_note, \n")
						.append("	'" + jjjArray.get("inspect_gubun") + "'AS inspect_gubun, \n")
						.append(" 	'" + jjjArray.get("member_key") + "'AS member_key,	\n") 
						.append("	TO_CHAR(SYSDATE,'YYYY-MM-DD') AS start_date, \n")
						.append("	'" + jjjArray.get("login_id") + "'AS create_user_id\n")
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.order_no=mQ.order_no\n")
						.append("	AND mm.lotno=mQ.lotno\n")
						.append("	AND mm.order_check_no=mQ.order_check_no\n")
						.append("	AND mm.order_check_seq=mQ.order_check_seq\n")
						.append("	AND mm.member_key=mQ.member_key\n")
//						.append("	AND mm.prod_cd=mQ.prod_cd\n")
//						.append("	AND mm.prod_rev=mQ.prod_rev\n")
//						.append("	AND mm.checklist_cd=mQ.checklist_cd\n")
//						.append("	AND mm.checklist_seq=mQ.checklist_seq\n")
//						.append("	AND mm.checklist_rev=mQ.checklist_rev\n")
//						.append("   AND mm.inspect_gubun=mQ.inspect_gubun\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.order_no=mQ.order_no,\n")
						.append("		mm.lotno=mQ.lotno,\n")
						.append("		mm.order_check_no=mQ.order_check_no,\n")
						.append("		mm.order_check_seq=mQ.order_check_seq,\n")
						.append("		mm.prod_cd=mQ.prod_cd,\n")
						.append("		mm.prod_rev=mQ.prod_rev,\n")
						.append("		mm.checklist_cd=mQ.checklist_cd,\n")
						.append("		mm.checklist_seq=mQ.checklist_seq,\n")
						.append("		mm.checklist_rev=mQ.checklist_rev,\n")
						.append("		mm.standard_guide=mQ.standard_guide,\n")
						.append("		mm.standard_value=mQ.standard_value,\n")
						.append("		mm.check_note=mQ.check_note,\n")
						.append("		mm.inspect_gubun=mQ.inspect_gubun,\n")
						.append("		mm.start_date=mQ.start_date,\n")
						.append("		mm.create_user_id=mQ.create_user_id,\n")
						.append("		mm.member_key=mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.order_no,\n")
						.append("		mm.lotno,\n")
						.append("		mm.order_check_no,\n")
						.append("		mm.order_check_seq,\n")
						.append("		mm.prod_cd,\n")
						.append("		mm.prod_rev,\n")
						.append("		mm.checklist_cd,\n")
						.append("		mm.checklist_seq,\n")
						.append("		mm.checklist_rev,\n")
						.append("		mm.standard_guide,\n")
						.append("		mm.standard_value,\n")
						.append("		mm.check_note,\n")
						.append("		mm.inspect_gubun,\n")
						.append("		mm.start_date,\n")
						.append("		mm.create_user_id,\n")
						.append("		mm.member_key\n")
						.append("	) VALUES (\n")
						.append("		mQ.order_no,\n")
						.append("		mQ.lotno,\n")
						.append("		mQ.order_check_no,\n")
						.append("		mQ.order_check_seq,\n")
						.append("		mQ.prod_cd,\n")
						.append("		mQ.prod_rev,\n")
						.append("		mQ.checklist_cd,\n")
						.append("		mQ.checklist_seq,\n")
						.append("		mQ.checklist_rev,\n")
						.append("		mQ.standard_guide,\n")
						.append("		mQ.standard_value,\n")
						.append("		mQ.check_note,\n")
						.append("		mQ.inspect_gubun,\n")
						.append("		mQ.start_date,\n")
						.append("		mQ.create_user_id,\n")
						.append("		mQ.member_key\n")
						.append("	)\n")
	    				.toString();

		    		// System.out.println(sql.toString());
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
		    	}
				
				con.commit();
				
			} catch(Exception e) {
				LoggingWriter.setLogError("M101S030100E131()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M101S030100E131()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
	}	

	//S101S030100.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
        			.append("	C.cust_nm,         	   	--고객사\n")
        			.append("	B.product_nm,          	--제품명\n")
        			.append("	cust_pono,             	--PO번호\n")
        			.append("	product_gubun,      	--제품구분\n")
        			.append("	part_source,      		--원부자재공급\n")
					.append("	order_date,      		--주문일\n")
					.append("	A.lotno,           		--lot번호\n")
					.append("	lot_count,    			--lot수량\n")
					.append("	part_chulgo_date,		--회로자재출고일\n")
					.append("	rohs,      				--rohs\n")
        			.append("	order_note,         	--특이사항\n")
        			.append("	delivery_date,         	--납기일\n")
        			.append("	bom_version,			--BOM버전\n")
        			.append("	A.order_no,         	--주문번호\n")
        			.append("	S.process_name,        	--현상태명\n")
        			.append("	A.bigo,                	--비고\n")
        			.append("	product_serial_no,     	--일련번호\n")
        			.append("	product_serial_no_end, 	--일련번호끝\n")
        			.append(" 	A.cust_cd,				--고객사코드\n")
        			.append("	A.cust_rev,\n")
        			.append("	A.prod_cd,				--제품코드\n")
        			.append("	A.prod_rev,\n")
        			.append("	Q.order_status,\n")
					.append("	project_name,\n")
        			.append("	DECODE(product_gubun,'0','양산품','1','개발품') AS product_gubun,	--제품구분\n")
        			.append("	DECODE(part_source,'01','사급','02','도급','03','사급&도급') AS part_source,   		--원부자재공급\n")
					.append("	DECODE(rohs,'0','Pb Free','1','Pb') AS rohs					--rohs\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("        ON A.cust_cd = C.cust_cd\n")
					.append("        and A.cust_rev = C.revision_no\n")
					.append("        and A.member_key = C.member_key\n")
					.append("INNER JOIN tbi_queue Q\n")
					.append("        ON A.order_no = Q.order_no\n")
					.append("        AND A.lotno = Q.lotno\n")
					.append("        AND A.member_key = Q.member_key\n")
					.append("INNER JOIN tbm_systemcode S\n")
					.append("        ON Q.order_status = S.status_code\n")
					.append("        AND Q.process_gubun = S.process_gubun\n")
					.append("        AND Q.member_key = S.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("        ON A.prod_cd = B.prod_cd\n")
					.append("        and  A.prod_rev = B.revision_no\n")
					.append("        and  A.member_key = B.member_key\n")
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
					.append("AND S.class_id = '" 		+ jArray.get("jsppage") + "' 	\n")
					.append("AND A.member_key = '" 		+ jArray.get("member_key") + "' \n")
					.append("AND order_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
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
			LoggingWriter.setLogError("M101S030100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E104()","==== finally ===="+ e.getMessage());
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

	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("DISTINCT \n")
					.append("	order_no,\n")
					.append("	A.prod_cd,\n")
					.append("	B.product_nm,\n")
					.append("	order_detail_seq,\n")
					.append("	product_serial_no,\n")
					.append("	order_count,\n")
					.append("	lotno,\n")
					.append("	lot_count,\n")
					.append("	A.bigo\n")
					.append("FROM\n")
					.append("	tbi_order A \n")
					.append("INNER JOIN tbm_product B \n")
					.append("ON A.prod_cd = B.prod_cd\n")
					.append("and A.prod_rev = B.revision_no\n")
					.append("and A.member_key = B.member_key\n")
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "'\n")
//					.append("	AND A.order_detail_seq = '" + c_paramArray[0][1] + "'\n")
					.append("	AND A.lotno = '" + jArray.get("lotno") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M101S030100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E114()","==== finally ===="+ e.getMessage());
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
	
	public int E122(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		Queue = new QueueProcessing();
		try {
			con = JDBCConnectionPool.getConnection();

//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);


			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			con.setAutoCommit(false);
//			
//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
				
    		String review_action_no="",confirm_action_no="";//없으면 없는대로 전달
			String jspPage 			= jArray.get("jspPage").toString();
			String order_detail_seq = jArray.get("order_detail_seq").toString();
			String gOrderNo 		= jArray.get("order_no").toString();
			String main_action_no 	= jArray.get("main_action_no").toString();
			String indGb			= jArray.get("indGb").toString();
			String lotno			= jArray.get("lotno").toString();
			String member_key		= jArray.get("member_key").toString();
			if(Queue.setQueue(con, jspPage, gOrderNo, order_detail_seq, main_action_no, review_action_no, confirm_action_no,indGb,lotno,member_key)<0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}	
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S030100E122()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E122()","==== finally ===="+ e.getMessage());
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

	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	order_no,			\n")
					.append("	A.document_no,		\n")
					.append("	C.document_name,	\n")
					.append("	A.file_real_name,	\n")
					.append("	A.file_view_name AS file_view_name \n")
					.append("	A.regist_no,		\n")
					.append("	B.revision_no,		\n")
					.append("	B.total_page		\n")
					.append("FROM tbi_order_doclist A \n")
					.append("INNER JOIN tbi_doc_regist_info B 	\n")
					.append("	ON A.regist_no = B.regist_no		\n")
					.append("	AND A.document_no = B.document_no	\n")
					.append("	AND A.member_key = B.member_key	\n")
					.append("INNER JOIN vtbm_doc_base C 			\n")
					.append("	ON A.document_no = C.document_no	\n")
					.append("	AND A.member_key = C.member_key	\n")
					.append("WHERE order_no = '" 	+ jArray.get("order_no") + "'\n")
					.append("AND A.member_key = '" 	+ jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M101S030100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E124()","==== finally ===="+ e.getMessage());
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
	
	//S101S030130.jsp,S101S030135.jsp: 주문별 제품검사 체크리스트
	public int E134(InoutParameter ioParam){
	resultInt = EventDefine.E_DOEXCUTE_INIT;

	try {
		con = JDBCConnectionPool.getConnection();
		
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
		String sql = new StringBuilder()
				.append("SELECT DISTINCT\n")
				.append("	O.inspect_gubun,\n")
				.append("	v.code_name,\n")
				.append("	[tbi_order].order_no,\n")
				.append("	O.order_check_no,\n")
				.append("	[tbi_order].project_name,\n")
//				.append("	[tbi_order].product_serial_no,\n")
				.append("	'',\n")
				.append("	[tbi_order].lotno,\n")
				.append("	[tbi_order].lot_count,\n")
				.append("	o.prod_cd,\n")
				.append("	P.product_nm,\n")
				.append("	A.checklist_cd,\n")
				.append("	O.standard_guide,\n")
				.append("	O.check_note,\n")
				.append("	O.standard_value,\n")
				.append("	B.item_type,\n")
				.append("	B.item_bigo,\n")
				.append("	o.prod_rev,\n")
				.append("	A.checklist_seq,\n")
				.append("	o.checklist_rev,\n")
				.append("	A.item_cd,\n")
				.append("	B.item_desc,\n")
				.append("	A.item_seq,\n")
				.append("	A.item_cd_rev\n")
				.append("FROM tbi_order\n")
				.append("	INNER JOIN tbi_order_product_inspect_checklist O\n")
				.append("	ON [tbi_order].order_no = O.order_no\n")
				.append("	AND [tbi_order].lotno = O.lotno\n")
				.append("	AND [tbi_order].member_key = O.member_key\n")
				.append("	INNER JOIN tbm_checklist A\n")
				.append("	ON o.checklist_cd = A.checklist_cd\n")
				.append("	AND o.checklist_seq = A.checklist_seq\n")
				.append("	AND o.checklist_rev = A.revision_no\n")
				.append("	AND o.member_key = A.member_key\n")
				.append("	INNER JOIN tbm_check_item B\n")
				.append("	ON A.item_cd = B.item_cd\n")
				.append("	AND A.item_seq = B.item_seq\n")
				.append("	AND A.item_cd_rev = B.revision_no\n")
				.append("	AND A.member_key = B.member_key\n")
				.append("	INNER JOIN tbm_product P\n")
				.append("	ON o.prod_cd = P.prod_cd\n")
				.append("	AND o.prod_rev = P.revision_no\n")
				.append("	AND o.member_key = P.member_key\n")
				.append("	INNER JOIN v_checklist_gubun v\n")
				.append("	ON O.inspect_gubun = v.code_value\n")
				.append("	AND O.member_key = v.member_key\n")
				.append("WHERE [tbi_order].order_no= '" + jArray.get("order_no") + "' \n")
				.append("AND [tbi_order].lotno = '" 	+ jArray.get("lotno") + "' \n")
				.append("AND A.member_key = '" 			+ jArray.get("member_key") + "'\n")
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
		LoggingWriter.setLogError("M101S030100E134()","==== SQL ERROR ===="+ e.getMessage());
		return EventDefine.E_DOEXCUTE_ERROR ;
	} finally {
		if (Config.useDataSource) {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M101S030100E134()","==== finally ===="+ e.getMessage());
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


	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	sys_bom_id,\n") 
					.append("	bom_cd,\n") 
					.append("	bom_cd_rev,\n") 
					.append("	A.part_cd,\n")
					.append("	bom_name,\n")
					.append("	B.part_nm ,\n")
					.append("	A.part_cd_rev,\n")
					.append("	part_cnt,\n")
					.append("	mesu,\n")
					.append("	gubun,\n")
					.append("	qar,\n")
					.append("	inspect_selbi,\n")
					.append("	packing_jaryo,\n")
					.append("	modify_note,\n")
					.append("	cust_code,\n")
					.append("	C.cust_nm,\n")
					.append("	cust_rev,\n")
					.append("	A.bigo,\n")
					.append("	last_no, \n")
					.append("	type_no,\n")
					.append("	geukyongpoommok, \n")
					.append("	approval_date,\n")
					.append("	dept_code,\n")
					.append("	approval,\n")
					.append("	CAST( SUM(NVL(D.post_amt,0)) AS NUMERIC(15,3) )\n")
					.append("FROM tbi_order_bomlist A \n")
					.append("LEFT OUTER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("	AND A.part_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("LEFT OUTER  JOIN tbm_customer C \n")
					.append("	ON A.cust_code = C.cust_cd\n")
					.append("	AND A.cust_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("LEFT OUTER JOIN tbi_part_storage D\n")
					.append("	ON A.part_cd = D.part_cd\n")
					.append("	AND A.part_cd_rev = D.part_cd_rev\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("WHERE proc_plan_no = '" 	+  jArray.get("proc_plan_no") + "'\n")
					.append("	AND A.member_key = '" 	+  jArray.get("member_key") + "'\n")
					.append("GROUP BY A.part_cd\n")
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
			LoggingWriter.setLogError("M101S030100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E144()","==== finally ===="+ e.getMessage());
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
	//공정확인표 공정별 체크리스트 선택
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.proc_cd,\n")
					.append("	process_nm,\n")
					.append("	A.checklist_seq,\n")
					.append("	dept_gubun,\n")
					.append("	B.checklist_cd,\n")
					.append("	B.check_note,\n")
					.append("	B.standard_guide,\n")
					.append("	B.standard_value,\n")
					.append("	C.item_type,\n")
					.append("	C.item_desc,\n")
					.append("	C.item_bigo,\n")
					.append("	A.checklist_cd_rev,\n")
					.append("	A.proc_cd_rev,\n")
					.append("	A.revision_no	\n")
					.append("FROM vtbm_process_checklist A \n")
					.append("	INNER JOIN vtbm_checklist B \n")
					.append("	ON A.checklist_cd = B.checklist_cd\n")
					.append("	AND A.checklist_cd_rev = B.revision_no\n")
					.append("	AND A.checklist_seq = B.checklist_seq\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("	INNER JOIN vtbm_check_item C \n")
					.append("	ON B.item_cd = C.item_cd\n")
					.append("	AND B.item_seq = C.item_seq\n")
					.append("	AND B.item_cd_rev = C.revision_no\n")
					.append("	AND B.member_key = C.member_key\n")
					.append("	INNER JOIN vtbm_process D \n")
					.append("	ON A.proc_cd = D.proc_cd\n")
					.append("	AND A.proc_cd_rev= D.revision_no\n")
					.append("	AND A.member_key= D.member_key\n")
					.append("WHERE A.member_key = '"+ jArray.get("member_key")+"'\n")
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
			LoggingWriter.setLogError("M101S030100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E154()","==== finally ===="+ e.getMessage());
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
			
//공정확인표 내역 S101S030160.jsp: 주문별 제품검사 체크리스트
	public int E164(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT \n")
					.append("	O.order_no,\n")
					.append("	O.order_check_no,\n")
					.append("	[tbi_order].project_name,\n")
					.append("	'',\n")	// .append("        [tbi_order].product_serial_no,\n")
					.append("	[tbi_order].prod_cd,\n")
					.append("	P.product_nm,\n")
					.append("	[tbi_order].lotno,\n")
					.append("	[tbi_order].lot_count,\n")
					.append("	O.qar,\n")
					.append("	O.spec_approval,\n")
					.append("	O.std_dwg,\n")
					.append("	O.job_guide,\n")
					.append("	O.program_rev,\n")
					.append("	O.proc_cd,\n")
					.append("	B.process_nm,\n")
					.append("	B.dept_gubun,\n")
					.append("	O.standard_guide,\n")
					.append("	O.standard_value,\n")
					.append("	O.tools,\n")
					.append("	O.check_note,\n")
					.append("	C.item_type,\n")
					.append("	C.item_bigo,        \n")
					.append("	O.checklist_cd,       \n")
					.append("	O.checklist_seq\n")
					.append("FROM tbi_order\n")
					.append("	INNER JOIN tbi_order_process_checklist O\n")
					.append("	ON [tbi_order].order_no = O.order_no\n")
					.append("	AND [tbi_order].lotno = O.lotno\n")
					.append("	AND [tbi_order].member_key = O.member_key\n")
					.append("	INNER JOIN tbm_process_checklist K\n")
					.append("	ON O.proc_cd = K.proc_cd\n")
					.append("	AND O.proc_rev = K.proc_cd_rev \n")
					.append("	AND O.checklist_cd = K.checklist_cd\n")
					.append("	AND O.checklist_seq = K.checklist_seq\n")
					.append("	AND O.checklist_rev = K.checklist_cd_rev\n")
					.append("	AND O.member_key = K.member_key\n")
					.append("	INNER JOIN tbm_checklist A\n")
					.append("	ON K.checklist_cd = A.checklist_cd\n")
					.append("	AND K.checklist_seq = A.checklist_seq\n")
					.append("	AND K.checklist_cd_rev = A.revision_no\n")
					.append("	AND K.member_key = A.member_key\n")
					.append("	INNER JOIN tbm_check_item C \n")
					.append("	ON A.item_cd = C.item_cd\n")
					.append("	AND A.item_seq = C.item_seq\n")
					.append("	AND A.item_cd_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("	INNER JOIN tbm_process B\n")
					.append("	ON O.proc_cd = B.proc_cd\n")
					.append("	AND O.proc_rev = B.revision_no\n")
					.append("	AND O.member_key = B.member_key\n")
					.append("	INNER JOIN tbm_product P\n")
					.append("	ON [tbi_order].prod_cd = P.prod_cd\n")
					.append("	AND [tbi_order].prod_rev = P.revision_no\n")
					.append("	AND [tbi_order].member_key = P.member_key\n")
					.append("WHERE [tbi_order].order_no= '" + jArray.get("order_no") + "'	\n")
					.append("	AND [tbi_order].lotno = '" 	+ jArray.get("lot_no") + "' \n")
					.append("	AND A.member_key = '" 		+ jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M101S030100E164()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E164()","==== finally ===="+ e.getMessage());
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
		

	public int E174(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT	\n")
					.append("	A.checklist_seq, \n")
					.append("	A.proc_cd,	\n")
					.append("	process_nm,	\n")
					.append("	dept_gubun,	\n")
					.append("	A.proc_rev,	\n")
					.append("	A.checklist_cd,	\n")
					.append("	A.checklist_rev, \n")
					.append("	A.standard_guide, \n")
					.append("	A.tools, \n")
					.append("	A.check_note, \n")
					.append("	A.standard_value \n")
					.append("FROM tbi_order_process_checklist A	\n")
					.append("INNER JOIN tbm_process D	 		\n")
					.append("	ON A.proc_cd = D.proc_cd		\n")
					.append("	AND A.proc_rev= D.revision_no	\n")
					.append("	AND A.member_key= D.member_key	\n")
					.append("WHERE A.order_no = '" 	+ jArray.get("order_no") + "'	\n")
					.append(" AND  A.lotno = '"		+ jArray.get("lotno") + "' 	\n")
					.append("AND A.member_key = '" 	+ jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M101S030100E174()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E174()","==== finally ===="+ e.getMessage());
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

	public int E184(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
						
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()					
				.append("WITH BOM_LIST AS(\n")
				.append("SELECT\n")
				.append("        A.bom_cd,\n")
				.append("        A.bom_name,\n")
				.append("        last_no,\n")
				.append("        type_no,\n")
				.append("        geukyongpoommok,\n")
				.append("        dept_code,\n")
				.append("        approval_date,\n")
				.append("        approval,\n")
				.append("        A.sys_bom_id,\n")
				.append("        A.part_cd,\n")
				.append("        A.part_cnt,\n")
				.append("        A.mesu,\n")
				.append("        A.gubun,\n")
				.append("        A.qar,\n")
				.append("        A.inspect_selbi,\n")
				.append("        A.packing_jaryo,\n")
				.append("        A.modify_note,\n")
				.append("        D.cust_nm,\n")
				.append("        A.bigo,\n")
				.append("        cust_code,\n")
				.append("        A.cust_rev,\n")
				.append("        A.part_cd_rev,\n")
				.append("        A.bom_cd_rev,\n")
				.append("        B.part_nm || '('||E.code_name  ||','||  F.code_name ||')' AS part_nm,\n")
				.append("		 CAST( SUM(NVL(S.post_amt,0)) AS NUMERIC(15,3) ) AS jaego\n")
				.append("FROM tbi_order_bomlist A\n")
				.append("LEFT OUTER JOIN tbm_customer D\n")
				.append("        ON A.cust_code = D.cust_cd\n")
				.append("        AND A.member_key = D.member_key\n")
				.append("LEFT OUTER JOIN tbm_part_list B\n")
				.append("        ON A.part_cd = B.part_cd\n")
				.append("        AND A.part_cd_rev = B.revision_no\n")
				.append("        AND A.member_key = B.member_key\n")
				.append("INNER JOIN v_partgubun_big E\n")
				.append("        ON B.part_gubun_b = E.code_value\n")
				.append("       AND B.member_key = E.member_key\n")
				.append("INNER JOIN v_partgubun_mid F\n")
				.append("        ON B.part_gubun_m = F.code_value\n")
				.append("       AND B.member_key = F.member_key        \n")
				.append("LEFT OUTER JOIN tbi_part_storage S\n")
				.append("		ON A.part_Cd = S.part_cd\n")
				.append("		AND A.part_cd_rev = S.part_cd_rev\n")
				.append("		AND A.member_key = S.member_key\n")
				.append("WHERE proc_plan_no = '" + jArray.get("proc_plan_no") + "'\n")
				.append("        AND  A.member_key = '" + jArray.get("member_key") + "'\n")
				.append("	GROUP BY A.part_cd\n")
				.append("	ORDER BY B.part_cd\n")
				.append(")\n")
				.append("SELECT DISTINCT\n")
				.append("        bom_cd,\n")
				.append("        bom_name,\n")
				.append("        last_no,\n")
				.append("        type_no,\n")
				.append("        geukyongpoommok,\n")
				.append("        dept_code,\n")
				.append("        approval_date,\n")
				.append("        approval,\n")
				.append("        sys_bom_id,\n")
				.append("        part_cd,\n")
				.append("        part_nm,\n")
				.append("        part_cnt,\n")
				.append("        mesu,\n")
				.append("        gubun,\n")
				.append("        qar,\n")
				.append("        inspect_selbi,\n")
				.append("        packing_jaryo,\n")
				.append("        modify_note,\n")
				.append("        cust_nm,\n")
				.append("        bigo,\n")
				.append("        cust_code,\n")
				.append("        cust_rev,\n")
				.append("        part_cd_rev,\n")
				.append("        bom_cd_rev,\n")
				.append("        jaego\n")
				.append("FROM BOM_LIST\n")
//				.append("START WITH sys_bom_parentid =0\n") // 이거실행하면 안나오는 레코드 있음
//				.append("CONNECT BY PRIOR sys_bom_id = sys_bom_parentid\n") // 이거실행하면 안나오는 레코드 있음
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
			LoggingWriter.setLogError("M101S030100E184()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E184()","==== finally ===="+ e.getMessage());
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
		
	
//주문제품별 검사체크리스트
	public int E194(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        order_no,\n")
					.append("        lotno,\n")
					.append("        inspect_gubun,\n")
					.append("        C.code_name,\n")
					.append("        order_check_no,\n")
					.append("        A.revision_no,\n")
					.append("        A.prod_cd,\n")
					.append("        B.product_nm  || '('||D.code_name  ||','||  E.code_name ||')',\n")
					.append("        A.prod_rev,\n")
					.append("        checklist_cd,\n")
					.append("        checklist_seq,\n")
					.append("        checklist_rev,\n")
					.append("        standard_guide,\n")
					.append("        standard_value,\n")
					.append("        check_note,\n")
					.append("        order_check_seq\n")
					.append("FROM tbi_order_product_inspect_checklist A\n")
					.append("INNER JOIN tbm_product B\n")
					.append("        ON A.prod_cd = B.prod_cd\n")
					.append("        AND A.prod_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_checklist_gubun C\n")
					.append("        on A.inspect_gubun = C.code_value\n")
					.append("        and A.member_key = C.member_key\n")
					.append("INNER JOIN v_prodgubun_big D\n")
					.append("        ON B.prod_gubun_b = D.code_value\n")
					.append("  AND B.member_key = D.member_key\n")
					.append("INNER JOIN v_prodgubun_mid E\n")
					.append("   ON B.prod_gubun_m = E.code_value\n")
					.append("  AND B.member_key = E.member_key        \n")
					.append("WHERE order_no = '" 		+ jArray.get("order_no") + "'	\n")
					.append("AND inspect_gubun like '" 	+ "%'	\n")
					.append("AND lotno = '" 	+ jArray.get("lotno") + "'	\n")
					.append("AND A.member_key = '"	+ jArray.get("member_key") + "' 	\n")
					.append("ORDER BY  order_no\n")
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
			LoggingWriter.setLogError("M101S030100E194()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E194()","==== finally ===="+ e.getMessage());
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
	
	
//제품별 체크리스트
public int E195(InoutParameter ioParam){
	resultInt = EventDefine.E_DOEXCUTE_INIT;
	
	try {
		con = JDBCConnectionPool.getConnection();
		
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
		String sql = new StringBuilder()
				.append("SELECT distinct\n")
				.append("        1,\n")
				.append("        K.prod_cd,\n")
				.append("        P.product_nm || '('||D.code_name  ||','||  E.code_name ||')',\n")
				.append("        A.checklist_cd,\n")
				.append("        standard_guide,\n")
				.append("        check_note,\n")
				.append("        standard_value,\n")
				.append("        B.item_type,\n")
				.append("        B.item_bigo,\n")
				.append("--      '<input type='''  ||  item_type || ''' id=''' || item_type || '1'''  || ' /input>' AS html_tag,\n")
				.append("        K.prod_cd_rev,\n")
				.append("        A.checklist_seq,\n")
				.append("        K.checklist_cd_rev,\n")
				.append("        A.item_cd,\n")
				.append("        B.item_desc,\n")
				.append("        A.item_seq,\n")
				.append("        A.item_cd_rev,\n")
				.append("        K.hangmok_code,\n")
				.append("        inspect_gubun,\n")
				.append("        C.code_name\n")
				.append("FROM vtbm_product_inspect_checklist K\n")
				.append("        INNER JOIN vtbm_checklist A\n")
				.append("			         ON K.checklist_cd = A.checklist_cd\n")
				.append("			       AND K.checklist_seq = A.checklist_seq\n")
				.append("			       AND K.checklist_cd_rev = A.revision_no\n")
				.append("			       AND K.member_key = A.member_key\n")
				.append("        INNER JOIN vtbm_check_item B\n")
				.append("			         ON A.item_cd = B.item_cd\n")
				.append("			       AND A.item_seq = B.item_seq\n")
				.append("		           AND A.item_cd_rev = B.revision_no\n")
				.append("		        AND A.member_key = B.member_key\n")
				.append("        INNER JOIN vtbm_product P\n")
				.append("			         ON K.prod_cd = P.prod_cd\n")
				.append("			        AND K.prod_cd_rev = P.revision_no\n")
				.append("			        AND K.member_key = P.member_key\n")
				.append("        INNER JOIN v_checklist_gubun C\n")
				.append("			         ON K.inspect_gubun = C.code_value\n")
				.append("			        AND K.member_key = C.member_key\n")
				.append("        INNER JOIN v_prodgubun_big D\n")
				.append("			         ON P.prod_gubun_b = D.code_value\n")
				.append("				   AND P.member_key = D.member_key\n")
				.append("		INNER JOIN v_prodgubun_mid E\n")
				.append("				    ON P.prod_gubun_m = E.code_value\n")
				.append("				  AND P.member_key = E.member_key\n")
				.append("WHERE K.prod_cd = '" + jArray.get("prod_cd") + "'	\n")
				.append("AND K.inspect_gubun LIKE '" + jArray.get("inspect_gubun") + "%' \n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
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
		LoggingWriter.setLogError("M101S030100E195()","==== SQL ERROR ===="+ e.getMessage());
		return EventDefine.E_DOEXCUTE_ERROR ;
    } finally {
    	if (Config.useDataSource) {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M101S030100E195()","==== finally ===="+ e.getMessage());
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
//주문관련 문서목록 S101S050100.jsp
public int E504(InoutParameter ioParam){
      resultInt = EventDefine.E_DOEXCUTE_INIT;
      
      try {
         con = JDBCConnectionPool.getConnection();
         
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
         
         String sql = new StringBuilder()
    			.append("SELECT\n")
    			.append("	reg_gubun,\n")
    			.append("	A.order_no,\n")
    			.append("	B.project_name,\n")
    			.append("	D.product_nm,\n")
    			.append("	regist_no,\n")
    			.append("	A.document_no,\n")
    			.append("	C.document_name,\n")
    			.append("	file_view_name,\n")
    			.append("	B.prod_cd,\n")
    			.append("	B.prod_rev,\n")
    			.append("   '',\n")	// .append("        A.order_detail_seq,\n")
    			.append("	regist_no_rev,\n")
    			.append("	A.document_no_rev,\n")
    			.append("	file_real_name\n")
    			.append("FROM tbi_order_doclist A \n")
    			.append("INNER JOIN tbi_order B \n")
    			.append("	ON A.order_no = B.order_no\n")
    			.append("	AND A.lotno = B.lotno\n")
    			.append("	AND A.member_key = B.member_key\n")
    			.append("INNER JOIN tbm_doc_base C \n")
    			.append("	ON A.document_no = C.document_no\n")
    			.append("	AND A.document_no_rev = C.revision_no\n")
    			.append("	AND A.member_key = C.member_key\n")
    			.append("INNER JOIN tbm_product D\n")
    			.append("	ON B.prod_cd = D.prod_cd\n")
    			.append("	AND B.prod_rev = D.revision_no\n")
    			.append("	AND B.member_key = D.member_key\n")
               .append("WHERE 1=1  \n")
               .append("AND order_date BETWEEN '" + jArray.get("fromdate") +"' AND '"+ jArray.get("todate") +"' \n")
               .append("AND A.member_key = '"	+ jArray.get("member_key") + "' \n")
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
         LoggingWriter.setLogError("M101S030100E504()","==== SQL ERROR ===="+ e.getMessage());
         return EventDefine.E_DOEXCUTE_ERROR ;
       } finally {
          if (Config.useDataSource) {
            try {
               if (con != null) con.close();
            } catch (Exception e) {
            	LoggingWriter.setLogError("M101S030100E504()","==== finally ===="+ e.getMessage());
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

	public int E804(InoutParameter ioParam){
	      resultInt = EventDefine.E_DOEXCUTE_INIT;
	      
	      try {
	         con = JDBCConnectionPool.getConnection();
	         
	         // 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

	         String sql = new StringBuilder()
	        		.append("SELECT DISTINCT\n")
    				.append("	C.cust_nm,				--고객사\n")
    				.append("	B.product_nm,			--제품명\n")
    				.append("	cust_pono,				--PO번호\n")
	        		.append("	product_gubun,			--제품구분\n")
	        		.append("	part_source,      		--원부자재공급\n")
					.append("	order_date,				--주문일\n")
					.append("	A.lotno,				--lot번호\n")
					.append("	lot_count,				--lot수량\n")
					.append("	part_chulgo_date,		--회로자재출고일\n")
					.append("	rohs,					--rohs\n")
	        		.append("	order_note,				--특이사항\n")
	        		.append("	delivery_date,			--납기일\n")
	        		.append("	bom_version,			--BOM버전\n")
	        		.append("	A.order_no,				--주문번호\n")
	        		.append("	S.process_name,			--현상태명\n")
	        		.append("	A.bigo,					--비고\n")
	        		.append("	product_serial_no,		--일련번호\n")
	        		.append("	product_serial_no_end, 	--일련번호끝\n")
	        		.append("	A.cust_cd,				--고객사코드\n")
	        		.append("	A.cust_rev,\n")
	        		.append("	A.prod_cd,				--제품코드\n")
	        		.append("	A.prod_rev,\n")
	        		.append("	Q.order_status,\n")
	        		.append("	DECODE(product_gubun,'0','양산품','1','개발품') AS product_gubun, --제품구분\n")
	        		.append("	DECODE(part_source,'01','사급','02','도급','03','사급&도급') AS part_source,	--원부자재공급\n")
					.append("	DECODE(rohs,'0','Pb Free','1','Pb') AS rohs	--rohs\n")
	        		.append("FROM tbi_order A\n")
	        		.append("INNER JOIN tbm_customer C\n")
	        		.append("	ON A.cust_cd = C.cust_cd\n")
	        		.append("	AND A.cust_rev = C.revision_no\n")
	        		.append("	AND A.member_key = C.member_key\n")
	        		.append("INNER JOIN tbi_queue Q\n")
	        		.append("	ON A.order_no = Q.order_no\n")
	        		.append("	AND A.lotno = Q.lotno\n")
	        		.append("	AND A.member_key = Q.member_key\n")
	        		.append("INNER JOIN tbm_systemcode S\n")
	        		.append("	ON Q.order_status = S.status_code\n")
	        		.append("	AND Q.process_gubun = S.process_gubun\n")
	        		.append("	AND Q.member_key = S.member_key\n")
	        		.append("INNER JOIN tbm_product B\n")
	        		.append("	ON A.prod_cd = B.prod_cd\n")
	        		.append("	AND A.prod_rev = B.revision_no\n")
	        		.append("	AND A.member_key = B.member_key\n")
	        		.append("WHERE A.cust_cd LIKE '%"+ jArray.get("cust_cd") +"' \n")
	        		.append("AND Q.process_gubun = 'ODPROCS' \n")
	        		.append("AND order_date BETWEEN '" + jArray.get("todate") +"'  AND '"+ jArray.get("fromdate") +"'   \n")
	        		.append("AND A.member_key = '" + jArray.get("member_key") +"' \n")
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
	         LoggingWriter.setLogError("M101S030100E804()","==== SQL ERROR ===="+ e.getMessage());
	         return EventDefine.E_DOEXCUTE_ERROR ;
	       } finally {
	          if (Config.useDataSource) {
	            try {
	               if (con != null) con.close();
	            } catch (Exception e) {
	            	LoggingWriter.setLogError("M101S030100E804()","==== finally ===="+ e.getMessage());
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
	
	public int E805(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			sql = new StringBuffer();
			String sql = new StringBuilder()
					.append("SELECT \n")
        			.append("		C.cust_nm,				--고객사\n")
        			.append("		B.product_nm,			--제품명\n")
        			.append("		cust_pono,				--PO번호\n")
        			.append("		product_gubun,			--제품구분\n")
        			.append("		part_source,			--원부자재공급\n")
					.append("		order_date,				--주문일\n")
					.append("		A.lotno,				--lot번호\n")
					.append("		lot_count,    			--lot수량\n")
					.append("		part_chulgo_date,		--회로자재출고일\n")
					.append("		rohs,					--rohs\n")
        			.append("		order_note,				--특이사항\n")
        			.append("		delivery_date,			--납기일\n")
        			.append("		bom_version,			--BOM버전\n")
        			.append("		A.order_no,				--주문번호\n")
        			.append("		S.process_name,			--현상태명\n")
        			.append("		A.bigo,					--비고\n")
        			.append("		product_serial_no,		--일련번호\n")
        			.append("		product_serial_no_end, 	--일련번호끝\n")
        			.append("		A.cust_cd,				--고객사코드\n")
        			.append("		A.cust_rev,\n")
        			.append("		A.prod_cd,				--제품코드\n")
        			.append("		A.prod_rev,\n")
        			.append("		Q.order_status,\n")
        			.append("		DECODE(product_gubun,'0','양산품','1','개발품') AS product_gubun,	--제품구분\n")
        			.append("		DECODE(part_source,'01','사급','02','도급','03','사급&도급') AS part_source,   		--원부자재공급\n")
					.append("		DECODE(rohs,'0','Pb Free','1','Pb') AS rohs					--rohs\n")
					.append("	FROM tbi_order A\n")
					.append("	INNER JOIN tbm_customer C\n")
					.append("		ON A.cust_cd = C.cust_cd\n")
					.append("		and A.cust_rev = C.revision_no\n")
					.append("		and A.member_key = C.member_key\n")
					.append("	INNER JOIN tbi_queue Q\n")
					.append("		ON A.order_no = Q.order_no\n")
					.append("		AND A.lotno = Q.lotno\n")
					.append("		AND A.member_key = Q.member_key\n")
					.append("	INNER JOIN tbm_systemcode S\n")
					.append("		ON Q.order_status = S.status_code\n")
					.append("		AND Q.process_gubun = S.process_gubun\n")
					.append("		AND Q.member_key = S.member_key\n")
					.append("	INNER JOIN tbm_product B\n")
					.append("		ON A.prod_cd = B.prod_cd\n")
					.append("		AND A.prod_rev = B.revision_no\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "'\n")
					.append("	AND A.lotno = '" + jArray.get("lotno") + "'\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M101S030100E805()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E805()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	//	주문제품별제조리드타임현황 
	public int E834(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        P.order_no,\n")
					.append("        P.lotno,\n")
					.append("        P.proc_exec_no,\n")
					.append("        P.proc_plan_no,\n")
					.append("        P.proc_info_no,\n")
					.append("        P.proc_odr,\n")
					.append("        P.proc_cd,\n")
					.append("        P.proc_cd_rev,\n")
					.append("		 PR.process_nm,\n")
					.append("        P.rout_dt,\n")
					.append("        P.start_dt,\n")
					.append("        P.finish_dt,\n")
					.append("        B.proc_qnt,\n")
					.append("        TO_CHAR(P.exec_qnt),\n")
					.append("        P.man_amt,\n")
					.append("        delay_yn,\n")
					.append("        P.delay_dt_num,\n")
					.append("        P.delay_reason_cd,\n")
					.append("        D.code_name,\n")
					.append("        P.exec_note,\n")
					.append("        P.worker_name,\n")
					.append("        P.prod_cd,\n")
					.append("        P.prod_cd_rev\n")
					
					.append("FROM\n")
					.append("	tbi_production_exec P\n")
					
					.append("INNER JOIN tbi_production_head A\n")
					.append("	ON P.order_no=A.order_no\n")
					.append("   AND P.lotno=A.lotno\n")
					.append("   AND P.member_key=A.member_key\n")
					.append("INNER JOIN tbi_production_plan B\n")
					.append("   ON A.proc_plan_no=B.proc_plan_no\n")
					.append("   AND P.proc_cd=B.proc_cd\n")
					.append("   AND P.member_key=B.member_key\n")
					.append("LEFT OUTER JOIN v_delay_reason D\n")
					.append("	ON P.delay_reason_cd=D.code_value\n")
					.append("   AND P.member_key=D.member_key\n")
					.append("INNER JOIN tbm_process PR\n")
					.append("	ON P.proc_cd=PR.proc_cd\n")
					.append("	AND P.proc_cd_rev=PR.revision_no\n")
					.append("   AND P.member_key=PR.member_key\n")
//					.append("LEFT OUTER JOIN tbi_production_work_result WR\n")
//					.append("	ON P.order_no=WR.order_no\n")
//					.append("	AND P.lotno=WR.lotno\n")
					
					.append("WHERE P.order_no ='"			+ jArray.get("order_no") + "'  \n")
					.append("	AND P.lotno = '"  		  	+ jArray.get("lotno") + "'  \n")
					.append("	AND P.prod_cd = '"  		+ jArray.get("prod_cd") + "'  \n")
					.append("	AND P.prod_cd_rev = '"  	+ jArray.get("prod_cd_rev") + "'  \n")
					.append("	AND P.proc_exec_no LIKE '"  + jArray.get("proc_exec_no") + "%' \n")
					.append("	AND P.member_key = '"  		+ jArray.get("member_key") + "'  \n")
//					.append("   AND B.proc_cd LIKE'" 		+ "" + "%' \n")
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
			LoggingWriter.setLogError("M101S030100E834()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E834()","==== finally ===="+ e.getMessage());
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
	
	
	
	//출하검사현황 
	public int E844(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	DISTINCT \n")
					.append("        hist_no,\n")
					.append("        A.order_no,\n")
					.append("        A.lotno,\n")
					.append("        product_serial_no,\n")
					.append("        product_serial_no_end,\n")
					.append("        inspect_no,\n")
					.append("        C.product_nm,\n")
					.append("        prod_cd_rev,\n")
					.append("        B.code_name AS inspect_gubun_name,\n")
					.append("        TO_CHAR(inspect_result_dt,'YYYY-MM-DD') AS inspect_result_date,\n")
					.append("        A.inspect_gubun,\n")
					.append("        A.prod_cd\n")
					.append("FROM tbi_order_product_inspect_result A\n")
					.append("        INNER JOIN v_checklist_gubun B\n")
					.append("        ON A.inspect_gubun = B.code_value\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("        LEFT OUTER  JOIN tbm_product C\n")
					.append("        ON A.prod_cd = C.prod_cd\n")
					.append("        AND A.prod_cd_rev = C.revision_no\n")
					.append("        AND A.member_key = C.member_key\n")
					.append("        LEFT OUTER JOIN haccp_hysteretic_system H \n")
					.append("        ON  A.order_no = H.order_no\n")
					.append("        AND A.lotno = H.lotno\n")
					.append("        AND A.member_key = H.member_key\n")
					.append("WHERE 1=1 \n")  
					.append("   AND A.order_no = '" 		+  jArray.get("order_no") + "'\n")
					.append("	AND A.lotno = '" 			+  jArray.get("lotno") + "'\n")
					.append("	AND A.inspect_gubun = '" 	+  jArray.get("inspect_gubun") + "'\n")
					.append("   AND A.member_key = '" 		+ jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S030100E844()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E844()","==== finally ===="+ e.getMessage());
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
	
	//출하검사 상세목록현황
	public int E845(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	order_no, \n")
					.append("	lotno, \n")
					.append("	product_serial_no, \n")
					.append("	product_serial_no_end, \n")
					.append("	inspect_no, \n")
					.append("	B.code_name AS inspect_gubun, \n")
					.append("	proc_info_no, \n")
					.append("	inspect_seq, \n")
					.append("	proc_cd, \n")
					.append("	proc_cd_rev, \n")
					.append("	C.product_nm AS prod_cd, \n")
					.append("	prod_cd_rev, \n")
					.append("	user_id, \n")
					.append("	checklist_cd, \n")
					.append("	checklist_cd_rev, \n")
					.append("	item_cd, \n")
					.append("	item_cd_rev, \n")
					.append("	standard_value, \n")
					.append("	result_value, \n")
					.append("	inspect_result_dt, \n")
					.append("	review_no, \n")
					.append("	confirm_no, \n")
					.append("	order_detail_seq, \n")
					.append("	pass_yn\n")
					.append("FROM tbi_order_product_inspect_result A\n")
					.append("	INNER JOIN v_checklist_gubun B\n")
					.append("	ON A.inspect_gubun = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbm_product C\n")
					.append("	ON A.prod_cd = C.prod_cd\n")
					.append("	AND  A.prod_cd_rev = C.revision_no\n")
					.append("	AND  A.member_key = C.member_key\n")
					.append("WHERE order_no = '" 	+  jArray.get("order_no") + "'\n")
					.append("	AND lotno = '" 		+  jArray.get("lotno") + "'\n")
					.append("	AND inspect_gubun = '" 	+  jArray.get("inspect_gubun") + "'\n")
					.append("AND A.member_key = '" 	+ jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S030100E845()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E845()","==== finally ===="+ e.getMessage());
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

	
	//포장처리현황
	public int E854(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("       P.order_no,\n")
					.append("       P.lotno,\n")
					.append("       P.package_no,\n")
					.append("       P.proc_plan_no,\n")
					.append("       P.proc_info_no,\n")
					.append("       P.proc_odr,\n")
					.append("       P.proc_cd,\n")
					.append("       P.proc_cd_rev,\n")
					.append("		PR.process_nm,\n")
					.append("       P.rout_dt,\n")
					.append("       P.start_dt,\n")
					.append("       P.finish_dt,\n")
					.append("		P.package_unit_weight,\n")
					.append("		P.package_unit_count,\n")
					.append("		P.package_count,\n")
					.append("		P.package_total_weight,\n")
					.append("		P.part_brand,\n")
					.append("		P.part_grade,\n")
					.append("       delay_yn,\n")
					.append("       P.delay_dt_num,\n")
					.append("       P.delay_reason_cd,\n")
					.append("       D.code_name,\n")
					.append("       P.exec_note,\n")
					.append("       P.worker_name,\n")
					.append("        P.prod_cd,\n")
					.append("        P.prod_cd_rev\n")
					
					.append("FROM\n")
					.append("	tbi_production_package_info P\n")
					
					.append("INNER JOIN tbi_production_head A\n")
					.append("	ON P.order_no=A.order_no\n")
					.append("   AND P.lotno=A.lotno\n")
					.append("   AND P.member_key=A.member_key\n")
					.append("INNER JOIN tbi_production_plan B\n")
					.append("   ON A.proc_plan_no=B.proc_plan_no\n")
					.append("   AND P.proc_cd=B.proc_cd\n")
					.append("   AND P.member_key=B.member_key\n")
					
					.append("LEFT OUTER JOIN v_delay_reason D\n")
					.append("	ON P.delay_reason_cd=D.code_value\n")
					.append("   AND P.member_key=D.member_key\n")
					.append("INNER JOIN tbm_process PR\n")
					.append("	ON P.proc_cd=PR.proc_cd\n")
					.append("	AND P.proc_cd_rev=PR.revision_no\n")
					.append("   AND P.member_key=PR.member_key\n")
					
					.append("WHERE P.order_no ='"			+ jArray.get("order_no") + "'  \n")
					.append("	AND P.lotno = '"  		  	+ jArray.get("lotno") + "'  \n")
					.append("	AND P.prod_cd = '"  		+ jArray.get("prod_cd") + "'  \n")
					.append("	AND P.prod_cd_rev = '"  	+ jArray.get("prod_cd_rev") + "'  \n")
					.append("	AND P.package_no LIKE '"  	+ jArray.get("package_no") + "%' \n")
					.append("	AND P.member_key = '"  		+ jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M101S030100E854()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E854()","==== finally ===="+ e.getMessage());
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
	
	
	//주문별출하현황
	public int E864(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("		A.member_key,\n")//이력반호
					.append("        A.order_no,\n")
					.append("        C.cust_nm,\n")
					.append("        B.product_nm,\n")
					.append("        A.order_no,\n")
					.append("        A.lotno,\n")
					.append("        H.chulha_no,\n")
					.append("        H.chulha_seq,\n")
					.append("        A.product_serial_no,\n")
					.append("        A.product_serial_no_end,\n")
					.append("        cust_pono,\n")
					.append("        order_date,\n")
					.append("        lot_count,\n")
					.append("        chulha_cnt,\n")
					.append("        chulha_unit,\n")
					.append("        chulha_unit_price,\n")
					.append("        delivery_date,\n")
					.append("        chuha_dt,\n")
					.append("        A.bigo,\n")
					.append("        order_note,\n")
					.append("        A.cust_cd,\n")
					.append("        A.cust_rev,\n")
					.append("        A.prod_cd,\n")
					.append("        A.prod_rev\n")
					.append("FROM tbi_order A\n")
					.append("	INNER JOIN tbi_chulha_info H \n")
					.append("	ON A.member_key = H.member_key\n")
					.append("	AND A.order_no = H.order_no\n")
					.append("	AND A.lotno = H.lotno\n")
					.append("	INNER JOIN tbm_customer C\n")
					.append("	ON A.member_key = C.member_key\n")
					.append("	AND A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_rev = C.revision_no\n")
					.append("	INNER JOIN tbm_product B	\n")
					.append("	ON A.member_key = B.member_key\n")
					.append("	AND A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev = B.revision_no\n")
					.append("WHERE  1=1 \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.append("AND A.order_no = '" + jArray.get("order_no") + "' 	\n")
					.append("AND A.lotno = '" + jArray.get("lotno") + "' 	\n")
					.append("AND A.order_date  BETWEEN '" +  jArray.get("fromdate") + "'\n")
					.append("AND '" +  jArray.get("todate") + "'\n")
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
			LoggingWriter.setLogError("M101S030100E864()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E864()","==== finally ===="+ e.getMessage());
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
		
	public int E884(InoutParameter ioParam){
	      resultInt = EventDefine.E_DOEXCUTE_INIT;
	      
	      try {
	         con = JDBCConnectionPool.getConnection();
	         
	         // 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
	         String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	         // 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
	         // rcvData = [위경도]
	         String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
	         String sql = new StringBuilder()
	        			.append("SELECT DISTINCT\n")
	        			.append("	C.cust_nm,              --고객사\n")
	        			.append("	B.product_nm,           --제품명\n")
	        			.append("	cust_pono,              --PO번호\n")
	        			.append("	product_gubun,          --제품구분\n")
	        			.append("	part_source,            --원부자재공급\n")
	        			.append("	order_date,             --주문일\n")
	        			.append("	A.lotno,                --lot번호\n")
	        			.append("	lot_count,              --lot수량\n")
	        			.append("	part_chulgo_date,       --자재출고일\n")
	        			.append("	rohs,\n")
	        			.append("	order_note,             --특이사항\n")
	        			.append("	delivery_date,          --납기일\n")
	        			.append("	bom_version,\n")
	        			.append("	A.order_no,             --주문번호\n")
	        			.append("	S.process_name,         --현상태명\n")
	        			.append("	A.bigo,                 --비고\n")
	        			.append("	product_serial_no,      --일련번호\n")
	        			.append("	product_serial_no_end,  --일련번호끝\n")
	        			.append("	A.cust_cd,\n")
	        			.append("	A.cust_rev,\n")
	        			.append("	A.prod_cd,\n")
	        			.append("	A.prod_rev,\n")
	        			.append("	Q.order_status\n")
	        			.append("FROM tbi_order A\n")
	        			.append("INNER JOIN tbm_customer C\n")
	        			.append("	ON A.cust_cd = C.cust_cd\n")
	        			.append("	AND A.cust_rev = C.revision_no\n")
	        			.append("	AND A.member_key = C.member_key\n")
	        			.append("INNER JOIN tbi_queue Q\n")
	        			.append("	ON A.order_no = Q.order_no\n")
	        			.append("	AND A.lotno = Q.lotno\n")
	        			.append("	AND A.member_key = Q.member_key\n")
	        			.append("INNER JOIN tbm_systemcode S\n")
	        			.append("	ON Q.order_status = S.status_code\n")
	        			.append("	AND Q.process_gubun = S.process_gubun\n")
	        			.append("	AND Q.member_key = S.member_key\n")
	        			.append("INNER JOIN tbm_product B\n")
	        			.append("	ON A.prod_cd = B.prod_cd\n")
	        			.append("	AND A.prod_rev = B.revision_no\n")
	        			.append("	AND A.member_key = B.member_key\n")
	        			.append(" " + c_paramArray[0][0] + "\n" )	//where 절이 포함되어 query 요청함
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
	         LoggingWriter.setLogError("M101S030100E884()","==== SQL ERROR ===="+ e.getMessage());
	         return EventDefine.E_DOEXCUTE_ERROR ;
	       } finally {
	          if (Config.useDataSource) {
	            try {
	               if (con != null) con.close();
	            } catch (Exception e) {
	            	LoggingWriter.setLogError("M101S030100E884()","==== finally ===="+ e.getMessage());
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
		

	public int E999(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("WITH order_bom_cnt AS(\n")
					.append("SELECT COUNT(order_no) AS BOM_Count FROM tbi_order_bomlist WHERE order_no='" + jArray.get("order_no") + "' AND lotno='" + jArray.get("lotno") + "'\n")
					.append("),\n")
					.append("order_doc_count AS(\n")
					.append("SELECT  COUNT(order_no) DOC_Count FROM tbi_order_doclist WHERE order_no='" + jArray.get("order_no") + "' AND lotno='" + jArray.get("lotno") + "'\n")
					.append("),\n") 
//					.append("order_process_count AS(\n")
//					.append("SELECT  COUNT(order_no) AS process_check_Count FROM tbi_order_process_checklist WHERE order_no='" + jArray.get("order_no") + "' AND lotno='" + jArray.get("lotno") + "'\n")
//					.append("),\n")
					.append("order_product_count AS(\n")
					.append("SELECT COUNT(order_no) AS product_check_Count FROM tbi_order_product_inspect_checklist WHERE order_no='" + jArray.get("order_no") + "' AND lotno='" + jArray.get("lotno") + "'\n")
					.append(")\n")
					.append("SELECT '주문번호: " + jArray.get("order_no") + ",Lot No: " + jArray.get("lotno") + "의 BOM 항목 수: ' || BOM_Count || '건,' || \n")
					.append("	' 문서의 수:' || DOC_Count || '건,' ||  \n") 
//					.append("	' 공정확인표의 수:' ||process_check_Count || '건,'  || \n")
					.append("	' 제품검사 체크리스트의 수:' || product_check_Count || '건' , \n")
					.append("	BOM_Count,\n")
					.append("	DOC_Count,\n") 
//					.append("	process_check_Count ,\n")
					.append("	product_check_Count \n")
					.append("FROM order_bom_cnt,order_doc_count, order_product_count\n")
//					.append("FROM order_bom_cnt,order_doc_count, order_process_count, order_product_count\n") , order_process_count, order_product_count 백업
					.append("WHERE member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S030100E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E999()","==== finally ===="+ e.getMessage());
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
	
	//S101S030900.jsp
	public int E904(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
        			.append("	C.cust_nm,				--고객사\n")
        			.append("	B.product_nm,			--제품명\n")
        			.append("	cust_pono,				--PO번호\n")
        			.append("	product_gubun,			--제품구분\n")
        			.append("	part_source,			--원부자재공급\n")
					.append("	order_date,				--주문일\n")
					.append("	A.lotno,				--lot번호\n")
					.append("	lot_count,				--lot수량\n")
					.append("	part_chulgo_date,		--회로자재출고일\n")
					.append("	rohs,					--rohs\n")
        			.append("	order_note,				--특이사항\n")
        			.append("	delivery_date,			--납기일\n")
        			.append("	bom_version,			--BOM버전\n")
        			.append("	A.order_no,				--주문번호\n")
        			.append("	S.process_name,			--현상태명\n")
        			.append("	A.bigo,					--비고\n")
        			.append("	product_serial_no,		--일련번호\n")
        			.append("	product_serial_no_end,	--일련번호끝\n")
        			.append("	A.cust_cd,				--고객사코드\n")
        			.append("	A.cust_rev,\n")
        			.append("	A.prod_cd,				--제품코드\n")
        			.append("	A.prod_rev,\n")
        			.append("	Q.order_status,\n")
					.append("	project_name,\n")
        			.append("	DECODE(product_gubun,'0','양산품','1','개발품') AS product_gubun,	--제품구분\n")
        			.append("	DECODE(part_source,'01','사급','02','도급','03','사급&도급') AS part_source,	--원부자재공급\n")
					.append(" 	DECODE(rohs,'0','Pb Free','1','Pb') AS rohs	--rohs\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbi_queue Q\n")
					.append("	ON A.order_no = Q.order_no\n")
					.append("	AND A.lotno = Q.lotno\n")
					.append("	AND A.member_key = Q.member_key\n")
					.append("INNER JOIN tbm_systemcode S\n")
					.append("	ON Q.order_status = S.status_code\n")
					.append("	AND Q.process_gubun = S.process_gubun\n")
					.append("	AND Q.member_key = S.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
//					.append("AND S.class_id = '" 		+ jArray.get("jsppage") + "' 	\n")
					.append("AND Q.process_gubun = 'ODPROCS'\n")
					.append("AND Q.order_status != 'COMPLTE'\n")
					.append("AND order_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	AND '" + jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
			
//					.append("SELECT DISTINCT\n")
//					.append("        C.cust_nm,\n")
//					.append("        B.product_nm,\n")
//					.append("        project_name,\n")
//					.append("        A.lotno,\n")
//					.append("        delivery_date,\n")
//					.append("        cust_pono,\n")
//					.append("        project_cnt,\n")
//					.append("        order_count,\n")
//					.append("		NVL(chulha_cnt,0),\n")
//					.append("		(order_count - NVL(chulha_cnt,0) ) AS remin_cnt,\n")
//					.append("        S.process_name,\n")
//					.append("        A.bigo, \n")
//					.append("        A.order_no,\n")
//					.append("        '',\n")	// .append("        A.order_detail_seq,\n")
//					.append("        order_date,\n")
//					.append("        A.cust_cd,\n")
//					.append("        A.cust_rev,\n")
//					.append("        '',\n")	// .append("        A.product_serial_no,\n") 
//					.append("        A.prod_cd,\n")
//					.append("        lot_count,\n")
//					.append("        Q.order_status\n")
//					.append("FROM\n")
//					.append("        tbi_order A\n")
//					.append("LEFT OUTER JOIN tbi_chulha_info h \n")
//					.append("ON 	A.order_no = h.order_no\n")
//					.append("AND A.lotno = h.lotno\n")
//					.append("INNER JOIN tbm_customer C		\n")
//					.append("ON A.cust_cd = C.cust_cd		\n")
//					.append("and A.cust_rev = C.revision_no \n")
//					.append("INNER JOIN tbi_queue Q			\n")
//					.append("ON A.order_no = Q.order_no		\n")
//					.append("AND A.lotno = Q.lotno	\n")
//					.append("INNER JOIN tbm_systemcode S		\n")
//					.append("ON Q.order_status = S.status_code 	\n")
//					.append("AND Q.process_gubun = S.process_gubun 	\n")
//					.append("INNER JOIN tbm_product B			\n")
//					.append(" ON A.prod_cd = B.prod_cd		\n")
//					.append(" and  A.prod_rev = B.revision_no\n")
//					.append("WHERE A.cust_cd LIKE '%" 	+ c_paramArray[0][2] + "'	\n")
//					.append("AND Q.process_gubun = 'ODPROCS'\n")
//					.append("AND Q.order_status != 'COMPLTE'\n")
//					.append("AND order_date \n")
//					.append("BETWEEN '" + c_paramArray[0][0] + "' 	\n")
//					.append("	 AND '" + c_paramArray[0][1] + "'	\n")
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
			LoggingWriter.setLogError("M101S030100E904()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E904()","==== finally ===="+ e.getMessage());
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
	
	public int E912(InoutParameter ioParam){
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			String[][] c_paramArray_Head=null;
			String[][] c_paramArray_Detail=null;
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

			c_paramArray_Head = (String[][])resultVector.get(0);//head table
    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
    		
	    	for(int i=0; i<c_paramArray_Detail.length; i++) { 
				sql = new StringBuilder()
					.append("MERGE INTO tbi_order_bomlist  mm     \n")
					.append("USING ( SELECT     \n")
					.append("	'" + c_paramArray_Detail[i][3] + "' AS order_no, \n") 		//order_no
					.append(" 	'" + c_paramArray_Detail[i][4] + "' AS bom_cd, \n") 			//bom_cd
					.append("	'" + c_paramArray_Detail[i][5] + "' AS bom_cd_rev, \n") 		//bom_cd_rev			
					.append("	'" + c_paramArray_Detail[i][6] + "' AS bom_name, \n") 			//bom_name
					.append("	'" + c_paramArray_Detail[i][7] + "' AS lotno, \n") 	//lotno	
					.append("	'" + c_paramArray_Detail[i][8] + "' AS last_no, \n") 			//last_no
					.append("	'" + c_paramArray_Detail[i][9] + "' AS type_no, \n") 			//type_no	
					.append("	'" + c_paramArray_Detail[i][10] + "' AS geukyongpoommok, \n") 	//geukyongpoommok 
					.append("	'" + c_paramArray_Detail[i][11] + "' AS dept_code, \n") 		//dept_code
					.append("	TO_DATE('" + c_paramArray_Detail[i][12] + "','YYYY-MM-DD') AS approval_date, \n") 	//approval_date
					.append("	'" + c_paramArray_Detail[i][13] + "' AS approval, \n") 			//approval
					.append("	'" + c_paramArray_Detail[i][14] + "' AS sys_bom_id,	\n") 		//sys_bom_id
					.append("	'" + c_paramArray_Detail[i][15] + "' AS jaryo_bunho, \n") 		//jaryo_bunho
					.append("	'" + c_paramArray_Detail[i][16] + "' AS bupum_bunho, \n") 		//bupum_bunho
					.append("	'" + c_paramArray_Detail[i][17] + "' AS part_cd, \n") 		//part_cd
					.append("	'" + c_paramArray_Detail[i][18] + "' AS jaryo_irum,  \n") 		//jaryo_irum					
					.append("	'" + c_paramArray_Detail[i][19] + "' AS part_cd_rev, \n") 		//part_cd_rev
					.append("	'" + c_paramArray_Detail[i][20] + "' AS part_cnt,	\n") 		//part_cnt
					.append("	'" + c_paramArray_Detail[i][21] + "' AS mesu, \n") 				//mesu
					.append("	'" + c_paramArray_Detail[i][22] + "' AS gubun, \n") 			//gubun
					.append("	'" + c_paramArray_Detail[i][23] + "' AS qar, \n") 				//qar
					.append(" 	'" + c_paramArray_Detail[i][24] + "' AS inspect_selbi,  \n")	//inspect_selbi
					.append("	'" + c_paramArray_Detail[i][25] + "' AS packing_jaryo, \n")		//packing_jaryo
					.append("	'" + c_paramArray_Detail[i][26] + "' AS modify_note,	\n")	//modify_note
					.append("	'" + c_paramArray_Detail[i][27] + "' AS cust_code, \n") 		//cust_code
					.append("	'" + c_paramArray_Detail[i][28] + "' AS cust_rev, \n") 			//cust_rev
					.append("	'" + c_paramArray_Detail[i][29] + "' AS bigo, \n") 				//bigo
					.append("	'" + c_paramArray_Detail[i][1] + "' AS create_user_id, \n") 	//create_user_id
					.append("	'" + c_paramArray_Detail[i][30] + "' AS modify_reason, \n") 	//modify_reason
					.append("	'" + c_paramArray_Detail[i][31] + "' AS revision_no \n") 	//revision_no
					.append("	  )  mQ    \n")						
					.append("ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.bom_cd = mQ.bom_cd AND mm.bom_cd_rev = mQ.bom_cd_rev  AND mm.sys_bom_id = mQ.sys_bom_id )    \n")
					.append("WHEN MATCHED THEN     \n")
					.append("	UPDATE SET     \n")
					.append(  "mm.order_no = mQ.order_no, 		mm.lotno = mQ.lotno, "
							+ "mm.bom_cd = mQ.bom_cd, 			mm.bom_cd_rev = mQ.bom_cd_rev, "
							+ "mm.bom_name = mQ.bom_name, 		mm.last_no = mQ.last_no, 		mm.sys_bom_id = mQ.sys_bom_id, "
							+ "mm.type_no = mQ.type_no, 		mm.geukyongpoommok = mQ.geukyongpoommok, mm.dept_code = mQ.dept_code, "
							+ "mm.approval_date = mQ.approval_date, mm.approval = mQ.approval, 	mm.jaryo_bunho = mQ.jaryo_bunho, "
							+ "mm.bupum_bunho = mQ.bupum_bunho, mm.part_cd = mQ.part_cd, 	mm.part_cd_rev = mQ.part_cd_rev,"
							+ "mm.jaryo_irum = mQ.jaryo_irum, 	mm.part_cnt = mQ.part_cnt, 		mm.mesu = mQ.mesu, mm.gubun = mQ.gubun, "
							+ "mm.qar = mQ.qar, 				mm.inspect_selbi = mQ.inspect_selbi, mm.packing_jaryo = mQ.packing_jaryo, "
							+ "mm.modify_note = mQ.modify_note, mm.cust_code = mQ.cust_code, 	mm.cust_rev = mQ.cust_rev, "
							+ "mm.bigo = mQ.bigo, 				mm.create_user_id = mQ.create_user_id, mm.modify_reason = mQ.modify_reason, mm.revision_no = mQ.revision_no  \n")
					.append("WHEN NOT MATCHED THEN     \n")
					.append(" INSERT  ( \n")
					.append(  "mm.order_no, mm.lotno, 	mm.bom_cd,  mm.bom_cd_rev,	mm.bom_name,"
							+ "mm.last_no,	mm.sys_bom_id,			mm.type_no,		mm.geukyongpoommok,	mm.dept_code,	mm.approval_date,"
							+ "mm.approval,	mm.jaryo_bunho,			mm.bupum_bunho,	mm.part_cd,		mm.part_cd_rev,	mm.jaryo_irum,"
							+ "mm.part_cnt,	mm.mesu,mm.gubun,		mm.qar,			mm.inspect_selbi,	mm.packing_jaryo,mm.modify_note,"
							+ "mm.cust_code,mm.cust_rev,			mm.bigo,		mm.create_user_id,	mm.modify_reason \n")
					.append(") \n")
					.append(" VALUES  ( \n")
					.append(  "mQ.order_no, mQ.lotno,	mQ.bom_cd,  mQ.bom_cd_rev,	mQ.bom_name,"
							+ "mQ.last_no,	mQ.sys_bom_id,			mQ.type_no,		mQ.geukyongpoommok,	mQ.dept_code,	mQ.approval_date,"
							+ "mQ.approval,	mQ.jaryo_bunho,			mQ.bupum_bunho,	mQ.part_cd,		mQ.part_cd_rev,	mQ.jaryo_irum,"
							+ "mQ.part_cnt,	mQ.mesu,mQ.gubun,		mQ.qar,			mQ.inspect_selbi,	mQ.packing_jaryo,mQ.modify_note,"
							+ "mQ.cust_code,mQ.cust_rev,			mQ.bigo,		mQ.create_user_id,	mQ.modify_reason \n")
					.append("); ")
					.toString();
				
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    	}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S030100E912()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E912()","==== finally ===="+ e.getMessage());
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
	
	public int E922(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";

		ApprovalActionNo ActionNo;
		String order_check_no="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String[][] c_paramArray_Head=null;
			String[][] c_paramArray_Detail=null;
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

			c_paramArray_Head = (String[][])resultVector.get(0);//head table
    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		String jspPage = c_paramArray_Detail[0][0];
    		String user_id = c_paramArray_Detail[0][1];
    		String prefix = c_paramArray_Detail[0][2];
    		String actionGubun = "Regist";
    		String detail_seq = c_paramArray_Detail[0][4];
    		String member_key = ""; // 현재 사용 안하는 메소드 - 나중에 사용할때 해당화면에서 멤버키 받아오도록 수정
    		
			ActionNo = new ApprovalActionNo();

			order_check_no= ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);  //order_check_no
	    	for(int i=0; i<c_paramArray_Detail.length; i++) {   
	    		sql = new StringBuilder()
	    				.append("MERGE INTO tbi_order_process_checklist  mm\n")
	    				.append("USING ( SELECT\n")
	    				.append("    	'" + c_paramArray_Detail[i][4] + "' AS lotno,\n")
	    				.append("    	'" + c_paramArray_Detail[i][3] + "' AS order_no,\n")
	    				.append("    	'" + c_paramArray_Detail[i][23] + "' AS order_check_no,\n")
//	    				.append("    	'" + order_check_no + "' AS order_check_no,\n")
	    				.append("    	'" + c_paramArray_Detail[i][5] + "' AS qar,\n")
	    				.append("    	'" + c_paramArray_Detail[i][6] + "' AS spec_approval,\n")
	    				.append("    	'" + c_paramArray_Detail[i][7] + "' AS spec_approval_rev,\n")
	    				.append("    	'" + c_paramArray_Detail[i][8] + "' AS std_dwg,\n")
	    				.append("    	'" + c_paramArray_Detail[i][9] + "' AS std_dwg_rev,\n")
	    				.append("    	'" + c_paramArray_Detail[i][10] + "' AS program_rev,\n")
	    				.append("    	'" + c_paramArray_Detail[i][11] + "' AS job_guide, \n")
	    				.append("    	'" + c_paramArray_Detail[i][12] + "' AS job_guide_rev,\n")
	    				.append("    	'" + c_paramArray_Detail[i][13] + "' AS proc_cd,\n")
	    				.append("    	'" + c_paramArray_Detail[i][14] + "' AS proc_rev,\n")
	    				.append("    	'" + c_paramArray_Detail[i][15] + "' AS checklist_cd,\n")
	    				.append("    	'" + c_paramArray_Detail[i][16] + "' AS checklist_seq,\n")
	    				.append("    	'" + c_paramArray_Detail[i][17] + "' AS checklist_rev,\n")
	    				.append("    	'" + c_paramArray_Detail[i][18] + "' AS standard_guide,\n")
	    				.append("    	'" + c_paramArray_Detail[i][19] + "' AS standard_value,\n")
	    				.append("    	'" + c_paramArray_Detail[i][20] + "' AS tools,\n")
	    				.append("    	'" + c_paramArray_Detail[i][21] + "' AS check_note,\n")
	    				.append("    	'" + c_paramArray_Detail[i][24] + "' AS start_date,\n")
	    				.append("    	'" + c_paramArray_Detail[i][25] + "' AS create_date,\n")
//	    				.append("    	to_char(sysdate,'YYYY-MM-DD') AS start_date,\n")
//	    				.append("    	SYSDATETIME AS create_date,\n")
	    				.append("    	'" + c_paramArray_Detail[i][1] + "' AS create_user_id,\n")
	    				.append("    	'" + c_paramArray_Detail[i][22] + "' AS modify_reason,\n")
	    				.append("    	'" + c_paramArray_Detail[i][26] + "' AS revision_no\n")
	    				.append("    	) mQ\n")
	    				.append("    	ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.order_check_no = mQ.order_check_no AND mm.proc_cd = mQ.proc_cd AND mm.proc_rev = mQ.proc_rev  AND mm.checklist_cd = mQ.checklist_cd AND mm.checklist_seq=mQ.checklist_seq AND mm.checklist_rev = mQ.checklist_rev )\n")
	    				.append("    	WHEN MATCHED THEN\n")
	    				.append("    	UPDATE SET\n")
	    				.append("    	mm.lotno = mQ.lotno, 						mm.order_no = mQ.order_no,\n")
	    				.append("    	mm.order_check_no = mQ.order_check_no, 		mm.qar = mQ.qar,\n")
	    				.append("    	mm.spec_approval= mQ.spec_approval,			mm.spec_approval_rev = mQ.spec_approval_rev,\n")
	    				.append("    	mm.std_dwg = mQ.std_dwg,					mm.std_dwg_rev = mQ.std_dwg_rev,\n")
	    				.append("    	mm.program_rev = mQ.program_rev,			mm.job_guide = mQ.job_guide,\n")
	    				.append("    	mm.job_guide_rev = mQ.job_guide_rev,		mm.proc_cd = mQ.proc_cd,\n")
	    				.append("    	mm.proc_rev = mQ.proc_rev,					mm.checklist_cd = mQ.checklist_cd,\n")
	    				.append("    	mm.checklist_seq = mQ.checklist_seq,		mm.checklist_rev = mQ.checklist_rev,\n")
	    				.append("    	mm.standard_guide = mQ.standard_guide,		mm.standard_value = mQ.standard_value,\n")
	    				.append("    	mm.tools = mQ.tools,						mm.check_note = mQ.check_note,\n")
	    				.append("    	mm.start_date = mQ.start_date,				mm.create_date= mQ.create_date,\n")
	    				.append("    	mm.create_user_id = mQ.create_user_id,		mm.modify_reason = mQ.modify_reason, mm.revision_no = mQ.revision_no\n")
	    				.append("    	WHEN NOT MATCHED THEN\n")
	    				.append("    	INSERT (\n")
	    				.append("    	mm.lotno, mm.order_no, mm.order_check_no, mm.qar, mm.spec_approval, mm.spec_approval_rev, mm.std_dwg, mm.std_dwg_rev,\n")
	    				.append("    	mm.program_rev,	mm.job_guide, mm.job_guide_rev, mm.proc_cd, mm.proc_rev ,	mm.checklist_cd, mm.checklist_seq,	 mm.checklist_rev,\n")
	    				.append("    	mm.standard_guide,	mm.standard_value, mm.tools, mm.check_note, mm.start_date,	mm.create_date, mm.create_user_id, mm.modify_reason\n")
	    				.append("    	)\n")
	    				.append("    	VALUES (\n")
	    				.append("    	mQ.lotno, mQ.order_no, '" + order_check_no + "',  mQ.qar, mQ.spec_approval, mQ.spec_approval_rev, mQ.std_dwg, mQ.std_dwg_rev, \n")
	    				.append("    	mQ.program_rev, mQ.job_guide, mQ.job_guide_rev, mQ.proc_cd, mQ.proc_rev,	mQ.checklist_cd, mQ.checklist_seq, mQ.checklist_rev, mQ.standard_guide,	\n")
	    				.append("    	mQ.standard_value, mQ.tools, mQ.check_note, to_char(sysdate,'YYYY-MM-DD'), SYSDATETIME, mQ.create_user_id,	'최초작성'\n")
	    				.append("    	)\n")
	    				.append(" ; ")
	    				.toString();

//	    		sql = new StringBuilder()
//    				.append("INSERT INTO\n")
//    				.append("	tbi_order_process_checklist (\n")
//    				.append("		order_detail_seq,\n")
//    				.append("		order_no,\n")
//    				.append("		order_check_no,\n")
//    				.append("		qar,\n")
//    				.append("		spec_approval,\n")
//    				.append("		spec_approval_rev,\n")
//    				.append("		std_dwg,\n")
//    				.append("		std_dwg_rev,\n")
//    				.append("		program_rev,\n")
//    				.append("		job_guide,\n")
//    				.append("		job_guide_rev,\n")
//    				.append("		proc_cd,\n")
//    				.append("		proc_rev,\n")
//    				.append("		checklist_cd,\n")
//    				.append("		checklist_seq,\n")
//    				.append("		checklist_rev,\n")
//    				.append("		standard_guide,\n")
//    				.append("		standard_value,\n")
//    				.append("		tools,\n")
//    				.append("		check_note,\n")
//    				.append("		start_date,\n")
//    				.append("		create_date,\n")
//    				.append("		create_user_id,\n")
//    				.append("		modify_reason\n")
//    				.append("	)\n")
//    				.append("VALUES	(\n")
//					.append(" 		'" + c_paramArray_Detail[i][4] + "'		\n") //order_detail_seq
//					.append(" 		,'" + c_paramArray_Detail[i][3] + "'	\n") //order_no
//					.append(" 		,'"  + order_check_no + "' \n") 			//order_check_no
//					.append(" 		,'" + c_paramArray_Detail[i][5] + "'	\n") //qar
//					.append(" 		,'" + c_paramArray_Detail[i][6] + "' 	\n") //spec_approval			
//					.append(" 		,'" + c_paramArray_Detail[i][7] + "'	\n") //spec_approval_rev
//					.append(" 		,'" + c_paramArray_Detail[i][8] + "'	\n") //std_dwg	
//					.append(" 		,'" + c_paramArray_Detail[i][9] + "'	\n") //std_dwg_rev
//					.append(" 		,'" + c_paramArray_Detail[i][10] + "'	\n") //program_rev	
//					.append(" 		,'" + c_paramArray_Detail[i][11] + "'	\n") //job_guide 
//					.append(" 		,'" + c_paramArray_Detail[i][12] + "'	\n") //job_guide_rev
//					.append(" 		,'" + c_paramArray_Detail[i][13] + "' 	\n") //proc_cd
//					.append(" 		,'" + c_paramArray_Detail[i][14] + "' 	\n") //proc_rev
//					.append(" 		,'" + c_paramArray_Detail[i][15] + "'	\n") //checklist_cd
//					.append(" 		,'" + c_paramArray_Detail[i][16] + "'	\n") //checklist_seq	
//					.append(" 		,'" + c_paramArray_Detail[i][17] + "'	\n") //checklist_rev 
//					.append(" 		,'" + c_paramArray_Detail[i][18] + "'	\n") //standard_guide
//					.append(" 		,'" + c_paramArray_Detail[i][19] + "'	\n") //standard_value
//					.append(" 		,'" + c_paramArray_Detail[i][20] + "' 	\n") //tools
//					.append(" 		,'" + c_paramArray_Detail[i][21] + "' 	\n") //check_note
//					.append(" 		, to_char(sysdate,'YYYY-MM-DD') 		\n") //start_date
//					.append(" 		, SYSDATETIME 							\n") //create_date
//					.append(" 		,'" + c_paramArray_Detail[i][1] + "' 	\n") //create_user_id
//					.append(" 		,'" + c_paramArray_Detail[i][22] + "' 	\n") //modify_reason
//    				.append("	);\n")
//    				.toString();

	    		System.out.println(c_paramArray_Detail.length+ "sql.toString()============"+i);
					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
	    	}
			
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S030100E922()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E922()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E932(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";

		ApprovalActionNo ActionNo;
		String order_check_no="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String[][] c_paramArray_Head=null;
			String[][] c_paramArray_Detail=null;
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

			c_paramArray_Head = (String[][])resultVector.get(0);//head table
    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		String jspPage = c_paramArray_Detail[0][0];
    		String user_id = c_paramArray_Detail[0][1];
    		String prefix = c_paramArray_Detail[0][2];
    		String actionGubun = "Regist";
    		String detail_seq = c_paramArray_Detail[0][4];
    		String member_key = ""; // 현재 사용 안하는 메소드 - 나중에 사용할때 해당화면에서 멤버키 받아오도록 수정
    		
    		String vorder_check_no = c_paramArray_Detail[0][14];
    		
    		if(vorder_check_no.length() < 1) {
				ActionNo = new ApprovalActionNo();
				order_check_no = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key); //order_check_no
    		}
    		else {
    			order_check_no = vorder_check_no;
    		}
	    	for(int i=0; i<c_paramArray_Detail.length; i++) {  
	    		String vorder_check_seq=c_paramArray_Detail[0][15];
	    		sql = new StringBuilder()
//    				.append("INSERT INTO\n")
//    				.append("	tbi_order_product_inspect_checklist (\n")
//    				.append("		order_no,\n")
//    				.append("		order_detail_seq,\n")
//    				.append("		order_check_no,\n")
//    				.append("		order_check_seq,\n")
//    				.append("		prod_cd,\n")
//    				.append("		prod_rev,\n")
//    				.append("		checklist_cd,\n")
//    				.append("		checklist_seq,\n")
//    				.append("		checklist_rev,\n")
//    				.append("		standard_guide,\n")
//    				.append("		standard_value,\n")
//    				.append("		check_note,\n")
//    				.append("		inspect_gubun,\n")
//    				.append("		start_date,\n")
//    				.append("		create_user_id\n")
//    				.append("	)\n")
//    				.append("VALUES ( \n")
//					.append(" 		'" + c_paramArray_Detail[i][3] + "'		\n") //order_no
//					.append(" 		,'" + c_paramArray_Detail[i][4] + "'	\n") //order_detail_seq
//					.append(" 		,'"  + order_check_no 			+ "' 	\n") //order_check_no
//					.append(" 		,'"  + i 			+ "' 	\n") //order_check_no
//					.append(" 		,'" + c_paramArray_Detail[i][5] + "'	\n") //prod_cd
//					.append(" 		,'" + c_paramArray_Detail[i][6] + "' 	\n") //prod_rev			
//					.append(" 		,'" + c_paramArray_Detail[i][7] + "'	\n") //checklist_cd
//					.append(" 		,'" + c_paramArray_Detail[i][8] + "'	\n") //checklist_seq	
//					.append(" 		,'" + c_paramArray_Detail[i][9] + "'	\n") //checklist_rev
//					.append(" 		,'" + c_paramArray_Detail[i][10] + "'	\n") //standard_guide	
//					.append(" 		,'" + c_paramArray_Detail[i][11] + "'	\n") //standard_value 
//					.append(" 		,'" + c_paramArray_Detail[i][12] + "'	\n") //check_note
//					.append(" 		,'" + c_paramArray_Detail[i][13] + "' 	\n") //inspect_gubun
//					.append(" 		, to_char(sysdate,'YYYY-MM-DD') 		\n") //start_date
//					.append(" 		,'" + c_paramArray_Detail[i][1] + "' 	\n") //create_user_id
//    				.append("	);\n")
    				.append("MERGE INTO tbi_order_product_inspect_checklist mm\n")
					.append("	USING ( \n")
					.append("SELECT \n")
	    			.append("		 '" + c_paramArray_Detail[i][3]  + "' AS order_no\n")
					.append("		,'" + c_paramArray_Detail[i][4]  + "' AS lotno\n")
					.append("		,'" + order_check_no 			 + "' AS order_check_no\n")
	                .append("		,'" + i 						 + "' AS order_check_seq\n")
					.append("		,'" + c_paramArray_Detail[i][5]  + "' AS prod_cd\n")
					.append("		,'" + c_paramArray_Detail[i][6]  + "' AS prod_rev\n")
					.append("		,'" + c_paramArray_Detail[i][7]  + "' AS checklist_cd\n")
					.append("		,'" + c_paramArray_Detail[i][8]  + "' AS checklist_seq\n")
					.append("		,'" + c_paramArray_Detail[i][9]  + "' AS checklist_rev\n")
					.append("		,'" + c_paramArray_Detail[i][10]  + "' AS standard_guide\n")
					.append("		,'" + c_paramArray_Detail[i][11] + "' AS standard_value\n")
					.append("		,'" + c_paramArray_Detail[i][12] + "' AS check_note\n")
					.append("		,'" + c_paramArray_Detail[i][13] + "' AS inspect_gubun\n")
					.append("		,  to_char(sysdate,'YYYY-MM-DD')    AS start_date\n")
					.append("		,'" + c_paramArray_Detail[i][1] + "' AS create_user_id\n")
					.append("	FROM db_root ) mQ\n")
					.append("ON ( \n")
					.append("	mm.order_no=mQ.order_no\n")
					.append("	AND mm.lotno=mQ.lotno\n")
					.append("	AND mm.order_check_no=mQ.order_check_no\n")
					.append("	AND mm.order_check_seq=mQ.order_check_seq\n")
//					.append("	AND mm.prod_cd=mQ.prod_cd\n")
//					.append("	AND mm.prod_rev=mQ.prod_rev\n")
//					.append("	AND mm.checklist_cd=mQ.checklist_cd\n")
//					.append("	AND mm.checklist_seq=mQ.checklist_seq\n")
//					.append("	AND mm.checklist_rev=mQ.checklist_rev\n")
//					.append("   AND mm.inspect_gubun=mQ.inspect_gubun\n")
					.append(")\n")
					.append("WHEN MATCHED THEN\n")
					.append("	UPDATE SET \n")
					.append("		mm.order_no=mQ.order_no,\n")
					.append("		mm.lotno=mQ.lotno,\n")
					.append("		mm.order_check_no=mQ.order_check_no,\n")
					.append("		mm.order_check_seq=mQ.order_check_seq,\n")
					.append("		mm.prod_cd=mQ.prod_cd,\n")
					.append("		mm.prod_rev=mQ.prod_rev,\n")
					.append("		mm.checklist_cd=mQ.checklist_cd,\n")
					.append("		mm.checklist_seq=mQ.checklist_seq,\n")
					.append("		mm.checklist_rev=mQ.checklist_rev,\n")
					.append("		mm.standard_guide=mQ.standard_guide,\n")
					.append("		mm.standard_value=mQ.standard_value,\n")
					.append("		mm.check_note=mQ.check_note,\n")
					.append("		mm.inspect_gubun=mQ.inspect_gubun,\n")
					.append("		mm.start_date=mQ.start_date,\n")
					.append("		mm.create_user_id=mQ.create_user_id\n")
					.append("WHEN NOT MATCHED THEN\n")
					.append("	INSERT (\n")
					.append("		mm.order_no,\n")
					.append("		mm.lotno,\n")
					.append("		mm.order_check_no,\n")
					.append("		mm.order_check_seq,\n")
					.append("		mm.prod_cd,\n")
					.append("		mm.prod_rev,\n")
					.append("		mm.checklist_cd,\n")
					.append("		mm.checklist_seq,\n")
					.append("		mm.checklist_rev,\n")
					.append("		mm.standard_guide,\n")
					.append("		mm.standard_value,\n")
					.append("		mm.check_note,\n")
					.append("		mm.inspect_gubun,\n")
					.append("		mm.start_date,\n")
					.append("		mm.create_user_id\n")
					.append("	) VALUES (\n")
					.append("		mQ.order_no,\n")
					.append("		mQ.lotno,\n")
					.append("		mQ.order_check_no,\n")
					.append("		mQ.order_check_seq,\n")
					.append("		mQ.prod_cd,\n")
					.append("		mQ.prod_rev,\n")
					.append("		mQ.checklist_cd,\n")
					.append("		mQ.checklist_seq,\n")
					.append("		mQ.checklist_rev,\n")
					.append("		mQ.standard_guide,\n")
					.append("		mQ.standard_value,\n")
					.append("		mQ.check_note,\n")
					.append("		mQ.inspect_gubun,\n")
					.append("		mQ.start_date,\n")
					.append("		mQ.create_user_id\n")
					.append("	)\n")
    				.toString();

					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
	    	}
			
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S030100E932()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E932()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E944(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	sys_bom_id,\n")
					.append("	bom_cd,\n")
					.append("	bom_cd_rev,\n")
					.append("	jaryo_bunho,\n")
					.append("	bupum_bunho,\n")
					.append("	part_cd,\n")
					.append("	jaryo_irum,\n")
					.append("	B.part_nm ,\n")
					.append("	part_cd_rev,\n")
					.append("	part_cnt,\n")
					.append("	mesu,\n")
					.append("	gubun,\n")
					.append("	qar,\n")
					.append("	inspect_selbi,\n")
					.append("	packing_jaryo,\n")
					.append("	modify_note,\n")
					.append("	cust_code,\n")
					.append("	C.cust_nm,\n")
					.append("	cust_rev,\n")
					.append("	A.bigo,\n")
					.append("	bom_cd,\n")
					.append("	bom_cd_rev, \n")
					.append("	bom_name,\n")
					.append("	last_no, \n")
					.append("	type_no,\n")
					.append("	geukyongpoommok, \n")
					.append("	approval_date,\n")
					.append("	dept_code,\n")
					.append("	approval,\n")
					.append("	A.modify_reason,\n")
					.append("	A.revision_no\n")
					.append("FROM tbi_order_bomlist A \n")
					.append("	LEFT OUTER JOIN tbm_part_list B\n")
					.append("	ON part_cd = part_cd\n")
					.append("	AND part_cd_rev = B.revision_no\n")
					.append("	AND member_key = B.member_key\n")
					.append("	LEFT OUTER  JOIN tbm_customer C \n")
					.append("	ON cust_code = C.cust_cd\n")
					.append("	AND cust_rev = C.revision_no\n")
					.append("	AND member_key = C.member_key\n")
					.append("WHERE order_no = '" +  jArray.get("order_no") + "'\n")
					.append("AND lotno = '" +  jArray.get("lotno") + "'\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S030100E944()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E944()","==== finally ===="+ e.getMessage());
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
	
	//공정확인표 공정별 체크리스트 선택
		public int E954(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
				// rcvData = [위경도]
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	A.proc_cd,\n")
						.append("	process_nm,\n")
						.append("	A.checklist_seq,\n")
						.append("	dept_gubun,\n")
						.append("	B.checklist_cd,\n")
						.append("	B.check_note,\n")
						.append("	B.standard_guide,\n")
						.append("	B.standard_value,\n")
						.append("	C.item_type,\n")
						.append("	C.item_desc,\n")
						.append("	C.item_bigo,\n")
						.append("	A.checklist_cd_rev,\n")
						.append("	A.proc_cd_rev,\n")
						.append("	A.revision_no	\n")
						.append("FROM vtbm_process_checklist A \n")
						.append("	INNER JOIN vtbm_checklist B \n")
						.append("	ON A.checklist_cd = B.checklist_cd\n")
						.append("	AND A.checklist_cd_rev = B.revision_no\n")
						.append("	AND A.checklist_seq = B.checklist_seq\n")
						.append("	AND A.member_key = B.member_key\n")
						.append("	INNER JOIN vtbm_check_item C \n")
						.append("	ON B.item_cd = C.item_cd\n")
						.append("	AND B.item_seq = C.item_seq\n")
						.append("	AND B.item_cd_rev = C.revision_no\n")
						.append("	AND B.member_key = C.member_key\n")
						.append("	INNER JOIN vtbm_process D \n")
						.append("	ON A.proc_cd = D.proc_cd\n")
						.append("	AND A.proc_cd_rev= D.revision_no\n")
						.append("	AND A.member_key= D.member_key\n")
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
				LoggingWriter.setLogError("M101S030100E954()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M101S030100E954()","==== finally ===="+ e.getMessage());
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
	
	public int E974(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT	\n")
					.append("	A.checklist_seq,	\n")
					.append("	A.proc_cd,			\n")
					.append("	process_nm,			\n")
					.append("	dept_gubun,			\n")
					.append("	A.proc_rev,			\n")
					.append("	A.checklist_cd,		\n")
					.append("	A.checklist_rev,	\n")
					.append("	A.standard_guide,	\n")
					.append("	A.tools,			\n")
					.append("	A.check_note, 		\n")
					.append("	A.standard_value,	\n")					
					.append("	A.order_check_no,	\n")
					.append("	A.qar,				\n")
					.append("	A.spec_approval,	\n")
					.append("	A.spec_approval_rev,\n")
					.append("	A.std_dwg,			\n")
					.append("	A.std_dwg_rev,		\n")
					.append("	A.program_rev,		\n")
					.append("	A.job_guide,		\n")
					.append("	A.job_guide_rev,	\n")
					.append("	A.start_date,		\n")
					.append("	A.create_date,		\n")
					.append("	A.modify_reason,	\n")
					.append("	A.revision_no		\n")
					.append("FROM tbi_order_process_checklist A	\n")
					.append("INNER JOIN tbm_process D	 		\n")
					.append("	ON A.proc_cd = D.proc_cd		\n")
					.append("	AND A.proc_rev= D.revision_no	\n")
					.append("	AND A.member_key= D.member_key	\n")
					.append("WHERE A.order_no = '" 	+ jArray.get("order_no") + "'	\n")
					.append("	AND  A.lotno = '"	+ jArray.get("lotno") + "' 	\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S030100E974()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S030100E974()","==== finally ===="+ e.getMessage());
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
	
	//주문제품별 검사체크리스트
		public int E994(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
				// rcvData = [위경도]
//				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	order_no,\n")
						.append("	lotno,\n")
						.append("	inspect_gubun,\n")
						.append("	C.code_name,\n")
						.append("	order_check_no,\n")
						.append("	A.revision_no,\n")
						.append("	A.prod_cd,\n")
						.append("	B.product_nm,\n")
						.append("	A.prod_rev,\n")
						.append("	checklist_cd,\n")
						.append("	checklist_seq,\n")
						.append("	checklist_rev,\n")
						.append("	standard_guide,\n")
						.append("	standard_value,\n")
						.append("	check_note,\n")
						.append("	order_check_seq\n")
						.append("FROM tbi_order_product_inspect_checklist A \n")
						.append("	INNER JOIN tbm_product B \n")
						.append("	ON A.prod_cd = B.prod_cd\n")
						.append("	AND A.prod_rev = B.revision_no\n")
						.append("	AND A.member_key = B.member_key\n")
						.append("	INNER JOIN v_checklist_gubun C\n")
						.append("	on A.inspect_gubun = C.code_value\n")
						.append("	and A.member_key = C.member_key\n")

						.append("WHERE order_no = '" + jArray.get("order_no") + "'	\n")
//						.append("AND order_detail_seq = '" 	+ jArray.get("order_detail_seq") + "' \n")
						.append("AND inspect_gubun like '" 	+ "%' \n")
						.append("AND lotno = '" + jArray.get("lotno") + "' \n")
						.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
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
				LoggingWriter.setLogError("M101S030100E994()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M101S030100E994()","==== finally ===="+ e.getMessage());
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
		//제품별 체크리스트
		public int E995(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
				// rcvData = [위경도]
//				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
				String sql = new StringBuilder()
						.append("SELECT distinct \n")
						.append("	1,\n")
						.append("	K.prod_cd,\n")
						.append("	P.product_nm,\n")
						.append("	A.checklist_cd,\n")
						.append("	standard_guide,\n")
						.append("	check_note,\n")
						.append("	standard_value,\n")
						.append("	B.item_type,\n")
						.append("	B.item_bigo,\n")
						.append("--	'<input type='''  ||  item_type || ''' id=''' || item_type || '1'''  || ' /input>' AS html_tag,\n")
						.append("	K.prod_cd_rev,\n")
						.append("	A.checklist_seq,\n")
						.append("	K.checklist_cd_rev,\n")
						.append("	A.item_cd,\n")
						.append("	B.item_desc,\n")
						.append("	A.item_seq,\n")
						.append("	A.item_cd_rev,\n")
						.append("	K.hangmok_code,\n")
						.append("	inspect_gubun,\n")
						.append("	C.code_name \n")
						.append("FROM vtbm_product_inspect_checklist K\n")
						.append("	INNER JOIN vtbm_checklist A\n")
						.append("	ON K.checklist_cd = A.checklist_cd\n")
						.append("	AND K.checklist_seq = A.checklist_seq\n")
						.append("	AND K.checklist_cd_rev = A.revision_no\n")
						.append("	AND K.member_key = A.member_key\n")
						.append("	INNER JOIN vtbm_check_item B\n")
						.append("	ON A.item_cd = B.item_cd\n")
						.append("	AND A.item_seq = B.item_seq\n")
						.append("	AND A.item_cd_rev = B.revision_no\n")
						.append("	AND A.member_key = B.member_key\n")
						.append("	INNER JOIN vtbm_product P\n")
						.append("	ON K.prod_cd = P.prod_cd\n")
						.append("	AND K.prod_cd_rev = P.revision_no\n")
						.append("	AND K.member_key = P.member_key\n")
						.append("	INNER JOIN v_checklist_gubun C\n")
						.append("	ON K.inspect_gubun = C.code_value\n")
						.append("	AND K.member_key = C.member_key\n")
						.append("WHERE K.prod_cd = '" 	+ jArray.get("prod_cd") + "'	\n")
						.append("	AND K.inspect_gubun LIKE '" 	+ jArray.get("inspect_gubun") + "%'	\n")
						.append("	AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
				LoggingWriter.setLogError("M101S030100E995()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M101S030100E995()","==== finally ===="+ e.getMessage());
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
