<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="org.json.simple.parser.*"%>
<%@page import="java.math.BigDecimal"%>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	DBServletLink dbServletLink =  new DBServletLink();
	String[] rTurnValue;
	
	String GV_ORDER_NO="", GV_ORDER_DETAIL_SEQ="", 
			GV_PROD_CD="", GV_PROD_CD_REV="", GV_PROD_NM="",
			GV_PART_CD="", GV_PART_CD_REV="", GV_IO_AMT="",  
			GV_WAREHOUSING_DATETIME="", GV_DELIVERY_DATE="";

	if(request.getParameter("order_no")== null)
		GV_ORDER_NO = "";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ = "";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("prod_nm")== null)
		GV_PROD_NM="";
	else
		GV_PROD_NM = request.getParameter("prod_nm");
	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");
	
	if(request.getParameter("part_cd_rev")== null)
		GV_PART_CD_REV="";
	else
		GV_PART_CD_REV = request.getParameter("part_cd_rev");
	
	if(request.getParameter("io_amt")== null)
		GV_IO_AMT="";
	else
		GV_IO_AMT = request.getParameter("io_amt");
	
	if(request.getParameter("warehousing_datetime")== null)
		GV_WAREHOUSING_DATETIME="";
	else
		GV_WAREHOUSING_DATETIME = request.getParameter("warehousing_datetime");

	if(request.getParameter("delivery_date")== null)
		GV_DELIVERY_DATE="";
	else
		GV_DELIVERY_DATE = request.getParameter("delivery_date");
	
	
	BigDecimal GV_PART_CNT = new BigDecimal(GV_IO_AMT);
	
// 	JSONObject jArray = new JSONObject();
// 	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
// 	jArray.put( "prod_cd", GV_PROD_CD);
// 	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
// 	jArray.put( "member_key", member_key);
		
// 	TableModel = new DoyosaeTableModel("M303S050100E155", jArray); //불출 원재료 목록 = 레시피(BOM)
//  	int RowCount = TableModel.getRowCount();
	
// 	for(int i=0; i<RowCount; i++){
// 		String GV_PART_CD = TableModel.getValueAt(i,4).toString().trim();
// 		String GV_PART_CD_REV = TableModel.getValueAt(i,5).toString().trim();
// 		BigDecimal GV_PART_CNT = new BigDecimal(TableModel.getValueAt(i,13).toString().trim());
		
		JSONObject jArrayPart = new JSONObject();
		jArrayPart.put( "part_cd", GV_PART_CD);
		jArrayPart.put( "part_cd_rev", GV_PART_CD_REV);
		jArrayPart.put( "member_key", member_key);
		jArrayPart.put( "delivery_date", GV_DELIVERY_DATE);
		DoyosaeTableModel TableModelPart = new DoyosaeTableModel("M303S060700E156", jArrayPart); //원재료별 재고현황
		int RowCountPart = TableModelPart.getRowCount();
		
		for(int j=0; j<RowCountPart; j++){
			if(GV_PART_CNT.compareTo(BigDecimal.ZERO)<1) break; // 불출 다하면 for문 끝
			
			String GV_EXPIRATION_DATE = TableModelPart.getValueAt(j,3).toString().trim();
			String GV_PART_NM = TableModelPart.getValueAt(j,2).toString().trim();
			BigDecimal GV_POST_AMT = new BigDecimal(TableModelPart.getValueAt(j,5).toString());
			
			BigDecimal GV_PART_CNT_temp = GV_PART_CNT.subtract(GV_POST_AMT); //남은 불출수량 = GV_PART_CNT - GV_POST_AMT
			try{ // 재고불출처리
				dbServletLink = new DBServletLink();
				dbServletLink.connectURL("M303S060700E151"); // 쿼리메소드(PID) 연결
				
				// String형태의 JSON 데이터를 JSONObject 형태로 변환한다.
// 				JSONParser parser = new JSONParser();
// 				JSONObject jObject = (JSONObject)parser.parse(GV_PARM);	
				JSONObject jObject = new JSONObject();
				jObject.put( "warehousing_datetime", GV_WAREHOUSING_DATETIME);
				jObject.put( "expiration_date", GV_EXPIRATION_DATE);
				jObject.put( "part_cd", GV_PART_CD);
				jObject.put( "part_cd_rev", GV_PART_CD_REV);
				jObject.put( "part_nm", GV_PART_NM);
				jObject.put( "pre_amt", GV_POST_AMT); //불출후 이전재고 = 현재고
				if(GV_PART_CNT_temp.compareTo(BigDecimal.ZERO)>0) { //남은 불출수량이 0보다 크면 불출수량=GV_POST_AMT
					jObject.put( "io_amt", GV_POST_AMT);
					jObject.put( "post_amt", "0"); //불출후 현재고 = 0
					GV_PART_CNT = GV_PART_CNT.subtract(GV_POST_AMT);
				} else {//남은 불출수량이 0보다 크지 않으면 불출수량=GV_PART_CNT
// 				} else if(GV_PART_CNT_temp.compareTo(BigDecimal.ZERO)<=0 || j==RowCountPart-1) {//남은 불출수량이 0보다 크지 않으면(또는 마지막 재고면) 불출수량=GV_PART_CNT
					jObject.put( "io_amt", GV_PART_CNT);
					jObject.put( "post_amt", GV_POST_AMT.subtract(GV_PART_CNT)); //불출후 현재고 = 현재고-불출수량
					GV_PART_CNT = BigDecimal.ZERO;
				}
				jObject.put( "part_cnt", GV_IO_AMT);
				jObject.put( "order_no", GV_ORDER_NO);
				jObject.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
				jObject.put( "prod_cd", GV_PROD_CD);
				jObject.put( "prod_cd_rev", GV_PROD_CD_REV);
				jObject.put( "prod_nm", GV_PROD_NM);
				jObject.put( "member_key", member_key);
				
				// JSONObject 데이터를 쿼리메소드(PID)로 보낸다.
				rTurnValue = dbServletLink.queryProcessForjsp(jObject, false).split("\t");
				
				//System.out.println("rTurnValue[2].trim() ==="+rTurnValue[2].trim());
// 				response.setContentType("text/html");
// 			    response.setHeader("Cache-Control", "no-store");
// 			    response.getWriter().print(rTurnValue[2].trim());
			}catch(Exception e){
				System.out.println(e);
			}
			
		}
// 	}
	
%>
