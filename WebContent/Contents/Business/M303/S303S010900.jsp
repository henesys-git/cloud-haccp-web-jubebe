<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	DBServletLink dbLink = new DBServletLink();
	DateTimeUtil dateTimeUtil = new DateTimeUtil();
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GIJONG_CODE="", BOM_CODE="", PROC_CD="";
	String param = "";
	int startPageNo = 1;
// 	Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
		
// 	final int PageSize=15; 

	String[] strColumnHead 	= { "BOM명", "원부자재", "원부자재수량","원부자재넓이","원부자재높이","원부자재두께","규격","상세규격","재질","2D도면", "BOM비고", "기종코드", "BOM일련번호", "원부자재코드" };
	int[] colOff 			= {20, 10, 5, 5, 5, 5, 5, 10, 5, 5, 19, 0, 0, 0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "file_real_name", rightbtnDocShow}};

	if(request.getParameter("GijongCode")== null)
		GIJONG_CODE="";
	else
		GIJONG_CODE = request.getParameter("GijongCode");
	
	if(request.getParameter("bomCode")== null)
		BOM_CODE="";
	else
		BOM_CODE = request.getParameter("bomCode");	
	
	if(request.getParameter("procCD")== null)
		PROC_CD="";
	else
		PROC_CD = request.getParameter("procCD");
		
	
	param = GIJONG_CODE + "|" + BOM_CODE + "|"+ PROC_CD + "|" + member_key + "|";	
	TableModel = new DoyosaeTableModel("M101S11000E114", strColumnHead, param);
 	int RowCount =TableModel.getRowCount();	
    int colspanCount =TableModel.getColumnCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableS010900";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();
%>

    
<script>
	$(document).ready(function () {

    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	 
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "desc" ]],
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
	    
	});

	function fn_Clear_varv(){
		vOrderNo 			= "";
		vProd_serial_no	= "";
		vOrderDetailSeq 		= "";
		vOrder_cnt 			= "";
		vCustCode 			= "";
	//		vGIJONG_CODE 		= "";
		$('#txt_custcode').val("");
	}

</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>
