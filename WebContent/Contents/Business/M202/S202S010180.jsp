<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="org.json.simple.parser.*"%>
<%
/* 
발주용 BOM 원재료 재고 조회
 */
	DoyosaeTableModel TableModel;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_PID="", GV_PARM="";
	
	if(request.getParameter("pid")== null)
		GV_PID="";
	else
		GV_PID = request.getParameter("pid");	
	
	if(request.getParameter("bomdata")== null)
		GV_PARM="";
	else
		GV_PARM = request.getParameter("bomdata");
	
	JSONArray jjArray = null;
	StringBuffer DataArray = new StringBuffer();
	
	String GV_WHERE = "WHERE 1=1 \n";
		// String형태의 JSON 데이터를 JSONObject 형태로 변환한다.
		JSONParser parser = new JSONParser();
		JSONObject jObject = (JSONObject)parser.parse(GV_PARM);	
		jjArray = (JSONArray) jObject.get("param");
		
		GV_WHERE += "AND (";
		for(int i=0; i<jjArray.size(); i++) {  
			JSONObject jjjArray = (JSONObject)jjArray.get(i);
			
			GV_WHERE += "(A.part_cd='" + jjjArray.get("part_cd") + "'"
					 + "AND A.revision_no='"+ jjjArray.get("part_cd_rev") +"')";
			if(i<jjArray.size()-1) GV_WHERE += "OR";
		}
		GV_WHERE += ")\n";
	
		GV_WHERE += " AND A.member_key='" + member_key + "'\n";
		
		JSONObject jArray = new JSONObject();
		jArray.put( "gv_where", GV_WHERE);
		jArray.put( "member_key", member_key);
		
		TableModel = new DoyosaeTableModel("M202S010100E184", jArray);
	 	int RowCount =TableModel.getRowCount();	
 	
	 	
	String htmlTable_ID	= "TableS202S010180";
	
	int DataCount=0;
 	// 표에 들어갈 데이터 -> 자바스크립트 배열로 가공
	DataArray.append("[");
	for(int i=0; i<RowCount; i++) {
		double CNT_POST_AMT = Double.parseDouble(TableModel.getValueAt(i, 3).toString().trim());
		double CNT_SAFETY_JAEGO = Double.parseDouble(TableModel.getValueAt(i, 4).toString().trim());
		double CNT_BALJU_COUNT = 0;
		for(int j=0; j<jjArray.size(); j++) { 
			JSONObject jjjArray = (JSONObject)jjArray.get(j);
			if(TableModel.getValueAt(i, 0).toString().trim().equals(jjjArray.get("part_cd")))
				CNT_BALJU_COUNT = Double.parseDouble(jjjArray.get("balju_count").toString());
		}
		if( (CNT_POST_AMT + CNT_BALJU_COUNT) < CNT_SAFETY_JAEGO ) { // 현재재고+발주수량<안전재고 : 경고
			DataArray.append("[");
			DataArray.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" + "," ); // 원부자재코드(part_cd)
			DataArray.append( "'" + TableModel.getValueAt(i, 1).toString().trim() + "'" + "," ); // revision_no
			DataArray.append( "'" + TableModel.getValueAt(i, 2).toString().trim() + "'" + "," ); // 원부자재명(part_nm)
			DataArray.append( "'" + CNT_POST_AMT 		+ "'" + "," ); // 현재 재고(post_amt)
			DataArray.append( "'" + CNT_SAFETY_JAEGO 	+ "'" + "," ); // 안전 재고(safety_jaego)
			DataArray.append( "'" + CNT_BALJU_COUNT 	+ "'" + "," ); // 발주예정 수량
			DataArray.append( "'" + ( CNT_SAFETY_JAEGO - (CNT_POST_AMT + CNT_BALJU_COUNT) )	+ "'" + "" ); // 예정 부족수량
			if(i==RowCount-1) DataArray.append("]");
			else DataArray.append("],");
			DataCount++;
		}
	}
	DataArray.append("]");
	
	response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-store");
    response.getWriter().print("");
 	
%>
<script>
    $(document).ready(function () {
    	var data_count = <%=DataCount%>;
    	if(data_count==0) {
    		parent.$('#modalReport_nd').hide();
    		Save_S202S010180();
    		return;
    	}
    	
		$('#<%=htmlTable_ID%>').DataTable({
			scrollX: true,
	 		scrollY: 400,
	 	    scrollCollapse: true,
	 	    paging: false,
	 	    searching: true,
	 	    ordering: true,
	 	    order: [[ 0, "desc" ]],
	 	    info: true,
		    data: <%=DataArray%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=htmlTable_ID%>_rowID");
	      		$(row).attr('onclick'," <%=htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [1],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],
			'drawCallback': function() { // 콜백함수(이거로 써야 테이블생성된후 체크박스에 적용된다)
	  		},
			language: { 
	               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	        }
		}); // datatable
    });
		

    function  <%=htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return			
		
<%--  		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", ""); --%>
// 		$(obj).attr("class", "hene-bg-color");
    }   

    function Save_S202S010180(){
    	parent.$("#ReportNote_nd").children().remove();
    	parent.$('#modalReport_nd').hide();
    	
		var chekrtn = confirm("등록하시겠습니까?"); 
		if(chekrtn){
			SendTojsp('<%=GV_PARM%>', '<%=GV_PID%>'); //S202S010101.jsp화면의 함수 실행
		}
    }
    
    function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         success: function (html) {	
	        	 if(html>-1){
	        		parent.DetailInfo_List.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	} 
    
</script>
    <table class='table table-bordered nowrap table-hover' id="<%=htmlTable_ID%>" style="width: 100%">
		<thead id="<%=htmlTable_ID%>_head">
		<tr>
		     <th>원부자재코드</th>
		     <th style='width:0px; display: none;'>revision_no</th>
		     <th>원부자재명</th>
		     <th>현재 재고</th>
		     <th>안전 재고</th>
		     <th>발주예정 수량</th>
		     <th>예상 부족수량</th>
		</tr>
		</thead>
		<tbody id="<%=htmlTable_ID%>_body">		
		</tbody>
	</table>
    
	<p style="text-align:center">
		<button id="btn_Save"  class="btn btn-info"  onclick="Save_S202S010180();">저장</button>
	    <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();">취소</button>
	</p>