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
	
	String GV_CHECK_GUBUN = "", 
		   GV_REV_CHECK = "", 
		   GV_PID = "";

	if(request.getParameter("check_gubun") != null)
		GV_CHECK_GUBUN = request.getParameter("check_gubun");	
	
	if (request.getParameter("total_rev_check") != null)
		GV_REV_CHECK = request.getParameter("total_rev_check");

	if(GV_REV_CHECK.equals("true")) {
		GV_PID = "M909S020100E105";
	} else if(GV_REV_CHECK.equals("false")) {
		GV_PID = "M909S020100E104";
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("CHECK_GUBUN", GV_CHECK_GUBUN);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel(GV_PID, jArray);	
 	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S020100";
%>

<script>

    $(document).ready(function () {
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [
					{
						'targets': [2],
						'createdCell': function (td) {
				  			$(td).attr('style', 'display: none;'); 
						}
					},
					{	// 점검표 양식 버튼
			  			'targets': [7],
			  			"orderable": false,
			  			'render': function(){
			  				var btn = " <button class='btn btn-outline-secondary btn-sm checklist-btn-format'> " +
					  				  " 	<i class='fab fa-wpforms'></i> " +
					  				  " </button>";
			  				return btn;
			  			}
			  		},
					{	// 점검표 알람 버튼
			  			'targets': [8],
			  			"orderable": false,
			  			'render': function(){
			  				var btn = " <button class='btn btn-outline-secondary btn-sm checklist-btn-alarm'> " +
					  				  " 	<i class='fas fa-bell'></i> " +
					  				  " </button>";
			  				return btn;
			  			}
			  		}
				],
				scrollX : true,
				pageLength : 10
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
    	// 점검표 양식 버튼 클릭 시
    	$('#<%=makeGridData.htmlTable_ID%>').on("click", ".checklist-btn-format", function() {
			let tr = $(this.closest("tr"));
		    let checklistId = tr.find("td:eq(0)").text();
		    let checklistRevNo = tr.find("td:eq(1)").text();
		    let formatRevNo = tr.find("td:eq(2)").text();
			
			let url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S020110.jsp"
		    			+ "?checklist_id=" + checklistId
		    			+ "&checklist_rev_no=" + checklistRevNo
		    			+ "&format_rev_no=" + formatRevNo;
	    	let footer = '<button id="btnSave" class="btn btn-info">등록</button>' +
	    				 '<button id="btnUpdate" class="btn btn-info">변경</button>';
	    	let title = "점검표 양식";
	    	let heneModal = new HenesysModal(url, 'large', title, footer);
	    	heneModal.open_modal();
		});
        
    	// 점검표 알림 버튼 클릭 시
    	$('#<%=makeGridData.htmlTable_ID%>').on("click", ".checklist-btn-alarm", function() {	
    		var confirmed = confirm('해당 점검표의 알림을 활성화 하시겠습니까?');
			
			if(confirmed) {
				var tr = $(this.closest("tr"));
			    var userId = tr.find("td:eq(0)").text();
				
			    var obj = new Object();
			    obj.userId = userId;
			    
			    $.ajax({
			        type: "POST",
			        dataType: "json",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
			        data: {"bomdata" : JSON.stringify(obj), "pid" : "M909S080100E112"},
			        success: function (rcvData) {
			        	if(rcvData > -1) {
			        		heneSwal.success("비밀번호 초기화 완료<br>" +
			        						 "초기 비밀번호: <%=ProjectConstants.INITIAL_PASSWORD%>");
			        	} else {
			        		heneSwal.error("비밀번호 초기화 실패, 다시 시도해주세요");
			        	}
			        },
			        error: function(rcvData) {
		        		heneSwal.error("비밀번호 초기화 실패, 다시 시도해주세요");
			        }
			    });
			}
		});
    });
    
    function clickMainMenu(obj) {
    var tr = $(obj);
	var td = tr.children();
	var trNum = $(obj).closest('tr').prevAll().length;
    	
    checklistId 		= td.eq(0).text().trim();
    checklistRevNo 		= td.eq(1).text().trim();
    formatRevNo 		= td.eq(2).text().trim();
    checklistName 		= td.eq(3).text().trim();
    checkTerm 			= td.eq(4).text().trim();
    
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th>점검표 아이디</th>
		     <th>수정이력번호</th>
		     <th style='width:0px; display:none;'>양식수정이력</th>
   		     <th>점검표명</th>
		     <th>점검 주기</th>
		     <th>적용날짜</th>
		     <th>적용만료날짜</th>
		     <th>양식</th>
		     <th>알림</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>                 
