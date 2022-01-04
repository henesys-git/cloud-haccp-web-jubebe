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
S202S120101.jsp
원부자재 신규 입고 등록 (수기등록)
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
	String GV_JSPPAGE = "";
	
	String initIpgoTypeCode = "PART_IPGO_TYPE002";
	Vector ipgoTypeCode = null;
    Vector ipgoTypeName = null;
    Vector ipgoTypeList = CommonData.getPartIpgoType();
%>
    
<script type="text/javascript">
	
	var checkval = true;
	
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#txt_ipgo_date", 0);
		new SetSingleDate2("", "#txt_expiration_date", 0);
		
		$('#txt_io_user_id').val('<%=loginID%>');
		
		$("#txt_part_name").click(function() {
			parent.pop_fn_PartList_View(1);
		});
    });	
	
  	// 원부자재 검색 2차 팝업창에서 행 클릭했을때
	function SetpartName_code(txt_part_name, txt_part_cd,
							  txt_part_revision_no, txt_gyugeok, txt_unit_price) { 
		$('#txt_part_cd').val(txt_part_cd);
		$('#txt_part_rev_no').val(txt_part_revision_no);
		$('#txt_part_name').val(txt_part_name);
  	}
	
	function checkValue(checkval){
    	
    	this.checkval = checkval;
    	
    	return checkval;
    }
  	
	function SaveOderInfo() {
    	if($('#txt_expiration_date').val() == "") {
			heneSwal.warning("유통기한을 입력하세요");
 			return;
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
			dataJsonBody.warehousing_date = $('#txt_ipgo_date').val();		// 입고날짜
			dataJsonBody.part_cd = $('#txt_part_cd').val();					// 원부자재코드	
			dataJsonBody.part_rev_no = $('#txt_part_rev_no').val();			// 원부자재개정번호
			dataJsonBody.part_nm = $('#txt_part_name').val();				// 원부자재명
			dataJsonBody.io_count = $('#txt_io_count').val();				// 입출고 수량	
			dataJsonBody.expiration_date = $('#txt_expiration_date').val();	// 유통기한
			dataJsonBody.ipgo_type = $('#ipgo_type').val();					// 입고타입
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
				SendTojsp(JSONparam, "M202S120100E101");
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

					vPartgubun_big = "";
					vPartgubun_mid = "";
					
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

<table class="table" id="bom_table">
	<tr>
		<td>
			입고일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="txt_ipgo_date" class="form-control">
		</td>
	</tr>
   	<tr>
   		<td>
			원부자재 코드
   		</td>
   		<td>
   			<input type="text" class="form-control" id="txt_part_cd" readonly>
   			<input type="hidden" class="form-control" id="txt_part_rev_no" readonly>
   		</td>
   	</tr>
 	<tr>
 		<td>
			원부자재 명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="txt_part_name" readonly placeholder="Click here">
  		</td>
  	</tr>
 	<tr>
 		<td>
			입고 수량
  		</td>
  		<td>
  			<input type="text" class="form-control" id="txt_io_count">
  		</td>
  	</tr>
	<tr>
		<td>
			유통 기한
		</td>
		<td>
			<input type="text" data-date-format="yyyy-mm-dd" id="txt_expiration_date" class="form-control">
		</td>
  	</tr>
	<tr>
		<td>
			입고 타입
		</td>
	  	<td>
			<select class="form-control" id="ipgo_type">
	        	<% ipgoTypeCode = (Vector) ipgoTypeList.get(1);%>
	            <% ipgoTypeName = (Vector) ipgoTypeList.get(2);%>
	            <% for(int i = 0; i < ipgoTypeName.size(); i++) { %>
					<option value='<%=ipgoTypeName.get(i).toString()%>' 
						<%=initIpgoTypeCode.equals(ipgoTypeCode.get(i).toString()) ? "selected" : "" %>>
						<%=ipgoTypeName.get(i).toString()%>
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