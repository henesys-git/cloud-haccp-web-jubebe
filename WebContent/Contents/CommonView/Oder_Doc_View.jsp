<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@page import="org.json.simple.JSONObject"%>
<%@ include file="/strings.jsp" %>

<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	int startPageNo = 1;
// 	final int PageSize=15; 
	
	String[] strColumnHead 	= {"주문번호","문서번호","문서명","등록번호","Rev", "파일명", "file_real_name"};
	int[] colOff 			= { 0, 1, 1, 1,1,0,1};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='Oder_Doc_ViewEvent(this)' "};
	String[] TD_Style		= {"","","","","","","","","","","","","","","","","","","","","",""};  //strColumnHead의 수만큼
	String[] HyperLink		= {"","","","","","","","","","","","","","","","","","","","","",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String GV_SQUENCE="", GV_CALLER="", GV_ORDERNO="", GV_ORDER_DETAIL_SEQ,GV_LOTNO;

	if(request.getParameter("caller")== null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");	
	

	if(request.getParameter("squence")== null)
		GV_SQUENCE="";
	else
		GV_SQUENCE = request.getParameter("squence");	


	if(request.getParameter("orderno")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("orderno");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");

	String param =  GV_ORDERNO + "|"  + GV_ORDER_DETAIL_SEQ + "|"+ GV_LOTNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lot_no", GV_LOTNO);
	
	
    TableModel = new DoyosaeTableModel("M101S020100E124", strColumnHead, jArray);	
    int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();

    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "Oder_Doc_View";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    zhtml = makeTableHTML.getHTML();
%>
 
<script>
	var txt_regist_no ="";
	var txt_revision_no = "";
	var txt_file_view_name = "";
	var caller="";
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
    		scrollX: true,
//     		scrollY: 600,
    	    scrollCollapse: true,
    	    autoWidth: true,
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
	
	function Oder_Doc_ViewEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });


		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
				 
		txt_regist_no = td.eq(3).text().trim();
		txt_revision_no = td.eq(4).text().trim();
		txt_file_view_name = td.eq(6).text().trim();
		if(caller=="0"){
	 		$("#txt_regist_no", parent.document).val(txt_regist_no);
	 		$("#txt_revision_no", parent.document).val(txt_revision_no);
	 		$("#txt_file_view_name", parent.document).val(txt_file_view_name);
		}
		else if(caller==1){
 			parent.SetOderDocInfo(txt_file_view_name,txt_regist_no, txt_revision_no, '<%=GV_SQUENCE%>');
		}
		parent.$('#modalReport_nd').hide();
	}
	
</script>	
<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div> 
