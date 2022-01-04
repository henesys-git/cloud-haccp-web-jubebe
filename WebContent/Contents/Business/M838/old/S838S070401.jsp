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
S838S070401.jsp
부적합품 등록 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklistId = "", checklistRevNo = "";
	
	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");	

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#dateWrite", 0);
		new SetSingleDate2("", "#dateOccur", 0);
		
		// 제품명 input tag 클릭 시 제품 검색 팝업 생성
		$('#prodName').click(function() {
			parent.pop_fn_ProductName_View(2,'01')
		});
    });	
	
 // 제품 검색 후 클릭한 데이터를 가져옴
    function SetProductName_code(prodName, prodCode, prodRevNo, 
    							 prodGyugyuk, safeStock, curStock) {
    	$('#prodName').val(prodName);
    	$('#prodCd').val(prodCode);
    	$('#prodRevNo').val(prodRevNo);
    }
	
	function SaveOderInfo() {
    	if($('#prodName').val() == "") {
			alert("부적합품을 선택하세요");
 			return;
    	} else {
	        var dataJson = new Object();
	        
			dataJson.personIdWrite = '<%=loginID%>';									
			dataJson.checklistId = '<%=checklistId%>';
			dataJson.checklistRevNo = '<%=checklistRevNo%>';
			dataJson.prodName = $('#prodName').val();	
			dataJson.prodCd = $('#prodCd').val();
			dataJson.prodRevNo = $('#prodRevNo').val();
			dataJson.dateOccur = $('#dateOccur').val();	
			dataJson.dateWrite = $('#dateWrite').val();
			dataJson.placeOccur = $('#placeOccur').val();		
			dataJson.nonConformCount = $('#nonConformCount').val();
			dataJson.nonConformDetail = $('#nonConformDetail').val();
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S070400E101");
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
					heneSwal.success('부적합품 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	        		parent.$('#SubInfo_List_contents').hide();
	         	} else {
					heneSwal.error('부적합품 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			작성일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="dateWrite" class="form-control">
		</td>
	</tr>
   	<tr>
   		<td>
			완제품 코드
   		</td>
   		<td>
   			<input type="text" class="form-control" id="prodCd" readonly />
   			<input type="hidden" class="form-control" id="prodRevNo" readonly />
   		</td>
   	</tr>
 	<tr>
 		<td>
			완제품 명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="prodName" readonly placeholder="Click here"/>
  		</td>
  	</tr>
 	<tr>
		<td>
			발생일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="dateOccur" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			발생장소
		</td>
	    <td>
			<input type="text" id="placeOccur" class="form-control">
		</td>
	</tr>
 	<tr>
 		<td>
			부적합 수량
  		</td>
  		<td>
  			<input type="number" class="form-control" id="nonConformCount" />
  		</td>
  	</tr>
  	<tr>
		<td>
			부적합 내용
		</td>
	    <td>
			<input type="text" id="nonConformDetail" class="form-control">
		</td>
	</tr>
</table>