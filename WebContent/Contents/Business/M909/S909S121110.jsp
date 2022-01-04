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
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String GV_PRODCD="", GV_PRODCD_REV="";
	
	if(request.getParameter("Prod_cd")== null)
		GV_PRODCD="";
	else
		GV_PRODCD = request.getParameter("Prod_cd");
	
	if(request.getParameter("Prod_cd_rev")== null)
		GV_PRODCD_REV="";
	else
		GV_PRODCD_REV = request.getParameter("Prod_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "prod_cd", GV_PRODCD);
	jArray.put( "prod_cd_rev", GV_PRODCD_REV);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M909S121100E114", jArray);	
 	//int ColCount =TableModel.getColumnCount();
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
	
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS909S121110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		var vColumnDefs = [{
	    	'targets': [1,3,8,13,14,16,17,18,19,20,21],
   			'createdCell':  function (td) {
      			$(td).attr('style', 'display: none;'); 
   			}
	    },
			// 문서버튼
		{
   			'targets': [22],
				'createdCell':  function (td) {
				//	$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
			}
		}];
		
		henesysSubTableOptions.data =<%=makeGridData.getDataArry()%>;
		henesysSubTableOptions.columnDefs = vColumnDefs;
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(henesysSubTableOptions);
    	
    	<%-- 
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    	    scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "desc" ],[ 3, "asc" ]],
    	    info: false,    
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{
    	    	'targets': [1,3,8,13,14,16,17,18,19,20,21],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
   			// 문서버튼
			{
	   			'targets': [22],
   				'createdCell':  function (td) {
					//	$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
			}],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	});   
    	
    	--%>
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
    }  
    

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th>공정코드</th>
			<th style='width:0px; display: none;'>공정rev</th>
			<th>공정명</th>
			<th style='width:0px; display: none;'>공정 seq</th>
			<th>부서구분</th>
			<th>표준공수</th>
			<th>필요인원수</th>
			<th>설비코드</th>
			<th style='width:0px; display: none;'>설비rev</th>
			<th>설비라인</th>
			<th>비고</th>
			<th>시작일</th>
			<th>생성일</th>
			<th style='width:0px; display: none;'>생성자</th>
			<th style='width:0px; display: none;'>수정일자</th>
			<th style='width:0px; display: none;'>수정자</th>
			<th>지속기간</th>
			<th style='width:0px; display: none;'>수정사유</th>
			<th style='width:0px; display: none;'>check_data_type</th>
			<th style='width:0px; display: none;'>삭제여부</th>
			<th style='width:0px; display: none;'>생산공정 여부</th>
			<th style='width:0px; display: none;'>종합공정 여부</th>
			<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
