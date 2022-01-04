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

// 챠트보기:4%,문서등록4%;문서View6%
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String GV_BAECHA_NO="" ;

	if(request.getParameter("baecha_no")== null)
		GV_BAECHA_NO="";
	else
		GV_BAECHA_NO = request.getParameter("baecha_no");
	
	//String param =  GV_ORDER_NO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "baecha_no", GV_BAECHA_NO);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M858S030100E114", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS858S030110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 
%>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		var vColumnDefs = [{
	    	'targets': [0,1,2,6],
   			'createdCell':  function (td) {
      			$(td).attr('style', 'display: none;'); 
   			}
	    },
		{
   			'targets': [12],
				'createdCell':  function (td) {
					$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
			}
		}];
		
		henesysSubTableOptions.data =<%=makeGridData.getDataArry()%>;
		henesysSubTableOptions.columnDefs = vColumnDefs;
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(henesysSubTableOptions);
    	
    	
    	<%-- $('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    	    scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 1, "asc" ]],
    	    keys: true,
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
   			// 조회컬럼크기
   			columnDefs: [{
    	    	'targets': [0,1,2,6],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
			{
	   			'targets': [12],
   				'createdCell':  function (td) {
						$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
			}],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	}); --%>
        
    	vTransportNo = "";
    });
    
    function clickSubMenu(obj){
    	var tr = $(obj);
  		var td = tr.children();
  		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
  		
  		$(SubMenu_rowID).attr("class", "");
  		$(obj).attr("class", "hene-bg-color");
		
		vTransportNo = td.eq(0).text().trim();
    }
    
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
				<th style='width:0px; display: none;'>transport_no</th>
				<th style='width:0px; display: none;'>baecha_no</th>
				<th style='width:0px; display: none;'>baecha_seq</th>
			    <th>운송시작일시</th>
			    <th>운송종료일시</th>
			    <th>차량번호</th>
			    <th style='width:0px; display: none;'>차량번호rev</th>
			    <th>차량명칭</th>
			    <th>주행거리(주행후)</th>
			    <th>주행거리(운행km)</th>
			    <th>배송기사</th>
			    <th>비고</th>
			    <!-- 버튼자리 -->
			    <th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>		
