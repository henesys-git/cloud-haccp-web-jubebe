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
	
	String GV_ORDER_NO="",GV_ORDER_DETAIL_SEQ="",GV_LOTNO="";

	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");
	
	if(request.getParameter("order_deatil_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_deatil_seq");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");	
	
	//String param =  GV_ORDER_NO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lot_no", GV_LOTNO);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M303S070100E114", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS303S070110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 
%>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		var vColumnDefs = [{
   			'targets': [11],
				'createdCell':  function (td) {
					$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
			}
			}
		];
		
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
	   			'targets': [11],
   				'createdCell':  function (td) {
						$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
   			}],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	}); 
    	--%>
        
    });
    
    function clickSubMenu(obj){
		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
    }
    
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th>주문번호</th>
			<th>프로젝트명</th>
			<th>제품명</th>
			<th>원부자재코드</th>
			<th>원부자재명</th>
			<th>요청일자</th>
			<th>불출희망일</th>
			<th>요청수량</th>
			<th>요청자</th>
			<th>수령인</th>
			<th>불출여부</th>
			<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>		
