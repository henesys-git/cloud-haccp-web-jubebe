<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_FROMDATE = "", GV_TODATE = "";

	if(request.getParameter("From") != null)
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		GV_TODATE = request.getParameter("To");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("fromdate", GV_FROMDATE);
	jArray.put("todate", GV_TODATE);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S015300E104", jArray);	
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S015300";
%>
<style>
#selectTime {
	width: 52%;
    text-align: center;
    margin: 0 auto;
    margin-top: 10px;
    font-size: 23px;
}
</style>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=tData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,3],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [5],
					'render': function(data) {
						if(data == '') {
							var btn = " <button class='btn btn-success btn-sm btn-checklist-check'> " +
					  				  " 	<i class='fas fa-signature'></i> " +
					  				  " </button>";
					  		return btn;
						} else {
							return data;
						}
					}
				},
				{
					'targets': [6],
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
				},
				{
					'targets': [8],
					'render': function(data) {
						if(data == '') {
							var btn = " <button class='btn btn-success btn-sm btn-checklist-action inspect1'> " +
					  				  " 	<i class='fas fa-signature'></i> " +
					  				  " </button>";
					  		return btn;
						} else {
							return data;
						}
					}
				},
				{
					'targets': [10],
					'render': function(data) {
						if(data == '') {
							var btn = " <button class='btn btn-success btn-sm btn-checklist-action inspect2'> " +
					  				  " 	<i class='fas fa-signature'></i> " +
					  				  " </button>";
					  		return btn;
						} else {
							return data;
						}
					}
				}
				]
		}
		
		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
    	
    	// 승인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-approve", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S015300E502";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    		});
    	});
		
    	// 검토자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-check", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S015300E512";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    		});
    	});
    	
    	// 품질관리팀장 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-action", function() {
	   		var pid = "M838S015300E522";	// 품질관리팀장(기록검증) 서명
    		var btn = $(this);
    		
	   		if(btn.closest("button").hasClass("inspect2")){	// 품질관리팀장(현장검증) 서명
	   	 		pid = "M838S015300E532";
	   		}
	   		
	   		var reload = function() {
				parent.fn_MainInfo_List(startDate, endDate);
			};
	   		
	   		let sign = new ChecklistSignature(table, pid, btn);
	   		sign.selectTimeAndSign(reload);
    	});
    	
    	loadJs(heneServerPath + '/js/auth-button/auth-button.js');    	
    });

    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		checklist_id		= td.eq(0).text().trim();
		checklist_rev_no 	= td.eq(1).text().trim();
		ccp_date  			= td.eq(2).text().trim();
		
		parent.DetailInfo_List.click();
    }
    
   /*  function selectTime(table, pid, btn) {

    	Swal.fire({
    		  title: '<strong>검증시간</strong>',
    		  html: '<input type="time" class="form-control" id="selectTime"/>',
    		  showCloseButton: true,
    		  showCancelButton: true,
    		  confirmButtonText: '확인',
    		  cancelButtonText: '취소'
    	}).then((result) => { 
			  if (result.value) {
				 var selectTime = $("#selectTime").val();
				 signTime(table, pid, btn, selectTime);
			  } // end  if (result.value)
		});
    }
    
    function signTime(table, pid, btn, time) {
    	
    	var data = table.row(btn.parents('tr')).data();
		data.push(time);
		 
		confirmChecklist(data, pid, function() {
			parent.fn_MainInfo_List(startDate, endDate);
		});
    } */
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>체크리스트 ID</th>
		     <th style='width:0px; display:none;'>체크리스트 수정이력</th>
		     <th>작성일자</th>
		     <th style='width:0px; display:none;'>담당자</th>
		     <th>작성자</th>
		     <th>검토자</th>
		     <th>승인자</th>
			 <th>기록검증 시간</th>
			 <th>품질관리팀장(기록검증)</th>
			 <th>현장검증 시간</th>
			 <th>품질관리팀장(현장검증)</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>