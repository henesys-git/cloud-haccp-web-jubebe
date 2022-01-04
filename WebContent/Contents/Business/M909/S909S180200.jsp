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
	MakeGridData makeGridData;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M909S180100E204",  jArray);	
 	int RowCount =TableModel.getRowCount();

    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS909S180200";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">

    $(document).ready(function () {
//     	var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/;	// 특수문자
//     	var pattern= /'"\\r\f\b\t\n/gi;	// 특수문자
//     	for(var i=0; i<qUeryData.length; i++){
//     		for(var j=0; j<qUeryData[i]; j++){
//     			if(qUeryData[i][j].indexof(pattern) != -1){
//     				qUeryData[i][j].replaceall(pattern, "\"+pattern);
//     			}
//     		}
//     	}
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 200,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: false,
			data: <%=makeGridData.getDataArry()%>,

		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [{
	       		'targets': [7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [24],
	       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
       			}
	       	}
			], 
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    });
    
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vSeolbiCd	= td.eq(0).text().trim();
		vRevisionNo	= td.eq(15).text().trim();
		
		fn_DetailInfo_List();
    }

</script>
	
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>메인코드</th>
		     <th>명칭</th>
		     <th>도입일자</th>
		     <th>규격</th>
		     <th>제조사</th>
		     <th>기기번호</th>
		     <th>담당부서</th>
		     
		     <th style='width:0px; display: none;'>사용담당자</th>
		     <th style='width:0px; display: none;'>책임담당자</th>
		     <th style='width:0px; display: none;'>교정담당자</th>
		     <th style='width:0px; display: none;'>유효일자</th>		     
		     <th style='width:0px; display: none;'>교정주기</th>
		     <th style='width:0px; display: none;'>교정일자</th>
		     <th style='width:0px; display: none;'>비고</th>
		     <th style='width:0px; display: none;'>이미지파일명</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     <th style='width:0px; display: none;'>적용시작일자</th>
		     <th style='width:0px; display: none;'>적용종료일자</th>
		     <th style='width:0px; display: none;'>create_user_id</th>		     
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>설비구분</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>


<div id="UserList_pager" class="text-center">
</div>                 
