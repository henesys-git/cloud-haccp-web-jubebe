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

	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo =1; //Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	

	String GV_ORDERNO="",GV_ORDERDETAIL="",GV_LOTNO="",GV_INSPECT_GUBUN="",GV_PRODUCT_SERIAL_NO="",GV_PRODUCT_SERIAL_NO_END="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("OrderDetail")== null)
		GV_ORDERDETAIL="";
	else
		GV_ORDERDETAIL = request.getParameter("OrderDetail");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("InspectGubun")== null)
		GV_INSPECT_GUBUN="";
	else
		GV_INSPECT_GUBUN = request.getParameter("InspectGubun");
	
	if(request.getParameter("product_serial_no")== null)
		GV_PRODUCT_SERIAL_NO="";
	else
		GV_PRODUCT_SERIAL_NO = request.getParameter("product_serial_no");
	
	if(request.getParameter("product_serial_no_end")== null)
		GV_PRODUCT_SERIAL_NO_END="";
	else
		GV_PRODUCT_SERIAL_NO_END = request.getParameter("product_serial_no_end");
	
	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "order_detail_seq", GV_ORDERDETAIL);
	jArray.put( "inspect_gubun", GV_INSPECT_GUBUN);
	jArray.put( "product_serial_no", GV_PRODUCT_SERIAL_NO);
	jArray.put( "product_serial_no_end", GV_PRODUCT_SERIAL_NO_END);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M303S060700E514", jArray);
 	int RowCount =TableModel.getRowCount();
 	
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"on", "fn_View_Canvas2(this)", "검수일지"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS303S060760";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
    
    //int ColCount =TableModel.getColumnCount()+1;
//     out.println(makeTableHTML.getHTML());
%>
<script>
   
    $(document).ready(function () {
		var vColumnDefs;
		if("<%=GV_TABLET_NY%>"=="Tablet") { // tablet화면에서 부를때
			vColumnDefs = [{
	   			// 제외할 컬럼 숫자 적기(0부터)
				'targets': [0,1,5,9,10,11,13,15],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
			},
			{
	   			// 조회컬럼크기
				'targets': [2,3,4,6,7,8,12,14,16,17],
	   			'createdCell':  function (td) {
//	   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
	   		}
			];
		} else { // 일반화면에서 부를때
			vColumnDefs = [{
				'targets': [0,1,5,9,10,11,13,15],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
			},
			{
	   			'targets': [2,3,4,6,7,8,12,14,16,17],
	   			'createdCell':  function (td) {
//	   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
	   		}
			];
		}		
    	<%-- $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({ --%>
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: false,
    	    order: [[ 0, "desc" ]],
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		},    
   	  		'columnDefs': vColumnDefs, 
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }

		});
    	fn_Clear_varv();
    });
    	
    			
    function <%=makeGridData.htmlTable_ID%>Event(obj){
      	var tr = $(obj);
  		var td = tr.children();
  		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
  		
  		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
  		
  		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
  		$(obj).attr("class", "hene-bg-color");
  		
  		vOrderNo 			= td.eq(0).text().trim(); 
	 	vLotNo				= td.eq(1).text().trim(); 
	 	inspect_no			= td.eq(2).text().trim();
	 	vInspectResultDt 	= td.eq(7).text().trim();
	 	checklist_cd		= td.eq(8).text().trim();
	 	inspect_seq			= td.eq(13).text().trim();
	 	vInspectGubun		= td.eq(14).text().trim();
	    
  }			
    
	
    function fn_Clear_varv(){
		vBalju_req_date	= "";
		vBalju_no 		= "";
		vImport_inspect_seq 			= "";
		vPart_cd 			= "";
//			vGIJONG_CODE 		= "";
		$('#txt_custcode').val("");
    }
    
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		<% if(GV_TABLET_NY.equals("Tablet")) { %>
		     <th style='width:0px; display: none;'>순번</th>
		     <th style='width:0px; display: none;'>주문번호상세</th>
		     <th>검사번호</th>
		     <th>검사구분</th>
		     <th>제품명</th>
		     
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th>검사담당자</th>
		     <th>결과등록일</th>
		     <th>체크코드</th>
		     <th style='width:0px; display: none;'>checklist_cd_rev</th>
		     <th style='width:0px; display: none;'>아이템코드</th>
		     
		     <th style='width:0px; display: none;'>item_cd_rev</th>
		     <th>검사결과값</th>
		     <th style='width:0px; display: none;'>inspect_seq</th>
		     <th>체크구분</th>
		     <th style='width:0px; display: none;'>자주코드</th>
		     
		     <th>표준값</th>
		     <th>불량수량</th>

		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>
		     
		<% } else { %>
			 <th style='width:0px; display: none;'>순번</th>
		     <th style='width:0px; display: none;'>주문번호상세</th>
		     <th>검사번호</th>
		     <th>검사구분</th>
		     <th>제품명</th>
		     
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th>검사담당자</th>
		     <th>결과등록일</th>
		     <th>체크코드</th>
		     <th style='width:0px; display: none;'>checklist_cd_rev</th>
		     <th style='width:0px; display: none;'>아이템코드</th>
		     
		     <th style='width:0px; display: none;'>item_cd_rev</th>
		     <th>검사결과값</th>
		     <th style='width:0px; display: none;'>inspect_seq</th>
		     <th>체크구분</th>
		     <th style='width:0px; display: none;'>자주코드</th>
		     
		     <th>표준값</th>
		     <th>불량수량</th>

		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th></th>
		     
		<% } %>
		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>              