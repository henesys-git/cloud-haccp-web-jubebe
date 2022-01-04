<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String Fromdate="",Todate="", GV_PARTGUBUN_BIG="", GV_PARTGUBUN_MID="";
	
	if(request.getParameter("partgubun_big") == null)
		GV_PARTGUBUN_BIG = "";
	else
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") == null)
		GV_PARTGUBUN_MID = "";
	else
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");
	
	String param = GV_PARTGUBUN_BIG + "|" + GV_PARTGUBUN_MID + "|"  + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put("partgubun_big", GV_PARTGUBUN_BIG);
	jArray.put("partgubun_mid", GV_PARTGUBUN_MID);
	jArray.put("member_key", member_key);
    TableModel = new DoyosaeTableModel("M202S010100E504", jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID = "tableS202S010500";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script>
    $(document).ready(function () {

    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArry()%>,
    			columnDefs : [
    				{
	    	       		'targets': [],
	    	       		'createdCell':  function(td) {
	    	          			$(td).attr('style', 'display: none;'); 
	    	       		}
	    	    	},
	    	    	{
	    	    		'targets': [7,8],
	    	    		'render': function(data) {
	    	    			return addComma(data);
	    	    		},
			  			'className' : "dt-body-right"
	    	    	}
    			],
    	    	order : [[ 0, "asc" ], [ 1, "asc" ],
    	    			 [ 2, "asc" ], [3, "asc" ],[4, "asc" ]],
    	    	pageLength : 10
    	}

    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    	
    	vPartgubun_big	= "";
    	vPartgubun_mid	= "";
    	vPartCd			= "";
    });
    
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;	//현재 클릭한 TR의 순서 return .bg-success
		
		vPartNo = td.eq(4).text().trim();
	}
	
    function fn_Clear_varv(){
		vOrderNo 		= "";
		vProd_serial_no	= "";
		vOrderDetailSeq	= "";
		vBalju_req_date	= "";
		vBalju_no		= "";
    }
    
    function fn_doc_registeration(){
         var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/FileUpload/com_Fileupload.jsp";
         modalFramePopup.setTitle("파일 업로드");
         modalFramePopup.show(modalContentUrl, "700px", "1400px");
         return false;
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			 <th>대분류</th>
			 <th>중분류</th>
		     <th>코드</th>
		     <th>원부재료/자재 명</th>
		     <th>규격</th>
		     <th>제조사</th>
		     <th>공급사</th>
		     <th>적정재고(ea)</th>
		     <th>현재고(ea)</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
	
<div id="UserList_pager" class="text-center">
</div>              