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
// 	final int PageSize=15; 
	
	String GV_ORDERNO="",GV_ORDER_DETAIL_SEQ="",GV_LOTNO="",GV_PROD_CD="",GV_PROD_REV="" ;

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("OrderDetailSeq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailSeq");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");

	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_rev", GV_PROD_REV);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M101S040100E146", jArray);	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
 	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave}
	,{"on", "pop_fn_Trading_List(this)", "상세"}};
 	
	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS101S040146";
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	
%>
<script>
	
    $(document).ready(function () {
    	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [3,4,6,10],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
				
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    	
    	
    	vChulhaNo="";
    	vChulhaBigo="";
    });

    function ClickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		

		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
		
		vChulhaNo = td.eq(0).text().trim();
		vChulhaBigo = td.eq(9).text().trim();
		
		vCustCd   = td.eq(6).text().trim();
		vChulhaDt = td.eq(7).text().trim();
    }  

</script>

	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th>출하번호</th>
		     <th>주문번호</th>
		     <th>Lot번호</th>
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_rev</th>
		     <th>납품처</th>
		     <th style='width:0px; display: none;'>고객사번호</th>
		     <th>납품일자</th>
		     <th>납품담당자</th>
		     <th>출하비고</th>
		     
		     <th style='width:0px; display: none;'>출하seq구분번호</th>
		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		    <!--  <th></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
	
	<div id="UserList_pager" class="text-center">
	</div> 
