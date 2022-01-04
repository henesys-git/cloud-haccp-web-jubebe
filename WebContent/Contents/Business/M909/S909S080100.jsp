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

	String GV_USER_ID = "", GV_REV_CHECK = "", GV_PID = "";
	String param = GV_USER_ID + "|";

	if(request.getParameter("user_id") != null)
		GV_USER_ID = request.getParameter("user_id");
	
	if (request.getParameter("total_rev_check") != null)
		GV_REV_CHECK = request.getParameter("total_rev_check");

	if(GV_REV_CHECK.equals("true")) {
		GV_PID = "M909S080100E104";
	} else if(GV_REV_CHECK.equals("false")) {
		GV_PID = "M909S080100E105";
	}

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("USER_ID", GV_USER_ID);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel(GV_PID, jArray);	

 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS909S080100";
%>
<script type="text/javascript">

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [
					{
						'targets': [6,8,9,10,13,16,17,18,19,20],
						'createdCell': function (td) {
				  			$(td).attr('style', 'display: none;'); 
						}
					},
		   			{
			  			'targets': [12],
			  			'render': function(data){
			  				return addComma(data);
			  			}
			  		},
		   			{
			  			'targets': [21],
			  			'render': function(){
			  				var btn = " <button class='btn btn-outline-secondary btn-sm btn-reset'> " +
					  				  " 	<i class='fas fa-key'></i> " +
					  				  " </button>";
			  				return btn;
			  			}
			  		}
				],
				scrollX: true,
				scrollY: true,
				pageLength: 10
		}
		
		var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
						mergeOptions(heneMainTableOpts, customOpts)
					);
    	
		user_id = "";
		vRevisionNo = "";
		group_cd = "";
		
		$(".btn-reset").click(function () {
			var confirmed = confirm('해당 사용자의 비밀번호를 초기화 하시겠습니까?');
			
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

    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		user_id = td.eq(0).text().trim(); 
		vRevisionNo = td.eq(1).text().trim(); 
		group_cd = td.eq(6).text().trim(); 
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th>아이디</th>
		     <th>개정번호</th>
		     <th>이름</th>
		     <th>휴대전화</th>
		     <th>이메일</th>
		     <th>직위</th>
		     <th style='width:0px; display: none;'>그룹코드</th>
		     <th>권한(그룹)</th>
		     <th style='width:0px; display: none;'>비밀번호</th>
		     <th style='width:0px; display: none;'>위치</th>
		     <th style='width:0px; display: none;'>부서코드</th>
		     <th>부서</th>
		     <th>시급</th>
		     <th style='width:0px; display: none;'>delyn</th>
		     <th>적용시작일자</th>
		     <th>적용종료일자</th>
		     <th style='width:0px; display: none;'>create_user_id</th>
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>modify_date</th>
		     <th></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>