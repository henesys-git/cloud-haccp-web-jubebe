<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	//String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String Fromdate="",Todate="", GV_PARTGUBUN_BIG="", GV_PARTGUBUN_MID="";
	
	if(request.getParameter("partgubun_big") == null)
		GV_PARTGUBUN_BIG = "";
	else
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") == null)
		GV_PARTGUBUN_MID = "";
	else
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");
	
	String param = GV_PARTGUBUN_BIG + "|" + 
				   GV_PARTGUBUN_MID + "|"  + 
				   member_key;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("partgubun_big", GV_PARTGUBUN_BIG);
	jArray.put("partgubun_mid", GV_PARTGUBUN_MID);
	
	//tablet 관련부분//////////////////////////////////////
	/* String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY = "";
	else
		GV_TABLET_NY = request.getParameter("TabletYN"); */
	////////////////////////////////////////////////////
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M202S050100E010", jArray);	

	MakeGridData makeGridData= new MakeGridData(TableModel);
 	//makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S050200";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""};
 	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">
  
    $(document).ready(function () {  
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	       		'targets': [2,6],
   	       		'createdCell':  function (td) {
   	          			$(td).attr('style', 'display: none;'); 
   	       		}
   	    	},
   			{
	  			'targets': [7,8],
	  			'render': function(data){
	  				
	  				return addComma(data);
	  			},
	  			'className' : "dt-body-right"
	  		}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    	
		vPartgubun_big	= "";
    	vPartgubun_mid	= "";
    	vPartCd			= "";
	 	vPartRev		= "";

    });
    
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
 	    });
	
		/* $(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color"); */
		
		vPartgubun_big	= td.eq(0).text().trim();
		vPartgubun_mid	= td.eq(1).text().trim();
		vPartNo  = td.eq(3).text().trim(); 
		vPartRev = td.eq(5).text().trim();
		
        //fn_DetailInfo_List();
		parent.DetailInfo_List.click();
	}
 
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>대분류</th>
			<th>중분류</th>
			<th style='width:0px; display: none;'>이력 추적 키</th>
			<th>품목코드</th>
			<th>원부재료/자재명</th>
			<th>규격</th>
			<th style='width:0px; display: none;'>원부재료/자재 수정이력번호</th>
			<th>현재재고</th>
			<th>적정재고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>