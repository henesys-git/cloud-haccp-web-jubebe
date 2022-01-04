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
	
	String location_nm = "";
	
	if(request.getParameter("location_nm") != null)
		location_nm = request.getParameter("location_nm");
	
	JSONObject jArray = new JSONObject();
	jArray.put("location_nm", location_nm);
	
	VectorToJson vtj = new VectorToJson();
	
	DoyosaeTableModel table = new DoyosaeTableModel("M909S115100E124", jArray); //배송순서 없는 가맹점 목록 조회
	
	DoyosaeTableModel table2 = new DoyosaeTableModel("M909S115100E144", jArray); //배송순서 최대값 조회	
	
	Vector CustVector = table.getVector();	
	
	Vector rowSingleData1 = null;
	Vector rowSingleData2 = null;
	Vector CustCode = null;
	Vector CustName = null;
 	
	rowSingleData1 = new Vector();
	rowSingleData2 = new Vector();
 	
	Vector rtnVector = new Vector();
	
 	int rCnt = CustVector.size();
 	
 	if(rCnt == 0){
 	rowSingleData1.addElement ("non");
	rowSingleData2.addElement ("배송 순서가 입력 안된 가맹점이 없습니다.");	
 	}
 	
 	else {
 	
 	for (int i=0; i<rCnt; i++) {
	    rowSingleData1.addElement (((Vector)CustVector.elementAt(i)).elementAt(0));
	    rowSingleData2.addElement (((Vector)CustVector.elementAt(i)).elementAt(1));
		}
 	}
 	
 	rtnVector.add(rowSingleData1);
 	rtnVector.add(rowSingleData2);
	
 	String maxRefNo = table2.getStrValueAt(0, 0);
%>

<script>
	
	$(document).ready(function () {
		
		$('#deliver_index').val('<%=maxRefNo%>');
		
		if($("#select_Customer").val() == 'non') {
		$('#deliver_index').attr('disabled', true);
		$('#btn_Save').attr('disabled', true);
		}
		
		$('#btn_Save').click(function() {
			insertInfo();
		});
		
		$('#btn_Canc').click(function() {
			$('#modalReport').modal('hide');
		});
		
		function insertInfo() {
			
	   		var dataJson = new Object();
	  		
	   		dataJson.member_key = "<%=member_key%>";
			
			dataJson.cust_cd   = $("#select_Customer option:selected").val();
			dataJson.deliver_index = $("#deliver_index").val();
			dataJson.deliver_index_max = '<%=maxRefNo%>';
			dataJson.location_nm ="<%=location_nm%>";
			dataJson.user_id ="<%=loginID%>";
			
			
			var JSONparam = JSON.stringify(dataJson);
			var confirmed = confirm("등록하시겠습니까?"); 
				
			if(confirmed){
				
				SendTojsp(JSONparam, "M909S115100E111");
			} else {
				return false;
			}
			
			function SendTojsp(bomdata, pid){
				$.ajax({
			         type: "POST",
			         dataType: "json",
			         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			         data:  {"bomdata" : bomdata, "pid" : pid},
			         success: function (html) {
			        	 if(html > -1) {
			        		heneSwal.success('배송순서가 등록 되었습니다');
			                $('#modalReport').modal('hide');
			                parent.fn_MainInfo_List();
			                parent.fn_DetailInfo_List();
			         	} else {
			         		heneSwal.error('배송순서 등록에 실패했습니다. 정보를 다시 확인해 주세요');
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
			가맹점명
		</td>
        <td></td>
        <td>
        	<select class="form-control" id="select_Customer">
        		 	<% CustCode = (Vector)rtnVector.get(0);%>
					<% CustName = (Vector)rtnVector.get(1);%>
					<% for(int i=0; i<CustName.size();i++){ %>
					<option value='<%=CustCode.get(i).toString()%>'>
					<%=CustName.get(i).toString()%>
					</option>
					<% } %>
			</select>
    	</td>
    </tr>

	<tr>
		<td>
			배송순서
		</td>
		<td></td>
		<td>
			<input type="number" class = "form-control" id = "deliver_index" min = "1" step = "1"/>
		</td>
	</tr>
 </table>