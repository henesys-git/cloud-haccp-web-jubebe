<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;

	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	
	String[] strColumnHead = {"요청일","요청자","고객","Project(기종)","납품계약일","실납품일","발주일", "발주담당자","발주확인일","발주확인담당","발주업체","발주내용",  
	"진행상태","입고예정일", "BALJU_NO","REQ_USER_ID", "CUST_CD","BALJU_UPCHE_CD","BALJU_USER_ID","MANAGER_USER_ID", "BALJU_STATUS","ORDER_NO",
	"ORDER_DETAIL_SEQ","발주용도","발주용도내용" };
	int[]   colOff = {0, 0, 0, 0, 0, 0, 10, 8, 10, 8, 10,0,8,10,0,0,0,0,0,0,0,0,0,0,10};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S202S020300Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {"fn_LoadMaterialInfo(this)"}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "file_real_name", "입고문서"}};;

	String Fromdate="",Todate="", GV_PROCESS_STATUS="";

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("Process_status")== null)
		GV_PROCESS_STATUS="";
	else
		GV_PROCESS_STATUS = request.getParameter("Process_status");	
	
	String param = Fromdate + "|" + Todate + "|"+ GV_PROCESS_STATUS + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "process_status", GV_PROCESS_STATUS);
	jArray.put( "member_key", member_key);	
	
//     TableModel = new DoyosaeTableModel("M202S020100E304", strColumnHead, param);
    TableModel = new DoyosaeTableModel("M202S020100E304", strColumnHead, jArray);
//     TableModel = new DoyosaeTableModel("M202S50000E004", strColumnHead, param);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS202S020300";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    zhtml = makeTableHTML.getHTML();
    
//     int ColCount =TableModel.getColumnCount()+1;
//     out.println(zhtml);
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
    
	function S202S020300Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });

	
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

	 	 vBalju_req_date = td.eq(1).text().trim(); 
	 	 vBalju_no = td.eq(15).text().trim(); 
        fn_DetailInfo_List();
	}
    function fn_doc_registeration(){

         var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/FileUpload/com_Fileupload.jsp";
         modalFramePopup.setTitle("파일 업로드");
         modalFramePopup.show(modalContentUrl, "700px", "1400px");
         return false;
    }    
</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>              