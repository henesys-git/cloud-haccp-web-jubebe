<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	System.out.println("2121 353/120.jsp 여기까지 옴?");
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	
	String Fromdate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE; 
	
	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");	
	
	if(request.getParameter("custcode")== null)
		custCode="";
	else
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");
	
	String param =  Fromdate + "|" + GV_JSPPAGE + "|"  + custCode + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "custcode", custCode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M353S010100E124",  jArray);	
 	int RowCount =TableModel.getRowCount();

    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS353S010120";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
	
%>

<script type="text/javascript">

    $(document).ready(function () {
    	   
    	var exportDate = new Date();        
    	var printCounter = 0;
    	var v<%=makeGridData.htmlTable_ID%> = $('#<%=makeGridData.htmlTable_ID%>').DataTable({		
    		scrollX: true,
//     		scrollY: 500,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: false,
//     	    ordering: true,
    	    order: [[ 9, "desc" ]],
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [{
	       		'targets': [9,10],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			}
			], 
			dom: 'Bfrtip',
            buttons: [
                {
                    extend: 'excelHtml5',
                    title: "원부자재수불일보 " + exportDate.format("yyyyMMdd_hhmmss"),
//                     customize: function ( xlsx ){
//                         var sheet = xlsx.xl.worksheets['sheet1.xml'];
         
//                         // jQuery selector to add a border
//                         $('row c[r*="10"]', sheet).attr( 's', '25' );
//                     },
					exportOptions: {
			            columns: [0,1,2,3,4,5,6,7,8]			 
			    	},
                    messageTop: null
                },
                {
                    extend: 'print',
                    title: "원부자재수불일보 " + exportDate.format("yyyyMMdd_hhmmss"),
					exportOptions: {
			            columns: [0,1,2,3,4,5,6,7,8]			 
			    	},
                    messageBottom: null
                }
            ],
//             'drawCallback': function() { // 콜백함수(이거로 써야 테이블생성된후 체크박스에 적용된다)
// 				$(".dt-button buttons-excel buttons-html5").click();
// 			},
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             },
		});
    });
    
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
    }
    
//     function <
   
</script>
	
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th></th>
		     <th>제품명</th>
		     <th>규격</th>
		     <th>입고금액</th>
		     <th>전일재고</th>
		     <th>입고</th>
		     <th>출고</th>
		     <th>현재고</th>
		     <th>유통기한</th>
		     <th style='width:0px; display: none;'>part_cd</th>
		     <th style='width:0px; display: none;'>버튼</th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
	
<div id="UserList_pager" class="text-center">
</div>                 
