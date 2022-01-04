<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String  GV_ORDER_NO="", GV_ORDER_DETAIL_SEQ="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");	
	
	if(request.getParameter("OrderDetailSeq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailSeq");	
	
	DoyosaeTableModel TableModel; 
	MakeTableHTML makeTableHTML;
	
	int startPageNo = 1;

	String[] strColumnHead 	= { "order_no","order_detail_seq","bulchul_req_no","part_cd","part_cd_rev","원부자재명","req_date","dept_code","부서명",
								"용도","구분","요청수량","단위","비고","불출일자","req_userid","수령인 ID","damdanja" };
	int[] colOff 			= { 0, 0, 0, 0, 0, 1, 0, 0, 1,
								1, 1, 1, 1, 1, 1, 0, 1 ,0 };	
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String param =  GV_ORDER_NO + "|" + GV_ORDER_DETAIL_SEQ + "|"  + member_key + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "member_key", member_key);
	
	
	TableModel = new DoyosaeTableModel("M303S040100E124", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    int colspanCount =TableModel.getColumnCount();
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS303S040120";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton;
    String zhtml=makeTableHTML.getHTML();
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">

    $(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	 
    		scrollX: true,
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 2, "asc" ]],
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
	});
	
	$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
		S303S040120_Row_index = vTableS303S040120.row( this ).index();
 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
 		vTableS303S040120.row(this).nodes().to$().attr("class","hene-bg-color");
	});
	
    </script>

    <%=zhtml%>

