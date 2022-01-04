package mes.frame.common;

import java.sql.Connection;
import java.sql.SQLException;

import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
public class QueueProcessing extends SqlAdapter{

	int resultInt = -1;
	String reultSting;
	
	public QueueProcessing() {
		
	}
	public String getCurrentPage_Status(Connection  con, String jspPage) {
		// TODO Auto-generated constructor stub
		String sql = new StringBuilder()
				.append("WITH GET_STATUS AS (			\n")
				.append("	SELECT						\n")
				.append("		class_id,				\n")
				.append("		prev_status,			\n")
				.append("		status_code,			\n")
				.append("		next_status				\n")
				.append("	FROM tbm_systemcode			\n")
				.append("  WHERE class_id='" + jspPage + "' \n")
				.append(")								\n")
				.append("	SELECT 						\n")
				.append("		B.class_id AS curr_page,\n")
				.append("		A.class_id AS prev_page,\n")
				.append("		A.prev_status AS prev_status,	\n")
				.append("		B.status_code AS curr_status,	\n")
				.append("		A.status_code,			\n")
				.append("		A.next_status			\n")
				.append("	FROM  tbm_systemcode A 		\n")
				.append("	INNER JOIN GET_STATUS B 	\n")
				.append("	ON A.status_code = B.prev_status	\n")
				.toString();

		try {
			reultSting 	= excuteQueryString(con, sql.toString());
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return reultSting;
	}
	public String QueryQueue(Connection con,String jspPage) {
		String sql = new StringBuilder()
				.append("SELECT								\n")
				.append("	next_status,					\n")
				.append("	prev_status, 					\n")
				.append("	status_code, 					\n")
				.append("	process_gubun 					\n")
				.append("FROM								\n")
				.append("	vtbm_systemcode					\n")
				.append("  WHERE class_id='" + jspPage + "' \n")
				.toString();
		reultSting = excuteQueryString(con, sql.toString());
		return reultSting;
	}
	
	public String NextPageclass_id(Connection  con, String status_code, String process_gubun) {
		String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	class_id	\n")
				.append("FROM\n")
				.append("	vtbm_systemcode\n")
				.append("  WHERE status_code = '" + status_code + "' \n")
				.append("  AND   process_gubun = '" + process_gubun + "' \n")
				.toString();
		reultSting 	= excuteQueryString(con, sql.toString());
		return reultSting;
	}

	public int setQueue(Connection  con, String jspPage, String orderNo, String OrderDetailSeq,String mainActionNo,  String reviewNo, String ConfirmNo, String IndGB) {
		String resultString = QueryQueue(con,jspPage);
		String[] Status 	= resultString.split("\t");
		String pStatus		= Status[Integer.parseInt( IndGB ) ];  //0:처리 , 1:반려
		String fromStatus 	= Status[Integer.parseInt( IndGB ) ];
		String Process_gubun		= Status[3];		//process_gubun  
		String NextPage="";
		if(IndGB.equals("0"))
			NextPage= NextPageclass_id(con,Status[0], Process_gubun).trim();
		else if(IndGB.equals("1")) {
			NextPage= NextPageclass_id(con,Status[1], Process_gubun).trim();
			
		}
		String sql = new StringBuilder()
				.append("MERGE  INTO tbi_queue  mm \n")
				.append("USING (\n")
				.append("  SELECT '" + orderNo 			+ "' as order_no		\n")
				.append("		,"   + OrderDetailSeq 	+ "	 as order_detail	\n")
				.append("		,'"  + NextPage 		+ "' as jspPage			\n")
				.append("		,'"  + pStatus 			+ "' as order_status	\n")
				.append("		,'"  + Process_gubun 			+ "' as process_gubun	\n")  //tbi_queue 에 process_gubun추가 후코멘트 풀것
				.append("		,'"  + fromStatus 		+ "' as from_status		\n")  //코멘트 풀것 
				.append("		,'"  + jspPage 			+ "' as from_class_id	\n")  //코멘트 풀것
				.append("		,'"  + mainActionNo 	+ "' as main_action_no	\n")  //코멘트 풀것
				.append("	FROM db_root  )  mQ	\n")
//				.append("ON (mm.order_no = mQ.order_no AND mm.order_detail = mQ.order_detail)\n")
				.append("ON (mm.order_no = mQ.order_no AND mm.order_detail = mQ.order_detail AND mm.process_gubun = mQ.process_gubun AND mm.main_action_no = mQ.main_action_no)\n") //코멘트 풀것
				.append("WHEN MATCHED THEN \n")
				.append("		UPDATE SET \n")
				.append("				mm.order_status		= mQ.order_status,	\n")
				.append("				mm.class_id			= mQ.jspPage,   	\n")
				.append("				mm.from_status		= mQ.from_status,	\n")
				.append("				mm.from_class_id	= mQ.from_class_id	\n") //보내기 전에 지꺼 저장함
				.append("WHEN NOT MATCHED THEN \n")
				.append("		INSERT  (mm.process_gubun,	mm.order_no,	mm.order_detail, mm.main_action_no, 	mm.order_status, mm.class_id, mm.from_status, mm.from_class_id)\n")
				.append(" 		VALUES  (mQ.process_gubun,	mQ.order_no,	mQ.order_detail, mQ.main_action_no,  	mQ.order_status, mQ.jspPage,  mQ.from_status, mQ.from_class_id)\n")
				.toString();
		
		resultInt = super.excuteUpdate(con, sql.toString());

		if (resultInt < 0) {
			try {
				con.rollback();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return EventDefine.E_DOEXCUTE_ERROR ;
		}
		
		
		sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbi_order_queue_log (	\n")
				.append("		order_no,			\n")
				.append("		order_detail_seq,	\n")
				.append("		order_status,		\n")
				.append("		action_process,		\n")
				.append("		main_action_no,		\n")
				.append("		review_action_no,	\n")
				.append("		confirm_action_no	\n")
				.append("	)	\n")
				.append("VALUES	\n")
				.append("	(	\n")
				.append("		'" + orderNo 		+ "',	\n") //OrderNo
				.append("		'" + OrderDetailSeq + "',	\n") //order_detail_seq
				.append("		'" + Status[2] 		+ "',	\n") //Current status_code
				.append("		'" + jspPage 		+ "',	\n") //action_process
				.append("		'" + mainActionNo 	+ "', 	\n") //main_action_no
				.append("		'" + reviewNo 		+ "',	\n") //review_action_no
				.append("		'" + ConfirmNo 		+ "' 	\n") //confirm_action_no
				.append("	);	\n")
				.toString();
		
		resultInt = super.excuteUpdate(con, sql.toString());

		if (resultInt < 0) {
			try {
				con.rollback();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return EventDefine.E_DOEXCUTE_ERROR ;
		}
		return resultInt;
	}
	//Lotno 추가하여 처리하는 Method
	public int setQueue(Connection  con, String jspPage, String orderNo, String OrderDetailSeq,String mainActionNo,  String reviewNo, 
			String ConfirmNo, String IndGB, String lotno, String member_key) {  //아래 
		String resultString = QueryQueue(con,jspPage);
		String[] Status 	= resultString.split("\t");
		String pStatus		= Status[Integer.parseInt( IndGB ) ];  //0:처리 , 1:반려
		String fromStatus 	= Status[Integer.parseInt( IndGB ) ];
		String Process_gubun		= Status[3];		//process_gubun  
		String NextPage="";
		if(IndGB.equals("0"))
			NextPage= NextPageclass_id(con,Status[0], Process_gubun).trim();
		else if(IndGB.equals("1")) {
			NextPage= NextPageclass_id(con,Status[1], Process_gubun).trim();
			
		}
		if(OrderDetailSeq.equals(null) || OrderDetailSeq.equals("")) OrderDetailSeq="1";
		String sql = new StringBuilder()
				.append("MERGE  INTO tbi_queue  mm \n")
				.append("USING (\n")
				.append("  SELECT '" + orderNo 			+ "' as order_no		\n")
				.append("		,'"  + lotno 			+ "' as lotno	\n")
				.append("		,"   + OrderDetailSeq 	+ "	 as order_detail	\n")
				.append("		,'"  + NextPage 		+ "' as jspPage			\n")
				.append("		,'"  + pStatus 			+ "' as order_status	\n")
				.append("		,'"  + Process_gubun 	+ "' as process_gubun	\n")  //tbi_queue 에 process_gubun추가 후코멘트 풀것
				.append("		,'"  + fromStatus 		+ "' as from_status		\n")  //코멘트 풀것 
				.append("		,'"  + jspPage 			+ "' as from_class_id	\n")  //코멘트 풀것
				.append("		,'"  + mainActionNo 	+ "' as main_action_no	\n")  //코멘트 풀것
				.append("		,'"  + member_key 		+ "' as member_key	\n")  //코멘트 풀것
				.append("	FROM db_root  )  mQ	\n")
				.append("ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.process_gubun = mQ.process_gubun "
						+ " AND mm.main_action_no 	= mQ.main_action_no"
						+ " AND mm.member_key 		= mQ.member_key)\n") //코멘트 풀것
				.append("WHEN MATCHED THEN \n")
				.append("		UPDATE SET \n")
				.append("				mm.order_status		= mQ.order_status,	\n")
				.append("				mm.class_id			= mQ.jspPage,   	\n")
				.append("				mm.from_status		= mQ.from_status,	\n")
				.append("				mm.from_class_id	= mQ.from_class_id	\n") //보내기 전에 지꺼 저장함
				.append("WHEN NOT MATCHED THEN \n")
				.append("	INSERT (mm.process_gubun, mm.order_no, mm.lotno, mm.main_action_no, mm.order_status, mm.class_id, mm.from_status"
						+ ", mm.from_class_id, mm.order_detail, mm.member_key )\n")
				.append(" 	VALUES (mQ.process_gubun, mQ.order_no, mQ.lotno, mQ.main_action_no, mQ.order_status, mQ.jspPage,  mQ.from_status"
						+ ", mQ.from_class_id, mQ.order_detail, mQ.member_key )\n")
				.toString();
		
		resultInt = super.excuteUpdate(con, sql.toString());

		if (resultInt < 0) {
			try {
				con.rollback();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return EventDefine.E_DOEXCUTE_ERROR ;
		}
		
		
		sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbi_order_queue_log (	\n")
				.append("		order_no,			\n")
				.append("		lotno,				\n")
				.append("		order_detail_seq,	\n")
				.append("		order_status,		\n")
				.append("		action_process,		\n")
				.append("		main_action_no,		\n")
				.append("		review_action_no,	\n")
				.append("		confirm_action_no,	\n")
				.append("		member_key	\n")
				.append("	)	\n")
				.append("VALUES	\n")
				.append("	(	\n")
				.append("		'" + orderNo 		+ "',	\n") //OrderNo
				.append("		'" + lotno 			+ "',	\n") //order_detail_seq
				.append("		'" + OrderDetailSeq + "',	\n") //order_detail_seq
				.append("		'" + Status[2] 		+ "',	\n") //Current status_code
				.append("		'" + jspPage 		+ "',	\n") //action_process
				.append("		'" + mainActionNo 	+ "', 	\n") //main_action_no
				.append("		'" + reviewNo 		+ "',	\n") //review_action_no
				.append("		'" + ConfirmNo 		+ "', 	\n") //confirm_action_no
				.append("		'" + member_key		+ "' 	\n") //member_key
				.append("	);	\n")
				.toString();
		
		resultInt = super.excuteUpdate(con, sql.toString());

		if (resultInt < 0) {
			try {
				con.rollback();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return EventDefine.E_DOEXCUTE_ERROR ;
		}
		return resultInt;
	}
	
	//처리 단위 지정하여 처리
//	처리단위(tbi_queue.process_unit):
//	기본 데이터: Connection  con, String jspPage, String orderNo, String lotno, String reviewNo:있으면 넣고 없으면 "", String ConfirmNo:있으면 넣고 없으면 ""
//	전후 처리: String IndGB : //0:처리 , 1:반려
//	process_unit: 	L(LotNo단위로 처리) 			String mainActionNo=lotno
//					D(Order_Detail_seq단위로 처리) 	String mainActionNo=Order_Detail_seq
//					S(product_serialNo단위로 처리) 	String mainActionNo=product_serialNo
//					B(balju_no단위로 처리) 			String mainActionNo=balju_no
//					D(Order_Detail_seq단위로 처리) 	String mainActionNo=Order_Detail_seq
		public int setQueue_process_unit(Connection  con, String jspPage, String orderNo, String OrderDetailSeq,String mainActionNo,  String reviewNo, 
				String ConfirmNo, String IndGB, String lotno, String process_unit) {
			String resultString = QueryQueue(con,jspPage);
			String[] Status 	= resultString.split("\t");
			String pStatus		= Status[Integer.parseInt( IndGB ) ];  //0:처리 , 1:반려
			String fromStatus 	= Status[Integer.parseInt( IndGB ) ];
			String Process_gubun		= Status[3];		//process_gubun  
			String NextPage="";
			if(IndGB.equals("0"))
				NextPage= NextPageclass_id(con,Status[0], Process_gubun).trim();
			else if(IndGB.equals("1")) {
				NextPage= NextPageclass_id(con,Status[1], Process_gubun).trim();
				
			}
			if(OrderDetailSeq.equals(null) || OrderDetailSeq.equals("")) OrderDetailSeq="1";
			String sql = new StringBuilder()
					.append("MERGE  INTO tbi_queue  mm \n")
					.append("USING (\n")
					.append("  SELECT '" + orderNo 			+ "' as order_no		\n")
					.append("		,'"  + lotno 			+ "' as lotno	\n")
					.append("		,"   + OrderDetailSeq 	+ "	 as order_detail	\n")
					.append("		,'"  + NextPage 		+ "' as jspPage			\n")
					.append("		,'"  + pStatus 			+ "' as order_status	\n")
					.append("		,'"  + Process_gubun 	+ "' as process_gubun	\n")  //tbi_queue 에 process_gubun추가 후코멘트 풀것
					.append("		,'"  + fromStatus 		+ "' as from_status		\n")  //코멘트 풀것 
					.append("		,'"  + jspPage 			+ "' as from_class_id	\n")  //코멘트 풀것
					.append("		,'"  + mainActionNo 	+ "' as main_action_no	\n")  //코멘트 풀것
					.append("		,'"  + process_unit 	+ "' as process_unit	\n")  //코멘트 풀것
					.append("	FROM db_root  )  mQ	\n")
					.append("ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.process_gubun = mQ.process_gubun AND "
							+ "  mm.main_action_no = mQ.main_action_no AND mm.process_unit = mQ.process_unit ) \n") //코멘트 풀것
					.append("WHEN MATCHED THEN \n")
					.append("		UPDATE SET \n")
					.append("				mm.order_status		= mQ.order_status,	\n")
					.append("				mm.class_id			= mQ.jspPage,   	\n")
					.append("				mm.from_status		= mQ.from_status,	\n")
					.append("				mm.from_class_id	= mQ.from_class_id	\n") //보내기 전에 지꺼 저장함
					.append("WHEN NOT MATCHED THEN \n")
					.append("	INSERT (mm.process_gubun, mm.order_no, mm.lotno, mm.main_action_no, mm.process_unit, mm.order_status, mm.class_id, mm.from_status, mm.from_class_id, mm.order_detail )\n")
					.append(" 	VALUES (mQ.process_gubun, mQ.order_no, mQ.lotno, mQ.main_action_no, mQ.process_unit, mQ.order_status, mQ.jspPage,  mQ.from_status, mQ.from_class_id, mQ.order_detail )\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());

			if (resultInt < 0) {
				try {
					con.rollback();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			
			sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbi_order_queue_log (	\n")
					.append("		order_no,			\n")
					.append("		lotno,			\n")
					.append("		order_detail_seq,	\n")
					.append("		order_status,		\n")
					.append("		action_process,		\n")
					.append("		main_action_no,		\n")
					.append("		process_unit,		\n")
					.append("		review_action_no,	\n")
					.append("		confirm_action_no	\n")
					.append("	)	\n")
					.append("VALUES	\n")
					.append("	(	\n")
					.append("		'" + orderNo 		+ "',	\n") //OrderNo
					.append("		'" + lotno + "',	\n") //order_detail_seq
					.append("		'" + OrderDetailSeq + "',	\n") //order_detail_seq
					.append("		'" + Status[2] 		+ "',	\n") //Current status_code
					.append("		'" + jspPage 		+ "',	\n") //action_process
					.append("		'" + mainActionNo 	+ "', 	\n") //main_action_no
					.append("		'" + reviewNo 		+ "',	\n") //review_action_no
					.append("		'" + ConfirmNo 		+ "' 	\n") //confirm_action_no
					.append("		'" + process_unit	+ "' 	\n") //process_unit
					.append("	);	\n") 
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());

			if (resultInt < 0) {
				try {
					con.rollback();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			return resultInt;
		}
		
		
	//Lotno 추가하여 처리하는 Method
	//제품단위로 Queue Flow처리하는
	public int setQueue_detail(Connection  con, String jspPage, String orderNo, String OrderDetailSeq,String mainActionNo,  String reviewNo, 
			String ConfirmNo, String IndGB, String lotno, String member_key) {
		String resultString = QueryQueue(con,jspPage);
		String[] Status 	= resultString.split("\t");
		String pStatus		= Status[Integer.parseInt( IndGB ) ];  //0:처리 , 1:반려
		String fromStatus 	= Status[Integer.parseInt( IndGB ) ];
		String Process_gubun		= Status[3];		//process_gubun  
		String NextPage="";
		if(IndGB.equals("0"))
			NextPage= NextPageclass_id(con,Status[0], Process_gubun).trim();
		else if(IndGB.equals("1")) {
			NextPage= NextPageclass_id(con,Status[1], Process_gubun).trim();
			
		}
		if(OrderDetailSeq.equals(null) || OrderDetailSeq.equals("")) OrderDetailSeq="1";
		String sql = new StringBuilder()
				.append("MERGE  INTO tbi_queue  mm \n")
				.append("USING (\n")
				.append("  SELECT '" + orderNo 			+ "' as order_no		\n")
				.append("		,'"  + lotno 			+ "' as lotno	\n")
				.append("		,"   + OrderDetailSeq 	+ "	 as order_detail	\n")
				.append("		,'"  + NextPage 		+ "' as jspPage			\n")
				.append("		,'"  + pStatus 			+ "' as order_status	\n")
				.append("		,'"  + Process_gubun 			+ "' as process_gubun	\n")  //tbi_queue 에 process_gubun추가 후코멘트 풀것
				.append("		,'"  + fromStatus 		+ "' as from_status		\n")  //코멘트 풀것 
				.append("		,'"  + jspPage 			+ "' as from_class_id	\n")  //코멘트 풀것
				.append("		,'"  + mainActionNo 	+ "' as main_action_no	\n")  //코멘트 풀것
				.append("		,'"  + member_key 		+ "' as member_key	\n")  //코멘트 풀것
				.append("	FROM db_root  )  mQ	\n")
				.append("ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.order_detail = mQ.order_detail "
						+ "AND mm.process_gubun = mQ.process_gubun AND mm.main_action_no = mQ.main_action_no"
						+ " AND mm.member_key = mQ.member_key )\n") //코멘트 풀것
				.append("WHEN MATCHED THEN \n")
				.append("		UPDATE SET \n")
				.append("				mm.order_status		= mQ.order_status,	\n")
				.append("				mm.class_id			= mQ.jspPage,   	\n")
				.append("				mm.from_status		= mQ.from_status,	\n")
				.append("				mm.from_class_id	= mQ.from_class_id	\n") //보내기 전에 지꺼 저장함
				.append("WHEN NOT MATCHED THEN \n")
				.append("	INSERT (mm.process_gubun, mm.order_no, mm.lotno, mm.order_detail, mm.main_action_no, mm.order_status, mm.class_id, mm.from_status, mm.from_class_id, mm.member_key)\n")
				.append(" 	VALUES (mQ.process_gubun, mQ.order_no, mQ.lotno, mQ.order_detail, mQ.main_action_no, mQ.order_status, mQ.jspPage,  mQ.from_status, mQ.from_class_id, mQ.member_key)\n")
				.toString();
		
		resultInt = super.excuteUpdate(con, sql.toString());

		if (resultInt < 0) {
			try {
				con.rollback();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return EventDefine.E_DOEXCUTE_ERROR ;
		}
		
		
		sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbi_order_queue_log (	\n")
				.append("		order_no,			\n")
				.append("		lotno,			\n")
				.append("		order_detail_seq,	\n")
				.append("		order_status,		\n")
				.append("		action_process,		\n")
				.append("		main_action_no,		\n")
				.append("		review_action_no,	\n")
				.append("		confirm_action_no	\n")
				.append("	)	\n")
				.append("VALUES	\n")
				.append("	(	\n")
				.append("		'" + orderNo 		+ "',	\n") //OrderNo
				.append("		'" + lotno + "',	\n") //order_detail_seq
				.append("		'" + OrderDetailSeq + "',	\n") //order_detail_seq
				.append("		'" + Status[2] 		+ "',	\n") //Current status_code
				.append("		'" + jspPage 		+ "',	\n") //action_process
				.append("		'" + mainActionNo 	+ "', 	\n") //main_action_no
				.append("		'" + reviewNo 		+ "',	\n") //review_action_no
				.append("		'" + ConfirmNo 		+ "' 	\n") //confirm_action_no
				.append("	);	\n")
				.toString();
		
		resultInt = super.excuteUpdate(con, sql.toString());

		if (resultInt < 0) {
			try {
				con.rollback();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return EventDefine.E_DOEXCUTE_ERROR ;
		}
		return resultInt;
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
