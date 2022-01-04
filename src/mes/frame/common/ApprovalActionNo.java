package mes.frame.common;

import java.sql.Connection;
import java.sql.SQLException;

import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
public class ApprovalActionNo extends SqlAdapter{

	int resultInt = -1;
	String[] reultSting;
	public String actionno="", maxno="";
	
	public ApprovalActionNo() {
		
	}
	
	public String getActionNo(Connection con, String jspPage,
							  String user_id, String prefix, 
							  String actionGubun, String member_key) {
		
		return getActionNo(con, jspPage, user_id, prefix, actionGubun, "1", member_key);
		
	}
	
	public String getActionNo(Connection con, String jspPage,
							  String user_id, String prefix, 
							  String actionGubun, String detail_seq, 
							  String member_key) {
		String sql = "";
		
		//import_inspect_seq 채번
		if(prefix.equals("DOC")) {	//문서번호 채번시에는 년도별 전체로 일련번호 채번
			sql = new StringBuilder()
				.append("SELECT \n")
				.append("	'" + prefix + "' || TO_CHAR(SYSDATE,'YY') || '-' || TO_CHAR(NVL(max(maxno),0)+1,'000000'), \n")
				.append("	NVL(max(maxno),0)+1			\n")
				.append("FROM tbi_approval_action 			\n")
				.append("WHERE TO_CHAR(action_date,'YY') = TO_CHAR(SYSDATE,'YY') \n")
				.append("  AND member_key='" + member_key + "' \n")
				.toString();
			
		} else if(prefix.equals("HACCP")) {	// 점검표번호 채번시에는 년도별 전체로 일련번호 채번
			sql = new StringBuilder()
					.append("SELECT \n")
					.append("	'" + prefix + "' || TO_CHAR(SYSDATE,'YY') || '-' || TO_CHAR(NVL(max(maxno),0)+1,'000000'), \n")
					.append("	NVL(max(maxno),0)+1			\n")
					.append("FROM tbi_approval_action 			\n")
					.append("WHERE TO_CHAR(action_date,'YY') = TO_CHAR(SYSDATE,'YY') \n")
					.append("  AND SUBSTR(actionno,0,5)='" + prefix + "' \n")
					.append("  AND member_key='" + member_key + "' \n")
					.toString();
				
		} else {	//기타 번호 채번시에는 요청하는 페이지 기준으로 년도별 일변번호 채번
			sql = new StringBuilder()
				.append("SELECT \n")
				.append("	'" + prefix + "' || TO_CHAR(SYSDATE,'YY') || '-' || TO_CHAR(NVL(max(maxno),0)+1,'000000'), \n")
				.append("	NVL(max(maxno),0)+1			\n")
				.append("FROM tbi_approval_action 			\n")
				.append("WHERE TO_CHAR(action_date,'YY') = TO_CHAR(SYSDATE,'YY') \n")
				.append("AND action_process='" + jspPage + "' \n")
				.append("AND member_key='" + member_key + "' \n")
				.toString();
		}
		
		try {
			reultSting = excuteQueryString(con, sql.toString()).split("\t");
			actionno = reultSting[0];
			maxno = reultSting[1];
			if (actionGubun.equals("")) {
				actionGubun = "Regist";
			}

			sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbi_approval_action (	\n")
				.append("		actionno,			\n")
				.append("		action_detail,		\n")
				.append("		action_process,		\n")
				.append("		action_date,		\n")
				.append("		action_lebel,		\n")
				.append("		maxno,				\n")
				.append("		user_id,			\n")
				.append("		member_key			\n")
				.append("	)\n")
				.append("VALUES ( 					\n")
				.append("	'" + actionno + "'	 	\n")
				.append("	,'1'	 				\n")
				.append("	,'" + jspPage + "' 		\n")
				.append("	,SYSDATE 				\n")
				.append("	,'" + actionGubun + "'	\n")
				.append("	,'" + maxno + "'	 	\n")
				.append("	,'" + user_id + "' 		\n")
				.append("	,'" + member_key + "' 	\n")
				.append(");\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return actionno;
	}

	public String getHaccpNo(Connection con, String jspPage,String user_id, String prefix, String actionGubun, String member_key) {
		// TODO Auto-generated constructor stub
		String sql="";
		//import_inspect_seq 채번
		if(prefix.equals("DOC")) {  //문서번호 채번시에는 년도별 전체로 일련번호 채번
			 sql = new StringBuilder()
					.append("SELECT \n")
					.append("	'" + prefix + "' || TO_CHAR(SYSDATE,'YYYYMMDD') || '-' || TO_CHAR(NVL(max(maxno),0)+1,'000000') \n")
					.append("	, NVL(max(maxno),0)+1			\n")
					.append("from tbi_approval_action 			\n")
					.append("where TO_CHAR(action_date,'YYYYMMDD') = TO_CHAR(SYSDATE,'YYYYMMDD') \n")
					.toString();
			 
		} else if(prefix.equals("HACCP")) {  
			 sql = new StringBuilder()
						.append("SELECT \n")
						.append("	'" + prefix + "' || TO_CHAR(SYSDATE,'YYYYMMDD') || '-' || TO_CHAR(NVL(max(maxno),0)+1,'000000') \n")
						.append("	, NVL(max(maxno),0)+1			\n")
						.append("from tbi_approval_action 			\n")
						.append("where TO_CHAR(action_date,'YYYYMMDD') = TO_CHAR(SYSDATE,'YYYYMMDD') \n")
						.toString();	
			 
		} else {		//기타 번호 채번시에는 요청하는 페이지 기준으로 년도별 일변번호 채번
		 sql = new StringBuilder()
				.append("SELECT \n")
				.append("	'" + prefix + "' || TO_CHAR(SYSDATE,'YYYYMMDD') || '-' || TO_CHAR(NVL(max(maxno),0)+1,'000000') \n")
				.append("	, NVL(max(maxno),0)+1			\n")
				.append("from tbi_approval_action 			\n")
				.append("where TO_CHAR(action_date,'YYYYMMDD') = TO_CHAR(SYSDATE,'YYYYMMDD') \n")
				.append("AND action_process='" + jspPage + "' \n")
				.toString();
		}
		try {
			reultSting 	= excuteQueryString(con, sql.toString()).split("\t");
			actionno 	= reultSting[0];
			maxno 	= reultSting[1];
			if (actionGubun.equals(""))
				actionGubun = "Regist";
			sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbi_approval_action (	\n")
				.append("		actionno,			\n")
				.append("		action_detail,			\n")
				.append("		action_process,		\n")
				.append("		action_date,		\n")
				.append("		action_lebel,		\n")
				.append("		maxno,				\n")
				.append("		user_id,			\n")
				.append("		member_key			\n")
				.append("	)\n")
				.append("VALUES ( 					\n")
				.append("	'" + actionno + "'	 	\n")
				.append("	,'1'	 	\n")
				.append("	,'" + jspPage + "' 		\n") //action_process(jsp Page)
				.append("	,SYSDATE 				\n")
				.append("	,'" + actionGubun + "'				\n")
				.append("	,'" + maxno + "'	 	\n")
				.append("	,'" + user_id + "' \n") //user_id
				.append("	,'" + member_key + "' \n") //user_id
				.append("	);\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return actionno;
	}	
	
	@Override
	protected int doExcute(InoutParameter ioParam) {
		// TODO Auto-generated method stub
		return 0;
	}
	@Override
	protected int custParamCheck(InoutParameter ioParam, StringBuffer p_sql) {
		// TODO Auto-generated method stub
		return 0;
	}

}
