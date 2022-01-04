<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
S909AS210111.jsp
선반별 제품 정보 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String shelf_type = "";
	
	if(request.getParameter("shelf_type") != null)
		shelf_type = request.getParameter("shelf_type");
%>

<script type="text/javascript">
	
    $(document).ready(function () {
    	$('#prod_name').click(function() {
			parent.pop_fn_ProductName_View(2, '01');
		});
    	
    	
    	document.forms['myForm']['shelf_type'].value = "<%=shelf_type%>";
    });
    
 	// 완제품 검색 2차 팝업창에서 행 클릭했을때
	function SetProductName_code(txt_prod_name, txt_prod_cd,
							  txt_prod_revision_no, txt_gyugeok, txt_unit_price) { 
		$('#prod_cd').val(txt_prod_cd);
		$('#prod_rev_no').val(txt_prod_revision_no);
		$('#prod_name').val(txt_prod_name);
  	}

	function insertInfo() {
		var obj = new Object();
		obj = getFormDataJson('#myForm');
		obj = JSON.stringify(obj);
		
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : obj, "pid" : "M909S210100E111"},
			success: function (html) {
				if(html > -1) {
					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
					heneSwal.success('제품 등록이 완료되었습니다');
	         	} else {
					heneSwal.error('제품 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<form id="myForm" name="myForm">
<table class="table">
	<tr>
		<td>
			선반 타입
		</td>
	    <td>
			<input type="text" class="form-control" name="shelf_type" readonly>
		</td>
	</tr>
   	<tr>
   		<td>
			완제품 코드
   		</td>
   		<td>
   			<input type="text" class="form-control" id="prod_cd" name="prod_cd" readonly />
   			<input type="hidden" class="form-control" id="prod_rev_no" name="prod_rev_no" readonly />
   		</td>
   	</tr>
 	<tr>
 		<td>
			완제품 명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="prod_name" name="prod_name" 
  				   readonly placeholder="Click here">
  		</td>
  	</tr>
 	<tr>
 		<td>
			쟁반별 완제품 개수
  		</td>
  		<td>
  			<input type="number" class="form-control" name="tray_prod_count" required>
  		</td>
  	</tr>
</table>
</form>