<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
기술문서목록
 */
 	EdmsDoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
//	final int PageSize=15; 
	
	String GV_ORDERNO="", GV_CUSTCODE="", GV_LOTNO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");

	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lot_no", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
 	TableModel = new EdmsDoyosaeTableModel("M101S020100E124", jArray);		
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
	String[] HyperLink		= {"","","","","","","","","",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "file_view_name", rightbtnDocRevise},{"on", "file_real_name", rightbtnDocShow}};
	
	makeGridData= new MakeGridData(TableModel);
	makeGridData.RightButton	= RightButton;
 	makeGridData.htmlTable_ID	= "tableS303S010140";
	makeGridData.Check_Box 	= "false";
	makeGridData.HyperLink 	= HyperLink;
%>
<script>
    $(document).ready(function () {  
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    	    scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 3, "desc" ]],
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		},    
   	  		'columnDefs': [
				{
					// 제외할 컬럼 숫자 적기(0부터)
					'targets': [0,5,7,8],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [9],
		   			'createdCell':  function (td) {
// 		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],       
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
    	});      	
    });

    function fn_right_btn_view(fileName, obj,view_revision){
    	/* 
    	{"on", "file_view_name", "문서View"} 인경우 이 함수를 반드시 사용한다.
    	 */
    	var tr = $(obj).parent().parent();
		var td = tr.children();

// 		{"주문번호","문서번호","문서명","등록번호","등록Rev", "파일명", "file_real_name"};
// 		fileName			= td.eq(5).text().trim();
		var regist_no 		= td.eq(3).text().trim();
		var regist_no_rev 	= td.eq(4).text().trim();
		var document_no 	= td.eq(1).text().trim();
		var document_no_rev = td.eq(7).text().trim();
		var JSPpage			= '<%=JSPpage%>';
		var loginID			= '<%=loginID%>';
		vOrderNo 			= td.eq(0).text().trim();
		vLotNo 				= td.eq(8).text().trim();

//      fn_pdf_View(regist_no, regist_no_rev, document_no, fileName, jsp_page, user_id) {
		fn_pdf_View(regist_no, regist_no_rev, document_no, document_no_rev,fileName, JSPpage, loginID,view_revision);	
    }
    
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
    }  
 

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th style='width:0px; display: none;'>주문번호</th>
		     <th>문서번호</th>
		     <th>문서명</th>
		     <th>등록번호</th>
		     <th>등록Rev</th>
		     
		     <th style='width:0px; display: none;'>file_real_name</th>
		     <th>파일명</th>
		     <th style='width:0px; display: none;'>document_no_rev</th>
		     <th style='width:0px; display: none;'>LOT NO</th>
		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>  
