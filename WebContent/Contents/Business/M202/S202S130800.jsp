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
	
	String[] strColumnHead = { "보관위치", "원부자재코드", "구품코드", "원부자재명", "출고량(합)", "입고량(합)", "위치재고량", "안전재고" }; 
	int[]   colOff 			= {150,	160	,0,250,120,120,120,120};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S202S130800Event(this)' "};
	String[] TD_Style		= {" align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {"fn_LoadMaterialInfo(this)"}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String Fromdate="",Todate="", MACHINE_NO="", GV_JSPPAGE;

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("machineNo")== null)
		MACHINE_NO="";
	else
		MACHINE_NO = request.getParameter("machineNo");	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
	String param = MACHINE_NO + "|" + Fromdate + "|" + Todate + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "machine_no", MACHINE_NO);
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M202S010100E504", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS202S130800";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
//     makeTableHTML.MAX_HEIGHT	= " height:550px";
    zhtml = makeTableHTML.getHTML();
    
//     int ColCount =TableModel.getColumnCount()+1;
//     out.println(zhtml);		oTable
%>
<script>
  
    $(document).ready(function () {       
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	
    		scrollX: true,
//     		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "desc" ]],
    	    info: false,
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});


    	
    	
		$("#checkboxAll").click(function(){ 			//만약 전체 선택 체크박스가 체크된상태일경우 
			if($("#checkboxAll").prop("checked")) { 	//해당화면에 전체 checkbox들을 체크해준다 
				$("input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우 
			} else {  
				$("input[type=checkbox]").prop("checked",false); 
			} 
		})
    });
    
	function S202S130800Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });

	
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		vPartNo = td.eq(1).text().trim(); 
        fn_DetailInfo_List();
	}
	
    function fn_Clear_varv(){
		vOrderNo 		= "";
		vProd_serial_no	= "";
		vOrderDetailSeq	= "";
		vBalju_req_date	= "";
		vBalju_no		= "";
// 		$('#txt_custcode').val("");
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