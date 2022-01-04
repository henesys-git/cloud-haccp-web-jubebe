<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.* ,org.json.simple.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
J909S110100.jsp
 */ 
	String member_key = session.getAttribute("member_key").toString();
	String GV_PID = "M909S110100E104";
	String GV_PARM = "";
	
	String[] cols 			= {"A.part_gubun_b", "A.part_gubun_m",
							   "A.serial_num", "A.gyugyeok",
							   "A.part_level", "A.part_cd",
							   "A.revision_no", "A.part_nm", 
							   "A.unit_price", "A.safety_jaego", 
							   "A.duration_date", "A.part_gubun", 
							   "part_gubun_name", "total"
							  };
	
	String[] strColumnHead 	= {"대분류", "중분류",
							   "일련번호", "단위규격", 
							   "Level", "코드", 
							   "개정번호", "원자재명", 
							   "단가", "안전재고", 
							   "적용만료일", "part_gubun", 
							   "원부자재 구분", "토탈"
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
    
	String GV_PARTGUBUN_BIG = "", GV_PARTGUBUN_MID = "", 
		   GV_PARTGUBUN_SM = "", GV_REV_CHECK = "";
	
	if(request.getParameter("partgubun_big") != null)
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") != null)
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");
	
	if(request.getParameter("partgubun_sm") != null)
		GV_PARTGUBUN_SM = request.getParameter("partgubun_sm");
	
	if (request.getParameter("total_rev_check") != null)
		GV_REV_CHECK = request.getParameter("total_rev_check");
	
	String G_where = " WHERE A.part_gubun_b LIKE '" + GV_PARTGUBUN_BIG + "%' "
			+ "	AND A.part_gubun_m LIKE '" + GV_PARTGUBUN_MID + "%' "
			+ " AND SYS_DATE BETWEEN A.start_date AND A.duration_date ";
	
	if(GV_REV_CHECK.equals("true")) 
		G_where = " where A.part_gubun_b like '" + GV_PARTGUBUN_BIG + "%' "
				+ "	AND A.part_gubun_m like '" + GV_PARTGUBUN_MID + "%' ";
	else if(GV_REV_CHECK.equals("false")) 
		G_where = " where A.part_gubun_b like '" + GV_PARTGUBUN_BIG + "%' "
				+ "	AND A.part_gubun_m like '" + GV_PARTGUBUN_MID + "%' "
				+ " AND SYS_DATE BETWEEN A.start_date  AND  A.duration_date ";
    
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
    
	if(request.getParameter("search[value]") == null) {
		searchTerm="";
	} else {
		searchTerm = request.getParameter("search[value]");
		//검색조건을 프로그램에 적절한 칼럼으로 변경한다
		globeSearch =  " AND (A.part_cd LIKE '%"+searchTerm+"%'"
                + " OR A.part_nm LIKE '%"+searchTerm+"%'"
             	+ " OR A.gyugyeok LIKE '%"+searchTerm+"%'"
              	+ " OR A.alt_part_cd LIKE '%"+searchTerm+"%' )";
	}
	
	String G_orderby = " ORDER BY A.part_cd ASC, A.revision_no ASC ";
	String G_limit = " LIMIT " + start + ", " + amount;	//페이지처리

	try {
		JSONObject jArrayParam = new JSONObject();
		jArrayParam.put("g_where", G_where);
		jArrayParam.put("g_search", globeSearch);
		jArrayParam.put("g_orderby", G_orderby);
		jArrayParam.put("g_limit", G_limit);
		
		DoyosaeTableModel TableModel = new DoyosaeTableModel(GV_PID, jArrayParam);
	    
		int RowCount = TableModel.getRowCount();
		
		String totalRowCount = "0";
		
		if(RowCount > 0) {
		    totalRowCount = TableModel.getValueAt(0,12).toString().trim();		
		}
	    	
	    JSONArray jBrray = new JSONArray();
		
	    for(int i=0; i<RowCount; i++ ) {
			JSONObject jArray = new JSONObject();
			for(int j=0; j< strColumnHead.length; j++){
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