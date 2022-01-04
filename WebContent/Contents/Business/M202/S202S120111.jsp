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
원부재료&부자재 재고보정(입고) (S202S120111.jsp)
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_PART_CD = "", GV_PART_REV_NO = "", 
		   GV_TRACE_KEY = "", GV_PART_NM = "",
		   GV_PART_CUR_STOCK = "";
	
	if(request.getParameter("part_cd") != null)
		GV_PART_CD = request.getParameter("part_cd");
	
	if(request.getParameter("part_rev_no") != null)
		GV_PART_REV_NO = request.getParameter("part_rev_no");
	
	if(request.getParameter("part_nm") != null)
		GV_PART_NM = request.getParameter("part_nm");
	
	if(request.getParameter("part_cur_stock") != null)
		GV_PART_CUR_STOCK = request.getParameter("part_cur_stock");
	
	if(request.getParameter("trace_key") != null)
		GV_TRACE_KEY = request.getParameter("trace_key");
	
	String initIpgoTypeCode = "PART_IPGO_TYPE003";
	Vector ipgoTypeCode = null;
    Vector ipgoTypeName = null;
    Vector ipgoTypeList = CommonData.getPartIpgoType();
%>
    
<script type="text/javascript">

    $(document).ready(function () {
		new SetSingleDate2("", "#txt_ipgo_date", 0);
		
		$('#txt_io_user_id').val('<%=loginID%>');
    });	
	
	function SaveOderInfo() {
		
		if($('#txt_io_count').val() == '') {
			heneSwal.warning("입고수량을 입력하세요");
			return false;
		} else {
	        var dataJsonHead = new Object();
	        var jArray = new Array();
	        
			dataJsonHead.user_id = '<%=loginID%>';
			
			var dataJsonBody = new Object();
			
			dataJsonBody.trace_key = '<%=GV_TRACE_KEY%>';		// 입고 추적 키
			dataJsonBody.ipgo_date = $('#txt_ipgo_date').val();	// 입고날짜(보정날짜)
			dataJsonBody.part_cd = '<%=GV_PART_CD%>';			// 원부자재코드	
			dataJsonBody.part_rev_no = '<%=GV_PART_REV_NO%>';	// 원부자재개정번호
			dataJsonBody.io_count = $('#txt_io_count').val();	// 입출고 수량	
			dataJsonBody.ipgo_type = $('#ipgo_type').val();		// 입고타입			
			dataJsonBody.bigo = $('#txt_bigo').val();			// 비고			
        	
			jArray.push(dataJsonBody);
		    
			var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
			dataJsonMulti.param = jArray;

			var JSONparam = JSON.stringify(dataJsonMulti);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M202S120100E111");
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
					heneSwal.success('입고 보정이 완료되었습니다');
					
					vPartgubun_big = "";
					vPartgubun_mid = "";
					
					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	        		parent.fn_DetailInfo_List();
	        	//	parent.$('#SubInfo_List_contents').hide();
				} else {
					heneSwal.error('입고 보정 실패했습니다, 다시 시도해주세요');	         		
				}
	         }
	     });
	}
</script>

<table class="table">
	<tr>
		<td>
			보정일자
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
   			<input type="text" class="form-control" id="txt_part_cd" readonly value=<%=GV_PART_CD%>>
   			<input type="hidden" class="form-control" id="txt_part_rev_no" readonly value=<%=GV_PART_REV_NO%>>
   			<input type="hidden" class="form-control" id="txt_trace_key" readonly value=<%=GV_TRACE_KEY%>>
   		</td>
   	</tr>
   	
 	<tr>
 		<td>
			원부자재 명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="txt_part_name" readonly value=<%=GV_PART_NM%>>
  		</td>
  	</tr>
  	<tr>
		<td>
			현재 재고
		</td>
		<td>
			<input type="text" class="form-control" id="txt_part_cur_stock" readonly value=<%=GV_PART_CUR_STOCK%>>
		</td>
  	</tr>
 	<tr>
 		<td>
			추가 입고 수량
  		</td>
  		<td>
  			<input type="text" class="form-control" id="txt_io_count">
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
			<input type="text" class="form-control" id="txt_bigo" value="재고보정">
		</td>
	</tr>
</table>