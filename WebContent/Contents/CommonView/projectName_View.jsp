<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>

<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	int startPageNo = 1;
// 	final int PageSize=15; 
	
	String[] strColumnHead 	= {"고객번호","cust_rec", "고객사명", "프로젝트명", "프로젝트수량", "고객사 Po No","제품코드","제품명"};	 
	int[]   colOff 			= {10,0, 10, 25,  20,1,1,1};
	String[] TR_Style		= {""," onclick='ProjectNameViewEvent(this)' "};
	String[] TD_Style		= {"","","","","","","","","",""};  //strColumnHead의 수만큼
	String[] HyperLink		= {"","","","","","","","","",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String SEARCH_GIJONG_CODE="", GV_CALLER="",SEARCH_SIZE_CODE="",SEARCH_MYUNSU_CODE="",SEARCH_FOLDING_CODE="",SEARCH_OPTION_CODE="";

	if(request.getParameter("caller")== null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");	
	
	String param = "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M101S020100E514", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();

    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tablePrpjectView";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    zhtml = makeTableHTML.getHTML();
%>

 
<script>
// document.body.onload = function () { window.print();}
	var txt_CustName;
	var caller="";
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";	
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    
    		scrollX: true,
//     		scrollY: 400,
    	    scrollCollapse: true,
    	    autoWidth: false,
    	    processing: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "desc" ]],
    	    info: true,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	    });
		
	});
	
	function ProjectNameViewEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");

		var cust_cd 		= td.eq(0).text().trim();
		var cust_rev		= td.eq(1).text().trim(); 
		var cust_nm 		= td.eq(2).text().trim(); 
		var project_name	= td.eq(3).text().trim(); 
		var projrctCnt		= td.eq(4).text().trim(); 
		var cust_pono 		= td.eq(5).text().trim(); 
		var prod_cd 		= td.eq(6).text().trim(); 
		var product_nm 		= td.eq(7).text().trim(); 
		
		if(caller=="0"){ //일반 화면에서 부를 때
			$('#txt_projrctName', parent.document).val(project_name);
			$('#txt_CustName', parent.document).val(cust_nm);
			$('#txt_cust_code', parent.document).val(cust_cd);
			$('#txt_cust_rev', parent.document).val(cust_rev);
			$('#txt_prod_cd', parent.document).val(prod_cd);
			$('#txt_product_nm', parent.document).val(product_nm);
			$('#txt_projrctCnt', parent.document).val(product_nm);
		}
		else if(caller==1){ //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
//  			top.document.getElementById("ReportNote").contentWindow.
 			parent.SetCustProjectInfo(cust_cd, cust_nm,project_name,cust_pono,prod_cd, product_nm,cust_rev, projrctCnt);
		}
		
		parent.$('#modalReport_nd').hide();
// 		window.close();
	}
	
	
</script>	
<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div> 
