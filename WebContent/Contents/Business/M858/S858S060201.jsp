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
완제품 재고보정(마이너스) (S858S060201.jsp)
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_PROD_CD = "", GV_PROD_REV_NO = "", 
		   GV_SEQ_NO = "", GV_PROD_NM = "",
		   GV_PROD_CUR_STOCK = "", GV_PROD_DATE = "";
	
	if(request.getParameter("prod_cd") != null)
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev_no") != null)
		GV_PROD_REV_NO = request.getParameter("prod_rev_no");
	
	if(request.getParameter("prod_nm") != null)
		GV_PROD_NM = request.getParameter("prod_nm");
	
	if(request.getParameter("prod_cur_stock") != null)
		GV_PROD_CUR_STOCK = request.getParameter("prod_cur_stock");
	
	if(request.getParameter("seq_no") != null)
		GV_SEQ_NO = request.getParameter("seq_no");

	if(request.getParameter("prod_date") != null)
		GV_PROD_DATE = request.getParameter("prod_date");
	
	String initChulgoTypeCode = "PROD_CHULGO_TYPE002";
	Vector chulgoTypeCode = null;
    Vector chulgoTypeName = null;
    Vector chulgoTypeList = CommonData.getProdChulgoType();
%>
    
<script type="text/javascript">

    $(document).ready(function () {
    	
		new SetSingleDate2("", "#txt_chulgo_date", 0);
		
		$('#txt_io_user_id').val('<%=loginID%>');

	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
    });
	
	function SaveOderInfo() {
		
		if($('#txt_io_count').val() == '') {
			
			heneSwal.warning("보정할 수량을 입력하세요");
			return false;
		
		} else {
	        var io_count = convertPlusToMinus($('#txt_io_count').val());
			
			var dataJsonHead = new Object();
	        var jArray = new Array();
	        
			dataJsonHead.user_id = '<%=loginID%>';
			
			var dataJsonBody = new Object();
			
			dataJsonBody.chulgo_date = $('#txt_chulgo_date').val();	// 출고날짜(보정날짜)
			dataJsonBody.seq_no = '<%=GV_SEQ_NO%>';					// 일련 번호
			dataJsonBody.prod_cd = '<%=GV_PROD_CD%>';				// 원부자재코드	
			dataJsonBody.prod_rev_no = '<%=GV_PROD_REV_NO%>';		// 원부자재개정번호
			dataJsonBody.io_count = io_count;						// 입출고 수량
			dataJsonBody.chulgo_type = $('#chulgo_type').val();		// 출고 타입
			dataJsonBody.bigo = $('#txt_bigo').val();				// 비고
			dataJsonBody.prod_date = '<%=GV_PROD_DATE%>';			// 생산일자
        	
			jArray.push(dataJsonBody);
		    
			var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
			dataJsonMulti.param = jArray;

			var JSONparam = JSON.stringify(dataJsonMulti);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M858S060100E201");
			}
		}
	}

	function SendTojsp(bomdata, pid) {
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : bomdata, "pid" : pid},
			success: function (rcvData) {	
				if(rcvData > -1) {
					heneSwal.success('출고 보정이 완료되었습니다');
					
					vProdgubun_big = "";
					vProdgubun_mid = "";
					
					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	        		parent.$('#SubInfo_List_contents').hide();
				} else {
					heneSwal.error('출고 보정 실패했습니다, 다시 시도해주세요');	         		
				}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			보정일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="txt_chulgo_date" class="form-control">
		</td>
	</tr>
   	<tr>
   		<td>
			완제품 코드
   		</td>
   		<td>
   			<input type="text" class="form-control" id="txt_prod_cd" readonly value=<%=GV_PROD_CD%>>
   			<input type="hidden" class="form-control" id="txt_prod_rev_no" readonly value=<%=GV_PROD_REV_NO%>>
   			<input type="hidden" class="form-control" id="txt_seq_no" readonly value=<%=GV_SEQ_NO%>>
   		</td>
   	</tr>
   	
 	<tr>
 		<td>
			품목명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="txt_prod_name" readonly value=<%=GV_PROD_NM%>>
  		</td>
  	</tr>
  	<tr>
		<td>
			현재 재고
		</td>
		<td>
			<div class="input-group">
				<input type="text" class="form-control" id="txt_prod_cur_stock" name="txt_prod_cur_stock" readonly value=<%=GV_PROD_CUR_STOCK%>>
		      	<div class="input-group-append">
		        	<span class="input-group-text">개</span>
		      	</div>
		    </div>
		</td>
  	</tr>
 	<tr>
 		<td>
			추가 출고 수량
  		</td>
  		<td>
  			<div class="input-group">
	  			<input type="number" class="form-control" id="txt_io_count" name="txt_io_count">
		      	<div class="input-group-append">
		        	<span class="input-group-text">개</span>
		      	</div>
		    </div>
  		</td>
  	</tr>
  	<tr>
		<td>
			출고 타입
		</td>
	  	<td>
			<select class="form-control" id="ipgo_type">
	        	<% chulgoTypeCode = (Vector) chulgoTypeList.get(1);%>
	            <% chulgoTypeName = (Vector) chulgoTypeList.get(2);%>
	            <% for(int i = 0; i < chulgoTypeName.size(); i++) { %>
					<option value='<%=chulgoTypeCode.get(i).toString()%>' 
						<%=initChulgoTypeCode.equals(chulgoTypeCode.get(i).toString()) ? "selected" : "" %>>
						<%=chulgoTypeName.get(i).toString()%>
					</option>
				<%} %>
			</select>
		</td>
  	</tr>
	<tr>
		<td>
			비고
		</td>
		<td>
			<input type="text" class="form-control" id="txt_bigo">
		</td>
	</tr>
</table>