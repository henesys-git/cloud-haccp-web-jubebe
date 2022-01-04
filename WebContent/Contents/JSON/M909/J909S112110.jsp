<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.* ,org.json.simple.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
S909S112110.jsp
 */
 	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel, totalTableModel;
	JsonData jsonData;
	String GV_PID="M909S112100E114";
	String GV_PARM="";
	//M909S112100E114 의 Query문의 칼럼 명을 그대로 적용한다
	//한글명칭은 화면에 뿌려주는 S909S112110.jsp의 columns:의 Member들과 일치시킨다.
	String[] cols 			= {"machineno","rakes","plate","colm", "use_yn"};
	String[] strColumnHead 	= {"창고번호", "렉번호", "선반번호","칸번호", "사용여부"};	

    JSONObject result = new JSONObject();
    JSONArray array = new JSONArray();

    int amount = 10;
    int start = 0;
    int echo = 0;
    int col = 0;
    String dir="";
    String sdraw = request.getParameter("draw");
    String sEcho = request.getParameter("sEcho");
    String sStart = request.getParameter("start");
    String slength = request.getParameter("length");
    String sCol = request.getParameter("iSortCol_0");
    String sdir = request.getParameter("sSortDir_0"); 
    

	String GV_MACHINENO="" , GV_PARTGUBUN_MID="";
	if(request.getParameter("machineno")== null)
		GV_MACHINENO="";
	else
		GV_MACHINENO = request.getParameter("machineno");

	String G_where = " where machineno like '" + GV_MACHINENO + "%'  AND member_key = '" + member_key +  "' ";
    String individualSearch = "";
    
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
    
    String searchSQL = "";
    String searchTerm = "";
    String globeSearch ="";
    
	if(request.getParameter("search[value]")== null)
		searchTerm="";
	else{
		searchTerm = request.getParameter("search[value]");
		//검색조건을 프로그램에 적절한 칼럼으로 변경한다
		globeSearch =  G_where + " AND (machineno like '%"+searchTerm+"%')";
	}
	System.out.println("searchTerm==="+ searchTerm);
    if(searchTerm!="" && individualSearch!=""){
        searchSQL = globeSearch + " and " + individualSearch;
    }
    else if(individualSearch!=""){
        searchSQL = G_where + individualSearch;
    }else if(searchTerm!=""){
        searchSQL=globeSearch;
    }
    else
    	searchSQL= G_where;
    
    //M909S112100E114 Query의 From Table이후
    //Where이하 모드를 여기에서 구성하여 파라메타로 전달한다.
    GV_PARM += searchSQL;
    GV_PARM += " order by machineno asc, rakes asc, plate asc,  colm asc ";
    GV_PARM += " limit " + start + ", " + amount;	//페이지처리
	
	try {     
	    TableModel = new DoyosaeTableModel(GV_PID, strColumnHead, GV_PARM +"|");
	    
	    totalTableModel = new DoyosaeTableModel(GV_PID, strColumnHead, G_where + "|");
	    int totalRowCount = totalTableModel.getRowCount();
	    int RowCount = TableModel.getRowCount();
	    int ColCounter = TableModel.getColumnCount();
	    
	    JSONArray jBrray = new JSONArray();
		for(int i=0; i<RowCount; i++ ){
			JSONObject jArray = new JSONObject();
			for(int j=0; j< strColumnHead.length; j++){
				jArray.put( strColumnHead[j], TableModel.getValueAt(i,j).toString().trim());
			}
			jBrray.add(jArray);
		}
		
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
