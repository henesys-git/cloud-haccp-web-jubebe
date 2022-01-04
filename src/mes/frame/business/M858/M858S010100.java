package mes.frame.business.M858;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser; 
import org.json.simple.parser.ParseException;

import mes.client.conf.Config;
import mes.client.guiComponents.DoyosaeTableModel;
import mes.client.guiComponents.VectorToJson;
import mes.client.util.ChulhaNumberGenerator;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M858S010100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M858S010100(){
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
	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M858S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M858S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M858S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M858S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M858S010100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	/* 
	 * 출하 등록 쿼리 (원우푸드)
	 * 1. IF vehicle != null -> 차량 관련 정보도 입력
	 * 	  ELSE -> 차량 관리 안함
	 * 1-1. P박스 출고 처리  (vehicleNote)
	 * 2. 출하정보 등록 
	 * 3. 완제품 재고 반영 (재고 생산일자에 따른 선입선출 반영)
	 * 4. 주문정보 납품상태 변경
	 * */
	public int E101(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject rcvData = new JSONObject();
    		rcvData = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String chulhaNum = ChulhaNumberGenerator.generateChulhaNum();

    		JSONObject orders = (JSONObject) rcvData.get("orders"); 
    		
    		JSONObject vehicle; 
    		
    		List allUsedList = new ArrayList();
    		List allUsedList3 = new ArrayList();
    		//JSONObject allUsedList2 = new JSONObject();
    		//System.out.println("======allUsedList2 1st : " +allUsedList2);
    		
    		
    		if(rcvData.get("vehicle") != null) {
    			vehicle = (JSONObject) rcvData.get("vehicle");
    			
    			sql = new StringBuilder()
    					.append("INSERT INTO														\n")
    					.append("	tbi_vehicle_log (												\n")
    					.append("		vehicle_cd,													\n")
    					.append("		vehicle_rev_no,												\n")
    					.append("		operation_date												\n")
    					.append("	)																\n")
    					.append("VALUES																\n")
    					.append("	(																\n")
    					.append("		'" + vehicle.get("vehicleCd") + "',							\n")
    					.append("		(SELECT MAX(vehicle_rev_no)									\n")
    					.append("		 FROM tbm_vehicle A											\n")
    					.append("		 WHERE A.vehicle_cd = '" + vehicle.get("vehicleCd") + "'),	\n")
    					.append("		SYSDATE														\n")
    					.append("	);																\n")
    					.toString();
    			
    			resultInt = super.excuteUpdate(con, sql);
    			if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR;
    			}
    			
    			sql = new StringBuilder()
    					.append("INSERT INTO														\n")
    					.append("	tbi_vehicle_log_detail (										\n")
    					.append("		chulha_no,													\n")
    					.append("		chulha_rev_no,												\n")
    					.append("		vehicle_cd,													\n")
    					.append("		vehicle_rev_no,												\n")
    					.append("		operation_date,												\n")
    					.append("		user_id,													\n")
    					.append("		user_rev_no													\n")
    					.append("	)																\n")
    					.append("VALUES																\n")
    					.append("	(																\n")
    					.append("		" + chulhaNum + ",											\n")
    					.append("		0,															\n")
    					.append("		'" + vehicle.get("vehicleCd") + "',							\n")
    					.append("		(SELECT MAX(vehicle_rev_no)									\n")
    					.append("		 FROM tbm_vehicle A											\n")
    					.append("		 WHERE A.vehicle_cd = '" + vehicle.get("vehicleCd") + "'),	\n")
    					.append("		SYSDATE,													\n")
    					.append("		'" + vehicle.get("vehicleDriver") + "',						\n")
    					.append("		(SELECT MAX(revision_no)									\n")
    					.append("		 FROM tbm_users 											\n")
    					.append("		 WHERE user_id = '" + vehicle.get("vehicleDriver") + "')	\n")
    					.append("	);																\n")
    					.toString();
    			
    			resultInt = super.excuteUpdate(con, sql);
    			if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR;
    			}
    			
    			sql = new StringBuilder()
    					.append("UPDATE tbi_part_storage2 									\n")
    					.append("SET 														\n")
    					.append("	pre_amt = post_amt, 									\n")
    					.append("	io_amt = "+ vehicle.get("vehicleNote") +", 				\n")
    					.append("	post_amt = post_amt - "+ vehicle.get("vehicleNote") +"	\n")
    					.append("WHERE trace_key = '20210512105110'							\n")
    					.append("	AND part_cd = 'B029' 									\n")
    					.append("	AND part_rev_no = 0;									\n")
    					.append("-- trace key는 원부재료 최초 입고 시 랜덤 생성되는 값이라서					\n")
    					.append("-- p박스 최초 생성 시 받은 trace_key를 계속 사용한다						\n")
    					.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
		    		
	    		sql = new StringBuilder()
    				.append("INSERT INTO tbi_part_chulgo2 (							                            \n")
    				.append("	part_cd, 										                                \n")
    				.append("	part_rev_no, 								                                    \n")
    				.append("	trace_key, 									                                    \n")
    				.append("	chulgo_date, 								                                    \n")
    				.append("	chulgo_time, 								                                    \n")
    				.append("	chulgo_amount, 							                                        \n")
    				.append("	chulgo_type, 								                                   	\n")
    				.append("	note												                            \n")
    				.append(") VALUES (										                                    \n")
    				.append("	'B029', 										                                \n")
    				.append("	0, 													                            \n")
    				.append("	'20210512105110', 					                                        	\n")
    				.append("	SYSDATE, 										                                \n")
    				.append("	SYSTIME, 										                                \n")
    				.append("	"+ vehicle.get("vehicleNote") +", 					                          	\n")
    				.append("	'제품출하_' + '"+ vehicle.get("vehicleLocationNm") +"' ,								\n")
    				.append("	SELECT user_nm 										                            \n")
    				.append("	FROM tbm_users										                            \n")
    				.append("	WHERE user_id = '" + vehicle.get("vehicleDriver") + "'	              			\n")
    				.append("	  AND revision_no = (SELECT MAX(revision_no) 			                    	\n")
    				.append("						 FROM tbm_users												\n")
    				.append("						 WHERE user_id = '" + vehicle.get("vehicleDriver") + "')	\n")
    				.append(");																					\n")
					.toString();

		    	resultInt = super.excuteUpdate(con, sql);
		    	if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
    		}
    		
    		for(int i = 0; i < orders.size(); i++) {
    			JSONObject order = (JSONObject) orders.get(String.valueOf(i));
    			JSONObject head = (JSONObject) order.get("paramHead");
    			JSONArray body = (JSONArray) order.get("param");
    			JSONArray body2 = (JSONArray) order.get("param2");
    			
    			
    			sql = new StringBuilder()
    					.append("UPDATE tbi_order2 										\n")
    					.append("SET delivery_yn = 'Y' 									\n")
    					.append("WHERE order_no = '" + head.get("orderNo") + "'			\n")
    					.append("  AND order_rev_no = " + head.get("orderRevNo") + "	\n")
    					.toString();

				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
			    	System.out.println("E101 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
    			
    			sql = new StringBuilder()
    					.append("INSERT INTO tbi_chulha (				\n")
    					.append("	chulha_no,							\n")
    					.append("	chulha_rev_no,						\n")
    					.append("	chulha_date,						\n")
    					.append("	order_no,							\n")
    					.append("	order_rev_no,						\n")
    					.append("	note,								\n")
    					.append("	delyn								\n")
    					.append(")										\n")
    					.append("VALUES (								\n")
    					.append("	" + chulhaNum + ",					\n")
    					.append("	0,									\n")
    					.append("	SYSDATE,							\n")
    					.append("	'" + head.get("orderNo") + "',		\n")
    					.append("	'" + head.get("orderRevNo") + "',	\n")
    					.append("	'" + head.get("chulhaNote") + "',	\n")
    					.append("	'N'									\n")
    					.append(");										\n")
    					.toString();
    	    		
				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
		    		
				for(int j = 0; j < body.size(); j++) {
					JSONObject eachRow = (JSONObject) body.get(j); // i번째 데이터묶음
					int chulhaCount = Integer.parseInt(eachRow.get("chulhaCount").toString());
					String prodCd = eachRow.get("prodCd").toString();
					
					JSONObject jArray = new JSONObject();
	    			jArray.put("prod_cd", prodCd);
	    			
	    			System.out.println("=========for1 chulhaCount :" + chulhaCount);
	    			
	    			
	    			DoyosaeTableModel table = new DoyosaeTableModel("M858S010100E214", jArray); //재고 정보를 가져온 것
	    			
	    			
	    			int body3 = table.getVectorSize();
					
					while(chulhaCount > 0) {	// 잔여 출하량이 0이 될 때까지 재고 테이블 조회/비교/차감
						for (int k = 0; k < body3; k++) { //완제품 재고 테이블 데이터 배열 결과 수만큼 for문 돌림
						System.out.println("=========while chulhaCount :" + chulhaCount);	
							//JSONObject eachRow2 = (JSONObject) body2.get(k); // k번째 데이터묶음
						
							String storage_prodDate = table.getValueAt(k, 0).toString(); //완제품 재고 생산일자
							String storage_prodCd = table.getValueAt(k, 1).toString(); //완제품 재고 제품코드
							int storage_postAmt = Integer.parseInt(table.getValueAt(k, 3).toString()); //완제품 재고 재고량
							int storage_seqNo = Integer.parseInt(table.getValueAt(k, 4).toString()); //완제품 재고 일련번호
							int storage_prodRevNo = Integer.parseInt(table.getValueAt(k, 2).toString()); //완제품 재고 수정이력번호
							int remain_chulhaCount = 0; //잔여 출하량
							int remain_storage_postAmt = 0; //잔여 재고량
							
							for(int l = 0; l < k; l++) {
							boolean aa = allUsedList.contains(prodCd+l);
							allUsedList3.add(aa);
							System.out.println("======allUsedList3 :" +allUsedList3);
							}
							
							//두 완제품 제품코드가 서로 같으면
							if(prodCd.equals(storage_prodCd) && !allUsedList.contains(prodCd+k)) {
							//if(prodCd.equals(storage_prodCd) && allUsedList2.containsValue(prodCd+k) == false) {
							//if(prodCd.equals(storage_prodCd) && !allUsedList3.contains(true)) {
								
								remain_chulhaCount = chulhaCount - storage_postAmt; //출하량 -재고량시 남는 출하량
								remain_storage_postAmt = storage_postAmt - chulhaCount; //재고량 - 출하량시 남는 재고량
								
								System.out.println("storage_postAmt"+storage_postAmt);
								System.out.println("remain_chulhaCount" + remain_chulhaCount);
								
								//출하량 - 재고량이 0보다 클때, 즉 재고량이 출고량보다 부족할때
								if(remain_chulhaCount > 0) {
									System.out.println("@@@@@@@@@@@@@@@@@@ if : 재고량 부족 @@@@@@@@@@");
								//System.out.println("======allUsedList2 2nd : " +allUsedList2);
								//System.out.println("======allUsedList2 2nd result : " + !allUsedList2.containsValue(prodCd+k));
									//출하 상세 테이블에 반영한다.
									sql = new StringBuilder()
											.append("INSERT INTO tbi_chulha_detail (			\n")
											.append("	chulha_no,								\n")
											.append("	chulha_rev_no,							\n")
											.append("   order_no, 								\n")
											.append("   order_rev_no, 							\n")
											.append("	prod_date,								\n")
											.append("	seq_no,									\n")
											.append("	prod_cd,								\n")
											.append("	prod_rev_no,							\n")
											.append("	chulha_count,							\n")
											.append("	note									\n")
											.append(")											\n")
											.append("VALUES ( 									\n")
											.append("	" + chulhaNum + ",						\n")
											.append("	0,										\n")
											.append("	'" + head.get("orderNo") + "',			\n")
											.append("	'" + head.get("orderRevNo") + "',		\n")
											.append("	'" + storage_prodDate + "',				\n")
											.append("	'" + storage_seqNo + "',				\n")
											.append("	'" + storage_prodCd + "',				\n")
											.append("	'" + storage_prodRevNo + "',			\n")
											.append("	'" + storage_postAmt + "',				\n")
											.append("	'" + eachRow.get("note") + "'			\n")
											.append(");											\n")
											.toString();
									
									resultInt = super.excuteUpdate(con, sql);
									if (resultInt < 0) {
										ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
										con.rollback();
										return EventDefine.E_DOEXCUTE_ERROR ;
									}
						
									//완제품 재고 테이블 반영
									sql = new StringBuilder()
											.append("UPDATE tbi_prod_storage2					\n")
											.append("SET 										\n")
											.append("	pre_amt = post_amt,						\n")
											.append("	io_amt = - "+storage_postAmt+",			\n")
											.append("	post_amt = post_amt - "+storage_postAmt+"\n")
											.append("WHERE prod_date = '"+storage_prodDate+"'	\n")
											.append("  AND seq_no = "+storage_seqNo+"			\n")
											.append("  AND prod_cd = '"+storage_prodCd+"'		\n")
											.append("  AND prod_rev_no = "+storage_prodRevNo+"	\n")
											.toString();
		
									resultInt = super.excuteUpdate(con, sql);
									if (resultInt < 0) {
										ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
										con.rollback();
										return EventDefine.E_DOEXCUTE_ERROR;
									}
							
									//완제품 출고 테이블 반영
									sql = new StringBuilder()
											.append("INSERT INTO tbi_prod_chulgo2 (			\n")
											.append("	prod_date,							\n")
											.append("	seq_no,								\n")
											.append("	prod_cd,							\n")
											.append("	prod_rev_no,						\n")
											.append("	chulgo_date,						\n")
											.append("	chulgo_time,						\n")
											.append("	chulgo_amount,						\n")
											.append("	chulgo_type,						\n")
											.append("	note								\n")
											.append(")										\n")
											.append("VALUES (								\n")
											.append("	'"+storage_prodDate+"',				\n")
											.append("	"+storage_seqNo+",					\n")
											.append("	'"+storage_prodCd+"',				\n")
											.append("	"+storage_prodRevNo+",				\n")
											.append("	SYSDATE,							\n")
											.append("	SYSTIME,							\n")
											.append("	"+storage_postAmt+",				\n")
											.append("	'"+head.get("chulgo_type")+"',		\n")
											.append("	''									\n")
											.append(");										\n")
											.toString();
						        		
									resultInt = super.excuteUpdate(con, sql);
									if (resultInt < 0) {
										ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
										con.rollback();
										return EventDefine.E_DOEXCUTE_ERROR;
									}
										
									chulhaCount = Math.abs(remain_chulhaCount);
									allUsedList.add(prodCd+k); // 해당 생산일자의 재고가 다 소진됐을 떄 index number를 List에 담는다.
									//allUsedList2.put(prodCd+k, prodCd+k);
									
								}
								
								//출하량 - 재고량이 0보다 같거나 작을때, 즉 재고량이 출하량보다 많을 떄	
								 else {
									 System.out.println("@@@@@@@@@@@@@@@@@@ else : 재고량 충분 @@@@@@@@@@");
									//출하 상세 테이블에 반영한다.
									sql = new StringBuilder()
											.append("INSERT INTO tbi_chulha_detail (			\n")
											.append("	chulha_no,								\n")
											.append("	chulha_rev_no,							\n")
											.append("   order_no, 								\n")
											.append("   order_rev_no, 							\n")
											.append("	prod_date,								\n")
											.append("	seq_no,									\n")
											.append("	prod_cd,								\n")
											.append("	prod_rev_no,							\n")
											.append("	chulha_count,							\n")
											.append("	note									\n")
											.append(")											\n")
											.append("VALUES ( 									\n")
											.append("	" + chulhaNum + ",						\n")
											.append("	0,										\n")
											.append("	'" + head.get("orderNo") + "',			\n")
											.append("	'" + head.get("orderRevNo") + "',		\n")
											.append("	'" + storage_prodDate + "',				\n")
											.append("	'" + storage_seqNo + "',				\n")
											.append("	'" + storage_prodCd + "',				\n")
											.append("	'" + storage_prodRevNo + "',			\n")
											.append("	'" + chulhaCount + "',					\n")
											.append("	'" + eachRow.get("note") + "'			\n")
											.append(");											\n")
											.toString();
									
									resultInt = super.excuteUpdate(con, sql);
									if (resultInt < 0) {
										ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
										con.rollback();
										return EventDefine.E_DOEXCUTE_ERROR ;
									}
						
									//완제품 재고 테이블 반영
									sql = new StringBuilder()
											.append("UPDATE tbi_prod_storage2					\n")
											.append("SET 										\n")
											.append("	pre_amt = post_amt,						\n")
											.append("	io_amt = - "+chulhaCount+",				\n")
											.append("	post_amt = post_amt - "+chulhaCount+"	\n")
											.append("WHERE prod_date = '"+storage_prodDate+"'	\n")
											.append("  AND seq_no = "+storage_seqNo+"			\n")
											.append("  AND prod_cd = '"+storage_prodCd+"'		\n")
											.append("  AND prod_rev_no = "+storage_prodRevNo+"	\n")
											.toString();
		
									resultInt = super.excuteUpdate(con, sql);
									if (resultInt < 0) {
										ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
										con.rollback();
										return EventDefine.E_DOEXCUTE_ERROR;
									}
						
									//완제품 출고 테이블 반영
									sql = new StringBuilder()
											.append("INSERT INTO tbi_prod_chulgo2 (			\n")
											.append("	prod_date,							\n")
											.append("	seq_no,								\n")
											.append("	prod_cd,							\n")
											.append("	prod_rev_no,						\n")
											.append("	chulgo_date,						\n")
											.append("	chulgo_time,						\n")
											.append("	chulgo_amount,						\n")
											.append("	chulgo_type,						\n")
											.append("	note								\n")
											.append(")										\n")
											.append("VALUES (								\n")
											.append("	'"+storage_prodDate+"',				\n")
											.append("	"+storage_seqNo+",					\n")
											.append("	'"+storage_prodCd+"',				\n")
											.append("	"+storage_prodRevNo+",				\n")
											.append("	SYSDATE,							\n")
											.append("	SYSTIME,							\n")
											.append("	"+chulhaCount+",					\n")
											.append("	'"+head.get("chulgo_type")+"',		\n")
											.append("	''									\n")
											.append(");										\n")
											.toString();
					        		
									resultInt = super.excuteUpdate(con, sql);
									if (resultInt < 0) {
										ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
										con.rollback();
										return EventDefine.E_DOEXCUTE_ERROR;
									}
									chulhaCount = 0;
									break;
								}
								
							}//for In if end
							/*
							else {
							//continue;
							chulhaCount = 0;
							}
							*/
					
						}// for(k) end
						//allUsedList.clear();
					}//while end
					
				}// for(j) end
				
    		}// for(i) end
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S010100E101()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E101()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E101 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam
	// 출하 수정
	// 기존 등록된 정보를 삭제하고 재등록 
	public int E102(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject rcvData = new JSONObject();
    		rcvData = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		JSONObject orders = (JSONObject) rcvData.get("orders");
    		JSONObject deleteInfo1 = (JSONObject) rcvData.get("deleteInfo1");
    		JSONObject deleteInfo2 = (JSONObject) rcvData.get("deleteInfo2");
			JSONObject vehicle; 
    		
    		List allUsedList = new ArrayList();
    		List allUsedList3 = new ArrayList();
    		//JSONObject allUsedList2 = new JSONObject();
    		//System.out.println("======allUsedList2 1st : " +allUsedList2);
    		
    		vehicle = (JSONObject) rcvData.get("vehicle");
    		
    		//차량 운행정보 상세 삭제
        	sql = new StringBuilder()
        			.append("DELETE FROM  													\n")
        			.append("tbi_vehicle_log_detail 										\n")
        			.append("WHERE vehicle_cd = '"+ vehicle.get("vehicleCd") +"'   			\n")
        			.append("AND vehicle_rev_no =  		(SELECT MAX(revision_no) 			\n")
        			.append("		 					FROM tbm_users 						\n")
        			.append("		 					WHERE user_id = '" + vehicle.get("vehicleDriver") + "')	\n")
        			.append("AND chulha_no = '"+ deleteInfo1.get("chulhaNo") +"'   				\n")
        			.append("AND chulha_rev_no =  '"+ deleteInfo1.get("chulhaRevNo") +"' 		\n")
        			.append("AND operation_date =  '"+ deleteInfo1.get("chulhaDate") +"' 		\n")
        			.toString();

        			resultInt = super.excuteUpdate(con, sql);
            		if (resultInt < 0) {
        				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        				con.rollback();
        		    	System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
        				return EventDefine.E_DOEXCUTE_ERROR ;
        			}
    		
    		
    		
    		//차량 운행정보 삭제
    		sql = new StringBuilder()
    				.append("DELETE FROM  												\n")
    				.append("tbi_vehicle_log 											\n")
    				.append("WHERE vehicle_cd = '"+  vehicle.get("vehicleCd") +"'   	\n")
    				.append("AND vehicle_rev_no =  		(SELECT MAX(revision_no) 			\n")
        			.append("		 					FROM tbm_users 						\n")
        			.append("		 					WHERE user_id = '" + vehicle.get("vehicleDriver") + "')	\n")
    				.append("AND operation_date =  '"+ deleteInfo1.get("chulhaDate") +"' 	\n")
    				.toString();

    			resultInt = super.excuteUpdate(con, sql);
        		if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    		    	System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    		
    		
        	//출하 상세 테이블 삭제
            sql = new StringBuilder()
                     .append("DELETE FROM  												\n")
                     .append("tbi_chulha_detail											\n")
                     .append("WHERE chulha_no = '"+ deleteInfo1.get("chulhaNo") +"'   		\n")
                     .append("AND chulha_rev_no =  '"+ deleteInfo1.get("chulhaRevNo") +"' 	\n")
                     .toString();

                   resultInt = super.excuteUpdate(con, sql);
                   if (resultInt < 0) {
                	   ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
                	   con.rollback();
                	   System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
                	   return EventDefine.E_DOEXCUTE_ERROR ;
                   }	
        		
            
            
            //출하 테이블  삭제여부(delyn) = 'Y'로 update
            sql = new StringBuilder()
                	.append("UPDATE  													\n")
                	.append("tbi_chulha SET												\n")
                	.append("delyn = 'Y'												\n")
                	.append("WHERE chulha_no = '"+ deleteInfo1.get("chulhaNo") +"'   		\n")
                	.append("AND chulha_rev_no =  '"+ deleteInfo1.get("chulhaRevNo") +"' 	\n")
                	.toString();

                	resultInt = super.excuteUpdate(con, sql);
                    if (resultInt < 0) {
                		 ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
                		 con.rollback();
                		 System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
                		 return EventDefine.E_DOEXCUTE_ERROR ;
                	}
               
              int pBoxCount = Integer.parseInt(vehicle.get("beforeVehicleNote").toString());  
              int setoffPBoxCount = 0 - pBoxCount;      
                    
                    
                  //pbox가 출고된 수량 만큼 다시 insert 해준다.
					sql = new StringBuilder()
							.append("INSERT INTO tbi_part_chulgo2 (							                            \n")
		    				.append("	part_cd, 										                                \n")
		    				.append("	part_rev_no, 								                                    \n")
		    				.append("	trace_key, 									                                    \n")
		    				.append("	chulgo_date, 								                                    \n")
		    				.append("	chulgo_time, 								                                    \n")
		    				.append("	chulgo_amount, 							                                        \n")
		    				.append("	chulgo_type, 								                                   	\n")
		    				.append("	note												                            \n")
		    				.append(") VALUES (										                                    \n")
		    				.append("	'B029', 										                                \n")
		    				.append("	0, 													                            \n")
		    				.append("	'20210512105110', 					                                        	\n")
		    				.append("	SYSDATE, 										                                \n")
		    				.append("	SYSTIME, 										                                \n")
		    				.append("	'"+ setoffPBoxCount +"', 					                        			\n")
		    				.append("	'제품출하_' + '"+ vehicle.get("vehicleLocationNm") +"' ,							\n")
		    				.append("	SELECT user_nm 										                            \n")
		    				.append("	FROM tbm_users										                            \n")
		    				.append("	WHERE user_id = '" + vehicle.get("vehicleDriver") + "'	              			\n")
		    				.append("	  AND revision_no = (SELECT MAX(revision_no) 			                    	\n")
		    				.append("						 FROM tbm_users												\n")
		    				.append("						 WHERE user_id = '" + vehicle.get("vehicleDriver") + "')	\n")
		    				.append(");																					\n")
							.toString();
		        		
		    	    	resultInt = super.excuteUpdate(con, sql);
		    	    	if (resultInt < 0) {
		    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
		    				con.rollback();
		    				return EventDefine.E_DOEXCUTE_ERROR;
		    			}
						
		    	    //원부재료 재고 테이블에 update 반영해준다.
					sql = new StringBuilder()
							.append("UPDATE tbi_part_storage2 									\n")
	    					.append("SET 														\n")
	    					.append("	pre_amt = post_amt, 									\n")
	    					.append("	io_amt = '"+ setoffPBoxCount +"', 						\n")
	    					.append("	post_amt = post_amt - '"+ setoffPBoxCount +"'			\n")
	    					.append("WHERE trace_key = '20210512105110'							\n")
	    					.append("	AND part_cd = 'B029' 									\n")
	    					.append("	AND part_rev_no = 0;									\n")
	    					.append("-- trace key는 원부재료 최초 입고 시 랜덤 생성되는 값이라서				\n")
	    					.append("-- p박스 최초 생성 시 받은 trace_key를 계속 사용한다					\n")
	    					.toString();

		
						resultInt = super.excuteUpdate(con, sql);
						if (resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR;
						}
                 
                 
                  JSONArray param = (JSONArray) deleteInfo2.get("param");
                  JSONArray param2 = (JSONArray) deleteInfo2.get("param2");
                  
            
                 for(int i = 0; i < param.size(); i++) {
            	   JSONObject order1 = (JSONObject) param.get(i);
            	   String order_no = (String) order1.get("order_no");
            	   String order_rev_no = (String) order1.get("order_rev_no");
            	   
            	   System.out.println("order_no :" + order_no);
            	   System.out.println("order_rev_no : " + order_rev_no);
            			
       				//주문정보 테이블 출하완료 여부(delivery_yn)'N'으로 update
            			sql = new StringBuilder()
            					.append("UPDATE tbi_order2 								\n")
            					.append("SET delivery_yn = 'N' 							\n")
            					.append("WHERE order_no = '" + order_no + "'			\n")
            					.append("  AND order_rev_no = " + order_rev_no + "		\n")
            					.toString();

        				resultInt = super.excuteUpdate(con, sql);
        	    		if (resultInt < 0) {
        					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        					con.rollback();
        			    	System.out.println("E101 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
        					return EventDefine.E_DOEXCUTE_ERROR ;
        					}
        	    		
                 }	
                        
                 
                 for(int j = 0; j < param2.size(); j++) {
        					JSONObject chulha1 = (JSONObject) param2.get(j); // k번째 데이터묶음
        					
        					String prod_date = (String) chulha1.get("prod_date");
        	            	String chulhaCount = (String) chulha1.get("chulhaCount");
        	            	String prodCd = (String) chulha1.get("prodCd");
        	            	int prodRevNo = Integer.parseInt((String)chulha1.get("prodRevNo"));
        	            	int seqNo = Integer.parseInt((String) chulha1.get("seqNo"));
        	            	
        					
        					int setoffChulhaCount = 0 - Integer.parseInt(chulhaCount);
        					
        					//완제품이 출고된 수량 만큼 다시 insert 해준다.
        					sql = new StringBuilder()
        		    				.append("INSERT INTO tbi_prod_chulgo2 (			\n")
        		    				.append("	prod_date,							\n")
        		    				.append("	seq_no,								\n")
        		    				.append("	prod_cd,							\n")
        		    				.append("	prod_rev_no,						\n")
        		    				.append("	chulgo_date,						\n")
        		    				.append("	chulgo_time,						\n")
        		    				.append("	chulgo_amount,						\n")
        		    				.append("	note								\n")
        		    				.append(")										\n")
        		    				.append("VALUES (								\n")
        		    				.append("	'" + prod_date + "',				\n")
        		    				.append("	" + seqNo + ",						\n")
        		    				.append("	'" + prodCd + "',					\n")
        		    				.append("	'" + prodRevNo + "',				\n")
        		    				.append("	SYSDATE,							\n")
        		    				.append("	SYSTIME,							\n")
        		    				.append("	"+setoffChulhaCount+",				\n")
        		    				.append("	'출하삭제'								\n")
        		    				.append(");										\n")
        		    				.toString();
        		        		
        		    	    	resultInt = super.excuteUpdate(con, sql);
        		    	    	if (resultInt < 0) {
        		    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        		    				con.rollback();
        		    				return EventDefine.E_DOEXCUTE_ERROR;
        		    			}
        						
        		    	    //완제품 재고 테이블에 update 반영해준다.
        					sql = new StringBuilder()
        							.append("UPDATE tbi_prod_storage2							\n")
        							.append("SET 												\n")
        							.append("	pre_amt = post_amt,								\n")
        							.append("	io_amt = - "+setoffChulhaCount+",				\n")
        							.append("	post_amt = post_amt - "+setoffChulhaCount+"		\n")
        							.append("WHERE prod_date = '"+prod_date+"' 					\n")
        							.append("  AND seq_no = "+seqNo+"							\n")
        							.append("  AND prod_cd = '"+ prodCd+"' 						\n")
        							.append("  AND prod_rev_no = "+prodRevNo+" 					\n")
        							.toString();
        		
        						resultInt = super.excuteUpdate(con, sql);
        						if (resultInt < 0) {
        							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        							con.rollback();
        							return EventDefine.E_DOEXCUTE_ERROR;
        						}
        					
        					}
           				
               			
               		
        				
        	    	//수정된 정보를 다시 재등록한다.
        	    		if(rcvData.get("vehicle") != null) {
        	    			vehicle = (JSONObject) rcvData.get("vehicle");
        	    			
        	    			sql = new StringBuilder()
        	    					.append("INSERT INTO														\n")
        	    					.append("	tbi_vehicle_log (												\n")
        	    					.append("		vehicle_cd,													\n")
        	    					.append("		vehicle_rev_no,												\n")
        	    					.append("		operation_date												\n")
        	    					.append("	)																\n")
        	    					.append("VALUES																\n")
        	    					.append("	(																\n")
        	    					.append("		'" + vehicle.get("vehicleCd") + "',							\n")
        	    					.append("		(SELECT MAX(vehicle_rev_no)									\n")
        	    					.append("		 FROM tbm_vehicle A											\n")
        	    					.append("		 WHERE A.vehicle_cd = '" + vehicle.get("vehicleCd") + "'),	\n")
        	    					.append("		SYSDATE														\n")
        	    					.append("	);																\n")
        	    					.toString();
        	    			
        	    			resultInt = super.excuteUpdate(con, sql);
        	    			if (resultInt < 0) {
        	    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        	    				con.rollback();
        	    				return EventDefine.E_DOEXCUTE_ERROR;
        	    			}
        	    			
        	    			sql = new StringBuilder()
        	    					.append("INSERT INTO														\n")
        	    					.append("	tbi_vehicle_log_detail (										\n")
        	    					.append("		chulha_no,													\n")
        	    					.append("		chulha_rev_no,												\n")
        	    					.append("		vehicle_cd,													\n")
        	    					.append("		vehicle_rev_no,												\n")
        	    					.append("		operation_date,												\n")
        	    					.append("		user_id,													\n")
        	    					.append("		user_rev_no													\n")
        	    					.append("	)																\n")
        	    					.append("VALUES																\n")
        	    					.append("	(																\n")
        	    					.append("		" + deleteInfo1.get("chulhaNo") + ",								\n")
        	    					.append("		" + deleteInfo1.get("chulhaRevNo") + " + 1,						\n")
        	    					.append("		'" + vehicle.get("vehicleCd") + "',							\n")
        	    					.append("		(SELECT MAX(vehicle_rev_no)									\n")
        	    					.append("		 FROM tbm_vehicle A											\n")
        	    					.append("		 WHERE A.vehicle_cd = '" + vehicle.get("vehicleCd") + "'),	\n")
        	    					.append("		SYSDATE,													\n")
        	    					.append("		'" + vehicle.get("vehicleDriver") + "',						\n")
        	    					.append("		(SELECT MAX(revision_no)									\n")
        	    					.append("		 FROM tbm_users 											\n")
        	    					.append("		 WHERE user_id = '" + vehicle.get("vehicleDriver") + "')	\n")
        	    					.append("	);																\n")
        	    					.toString();
        	    			
        	    			resultInt = super.excuteUpdate(con, sql);
        	    			if (resultInt < 0) {
        	    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        	    				con.rollback();
        	    				return EventDefine.E_DOEXCUTE_ERROR;
        	    			}
        	    			
        	    			sql = new StringBuilder()
        	    					.append("UPDATE tbi_part_storage2 									\n")
        	    					.append("SET 														\n")
        	    					.append("	pre_amt = post_amt, 									\n")
        	    					.append("	io_amt = "+ vehicle.get("vehicleNote") +", 				\n")
        	    					.append("	post_amt = post_amt - "+ vehicle.get("vehicleNote") +"	\n")
        	    					.append("WHERE trace_key = '20210512105110'							\n")
        	    					.append("	AND part_cd = 'B029' 									\n")
        	    					.append("	AND part_rev_no = 0;									\n")
        	    					.append("-- trace key는 원부재료 최초 입고 시 랜덤 생성되는 값이라서					\n")
        	    					.append("-- p박스 최초 생성 시 받은 trace_key를 계속 사용한다						\n")
        	    					.toString();

        					resultInt = super.excuteUpdate(con, sql.toString());
        		    		if (resultInt < 0) {
        						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        						con.rollback();
        						return EventDefine.E_DOEXCUTE_ERROR ;
        					}
        			    		
        		    		sql = new StringBuilder()
        	    				.append("INSERT INTO tbi_part_chulgo2 (							                            \n")
        	    				.append("	part_cd, 										                                \n")
        	    				.append("	part_rev_no, 								                                    \n")
        	    				.append("	trace_key, 									                                    \n")
        	    				.append("	chulgo_date, 								                                    \n")
        	    				.append("	chulgo_time, 								                                    \n")
        	    				.append("	chulgo_amount, 							                                        \n")
        	    				.append("	chulgo_type, 								                                   	\n")
        	    				.append("	note												                            \n")
        	    				.append(") VALUES (										                                    \n")
        	    				.append("	'B029', 										                                \n")
        	    				.append("	0, 													                            \n")
        	    				.append("	'20210512105110', 					                                        	\n")
        	    				.append("	SYSDATE, 										                                \n")
        	    				.append("	SYSTIME, 										                                \n")
        	    				.append("	"+ vehicle.get("vehicleNote") +", 					                          	\n")
        	    				.append("	'제품출하_' + '"+ vehicle.get("vehicleLocationNm") +"' ,								\n")
        	    				.append("	SELECT user_nm 										                            \n")
        	    				.append("	FROM tbm_users										                            \n")
        	    				.append("	WHERE user_id = '" + vehicle.get("vehicleDriver") + "'	              			\n")
        	    				.append("	  AND revision_no = (SELECT MAX(revision_no) 			                    	\n")
        	    				.append("						 FROM tbm_users												\n")
        	    				.append("						 WHERE user_id = '" + vehicle.get("vehicleDriver") + "')	\n")
        	    				.append(");																					\n")
        						.toString();

        			    	resultInt = super.excuteUpdate(con, sql);
        			    	if (resultInt < 0) {
        						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        						con.rollback();
        						return EventDefine.E_DOEXCUTE_ERROR;
        					}
        	    		}
        	    		
        	    		for(int i = 0; i < orders.size(); i++) {
        	    			JSONObject order = (JSONObject) orders.get(String.valueOf(i));
        	    			JSONObject head = (JSONObject) order.get("paramHead");
        	    			JSONArray body = (JSONArray) order.get("param");
        	    			JSONArray body2 = (JSONArray) order.get("param2");
        	    			
        	    			
        	    			sql = new StringBuilder()
        	    					.append("UPDATE tbi_order2 										\n")
        	    					.append("SET delivery_yn = 'Y' 									\n")
        	    					.append("WHERE order_no = '" + head.get("orderNo") + "'			\n")
        	    					.append("  AND order_rev_no = " + head.get("orderRevNo") + "	\n")
        	    					.toString();

        					resultInt = super.excuteUpdate(con, sql);
        		    		if (resultInt < 0) {
        						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        						con.rollback();
        				    	System.out.println("E101 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
        						return EventDefine.E_DOEXCUTE_ERROR ;
        					}
        	    			
        	    			sql = new StringBuilder()
        	    					.append("INSERT INTO tbi_chulha (				\n")
        	    					.append("	chulha_no,							\n")
        	    					.append("	chulha_rev_no,						\n")
        	    					.append("	chulha_date,						\n")
        	    					.append("	order_no,							\n")
        	    					.append("	order_rev_no,						\n")
        	    					.append("	note,								\n")
        	    					.append("	delyn								\n")
        	    					.append(")										\n")
        	    					.append("VALUES (								\n")
        	    					.append("	" + deleteInfo1.get("chulhaNo") + ",		\n")
        	    					.append("	" + deleteInfo1.get("chulhaRevNo") + " + 1,	\n")
        	    					.append("	SYSDATE,							\n")
        	    					.append("	'" + head.get("orderNo") + "',		\n")
        	    					.append("	'" + head.get("orderRevNo") + "',	\n")
        	    					.append("	'" + head.get("chulhaNote") + "',	\n")
        	    					.append("	'N'									\n")
        	    					.append(");										\n")
        	    					.toString();
        	    	    		
        					resultInt = super.excuteUpdate(con, sql);
        		    		if (resultInt < 0) {
        						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        						con.rollback();
        						return EventDefine.E_DOEXCUTE_ERROR ;
        					}
        			    		
        					for(int j = 0; j < body.size(); j++) {
        						JSONObject eachRow = (JSONObject) body.get(j); // i번째 데이터묶음
        						int chulhaCount = Integer.parseInt(eachRow.get("chulhaCount").toString());
        						String prodCd = eachRow.get("prodCd").toString();
        						
        						JSONObject jArray = new JSONObject();
        		    			jArray.put("prod_cd", prodCd);
        		    			
        		    			
        		    			
        		    			DoyosaeTableModel table = new DoyosaeTableModel("M858S010100E214", jArray); //재고 정보를 가져온 것
        		    			
        		    			
        		    			int body3 = table.getVectorSize();
        						
        						while(chulhaCount > 0) {	// 잔여 출하량이 0이 될 때까지 재고 테이블 조회/비교/차감
        							for (int k = 0; k < body3; k++) { //완제품 재고 테이블 데이터 배열 결과 수만큼 for문 돌림
        								
        								//JSONObject eachRow2 = (JSONObject) body2.get(k); // k번째 데이터묶음
        							
        								String storage_prodDate = table.getValueAt(k, 0).toString(); //완제품 재고 생산일자
        								String storage_prodCd = table.getValueAt(k, 1).toString(); //완제품 재고 제품코드
        								int storage_postAmt = Integer.parseInt(table.getValueAt(k, 3).toString()); //완제품 재고 재고량
        								int storage_seqNo = Integer.parseInt(table.getValueAt(k, 4).toString()); //완제품 재고 일련번호
        								int storage_prodRevNo = Integer.parseInt(table.getValueAt(k, 2).toString()); //완제품 재고 수정이력번호
        								int remain_chulhaCount = 0; //잔여 출하량
        								int remain_storage_postAmt = 0; //잔여 재고량
        								
        								for(int l = 0; l < k; l++) {
        								boolean aa = allUsedList.contains(prodCd+l);
        								allUsedList3.add(aa);
        								//System.out.println("======allUsedList3 :" +allUsedList3);
        								}
        								
        								//두 완제품 제품코드가 서로 같으면
        								if(prodCd.equals(storage_prodCd) && !allUsedList.contains(prodCd+k)) {
        								//if(prodCd.equals(storage_prodCd) && allUsedList2.containsValue(prodCd+k) == false) {
        								//if(prodCd.equals(storage_prodCd) && !allUsedList3.contains(true)) {
        									
        									remain_chulhaCount = chulhaCount - storage_postAmt; //출하량 -재고량시 남는 출하량
        									remain_storage_postAmt = storage_postAmt - chulhaCount; //재고량 - 출하량시 남는 재고량
        									
        									System.out.println("storage_postAmt"+storage_postAmt);
        									System.out.println("remain_chulhaCount" + remain_chulhaCount);
        									
        									//출하량 - 재고량이 0보다 클때, 즉 재고량이 출고량보다 부족할때
        									if(remain_chulhaCount > 0) {
        									//System.out.println("======allUsedList2 2nd : " +allUsedList2);
        									//System.out.println("======allUsedList2 2nd result : " + !allUsedList2.containsValue(prodCd+k));
        										//출하 상세 테이블에 반영한다.
        										sql = new StringBuilder()
        												.append("INSERT INTO tbi_chulha_detail (			\n")
        												.append("	chulha_no,								\n")
        												.append("	chulha_rev_no,							\n")
        												.append("   order_no, 								\n")
        												.append("   order_rev_no, 							\n")
        												.append("	prod_date,								\n")
        												.append("	seq_no,									\n")
        												.append("	prod_cd,								\n")
        												.append("	prod_rev_no,							\n")
        												.append("	chulha_count,							\n")
        												.append("	note									\n")
        												.append(")											\n")
        												.append("VALUES ( 									\n")
        												.append("	'" + deleteInfo1.get("chulhaNo") + "',		\n")
        												.append("	'" + deleteInfo1.get("chulhaRevNo") + "' + 1,\n")
        												.append("	'" + head.get("orderNo") + "',			\n")
        												.append("	'" + head.get("orderRevNo") + "',		\n")
        												.append("	'" + storage_prodDate + "',				\n")
        												.append("	'" + storage_seqNo + "',				\n")
        												.append("	'" + storage_prodCd + "',				\n")
        												.append("	'" + storage_prodRevNo + "',			\n")
        												.append("	'" + storage_postAmt + "',				\n")
        												.append("	'" + eachRow.get("note") + "'			\n")
        												.append(");											\n")
        												.toString();
        										
        										resultInt = super.excuteUpdate(con, sql);
        										if (resultInt < 0) {
        											ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        											con.rollback();
        											return EventDefine.E_DOEXCUTE_ERROR ;
        										}
        							
        										//완제품 재고 테이블 반영
        										sql = new StringBuilder()
        												.append("UPDATE tbi_prod_storage2					\n")
        												.append("SET 										\n")
        												.append("	pre_amt = post_amt,						\n")
        												.append("	io_amt = - "+storage_postAmt+",			\n")
        												.append("	post_amt = post_amt - "+storage_postAmt+"\n")
        												.append("WHERE prod_date = '"+storage_prodDate+"'	\n")
        												.append("  AND seq_no = "+storage_seqNo+"			\n")
        												.append("  AND prod_cd = '"+storage_prodCd+"'		\n")
        												.append("  AND prod_rev_no = "+storage_prodRevNo+"	\n")
        												.toString();
        			
        										resultInt = super.excuteUpdate(con, sql);
        										if (resultInt < 0) {
        											ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        											con.rollback();
        											return EventDefine.E_DOEXCUTE_ERROR;
        										}
        								
        										//완제품 출고 테이블 반영
        										sql = new StringBuilder()
        												.append("INSERT INTO tbi_prod_chulgo2 (			\n")
        												.append("	prod_date,							\n")
        												.append("	seq_no,								\n")
        												.append("	prod_cd,							\n")
        												.append("	prod_rev_no,						\n")
        												.append("	chulgo_date,						\n")
        												.append("	chulgo_time,						\n")
        												.append("	chulgo_amount,						\n")
        												.append("	chulgo_type,						\n")
        												.append("	note								\n")
        												.append(")										\n")
        												.append("VALUES (								\n")
        												.append("	'"+storage_prodDate+"',				\n")
        												.append("	"+storage_seqNo+",					\n")
        												.append("	'"+storage_prodCd+"',				\n")
        												.append("	"+storage_prodRevNo+",				\n")
        												.append("	SYSDATE,							\n")
        												.append("	SYSTIME,							\n")
        												.append("	"+storage_postAmt+",				\n")
        												.append("	'"+head.get("chulgo_type")+"',		\n")
        												.append("	''									\n")
        												.append(");										\n")
        												.toString();
        							        		
        										resultInt = super.excuteUpdate(con, sql);
        										if (resultInt < 0) {
        											ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        											con.rollback();
        											return EventDefine.E_DOEXCUTE_ERROR;
        										}
        											
        										chulhaCount = Math.abs(remain_chulhaCount);
        										allUsedList.add(prodCd+k); // 해당 생산일자의 재고가 다 소진됐을 떄 index number를 List에 담는다.
        										//allUsedList2.put(prodCd+k, prodCd+k);
        										
        									}
        									
        									//출하량 - 재고량이 0보다 같거나 작을때, 즉 재고량이 출하량보다 많을 떄	
        									 else { 
        										//출하 상세 테이블에 반영한다.
        										sql = new StringBuilder()
        												.append("INSERT INTO tbi_chulha_detail (			\n")
        												.append("	chulha_no,								\n")
        												.append("	chulha_rev_no,							\n")
        												.append("   order_no, 								\n")
        												.append("   order_rev_no, 							\n")
        												.append("	prod_date,								\n")
        												.append("	seq_no,									\n")
        												.append("	prod_cd,								\n")
        												.append("	prod_rev_no,							\n")
        												.append("	chulha_count,							\n")
        												.append("	note									\n")
        												.append(")											\n")
        												.append("VALUES ( 									\n")
        												.append("	" + deleteInfo1.get("chulhaNo") + ",	\n")
        												.append("	" + deleteInfo1.get("chulhaRevNo") + " + 1,	\n")
        												.append("	'" + head.get("orderNo") + "',			\n")
        												.append("	'" + head.get("orderRevNo") + "',		\n")
        												.append("	'" + storage_prodDate + "',				\n")
        												.append("	'" + storage_seqNo + "',				\n")
        												.append("	'" + storage_prodCd + "',				\n")
        												.append("	'" + storage_prodRevNo + "',			\n")
        												.append("	'" + chulhaCount + "',					\n")
        												.append("	'" + eachRow.get("note") + "'			\n")
        												.append(");											\n")
        												.toString();
        										
        										resultInt = super.excuteUpdate(con, sql);
        										if (resultInt < 0) {
        											ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        											con.rollback();
        											return EventDefine.E_DOEXCUTE_ERROR ;
        										}
        							
        										//완제품 재고 테이블 반영
        										sql = new StringBuilder()
        												.append("UPDATE tbi_prod_storage2					\n")
        												.append("SET 										\n")
        												.append("	pre_amt = post_amt,						\n")
        												.append("	io_amt = - "+chulhaCount+",				\n")
        												.append("	post_amt = post_amt - "+chulhaCount+"	\n")
        												.append("WHERE prod_date = '"+storage_prodDate+"'	\n")
        												.append("  AND seq_no = "+storage_seqNo+"			\n")
        												.append("  AND prod_cd = '"+storage_prodCd+"'		\n")
        												.append("  AND prod_rev_no = "+storage_prodRevNo+"	\n")
        												.toString();
        			
        										resultInt = super.excuteUpdate(con, sql);
        										if (resultInt < 0) {
        											ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        											con.rollback();
        											return EventDefine.E_DOEXCUTE_ERROR;
        										}
        							
        										//완제품 출고 테이블 반영
        										sql = new StringBuilder()
        												.append("INSERT INTO tbi_prod_chulgo2 (			\n")
        												.append("	prod_date,							\n")
        												.append("	seq_no,								\n")
        												.append("	prod_cd,							\n")
        												.append("	prod_rev_no,						\n")
        												.append("	chulgo_date,						\n")
        												.append("	chulgo_time,						\n")
        												.append("	chulgo_amount,						\n")
        												.append("	chulgo_type,						\n")
        												.append("	note								\n")
        												.append(")										\n")
        												.append("VALUES (								\n")
        												.append("	'"+storage_prodDate+"',				\n")
        												.append("	"+storage_seqNo+",					\n")
        												.append("	'"+storage_prodCd+"',				\n")
        												.append("	"+storage_prodRevNo+",				\n")
        												.append("	SYSDATE,							\n")
        												.append("	SYSTIME,							\n")
        												.append("	"+chulhaCount+",					\n")
        												.append("	'"+head.get("chulgo_type")+"',		\n")
        												.append("	''									\n")
        												.append(");										\n")
        												.toString();
        						        		
        										resultInt = super.excuteUpdate(con, sql);
        										if (resultInt < 0) {
        											ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        											con.rollback();
        											return EventDefine.E_DOEXCUTE_ERROR;
        										}
        										chulhaCount = 0;
        										break;
        										
        									}
        									
        								}//for In if end
        								/*
        								else {
        								//continue;
        								chulhaCount = 0;
        								}
        								*/
        						
        							}// for(k) end
        							//allUsedList.clear();
        						}//while end
        						
        					}// for(j) end
        					
        	    		}// for(i) end
    			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S010100E102()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E102()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E102 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}

	// yumsam
	// 출하 삭제
	public int E103(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject rcvData = new JSONObject();
    		rcvData = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		JSONObject rcvHead = (JSONObject) rcvData.get("paramHead");
    		JSONArray rcvBody = (JSONArray) rcvData.get("param");
    		JSONArray rcvBody2 = (JSONArray) rcvData.get("param2");
    		
    		//차량 운행정보 상세 삭제
        	sql = new StringBuilder()
        			.append("DELETE FROM  													\n")
        			.append("tbi_vehicle_log_detail 										\n")
        			.append("WHERE vehicle_cd = '"+ rcvHead.get("vehicle_cd") +"'   		\n")
        			.append("AND vehicle_rev_no =  '"+ rcvHead.get("vehicle_rev_no") +"' 	\n")
        			.append("AND chulha_no = '"+ rcvHead.get("chulha_no") +"'   			\n")
        			.append("AND chulha_rev_no =  '"+ rcvHead.get("chulha_rev_no") +"' 		\n")
        			.append("AND operation_date =  '"+ rcvHead.get("chulha_date") +"' 		\n")
        			.toString();

        			resultInt = super.excuteUpdate(con, sql);
            		if (resultInt < 0) {
        				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        				con.rollback();
        		    	System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
        				return EventDefine.E_DOEXCUTE_ERROR ;
        			}
    		
    		
    		
    		//차량 운행정보 삭제
    		sql = new StringBuilder()
    				.append("DELETE FROM  												\n")
    				.append("tbi_vehicle_log 											\n")
    				.append("WHERE vehicle_cd = '"+ rcvHead.get("vehicle_cd") +"'   	\n")
    				.append("AND vehicle_rev_no =  '"+ rcvHead.get("vehicle_rev_no") +"' \n")
    				.append("AND operation_date =  '"+ rcvHead.get("chulha_date") +"' 	\n")
    				.toString();

    			resultInt = super.excuteUpdate(con, sql);
        		if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    		    	System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
           
        	//출하 상세 테이블 삭제
            sql = new StringBuilder()
                     .append("DELETE FROM  												\n")
                     .append("tbi_chulha_detail											\n")
                     .append("WHERE chulha_no = '"+ rcvHead.get("chulha_no") +"'   		\n")
                     .append("AND chulha_rev_no =  '"+ rcvHead.get("chulha_rev_no") +"' 	\n")
                     .toString();

                   resultInt = super.excuteUpdate(con, sql);
                   if (resultInt < 0) {
                	   ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
                	   con.rollback();
                	   System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
                	   return EventDefine.E_DOEXCUTE_ERROR ;
                   }	
        		
        		
            
            //출하 테이블  삭제여부(delyn) = 'Y'로 update
            sql = new StringBuilder()
                	.append("UPDATE  													\n")
                	.append("tbi_chulha SET												\n")
                	.append("delyn = 'Y'												\n")
                	.append("WHERE chulha_no = '"+ rcvHead.get("chulha_no") +"'   		\n")
                	.append("AND chulha_rev_no =  '"+ rcvHead.get("chulha_rev_no") +"' 	\n")
                	.toString();

                	resultInt = super.excuteUpdate(con, sql);
                    if (resultInt < 0) {
                		 ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
                		 con.rollback();
                		 System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
                		 return EventDefine.E_DOEXCUTE_ERROR ;
                	}
                  
                  int pBoxCount = Integer.parseInt(rcvHead.get("pBoxCount").toString());  
                  int setoffPBoxCount = 0 - pBoxCount;
                  
                  
                  //pbox가 출고된 수량 만큼 다시 insert 해준다.
					sql = new StringBuilder()
							.append("INSERT INTO tbi_part_chulgo2 (							                            \n")
		    				.append("	part_cd, 										                                \n")
		    				.append("	part_rev_no, 								                                    \n")
		    				.append("	trace_key, 									                                    \n")
		    				.append("	chulgo_date, 								                                    \n")
		    				.append("	chulgo_time, 								                                    \n")
		    				.append("	chulgo_amount, 							                                        \n")
		    				.append("	chulgo_type, 								                                   	\n")
		    				.append("	note												                            \n")
		    				.append(") VALUES (										                                    \n")
		    				.append("	'B029', 										                                \n")
		    				.append("	0, 													                            \n")
		    				.append("	'20210512105110', 					                                        	\n")
		    				.append("	SYSDATE, 										                                \n")
		    				.append("	SYSTIME, 										                                \n")
		    				.append("	'"+ setoffPBoxCount +"', 					                        			\n")
		    				.append("	'제품출하_' + '"+ rcvHead.get("location_type_nm") +"' ,							\n")
		    				.append("	SELECT user_nm 										                            \n")
		    				.append("	FROM tbm_users										                            \n")
		    				.append("	WHERE user_id = '" + rcvHead.get("vehicle_driver") + "'	              			\n")
		    				.append("	  AND revision_no = (SELECT MAX(revision_no) 			                    	\n")
		    				.append("						 FROM tbm_users												\n")
		    				.append("						 WHERE user_id = '" + rcvHead.get("vehicle_driver") + "')	\n")
		    				.append(");																					\n")
							.toString();
		        		
		    	    	resultInt = super.excuteUpdate(con, sql);
		    	    	if (resultInt < 0) {
		    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
		    				con.rollback();
		    				return EventDefine.E_DOEXCUTE_ERROR;
		    			}
						
		    	    //원부재료 재고 테이블에 update 반영해준다.
					sql = new StringBuilder()
							.append("UPDATE tbi_part_storage2 									\n")
	    					.append("SET 														\n")
	    					.append("	pre_amt = post_amt, 									\n")
	    					.append("	io_amt = '"+ setoffPBoxCount +"', 						\n")
	    					.append("	post_amt = post_amt - '"+ setoffPBoxCount +"'			\n")
	    					.append("WHERE trace_key = '20210512105110'							\n")
	    					.append("	AND part_cd = 'B029' 									\n")
	    					.append("	AND part_rev_no = 0;									\n")
	    					.append("-- trace key는 원부재료 최초 입고 시 랜덤 생성되는 값이라서				\n")
	    					.append("-- p박스 최초 생성 시 받은 trace_key를 계속 사용한다					\n")
	    					.toString();

		
						resultInt = super.excuteUpdate(con, sql);
						if (resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR;
						}
					
                    
            
               for(int i = 0; i < rcvBody.size(); i++) {
            		JSONObject order = (JSONObject) rcvBody.get(i);
            			
            			//주문정보 테이블 출하완료 여부(delivery_yn)'N'으로 update
            			sql = new StringBuilder()
            					.append("UPDATE tbi_order2 										\n")
            					.append("SET delivery_yn = 'N' 									\n")
            					.append("WHERE order_no = '" + order.get("order_no") + "'		\n")
            					.append("  AND order_rev_no = " + order.get("order_rev_no") + "	\n")
            					.toString();

        				resultInt = super.excuteUpdate(con, sql);
        	    		if (resultInt < 0) {
        					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        					con.rollback();
        			    	System.out.println("E101 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
        					return EventDefine.E_DOEXCUTE_ERROR ;
        					}
           				}
           
        				for(int j = 0; j < rcvBody2.size(); j++) {
        					JSONObject eachRow = (JSONObject) rcvBody2.get(j); // i번째 데이터묶음
        					int chulhaCount = Integer.parseInt(eachRow.get("chulhaCount").toString());
        					
        					int setoffChulhaCount = 0 - Integer.parseInt((String)eachRow.get("chulhaCount"));
        					
        					//완제품이 출고된 수량 만큼 다시 insert 해준다.
        					sql = new StringBuilder()
        		    				.append("INSERT INTO tbi_prod_chulgo2 (			\n")
        		    				.append("	prod_date,							\n")
        		    				.append("	seq_no,								\n")
        		    				.append("	prod_cd,							\n")
        		    				.append("	prod_rev_no,						\n")
        		    				.append("	chulgo_date,						\n")
        		    				.append("	chulgo_time,						\n")
        		    				.append("	chulgo_amount,						\n")
        		    				.append("	note								\n")
        		    				.append(")										\n")
        		    				.append("VALUES (								\n")
        		    				.append("	'"+eachRow.get("prod_date")+"',		\n")
        		    				.append("	"+eachRow.get("seqNo")+",			\n")
        		    				.append("	'"+eachRow.get("prodCd")+"',		\n")
        		    				.append("	"+eachRow.get("prodRevNo")+",		\n")
        		    				.append("	SYSDATE,							\n")
        		    				.append("	SYSTIME,							\n")
        		    				.append("	"+setoffChulhaCount+",				\n")
        		    				.append("	'출하삭제'								\n")
        		    				.append(");										\n")
        		    				.toString();
        		        		
        		    	    	resultInt = super.excuteUpdate(con, sql);
        		    	    	if (resultInt < 0) {
        		    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        		    				con.rollback();
        		    				return EventDefine.E_DOEXCUTE_ERROR;
        		    			}
        						
        		    	    //완제품 재고 테이블에 update 반영해준다.
        					sql = new StringBuilder()
        							.append("UPDATE tbi_prod_storage2							\n")
        							.append("SET 												\n")
        							.append("	pre_amt = post_amt,								\n")
        							.append("	io_amt = - "+setoffChulhaCount+",				\n")
        							.append("	post_amt = post_amt - "+setoffChulhaCount+"		\n")
        							.append("WHERE prod_date = '"+eachRow.get("prod_date")+"' 	\n")
        							.append("  AND seq_no = "+eachRow.get("seqNo")+"			\n")
        							.append("  AND prod_cd = '"+eachRow.get("prodCd")+"' 		\n")
        							.append("  AND prod_rev_no = "+eachRow.get("prodRevNo")+" 	\n")
        							.toString();
        		
        						resultInt = super.excuteUpdate(con, sql);
        						if (resultInt < 0) {
        							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        							con.rollback();
        							return EventDefine.E_DOEXCUTE_ERROR;
        						}
        					
        				}
        	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S010100E103()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E103()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E103 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 출하 메인 정보 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 								                    \n")
					.append("	A.chulha_no,						                    \n")
					.append("	A.chulha_rev_no,					                    \n")
					.append("	A.chulha_date,						                    \n")
					.append("	A.order_no,							                    \n")
					.append("	A.order_rev_no,						                    \n")
					.append("	C.cust_nm,							                    \n")
					.append("	A.note,								                    \n")
					.append("   B.order_date,						                    \n")
					.append("   B.delivery_date,					                    \n")
					.append("   B.note,  							                    \n")
					.append("   E.product_nm, 						                    \n")
					.append("   D.chulha_count, 					                    \n")
					.append("   D.note,     						                    \n")
					.append("   B.cust_cd, 							                    \n")
					.append("   B.cust_rev_no, 						                    \n")
					.append("   U.user_nm,	 						                    \n")
					.append("   V.vehicle_cd,	 						                \n")
					.append("   V.vehicle_rev_no,	 						            \n")
					.append("   C.company_type_m, 										\n")
					.append("   U.user_id, 												\n")
					.append("   W.code_name 											\n")
					.append("FROM tbi_chulha A						                    \n")
					.append("INNER JOIN tbi_order2 B				                    \n")
					.append("	ON A.order_no = B.order_no			                    \n")
					.append("	AND A.order_rev_no = B.order_rev_no	                    \n")
					.append("INNER JOIN tbm_customer C				                    \n")
					.append("	ON B.cust_cd = C.cust_cd			                    \n")
					.append("	AND B.cust_rev_no = C.revision_no	                    \n")
					.append("INNER JOIN tbi_chulha_detail D  		                    \n")
					.append("   ON A.chulha_no = D.chulha_no  		                    \n")
					.append("   AND A.chulha_rev_no = D.chulha_rev_no                   \n")
					.append("INNER JOIN tbm_product E  				                    \n")
					.append("	ON D.prod_cd = E.prod_cd			                    \n")
					.append("	AND D.prod_rev_no = E.revision_no	                    \n")
					.append("INNER JOIN tbi_vehicle_log_detail V						\n")
					.append("	ON V.chulha_no = A.chulha_no							\n")
					.append("	AND V.chulha_rev_no = A.chulha_rev_no					\n")
					.append("INNER JOIN tbm_users U										\n")
					.append("	ON V.user_id = U.user_id								\n")
					.append("	AND V.user_rev_no = U.revision_no						\n")
					.append("INNER JOIN tbm_code_book W									\n")
					.append("	ON C.company_type_m = W.code_value						\n")
					.append("WHERE 									                    \n")
					.append("		A.chulha_date BETWEEN			                    \n")
					.append("		'"+jArr.get("startDate")+"' AND	                    \n")
					.append("		'"+jArr.get("endDate")+"'							\n")
					.append("	AND A.delyn != 'Y'										\n")
					.append("   AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       	\n")
					.append("       				FROM tbi_chulha F                  	\n")
					.append("      					WHERE A.chulha_no = F.chulha_no)   	\n")
					.append("GROUP BY A.order_no    				   				   	\n")
					.append("ORDER BY A.chulha_date DESC 							   	\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 출하 상세 정보 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 												\n")
					//.append("	A.prod_date,										\n")
					.append("	C.product_nm,										\n")
					.append("	A.prod_cd,											\n")
					.append("	A.prod_rev_no,										\n")
					.append("	SUM(A.chulha_count),								\n")
					.append("	A.note												\n")
					.append("FROM tbi_chulha_detail A								\n")
					//.append("INNER JOIN tbi_chulha B								\n")
					//.append("	ON A.chulha_no = B.chulha_no						\n")
					//.append("	AND A.chulha_rev_no = B.chulha_rev_no				\n")
					.append("INNER JOIN tbm_product C								\n")
					.append("	ON A.prod_cd = C.prod_cd							\n")
					.append("	AND A.prod_rev_no = C.revision_no					\n")
					.append("WHERE A.chulha_no = '"+jArr.get("chulhaNo")+"'			\n")
					.append("AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       \n")
					.append("       				FROM tbi_chulha_detail D        \n")
					.append("      					WHERE A.prod_cd = D.prod_cd 	\n")
					.append("      					AND A.chulha_no = D.chulha_no   \n")
					.append("      					AND A.prod_rev_no = D.prod_rev_no) \n")
					.append("AND A.order_no = '"+jArr.get("orderNo")+"'				\n")
					.append("GROUP BY A.prod_cd 									\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 주문별 상세 내역 (완제품 리스트) 조회
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 											\n")
					.append("	B.product_nm,									\n")
					.append("	A.prod_cd,										\n")
					.append("	A.order_count,									\n")
					.append("	A.note,											\n")
					.append("   A.prod_rev_no 									\n")
					.append("FROM tbi_order_detail2 A							\n")
					.append("INNER JOIN tbm_product B							\n")
					.append("	ON A.prod_cd = B.prod_cd						\n")
					.append("  AND A.prod_rev_no = B.revision_no				\n")
					.append("WHERE order_no = '"+jArr.get("orderNo")+"'			\n")
					.append("AND order_rev_no = '"+jArr.get("orderRevNo")+"'	\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 출하 상세 내역 (완제품 리스트) 조회
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 											\n")
					.append("   B.product_nm, 									\n")
					.append("   A.prod_date, 									\n")
					.append("   A.seq_no, 										\n")
					.append("   A.prod_cd, 										\n")
					.append("   A.prod_rev_no, 									\n")
					.append("   A.chulha_count, 								\n")
					.append("   A.note     										\n")
					.append("FROM tbi_chulha_detail A  							\n")
					.append("INNER JOIN tbm_product B  							\n")
					.append("	ON A.prod_cd = B.prod_cd						\n")
					.append("	AND A.prod_rev_no = B.revision_no				\n")
					.append("WHERE chulha_no = '"+jArr.get("chulhaNo")+"'		\n")
					.append("AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       \n")
					.append("       				FROM tbi_chulha_detail D        \n")
					.append("      					WHERE A.prod_cd = D.prod_cd 	\n")
					.append("      					AND A.chulha_no = D.chulha_no   \n")
					.append("      					AND A.prod_rev_no = D.prod_rev_no) \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	
	
	
	
	/* 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 아래는 계측기 관련인 것 같은데, 
	 * M858S010300으로 옮겨야할 듯 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * */
	
	
	
	//계측기 등록처리부분
	public int E301(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append(" insert into tbi_seolbi_repare ( 		\n");
			sql.append(" 		seolbi_cd						\n"); 
			sql.append(" 		,seq_no							\n"); 
			sql.append(" 		,reason_cd						\n"); 
			sql.append(" 		,start_dt						\n"); 
			sql.append(" 		,end_dt							\n"); 
			sql.append(" 		,user_id						\n"); 
			sql.append(" 		,biyong							\n"); 
			sql.append(" 		,gigwan_nm						\n"); 
			sql.append(" 		,work_memo						\n"); 
			sql.append(" 		,bigo							\n"); 
			sql.append(" 		,member_key						\n"); // sql.member_key_insert
			sql.append(" 	) values ( 							\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "' 	\n"); 	//seolbi_cd
			sql.append(" 		,(select coalesce(max(seq_no),0)+1 from tbi_seolbi_repare where \n"); 	//sys_bom_id
			sql.append(" 		 	seolbi_cd='" + jArray.get("seolbi_code") + "') \n");
			sql.append(" 		,'" + jArray.get("job_gubun") + "' 	\n"); 	//reason_cd
			sql.append(" 		,'" + jArray.get("start_date") + "' \n"); 	//start_dt
			sql.append(" 		,'" + jArray.get("end_date") + "'	\n"); 	//end_dt
			sql.append(" 		,'" + jArray.get("damdangja") + "' 	\n"); 	//user_id
			sql.append(" 		,'" + jArray.get("biyong") + "' 	\n"); 	//biyong
			sql.append(" 		,'" + jArray.get("gigwan_name") + "'\n"); 	//gigwan_nm
			sql.append(" 		,'" + jArray.get("work_memo") + "' \n"); 	//work_memo
			sql.append(" 		,'" + jArray.get("bigo") + "'		\n"); 	//bigo
			sql.append(" 		,'" + jArray.get("member_key") + "' \n"); // sql.member_key_values
			sql.append(" 	) 										\n");

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
			LoggingWriter.setLogError("M858S010100E301()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E301()","==== finally ===="+ e.getMessage());
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

	public int E302(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" update tbi_seolbi_repare set 						\n");
			sql.append(" 	reason_cd = 	'" + jArray.get("job_gubun") + "'	\n"); 
			sql.append(" 	,start_dt = 	'" + jArray.get("start_date") + "'	\n"); 
			sql.append(" 	,end_dt = 		'" + jArray.get("end_date") + "'	\n"); 
			sql.append(" 	,user_id = 		'" + jArray.get("damdangja") + "'	\n"); 
			sql.append(" 	,biyong = 		'" + jArray.get("biyong") + "'		\n"); 
			sql.append(" 	,gigwan_nm = 	'" + jArray.get("gigwan_name") + "'	\n"); 
			sql.append(" 	,work_memo = 	'" + jArray.get("work_memo") + "'	\n"); 
			sql.append(" 	,bigo = 		'" + jArray.get("bigo") + "'		\n"); 
			sql.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n");  // member_key_update
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); // sql.member_key_select, update, delete

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
			LoggingWriter.setLogError("M858S010100E302()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E302()","==== finally ===="+ e.getMessage());
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

	public int E303(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" delete from tbi_seolbi_repare 						\n");
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' 	\n");
			sql.append(" 	AND seq_no = 	'" + jArray.get("seq_no") + "' 			\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); // sql.member_key_select, update, delete

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
			LoggingWriter.setLogError("M858S010100E303()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E303()","==== finally ===="+ e.getMessage());
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

	public int E304(InoutParameter ioParam) {
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
					.append("	C.code_name,\n")
					.append("	D.code_name,\n")
					.append("	B.product_nm,\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("	chulha_no,\n")
					.append("	chulha_seq,\n")
					.append("	cust_cd,\n")
					.append("	cust_rev,\n")
					.append("	product_serial_no,\n")
					.append("	product_serial_no_end,\n")
					.append("	chulha_cnt,\n")
					.append("	chulha_unit,\n")
					.append("	chulha_unit_price,\n")
					.append("	chuha_dt,\n")
					.append("	chulha_user_id,\n")
					.append("	A.prod_cd,\n")
					.append("	prod_rev,\n")
					.append("	review_no,\n")
					.append("	confirm_no,\n")
					.append("	order_detail_seq,\n")
					.append("	A.member_key\n")
					.append("FROM tbi_chulha_info A\n")
					.append("	INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("	INNER JOIN v_prodgubun_big C\n")
					.append("	ON B.prod_gubun_b = C.code_value\n")
					.append("	AND B.member_key = C.member_key\n")
					.append("	INNER JOIN v_prodgubun_mid D\n")
					.append("	ON B.prod_gubun_m = D.code_value\n")
					.append("	AND B.member_key = D.member_key\n")
					.append("WHERE  TO_CHAR(A.chuha_dt,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("ORDER BY A.chuha_dt DESC\n")
					.toString();


			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010100E304()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E304()","==== finally ===="+ e.getMessage());
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
	
	public int E314(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,B.code_name AS reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,A.bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare A	\n")
					.append("INNER JOIN tbm_code_book B\n")
					.append("	ON A.reason_cd = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("seolbi_cd") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") // sql.member_key_select, update, delete
					.append(" ORDER BY seq_no DESC							 \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010100E314()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E114()","==== finally ===="+ e.getMessage());
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

	public int E115(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare	\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("sulbi_cd") + "' \n")
					.append(" 	AND seq_no = '" + jArray.get("seq_no") + "' \n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") // sql.member_key_select, update, delete
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010100E115()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010100E115()","==== finally ===="+ e.getMessage());
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
	
	
		
		// 배송기사 선택시 차량, 지역 매칭용
				public int E204(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT					\n")
								.append("	A.user_id,			\n")
								.append("	A.user_rev_no,		\n")
								.append("	B.user_nm,			\n")
								.append("	code_name,			\n")
								.append("	cust_gubun,			\n")
								.append("	C.vehicle_nm,			\n")
								.append("	A.vehicle_cd,			\n")
								.append("	A.vehicle_rev_no		\n")
								.append("FROM tbm_vehicle_users A						\n")
								.append("LEFT OUTER JOIN tbm_users B					\n")
								.append("	ON A.user_id = B.user_id					\n")
								.append("	AND A.user_rev_no = B.revision_no			\n")
								.append("LEFT OUTER JOIN tbm_vehicle C					\n")
								.append("	ON A.vehicle_cd = C.vehicle_cd				\n")
								.append("	AND A.vehicle_rev_no = C.vehicle_rev_no 	\n")
								.append("LEFT OUTER JOIN tbm_code_book D				\n")
								.append("	ON A.cust_gubun = D.code_value				\n")
								.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date\n")
								.append("AND A.user_id = '" + jObj.get("driver_id") +"'     \n")
								.append("ORDER BY A.user_id ASC, A.user_rev_no DESC			\n")
								.toString();  

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S115100E104()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M909S115100E104()","==== finally ===="+ e.getMessage());
							}
				    	} else {
				    	}
				    }
					
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    
			    	return EventDefine.E_QUERY_RESULT;
				}
				
				// 완제품 선입선출 적용 위한 완제품 재고테이블 데이터 조회용
				public int E214(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT					\n")
								.append("	prod_date,			\n")
								.append("	prod_cd,			\n")
								.append("   prod_rev_no, 		\n")
								.append("	post_amt,			\n")
								.append("	seq_no,				\n")
								.append("	ROW_NUMBER() OVER(ORDER BY prod_date) AS MIN_RANK	\n")
								.append("FROM tbi_prod_storage2 								\n")
								.append("WHERE prod_cd = '" + jObj.get("prod_cd") +"' 			\n")
								.append("AND post_amt > 0 		\n")
								.toString();  

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010100E214()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010100E214()","==== finally ===="+ e.getMessage());
							}
				    	} else {
				    	}
				    }
					
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    
			    	return EventDefine.E_QUERY_RESULT;
				}
				
				// 출하삭제 페이지 데이터 조회용 - 가맹점별 주문정보
				public int E224(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT 												\n")
								.append("   E.cust_nm, 											\n")
								.append("	C.product_nm,										\n")
								.append("   A.prod_date, 										\n")
								.append("	A.chulha_count,										\n")
								.append("	A.prod_cd,											\n")
								.append("	A.prod_rev_no,										\n")
								.append("   A.seq_no, 											\n")
								.append("	D.cust_cd											\n")
								.append("FROM tbi_chulha_detail A								\n")
								.append("INNER JOIN tbm_product C								\n")
								.append("	ON A.prod_cd = C.prod_cd							\n")
								.append("	AND A.prod_rev_no = C.revision_no					\n")
								.append("INNER JOIN tbi_order2 D								\n")
								.append("	ON A.order_no = D.order_no							\n")
								.append("	AND A.order_rev_no = D.order_rev_no					\n")
								.append("INNER JOIN tbm_customer E								\n")
								.append("	ON D.cust_cd = E.cust_cd							\n")
								.append("	AND D.cust_rev_no = E.revision_no					\n")
								.append("WHERE A.chulha_no = '"+jObj.get("chulha_no")+"'		\n")
								.append("AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       \n")
								.append("       				FROM tbi_chulha_detail D        \n")
								.append("      					WHERE A.prod_cd = D.prod_cd 	\n")
								.append("      					AND A.chulha_no = D.chulha_no   \n")
								.append("      					AND A.prod_rev_no = D.prod_rev_no) \n")
								.append("AND A.order_no = '"+jObj.get("order_no")+"'       		\n")
								.append("AND E.company_type_m = '"+jObj.get("location_type")+"'	\n")
								.append("AND A.chulha_count > 0									\n")
								.toString();

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010100E224()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010100E224()","==== finally ===="+ e.getMessage());
							}
				    	} else {
				    	}
				    }
					
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    
			    	return EventDefine.E_QUERY_RESULT;
				}
				
				
				
				
				// 출하삭제 페이지 데이터 조회용 - 출하 내역 주문번호 및 가맹점명 조회 
				public int E234(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT DISTINCT										\n")
								.append("   A.order_no, 										\n")
								.append("	A.order_rev_no,										\n")
								.append("	D.cust_nm,											\n")
								.append("	D.cust_cd,											\n")
								.append("	D.refno, 											\n")
								.append("   C.order_date,	 									\n")
								.append("   C.delivery_date, 									\n")
								.append("   B.note 												\n")
								.append("FROM tbi_chulha_detail A								\n")
								.append("INNER JOIN tbi_chulha B								\n")
								.append("	ON A.chulha_no = B.chulha_no						\n")
								.append("	AND A.chulha_rev_no = B.chulha_rev_no				\n")
								.append("INNER JOIN tbi_order2 C								\n")
								.append("	ON A.order_no = C.order_no							\n")
								.append("	AND A.order_rev_no = C.order_rev_no					\n")
								.append("INNER JOIN tbm_customer D								\n")
								.append("	ON C.cust_cd = D.cust_cd							\n")
								.append("	AND C.cust_rev_no = D.revision_no					\n")
								.append("WHERE A.chulha_no = '"+jObj.get("chulha_no")+"'		\n")
								.append("AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       \n")
								.append("       				FROM tbi_chulha_detail D        \n")
								.append("      					WHERE A.prod_cd = D.prod_cd 	\n")
								.append("      					AND A.chulha_no = D.chulha_no   \n")
								.append("      					AND A.prod_rev_no = D.prod_rev_no) \n")
								.append("AND D.company_type_m = '"+jObj.get("location_type")+"'		\n")
								.append("ORDER BY D.refno 										\n")
								.toString();

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010100E234()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010100E234()","==== finally ===="+ e.getMessage());
							}
				    	} else {
				    	}
				    }
					
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    
			    	return EventDefine.E_QUERY_RESULT;
				}
				
				
				// 출하삭제 페이지 데이터 조회용(페이지 load용) - 가맹점별 주문정보
				public int E244(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT 												\n")
								.append("   E.cust_nm, 											\n")
								.append("	C.product_nm,										\n")
								.append("   A.prod_date, 										\n")
								.append("	A.chulha_count										\n")
								.append("FROM tbi_chulha_detail A								\n")
								.append("INNER JOIN tbm_product C								\n")
								.append("	ON A.prod_cd = C.prod_cd							\n")
								.append("	AND A.prod_rev_no = C.revision_no					\n")
								.append("INNER JOIN tbi_order2 D								\n")
								.append("	ON A.order_no = D.order_no							\n")
								.append("	AND A.order_rev_no = D.order_rev_no					\n")
								.append("INNER JOIN tbm_customer E								\n")
								.append("	ON D.cust_cd = E.cust_cd							\n")
								.append("	AND D.cust_rev_no = E.revision_no					\n")
								.append("WHERE A.chulha_no = '"+jObj.get("chulha_no")+"'		\n")
								.append("AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       \n")
								.append("       				FROM tbi_chulha_detail D        \n")
								.append("      					WHERE A.prod_cd = D.prod_cd 	\n")
								.append("      					AND A.chulha_no = D.chulha_no   \n")
								.append("      					AND A.prod_rev_no = D.prod_rev_no) \n")
								.append("AND A.order_no = '"+jObj.get("order_no")+"'       		\n")
								.append("AND E.company_type_m = '"+jObj.get("location_type")+"'	\n")
								.append("AND A.chulha_count > 0									\n")
								.toString();

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010100E244()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010100E244()","==== finally ===="+ e.getMessage());
							}
				    	} else {
				    	}
				    }
					
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    
			    	return EventDefine.E_QUERY_RESULT;
				}
				
				
				public int E254(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
					JSONObject jObj = new JSONObject();
					jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT \n")
								.append("	A.order_no,			\n")
								.append("	A.order_rev_no,		\n")
								.append("	B.cust_nm,			\n")
								.append("	A.order_date,		\n")
								.append("	A.delivery_date,	\n")
								.append("	A.note,				\n")
								.append("   A.cust_cd,			\n")
								.append("   A.cust_rev_no 		\n")
								.append("FROM tbi_order2 A		\n")
								.append("INNER JOIN tbm_customer B			 \n")
								.append("	ON A.cust_cd = B.cust_cd		 \n")
								.append("	AND A.cust_rev_no = B.revision_no\n")
								.append("WHERE A.order_no   = '"+ jObj.get("orderNo") +"'		\n")
								.append("AND A.order_rev_no = (SELECT MAX(order_rev_no)       	\n")
								.append("       				FROM tbi_order2 D        		\n")
								.append("      					WHERE A.order_no = D.order_no 	\n")
								.append("      					AND A.order_date = D.order_date)\n")
								.append("AND A.delyn = 'N' 										\n")
								.append("ORDER BY B.refno ASC 									\n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010100E254()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010100E254()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

			    	return EventDefine.E_QUERY_RESULT;
				}
				
				//수정, 삭제  p박스량 조회용
				public int E264(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
					JSONObject jObj = new JSONObject();
					jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT \n")
								.append("	SUM(chulgo_amount)						\n")
								.append("FROM tbi_part_chulgo2 A					\n")
								.append("WHERE A.part_cd   = 'B029'					\n")
								.append("AND A.trace_key = '20210512105110'       	\n")
								.append("AND A.part_rev_no = 0						\n")
								.append("AND A.chulgo_date = '"+jObj.get("chulha_date")+"'	\n")
								.append("AND A.chulgo_type = '제품출하_'  + '"+jObj.get("location_nm")+"'	\n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010100E264()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010100E264()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

			    	return EventDefine.E_QUERY_RESULT;
				}
				
				//당일 해당 배송지역 출하 여부 조회용
				public int E274(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
					JSONObject jObj = new JSONObject();
					jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT \n")
								.append("	vehicle_cd					\n")
								.append("FROM tbi_vehicle_log 			\n")
								.append("WHERE operation_date   = '"+jObj.get("chulha_date")+"'	 \n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010100E274()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010100E274()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

			    	return EventDefine.E_QUERY_RESULT;
				}
				
}