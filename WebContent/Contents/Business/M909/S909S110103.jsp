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

    String GV_PART_CD = "", GV_REVISION_NO = "";
	
	String[] strColumnHead = {
								"대분류", "중분류", "소분류", "원자재코드",
								"일련번호", "원자재명", "규격", "원자재Level", 
								"단가", "안전재고", "개정번호", "적용일자"
							 };
	
	if(request.getParameter("part_code") != null)
		GV_PART_CD = request.getParameter("part_code");
	
	if(request.getParameter("revision_no") != null)
		GV_REVISION_NO = request.getParameter("revision_no");

	JSONObject jArray = new JSONObject();
	jArray.put("PART_CD", GV_PART_CD);
	jArray.put("REVISION_NO", GV_REVISION_NO);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M909S110100E116", strColumnHead, jArray);
    Vector partInfo = (Vector)(table.getVector().get(0));

    String partGubunBigCode = partInfo.get(0).toString();
    String partGubunMidCode = partInfo.get(1).toString();
    String partCd = partInfo.get(2).toString();
    String partName = partInfo.get(3).toString();
    String partPackingQty = partInfo.get(4).toString();
    String partUnitType = partInfo.get(5).toString();
    String partUnitPrice = partInfo.get(6).toString();
    String partSafeStock = partInfo.get(7).toString();
    String partRevNo = partInfo.get(8).toString();
    String partStartDate = partInfo.get(9).toString();
    String partGyugyeok = partInfo.get(10).toString();
%>

<script type="text/javascript">

    $(document).ready(function () {
       	
        $("#partGubunBigCode").val('<%=partGubunBigCode%>')
   		$("#partGubunMidCode").val('<%=partGubunMidCode%>');
        $("#partCd").val('<%=partCd%>');
        $("#partName").val('<%=partName%>');
        $("#partPackingQty").val('<%=partPackingQty%>');
        $("#partUnitType").val("<%=partUnitType%>");
        $("#partUnitPrice").val('<%=partUnitPrice%>');
        $("#partSafeStock").val('<%=partSafeStock%>');
        $("#partGyugyeok").val('<%=partGyugyeok%>');
    });
	
	function SaveOderInfo3() {
		
   		var dataJson = new Object();
	 	dataJson.partCd = $("#partCd").val();
			
		if(confirm("삭제하시겠습니까?")){
			sendToServer(JSON.stringify(dataJson), "M909S110100E113");
		}
	}
 
	function sendToServer(bomdata, pid) {
		
	    $.ajax({
	    	type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: "bomdata=" + bomdata + "&pid=" + pid,
	        success: function (html) {
		        if(html > -1) {
	        		heneSwal.success('원부자재 정보 삭제에 성공했습니다');
	        		$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove(); 
	         	} else{
		        	heneSwal.error('원부자재 정보 삭제에 실패했습니다, 관리자에게 문의해주세요')
		        }
			},
		    error: function (xhr, option, error) {
		    	heneSwal.error('원부자재 정보 삭제에 실패했습니다, 관리자에게 문의해주세요')
		    }
	    });
	}

</script>


<form id="formId">
	<table class="table table-hover">
        
        <tr>
            <td>
            	대분류코드
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="partGubunBigCode" readonly/>
           	</td>
        </tr>
        
        <tr>
            <td>
            	중분류코드
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="partGubunMidCode" readonly/>
           	</td>
        </tr>

        <tr>
            <td>
            	원자재코드
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="partCd" readonly/>
           	</td>
        </tr>
        
         <tr>
            <td>
            	원자재명
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="partName" readonly/>
           	</td>
        </tr>
        
        <tr>
		    <td>
		    	포장 단위
		    </td>
		    <td>
		    </td>
		    <td>
		    	<input type="number" class="form-control" id="partPackingQty" readonly/>
		   	</td>
		</tr>
       
		<tr>
			<td>
		   		개별 규격 
		   	</td>
		   	<td>
		   	</td>
		   	<td>
		   		<input type="number" class="form-control" id="partGyugyeok" readonly/>
	       	</td>
	    </tr>

		<tr>
			<td>
		   		개별 규격 단위
		   	</td>
		   	<td>
		   	</td>
		   	<td>
		   		<input type="text" class="form-control" id="partUnitType" readonly/>
	       	</td>
	    </tr>
       
        <tr>
            <td>
            	안전재고
            </td>
            <td>
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" 
			      			id="partSafeStock" name="partSafeStock" readonly/>
			      <div class="input-group-append">
			        <span class="input-group-text">개</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	단가
            </td>
            <td>
            </td>
            <td>
				<div class="input-group">
					<input type="text" class="form-control" id="partUnitPrice" readonly/>
			      	<div class="input-group-append">
			        	<span class="input-group-text">원</span>
			      	</div>
			    </div>
           	</td>
        </tr>
    </table>
</form>