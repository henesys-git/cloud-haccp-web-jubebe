<%@page import="java.io.FileReader"%>
<%@page import="org.json.simple.parser.JSONParser"%>
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

    Vector optCode = null;
    Vector optName = null;
	Vector UserGroupVector = CommonData.getUserGroupData(member_key);
	
	Vector deptCode = null;
    Vector deptName = null;
	Vector UserDeptVector = CommonData.getDeptCode(member_key);
	
	String GV_USER_ID = "", GV_REVISION_NO = "";

	if(request.getParameter("user_id") != null)
		GV_USER_ID = request.getParameter("user_id");
	
	if(request.getParameter("RevisionNo") != null)
		GV_REVISION_NO = request.getParameter("RevisionNo");

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("USER_ID", GV_USER_ID);
	jArray.put("REVISION_NO", GV_REVISION_NO);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S080100E204", jArray);
		
    Vector user = (Vector)(TableModel.getVector().get(0));
%>

<script>
	
	$(document).ready(function () {
		
		let startDateOrg = "<%=user.get(12).toString()%>";
		new SetSingleDate2(startDateOrg, '#startDate', 0);
		
		$('#btnUpdate').click(function() {
			updateUser();
		});
		
		function updateUser() {
			
			if ($('#name').val().length < 1) {
				heneSwal.warning("이름을 입력해주세요");
				return false;
			}

	   		var dataJson = new Object();
	  		
	   		dataJson.member_key = "<%=member_key%>";
			dataJson.userId = $('#userId').val();
			dataJson.RevisionNo_Target = "<%=user.get(1).toString()%>";
			dataJson.name = $('#name').val();
			dataJson.tel = $('#tel').val();
			dataJson.email = $('#email').val();
			dataJson.hourPay = $('#hourPay').val();
			dataJson.userGroupCode = $("#select_UserGroupCode option:selected").val();
			dataJson.userDeptCode = $("#select_UserDeptCode option:selected").val();
		    dataJson.modifyUserId = "<%=loginID%>";
		    dataJson.startDate = $('#startDate').val();;
			    
			var confirmed = confirm("수정하시겠습니까?"); 
				
			if(confirmed) {
				$.ajax({
			         type: "POST",
			         dataType: "json",
			         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			         data: "bomdata=" + JSON.stringify(dataJson) + "&pid=M909S080100E102",
			         success: function (html) {
			        	 if(html > -1) {
			                $('#modalReport').modal('hide');
			        	   	parent.fn_MainInfo_List();
			        	   	heneSwal.success("사용자 정보가 수정 완료되었습니다.");
			         	} else {
			        	   	heneSwal.error("사용자 정보 수정에 실패했습니다.");
			         	}
			         }
				});
			}
		}
	});
	
</script>
   
<table class="table table-hover">
     <tr>
        <td>
			<label for="userId">아이디</label>
		</td>
        <td></td>
        <td>
        	<input type="text" class="form-control" id="userId" name="userId" 
        		   readonly value="<%=user.get(0).toString()%>">
    	</td>
    </tr>

     <tr>
        <td>
			<label for="name">이름</label>
		</td>
        <td></td>
        <td>
         	<input type="text" class="form-control" id="name" name="name" value="<%=user.get(2).toString()%>">
		</td>
     </tr>
     
	<tr>
		<td>
			<label for="tel">휴대전화</label>
		</td>
		<td></td>
		<td>
			<input type="tel" id="tel" name="tel" class="form-control" 
				   placeholder="ex) 010-1234-5678" pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}" 
				   value="<%=user.get(3).toString()%>" required>
        </td>
	</tr>

	<tr>
		<td>
			그룹코드
		</td>
		<td></td>
		<td>
			<select class="form-control" id="select_UserGroupCode">
				<% optCode = (Vector)UserGroupVector.get(0);%>
				<% optName = (Vector)UserGroupVector.get(1);%>
				<% for(int i = 0; i < optName.size(); i++){ %>
					<option value='<%=optCode.get(i).toString()%>'
						<%=user.get(6).toString().equals(optCode.get(i).toString()) ? "selected" : "" %> >
						<%=optName.get(i).toString()%>
					</option>
				<% } %>
			</select>
		</td>
	</tr>
     
	<tr>
		<td>
			부서
		</td>
        <td></td>
        <td>
			<select class="form-control" id="select_UserDeptCode">
		    	<% deptCode = (Vector)UserDeptVector.get(0);%>
		    	<% deptName = (Vector)UserDeptVector.get(1);%>
		        <% for(int i = 0; i < deptName.size(); i++){ %>
					<option value='<%=deptCode.get(i).toString()%>'
						<%=user.get(9).toString().equals(deptCode.get(i).toString()) ? "selected" : "" %> >
						<%=deptName.get(i).toString()%>
					</option>
				<% } %>
			</select>
		</td>
	</tr>
	
	<tr>
        <td>
			<label for="startDate">적용시작일자</label>
		</td>
        <td></td>
        <td>
         	<input type="text" data-date-format="yyyy-mm-dd" id="startDate" class="form-control">
    	</td>
    </tr>
 </table>