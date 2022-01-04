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

	String Fromdate = "", Todate = "";
	
	String CheckGubunName = "", CheckGubunType = "", CheckGubunLocation = "", CheckGubunBreakaway = "";

	if(request.getParameter("From") != null)
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		Todate = request.getParameter("To");
	
	if(request.getParameter("CheckGubunName") != null)
		CheckGubunName = request.getParameter("CheckGubunName");	
	
	if(request.getParameter("CheckGubunType") != null)
		CheckGubunType = request.getParameter("CheckGubunType");	
	
	if(request.getParameter("CheckGubunLocation") != null)
		CheckGubunLocation = request.getParameter("CheckGubunLocation");	
	
	if(request.getParameter("CheckGubunBreakaway") != null)
		CheckGubunBreakaway = request.getParameter("CheckGubunBreakaway");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	jArray.put("CheckGubunName", CheckGubunName);
	jArray.put("CheckGubunType", CheckGubunType);
	jArray.put("CheckGubunLocation", CheckGubunLocation);
	jArray.put("CheckGubunBreakaway", CheckGubunBreakaway);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M808S010100E104", jArray);	
	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS808S010100";
        
 	// 개선조치항목
    Vector codeVector = CommonData.getCodeList("CCP_IMPROVE_CD");
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
	margin-left: 2px;
}
</style>
<script type="text/javascript">

	var orgImprove = "";
	var ccp_table = "";
    $(document).ready(function () {
 
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;		
		// 전체/정상
		var columnDefArr = [{
								'targets': [0,1],
								'createdCell': function(td) {
						  			$(td).attr('style', 'display: none;'); 
								}
							},
							{
								'targets': [9],
								'createdCell': function(td) {
									var min_value = parseFloat($(td).prev().prev().html());
									var max_value = parseFloat($(td).prev().html());
									var value = parseFloat($(td).html());
									if(value < min_value || value > max_value){
										$(td).attr('style', 'color: red;'); 
									} else {
										$(td).attr('style', 'color: blue;'); 
									}
								}
							}];
		
		// 이탈일때
		if('<%=CheckGubunBreakaway%>' != "" && '<%=CheckGubunBreakaway%>' != "0"){
			
			columnDefArr.push({
									'targets': [10],
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
									'createdCell': function(td) {
										$(td).css({"display":"flex", "align-items":"center", "justify-content":"space-between"}); 
									}
								},
								{
									'targets': [11],
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
			columnDefs : columnDefArr,
			order : [[5, "desc"], [6, "desc"]],
			pageLength : 10
		}
		
    	ccp_table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
    	vOrderNo	= "";
        vLotNo 		= "";
        vProductNo 	= "";
        
     	// ccp 확인 서명(+개선조치사항 같이)
		$('#<%=makeGridData.htmlTable_ID%>').on("click", ".btn-checklist-approve", function() {
			var improve_cd = $(this).closest('td').prev().children("select").val();
			if(improve_cd == "" || improve_cd == null){
				heneSwal.warningTimer("개선조치사항을 선택해주세요.");
				return false;
			}
			
			var data = ccp_table.row( $(this).parents('tr') ).data();
			data.push(improve_cd);
			var pid = "M808S010100E502";
			confirmChecklist3(data, pid, function() {
				parent.fn_MainInfo_List(startDate, endDate);
			});
		});
     	
    });

    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
        vOrderNo	= td.eq(13).text().trim();
        vLotNo 	= td.eq(6).text().trim();
        vProductNo = td.eq(20).text().trim(); //prod_cd
    }
    
    function improveUpdate(obj){
    	orgImprove = $(obj).closest("td").html();

 		var selectAction = "<%=selectAction%>".replace("rol'>", "rol' style='width:60%;display:inline-block;padding:0;margin-left:-3%;'>");
 		var updateHtml = selectAction + "<button type='button' class='improve_confirm btn btn-outline-success' onclick='improveConfirm(this)'>확인</button>"
 									  + "<button type='button' class='improve_cancel btn btn-outline-danger' style='margin-right:-3%;' onclick='improveCancel(this)'>취소</button>";
 		
 		$(obj).closest("td").html(updateHtml);
 		
 	//	setTimeout(function(){ccp_table.columns.adjust().draw();},200);
    }
    
 	function improveConfirm(obj){
    	
   		var improve_cd = $(obj).closest("td").children("select").val();
		if(improve_cd == "" || improve_cd == null){
			heneSwal.warningTimer("개선조치사항을 선택해주세요.");
			return false;
		}
		
		var data = ccp_table.row( $(obj).parents('tr') ).data();
		data.push(improve_cd);
		var pid = "M808S010100E502";
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
		     <th style='width:0px; display: none;'>센서번호</th>
		     <th style='width:0px; display: none;'>센서수정이력번호</th>
		     <th>센서명</th>
		     <th>센서 타입</th>
		     <th>센서 위치</th>
		     <th>생성날짜</th>
		     <th>생성시간</th>
		     <th>최소값</th>
		     <th>최대값</th>
		     <th>측정값</th>
	       <% if("".equals(CheckGubunBreakaway.trim())){ %>
			 <th>상태</th>
		   <% } %>
		   <% if(!"".equals(CheckGubunBreakaway.trim()) && !"0".equals(CheckGubunBreakaway.trim())){ %>
			 <th style="width:250px;">개선조치사항</th>
		     <th>확인</th>
		   <% } %>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center"></div>                 