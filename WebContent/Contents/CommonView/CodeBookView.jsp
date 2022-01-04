<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String zhtml = "";
	int startPageNo = 1;
// 	final int PageSize=15;  vtbm_code_book
	
	String[] strColumnHead 	= {"코드","코드값", "코드이름","개정번호" ,"비고","start_date","duration_date","create_user_id","순서"};
	int[]   colOff 			= { 1,1,1,1,1,0,0,0,1};
	String[] TR_Style		= {""," onclick='CodeBookViewEvent(this)' "};
	String[] TD_Style		= {"","","","","","","","",""};		//strColumnHead의 수만큼
	String[] HyperLink		= {"","","","","","","","",""}; 	//strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String GV_CALLER="", GV_LEVEL="", GV_CODE_CD="";

	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("code_cd")== null)
		GV_CODE_CD="";
	else
		GV_CODE_CD = request.getParameter("code_cd");	


	String  param =  GV_CODE_CD + "|" + member_key + "|";
	
    TableModel = new DoyosaeTableModel("M909S140100E214", strColumnHead, param);
    int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();

    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableCodeBookView";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    zhtml = makeTableHTML.getHTML();
%>
  




 
<script>
 
	var caller="";
	var GV_GIJONG_CD;
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
		
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
    		scrollX: true,
//     		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 2, "asc" ]], 
    	    info: true,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	    });
	});
	
	function CodeBookViewEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
		var txt_code_cd		= td.eq(0).text().trim();
		var txt_code_value	= td.eq(1).text().trim();
		var txt_code_name	= td.eq(2).text().trim(); 
		var txt_revision_no	= td.eq(3).text().trim(); 
		var txt_bigo		= td.eq(4).text().trim();
		var txt_order_index		= td.eq(8).text().trim();
		
		
		if(caller==0){ //일반 화면에서 부를 때
			$('#txt_code_cd').val(txt_code_cd);
			$('#txt_code_value').val(txt_code_value);
			$('#txt_code_name').val(txt_code_name);
			$('#txt_revision_no').val(txt_revision_no);
		}
		else if(caller==1){ //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
 			parent.SetCodeBook(txt_code_cd,txt_code_value, txt_code_name,txt_revision_no);
		}
		parent.$('#modalReport_nd').hide();
	}
</script>	

<%=zhtml%>
<div id="UserList_pager" class="text-center">
	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport_nd').hide();">닫기</button>
</div> 

