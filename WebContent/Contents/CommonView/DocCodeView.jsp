<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ include file="/strings.jsp" %>

<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	int startPageNo = 1;
// 	final int PageSize=15; 
	
	String[] strColumnHead 	= {"문서코드","개정번호", "문서명","비밀여부","보존기한","문서구분코드","문서구분명"} ;	
	int[]   colOff 			= {10, 1, 10, 10, 10, 15, 10} ;
	String[] TR_Style		= {""," onclick='DocCodeViewEvent(this)' "};
	String[] TD_Style		= {"","","","","","","","","","","","","","","","","","","","","",""};  //strColumnHead의 수만큼
	String[] HyperLink		= {"","","","","","","","","","","","","","","","","","","","","",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String GV_NUM="", GV_CALLER="", GV_DOC_GUBUN="", GV_DOC_NO="";

	if(request.getParameter("caller")== null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");	
	

	if(request.getParameter("num")== null)
		GV_NUM="0";
	else
		GV_NUM = request.getParameter("num");	
	
	if(request.getParameter("doc_gubun")== null)
		GV_DOC_GUBUN="";
	else
		GV_DOC_GUBUN = request.getParameter("doc_gubun");
	
	if(request.getParameter("doc_no")== null)
		GV_DOC_NO="";
	else
		GV_DOC_NO = request.getParameter("doc_no");
	
	String param = GV_DOC_GUBUN + "|" + GV_DOC_NO + "|" + member_key + "|";
		
    TableModel = new DoyosaeTableModel("M909S130100E194", strColumnHead, param);
    int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();

    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "DocCodeView";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    zhtml = makeTableHTML.getHTML();
%>
 
<script>
	var txt_DocName ="";
	var txt_Doccode = "";
	var txt_revision_no = "";
	var txt_Doc_gubun_code = "";
	var caller="";
	
	$(document).ready(function () {
		
		setTimeout(function(){
		
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
    	    
    	    'createdRow': function(row) {	
    	    	$(row).attr('id', "<%=makeTableHTML.htmlTable_ID%>_rowID");
    	    	$(row).attr('onclick', "<%=makeTableHTML.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},
    	    
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	    });
		
		}, 300);
		
	});
	
	function <%=makeTableHTML.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();
		
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });


		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
				
		txt_Doccode 		= td.eq(0).text().trim(); 
		txt_revision_no 	= td.eq(1).text().trim();
		txt_DocName 		= td.eq(2).text().trim();
		txt_Doc_gubun_code 	= td.eq(5).text().trim();
		txt_Doc_gubun_nm 	= td.eq(6).text().trim();
		if(caller=="0"){
	 		$("#txt_DocName", parent.document).val(txt_DocName);
	 		$("#txt_Doccode", parent.document).val(txt_Doccode);
	 		$("#txt_revision_no", parent.document).val(txt_revision_no);
	 		$("#txt_Doc_gubun_code", parent.document).val(txt_Doc_gubun_code);
		}
		else if(caller==1){
 			parent.SetDocName_code(txt_DocName, txt_Doccode, txt_revision_no, '<%=GV_NUM%>', txt_Doc_gubun_code, txt_Doc_gubun_nm);
		}
		
		$('#modalReport2').modal('hide');
	}
	
	function fun_retObj(DocName, Doccode){
		this.txt_DocName = DocName;
		this.txt_Doccode = Doccode;
		alert(DocName);
		return;
	}
	
	
</script>	
<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div> 
