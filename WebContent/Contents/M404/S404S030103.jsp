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
S404S030103.jsp
중량 선별 결과 삭제
*/

/* 
2021 02 02 최현수
등록 페이지 그대로 복사만 해놓음
*/


	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
	String GV_JSPPAGE = "";
%>
    
<script type="text/javascript">
	
    $(document).ready(function () {
		$('#txt_io_user_id').val('<%=loginID%>');
		
		$('#prod_name').click(function() {
			parent.pop_fn_ProductName_View(2, '01');
		});
    });	
	
  	// 완제품 검색 2차 팝업창에서 행 클릭했을때
	function SetProductName_code(txt_prod_name, txt_prod_cd,
							  txt_prod_revision_no, txt_gyugeok, txt_unit_price) { 
		$('#censor_value2').val(txt_prod_cd);
		$('#prod_name').val(txt_prod_name);
  	}
	
	function SaveOderInfo() {
    	if($('#censor_date').val() == "") {
			heneSwal.warning("선별 일자를 입력하세요");
 			return false;
    	}
		
		if($('#txt_io_count').val() == '') {
			heneSwal.warning("입고수량을 입력하세요");
			return false;
		} else {
	        var dataJsonHead = new Object();
	        var jArray = new Array();
	        
			dataJsonHead.jsp_page 		= '<%=GV_JSPPAGE%>';								
			dataJsonHead.user_id 		= '<%=loginID%>';									
			dataJsonHead.ipg 			= 'IPG';	//입고, 채번 prefix
			
			var dataJsonBody = new Object();
			dataJsonBody.io_user_id = $('#txt_io_user_id').val();			// 입고담당자
			dataJsonBody.ipgo_date = $('#txt_ipgo_date').val();				// 입고날짜
			dataJsonBody.prod_cd = $('#txt_prod_cd').val();					// 원부자재코드	
			dataJsonBody.prod_rev_no = $('#txt_prod_rev_no').val();			// 원부자재개정번호
			dataJsonBody.prod_nm = $('#txt_prod_name').val();				// 원부자재명
			dataJsonBody.io_count = $('#txt_io_count').val();				// 입출고 수량	
			dataJsonBody.expiration_date = $('#txt_expiration_date').val();	// 유통기한
			dataJsonBody.bigo = $('#txt_bigo').val();						// 비고
			
        	<%if(history_yn.equals("Y")){ %>
        		dataJsonBody.hist_no = $('#txt_hist_no').val();
        	<%} else{ %>
        		dataJsonBody.hist_no = 'NON';
        	<%}%>
        	
			jArray.push(dataJsonBody);
		    
			var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
			dataJsonMulti.param = jArray;

			var JSONparam = JSON.stringify(dataJsonMulti);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M858S060100E101");
			}
		}
	}

	function SendTojsp(bomdata, pid) {
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : bomdata, "pid" : pid},
			success: function (html) {	
				if(html > -1) {
					
					heneSwal.success('입출고 등록이 완료되었습니다');

					vProdgubun_big = "";
					vProdgubun_mid = "";
					
					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	        		parent.$('#SubInfo_List_contents').hide();
	         	} else {
					heneSwal.error('입출고 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>


<form id="myForm">
<table class="table">
	<tr>
		<td>
			선별 일자
		</td>
		<td>
			<input type="date" data-date-format="yyyy-mm-dd" id="censor_date" class="form-control">
		</td>
  	</tr>
	<tr>
		<td>
			선별 시간
		</td>
	    <td>
			<input type="time" id="censor_data_create_time" class="form-control">
		</td>
	</tr>
   	<tr>
   		<td>
			완제품 코드
   		</td>
   		<td>
   			<input type="text" class="form-control" id="censor_value2" readonly>
   		</td>
   	</tr>
 	<tr>
 		<td>
			완제품 명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="prod_name" readonly placeholder="Click here">
  		</td>
  	</tr>
 	<tr>
 		<td>
			총 집계 수량
  		</td>
  		<td>
  			<input type="number" class="form-control" id="censor_value0">
  		</td>
  	</tr>
 	<tr>
 		<td>
			정량
  		</td>
  		<td>
  			<input type="number" class="form-control" id="censor_value1">
  		</td>
  	</tr>
</table>
</form>