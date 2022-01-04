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
	

	String RightButton[][]	= {{"on", "fn_View_Canvas(this)", "검수일지"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "pop_fn_work_start(this)", "생산시작"}};

	String GV_ORDERNO="", GV_LOTNO="", GV_PROD_CD="", GV_PROD_CD_REV="",
			GV_DELIVERY_DATE="",GV_EXPIRATION_DATE="",GV_ORDERDETAIL="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("DeliveryDate")== null)
		GV_DELIVERY_DATE="";
	else
		GV_DELIVERY_DATE = request.getParameter("DeliveryDate");
	
	if(request.getParameter("ExpirationDate")== null)
		GV_EXPIRATION_DATE="";
	else
		GV_EXPIRATION_DATE = request.getParameter("ExpirationDate");
	
	if(request.getParameter("OrderDetail")== null)
		GV_ORDERDETAIL="";
	else
		GV_ORDERDETAIL = request.getParameter("OrderDetail");	
	
	//String param =  GV_ORDERNO + "|" + GV_LOTNO + "|"  + "|"  + "|"  ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "package_no", "");
	jArray.put( "delivery_date", GV_DELIVERY_DATE);
	jArray.put( "expiration_date", GV_EXPIRATION_DATE);
	jArray.put( "order_detail_seq", GV_ORDERDETAIL);
	jArray.put( "member_key", member_key);
		
	TableModel = new DoyosaeTableModel("M303S060700E114", jArray);
 	int RowCount =TableModel.getRowCount();	


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
  	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
 	
  	makeGridData.htmlTable_ID	= "tableS303S060710";
  
 	//makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink; 

%>

    
<script>
	$(document).ready(function () {
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		var vColumnDefs = [
  			{
	   			'targets': [0,1,2,7,8],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
			},
			{
	   			'targets': [9],
	   			'createdCell':  function (td) {
//		   				$(td).attr(); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
	   		}
		]
		
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
    	    order: [[ 2, "asc" ]],
    	    info: false,         
    	    data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
	  			{
		   			'targets': [0,1,2,7,8],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [9],
		   			'createdCell':  function (td) {
// 		   				$(td).attr(); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],    
          	language: { 
              url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
           	}
		});
    	
    	vPackageNo = "";
    	vExec_Note = ""; --%>
    	
    	vPackageNo = "";
    	vExec_Note = "";
    	
	});

	function clickSubMenu(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-success");

// 	     vOrderNo		= td.eq(0).text().trim();
// 	     vLotNo 		= td.eq(1).text().trim();
	     vPackageNo	= td.eq(2).text().trim();
	     vExec_Note	= td.eq(5).text().trim();
	     
	}
	
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			<th style='width:0px; display: none;'>order_no</th>
			<th style='width:0px; display: none;'>lotno</th>
			<th style='width:0px; display: none;'>package_no</th>
			<th>공정시작일</th>
			<th>공정완료일</th>
			
			<th>포장수량</th>
			<th>비고</th>
<!-- 			<th>공정완료 제품개수</th> -->
			<th style='width:0px; display: none;'>제품코드</th>
			<th style='width:0px; display: none;'>제품코드rev</th>
			<!-- 	버튼자리	 -->
			<th></th>
<!-- 			<th></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>		
<div id="UserList_pager" class="text-center">
</div>
