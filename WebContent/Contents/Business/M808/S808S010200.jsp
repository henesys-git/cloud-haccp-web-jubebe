<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String startDate = "", endDate = "", metalName = "", checkBreakaway = "";
	
	if(request.getParameter("startDate") != null)
		startDate = request.getParameter("startDate");
	
	if(request.getParameter("endDate") != null)
		endDate = request.getParameter("endDate");
	
	if(request.getParameter("metalName") != null)
		metalName = request.getParameter("metalName");
	
	if(request.getParameter("checkBreakaway") != null)
		checkBreakaway = request.getParameter("checkBreakaway");
	
	JSONObject jArray = new JSONObject();
	jArray.put("startDate", startDate);
	jArray.put("endDate", endDate);
	jArray.put("metalName", metalName);
	jArray.put("checkBreakaway", checkBreakaway);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M808S010200E114", jArray);	
	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS808S010200";

    // 개선조치항목
    Vector codeVector = CommonData.getCodeList("METAL_IMPROVE_CD");
    Vector code_value = (Vector) codeVector.get(1);
    Vector code_name = (Vector) codeVector.get(2);
    
    String selectAction = " <select class='form-control'> " +
			  			  " 	<option value=''>개선조치 선택</option> ";
    for(int v = 0; v < code_value.size(); v++){
    	selectAction += "<option value = "+code_value.get(v)+">"+code_name.get(v)+"</option>";
    }
    selectAction += "</select>";
%>
<style>
button[class^='improve_'] {
	margin-left: 2PX;
}
</style>
<script type="text/javascript">

	var ccp_table = "";

    $(document).ready(function () {

		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;	
    			
		let columnDefArr = [{
								'targets': [2],
								'visible': false
							},
							{
								'targets': [5],
								'render': function(data) {									
									if(data == 'T') {
										return '테스트';
									} else if(data == 'R') {
										return '운영';
									} else {
										return '기타';
									}
								}
							},
							{
								'targets': [7],
								'render': function(data) {
									switch(data) {
										case 'L':
											return '좌';
											break;
										case 'R':
											return '우';
											break;
										case 'C':
											return '중';
											break;
										case 'U':
											return '위';
											break;
										case 'D':
											return '아래';
											break;
										default:
											return '';
									}
								}
							},
							{
								'targets': [8],
								'render': function(data) {
									if(data == 'O') {
										return '합격';
									} else {
										return '불합격';
									}
								}
							},
							{
								'targets': [8],
								'createdCell': function(td) {
									var value = $(td).html();
									if(value == "불합격"){
										$(td).attr('style', 'color: red;'); 
									} else {
										$(td).attr('style', 'color: blue;'); 
									}
								}
							}
						];
			
		// 이탈일때
		if('<%=checkBreakaway%>' != "" && '<%=checkBreakaway%>' != "0"){
			
			 columnDefArr.push({
									'targets': [9],
									'createdCell': function(td) {
										$(td).css({"display":"flex", "align-items":"center", "justify-content":"space-between"});
									}
								},
								{
									'targets': [9],
									'render': function(data) {
										if(data == ""){
											return "<%=selectAction%>";
										}
										var btn = "&nbsp;" + data + "<button type = 'button' class='improve_update btn btn-outline-warning' onclick = 'improveUpdate(this)'>수정</button>";
										return btn;
									}
								},
								{
									'targets': [10],
									'render': function(data) {
										if(data == '') {
											var btn = " <button class='btn btn-success btn-sm btn-checklist-approve'> " +
									  				  " 	<i class='fas fa-signature'></i> " +
									  				  " </button>";
									  		return btn;
										} else {
											return data;
										}
									}
								});
			
		}
		
    	var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			order: [[ 0, "desc" ],[ 1, "desc" ]],
			columnDefs : columnDefArr,
			pageLength : 10
		}
		
    	ccp_table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
     	// 금속검출기 개선조치 확인 서명
		$('#<%=makeGridData.htmlTable_ID%>').on("click", ".btn-checklist-approve", function() {
			var improve_cd = $(this).closest('td').prev().children("select").val();
			if(improve_cd == "" || improve_cd == null){
				heneSwal.warningTimer("개선조치사항을 선택해주세요.");
				return false;
			}
			
			var data = ccp_table.row( $(this).parents('tr') ).data();
			data.push(improve_cd);
			var pid = "M808S010200E502";
			confirmChecklist3(data, pid, function() {
				parent.fn_MainInfo_List(startDate, endDate);
			});
		});
    	
    });
    
    function improveUpdate(obj){
    	orgImprove = $(obj).closest("td").html();

    	var selectAction = "<%=selectAction%>".replace("rol'>", "rol' style = 'width:57%;display:inline-block;padding:0;'>");
 		var updateHtml = selectAction + "<button type = 'button' class='improve_confirm btn btn-outline-success' onclick = 'improveConfirm(this)'>확인</button>"
 									  + "<button type = 'button' class='improve_cancel btn btn-outline-danger' onclick = 'improveCancel(this)'>취소</button>";
 		
 		$(obj).closest("td").html(updateHtml);
 		
 		//setTimeout(function(){ccp_table.columns.adjust().draw();},200);
    }
    
 	function improveConfirm(obj){
    	
   		var improve_cd = $(obj).closest("td").children("select").val();
		if(improve_cd == "" || improve_cd == null){
			heneSwal.warningTimer("개선조치사항을 선택해주세요.");
			return false;
		}
		
		var data = ccp_table.row( $(obj).parents('tr') ).data();
		data.push(improve_cd);
		var pid = "M808S010200E502";
		confirmChecklist3(data, pid, function() {
			parent.fn_MainInfo_List(startDate, endDate);
		});
    }
    
    function improveCancel(obj){
   		$(obj).closest("td").html(orgImprove);
    }
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th>검출 일자</th>
		     <th>검출 시간</th>
		     <th style="display:none;">일련번호</th>
		     <th>금속검출기</th>
		     <th>품명</th>
		     <th>검출타입</th>
		     <th>검사타입</th>
		     <th>검사위치</th>
		     <th>검사결과</th>
	       <% if("".equals(checkBreakaway.trim())){ %>
			 <th>상태</th>
		   <% } %>
		   <% if(!"".equals(checkBreakaway.trim()) && !"0".equals(checkBreakaway.trim())){ %>
			 <th style = "width:225px">개선조치사항</th>
		     <th>확인</th>
		   <% } %>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>             