<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.* ,org.json.simple.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
JPartCodeView.jsp
 */
 
 	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel, totalTableModel;
	JsonData jsonData;
	String GV_PID = "M909S110100E114";
	String GV_PARM = "";
	//한글명칭은 화면에 뿌려주는 JPartCodeView.jsp의 columns:의 Member들과 일치시킨다.
	String[] cols = {
					 	"gubun_b", "gubun_m", "A.gyugyeok", "A.part_level", 
				     	"A.part_cd", "A.revision_no", "A.part_nm", "A.unit_price", 
					 	"A.safety_jaego", "A.source_barcode", "A.alt_part_cd", "B.part_nm", 
					 	"A.alt_revision_no", "A.start_date", "A.duration_dat", "A.part_gubun_b",
					 	"A.part_gubun_m", "total","A.wonsanji", "jaego", 
						"detail_gyugyeok"
				    };
	String[] strColumnHead = {
								"원부자재 대분류", "원부자재 중분류", "규격", "원부자재Level", 
								"원부자재코드", "개정번호", "원부자재명", "단가" , 
								"안전재고", "바코드", "대체품코드","대체품명", 
								"대체개정번호", "적용일자", "적용만료일", "part_gubun_b",
								"part_gubun_m", "total", "원산지", "재고",
								"g단위규격"
							 };

    int amount = 10;
    int start = 0;
    int echo = 0;
    int col = 0;
    String dir = "";
    String sdraw = request.getParameter("draw");
    String sEcho = request.getParameter("sEcho");
    String sStart = request.getParameter("start");
    String slength = request.getParameter("length");
    String sCol = request.getParameter("iSortCol_0");
    String sdir = request.getParameter("sSortDir_0");

	String GV_PARTGUBUN_BIG = "" , GV_PARTGUBUN_MID = "", 
		   GV_PARTGUBUN = "", GV_CUST_CODE = "";
	
	if(request.getParameter("partgubun_big") != null)
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") != null)
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");
	
	if(request.getParameter("partgubun") != null)
		GV_PARTGUBUN = request.getParameter("partgubun");

	if(request.getParameter("cust_code") != null)
		GV_CUST_CODE = request.getParameter("cust_code");
	
	String G_where = " WHERE A.part_gubun_b LIKE '" + GV_PARTGUBUN_BIG + "%' 	\n"
					+ "	AND A.part_gubun_m LIKE '" + GV_PARTGUBUN_MID + "%' 	\n"
					+ " AND SYS_DATE BETWEEN A.start_date AND A.duration_date 	\n"
					+ "	AND A.member_key = '" + member_key +  "' 				\n";
	if( !GV_CUST_CODE.equals("") ) {
		G_where += "	AND M.cust_cd LIKE '" + GV_CUST_CODE + "%' ";
	}
	if(GV_PARTGUBUN.equals("IMPORT") || GV_PARTGUBUN.equals("IMPORT2")){
		G_where += "	AND A.part_gubun = '" + GV_PARTGUBUN +  "' ";
	}

    if (sStart != null) {
        start = Integer.parseInt(sStart);
        if (start < 0)
            start = 0;
    }
    if (slength != null) {
        amount = Integer.parseInt(slength);
        if (amount < 5 || amount > 100)
            amount = 5;
    }
    if (sEcho != null) {
        echo = Integer.parseInt(sEcho);
    }
    if (sCol != null) {
        col = Integer.parseInt(sCol);
        if (col < 0 || col > 5)
            col = 0;
    }
    if (sdir != null) {
        if (!sdir.equals("asc"))
            dir = "desc";
    }
    String colName = cols[col];
    String searchTerm = "";
    String globeSearch ="";
    
	if(request.getParameter("search[value]") != null) {
		
		searchTerm = request.getParameter("search[value]");

		globeSearch = "AND (A.part_cd like '%"+searchTerm+"%'		\n"
                	+ " 	OR A.part_nm like '%"+searchTerm+"%'	\n"
             		+ " 	OR A.gyugyeok like '%"+searchTerm+"%'	\n"
               		+ " 	OR C.code_name like '%"+searchTerm+"%'	\n"
              		+ " 	OR D.code_name like '%"+searchTerm+"%'	\n"
              		+ " 	OR A.alt_part_cd like '%"+searchTerm+"%')";
	}
	
	
	String G_orderby = " ORDER BY A.part_cd ASC, A.revision_no ASC ";
	String G_limit = " LIMIT " + start + ", " + amount;	//페이지처리
	
	try {     
		JSONObject jArrayParam = new JSONObject();
		jArrayParam.put( "g_where", G_where);
		jArrayParam.put( "g_search", globeSearch);
		jArrayParam.put( "g_orderby", G_orderby);
		jArrayParam.put( "g_limit", G_limit);
		
		TableModel = new DoyosaeTableModel(GV_PID, jArrayParam);
	    int RowCount = TableModel.getRowCount();
	    
	    String totalRowCount = "0";
	    if(RowCount>0) {
	    	totalRowCount = TableModel.getValueAt(0,17).toString().trim();
	    }
	    
	    JSONArray jBrray = new JSONArray();
		for(int i = 0; i < RowCount; i++) {
			JSONObject jArray = new JSONObject();
			for(int j = 0; j < strColumnHead.length; j++) {
				jArray.put( strColumnHead[j], TableModel.getValueAt(i,j).toString().trim());
			}
			jBrray.add(jArray);
		}
		
		JSONObject result = new JSONObject();
		result.put("draw", Integer.parseInt(sdraw));
		result.put("sEcho", echo);
	    result.put("length", RowCount);
		result.put("iTotalRecords", totalRowCount);
	    result.put("iTotalDisplayRecords", totalRowCount);
	    result.put("aaData", jBrray);
	    
	    response.setContentType("application/json");
	    response.setHeader("Cache-Control", "no-store");
    
	    response.getWriter().print(result);
	} catch (Exception e) {
	    e.printStackTrace();
	    response.setContentType("text/html");
	    response.getWriter().print(e.getMessage());
	}	
%>