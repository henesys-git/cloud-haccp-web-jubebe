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

	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	MakeGridData makeGridData;
	
	int startPageNo = 1;
/* =========================복사하여 수정 할 부분=================================================  */   

	String GV_PART_CD="", GV_PART_CD_REV="";
	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");

	if(request.getParameter("part_cd_rev")== null)
		GV_PART_CD_REV="";
	else
		GV_PART_CD_REV = request.getParameter("part_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "PART_CD", GV_PART_CD);
	jArray.put( "PART_CD_REV", GV_PART_CD_REV);
	
    TableModel = new DoyosaeTableModel("M909S124100E114", jArray);	

/* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "tableS909S124110";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;    
%>
<script type="text/javascript">

    $(document).ready(function () {
    	var v<%=makeGridData.htmlTable_ID%> = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
//    		scrollY: 200,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: false,
    	    select : true,
			data: <%=makeGridData.getDataArry()%>,				
			"dom": '<"top"i>rt<"bottom"flp><"clear">',			
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		}, 
	  		/* =========================복사하여 수정 할 부분===========================================  */   
	  		'columnDefs': [{
	       		'targets': [1,4,5,7,8,9],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [16],
	       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
       			}
	       	}, 
	       	
	       	
	  		/* =========================복사하여 수정 할 부분====끝=====================================  */  
			
			],    
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             },
            
             
             
	       	'drawCallback' :function() {
	       		for(i=0; i<<%=RowCount%>; i++) {      			       			
	       			$('input[id=text1]').eq(i).prop("readonly",true);
	       			$('input[id=checkbox1]').eq(i).prop("disabled",true);
	       		}
          	}
	  		
	  		
		});
    	
    	
    	
// 		vPart_cd 			= "";
// 		vPart_nm				= "";
		vChecklist_cd 		= "";
// 		vCheck_note 			= "";
// 		vChecklist_seq 		= "";
// 		vStandard_guide		= "";
// 		vStandard_value		= "";
// 		vItem_desc			= "";
// 		vItem_type			= "";
// 		vItem_bigo			= "";

    });
    /* =========================복사하여 수정 할 부분===========================================  */  
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vPart_cd 			= td.eq(1).text().trim();
		vPart_nm				= td.eq(2).text().trim();
		vChecklist_cd 		= td.eq(3).text().trim();
		vCheck_note 			= td.eq(11).text().trim();
		vChecklist_seq 		= td.eq(4).text().trim();
		vStandard_guide		= td.eq(10).text().trim();
		vStandard_value		= td.eq(12).text().trim();
		vItem_desc			= td.eq(7).text().trim();
		vItem_type			= td.eq(14).text().trim();
		vItem_bigo			= td.eq(15).text().trim();
		
		// 서브 메뉴를 보여준다.
// 		fn_DetailInfo_List();
    }
    /* =========================복사하여 수정 할 부분====끝=====================================  */ 

</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>순번</th>
		     <th style='width:0px; display: none;'>원부자재코드</th>
		     <th >원부자재명</th>
		     <th >체크코드</th>
		     <th style='width:0px; display: none;'>체크코드순번</th>
		     <th style='width:0px; display: none;'>체크개정</th>
		     <th>항목코드</th>
		     <th style='width:0px; display: none;'>항목명</th>
		     <th style='width:0px; display: none;'>항목순</th>
		     <th style='width:0px; display: none;'>항목개정</th>
		     <th>표준지침</th>
		     <th>문항내용</th>
		     <th>기준값</th>
		     <th>tag</th>
		     <th>항목유형</th>
		     <th>항목비고</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
