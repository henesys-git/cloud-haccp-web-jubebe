<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
	String checklist_id="";
	
	if(request.getParameter("checklist_id")!= null)
		checklist_id = request.getParameter("checklist_id");	

	JSONObject jArray = new JSONObject();
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S090100E124", jArray);
	MakeGridData tdata = new MakeGridData(TableModel);
	
	String html = "<select class=\"form-control\" id = \"prod_nm_select\">"
				+ "<option value = '0'>제품명 선택</option>";
	int row = 0;
	for(int j = 0; j < TableModel.getRowCount(); j++){
		
		html += "<option value = "+TableModel.getValueAt(j, 4)+"_"+TableModel.getValueAt(j, 3)+"_"+TableModel.getValueAt(j, 6)+">"
				+TableModel.getValueAt(j, 2) + " | "+ TableModel.getValueAt(j, 3) +"</option>";
	}
	
	html += "</select>";
%>
<script type="text/javascript">
    
    $(document).ready(function () {
    	
    	if("<%=TableModel.getRowCount()%>" == 0){
    		heneSwal.warning("반품된 제품이 없습니다. <br><br> 반품관리에서 반품등록을 해주세요.");
    	}
    	
        $("#Unstoring").hide();
 		$("#return").hide();
        
        $("#prod_nm_select").change(function() {
        	
        	$("#Unstoring").show();
     		$("#return").show();

        	var selectData = $(this).val();
        	var selArr = selectData.split("_");
    		
        	if(selectData == '0'){ return false; }
        	
        	var dataAjax = {
					"chulha_no": selArr[0],
					"prod_date": selArr[1],
					"prod_cd": selArr[2]
				  };
	
			dataAjax = JSON.stringify(dataAjax);
			
			 $.ajax({
			        type: "POST",
			        dataType: "json",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
			        data:  {"prmtr" : dataAjax, "pid" : "M838S090100E134"},
					success: function (data) {	

			        	var UnstoringHtml = "<tr><th rowspan = 8 style = 'vertical-align: middle;'>출고내역</th><th>거래처</th><th>수량</th><th>규격</th><th>출고지</th><th>배송자</th></tr>";
						var returnHtml = "<tr><th rowspan = 8 style = 'vertical-align: middle;'>회수내역</th><th>거래처</th><th>수량</th><th>규격</th><th>회수지</th><th>배송자</th></tr>";
			     		
						if(data.length > 1) {
							$("#prod_date").val(data[0][5]);
							$("#prod_cd").val(data[0][7]);
							$('#output').val(data[0][9]);
							$('#deliveryAmount').val(data[0][10]);
							
							for( x in data){
								UnstoringHtml += "<tr>",returnHtml += "<tr>";
								
								UnstoringHtml += "<td>"+data[x][11]+"</td>" 	// 거래처
											    +"<td>"+(parseInt(data[x][14])+parseInt(data[x][15]!=""?data[x][15]:0))+"</td>"	//수량
												+"<td>"+data[x][16]+"</td>"		// 규격
												+"<td>원우푸드</td>"				// 출고지
												+"<td>"+data[x][17]+"</td>";	// 배송자
												
								if(data[x][15] != "" && data[x][15] != null){
									
									returnHtml += "<td>"+data[x][11]+"</td>" 	// 거래처 				
												 +"<td>"+data[x][15]+"</td>"	// 수량
												 +"<td>"+data[x][16]+"</td>"	// 규격
												 +"<td>"+data[x][11]+"</td>"	// 회수지
												 +"<td>"+data[x][17]+"</td>";	// 배송자	
								}	
								
								UnstoringHtml += "</tr>",returnHtml += "</tr>";			 
							}			
							
							$("#Unstoring").html(UnstoringHtml);
							$("#return").html(returnHtml);
							
			         	} else {
			         		$("#Unstoring").html("");
			         		$("#return").html("");
			         		$("#returnTbl input").val("");
			         		heneSwal.warningTimer("데이터가 없습니다.");
			         	}
			         }
			     });	
        	
        });
        
    });
    
	function SendTojsp() {        
		
		if($("#prod_nm_select").val() == "0"){
			heneSwal.warning("리콜제품을 선택해주세요.");
			return false;
		}
		
		var dataJson = new Object();
		
		dataJson.checklist_id 		= '<%=checklist_id%>';
		dataJson.prod_cd 			= $("#prod_cd").val();
		dataJson.prod_date 			= $("#prod_date").val();
		dataJson.action_result 		= $("#action_result").val();
		dataJson.action_plan 		= $("#action_plan").val();
		dataJson.person_write_id	= "<%=loginID%>";
		
		var JSONparam = JSON.stringify(dataJson);
		
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn){
			
			$.ajax({
		         type: "POST",
		         dataType: "json", // Ajax로 json타입으로 보낸다.
		         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		         data:  {"bomdata" : JSONparam, "pid" : "M838S090100E101" },
		         success: function (html) {	
	 	         	if(html > -1) {

       					heneSwal.success('회수결과기록 등록이 완료되었습니다');
       					
       					$('#modalReport').modal('hide');
       					parent.fn_MainInfo_List(startDate, endDate);
       				} else {
       					heneSwal.errorTimer("회수결과기록 등록을 실패했습니다, 다시 시도해주세요");
       				}
		         }
		     }); // end ajax
		}
	}
	
</script>

<table class="table table-hover" id = "returnTbl" style="width: 100%; margin: 0 auto; align:left">
     <tr>
        <td style = "width: 15%;">제품명</td>
        <td>
         	<%= html %>
        </td>
         <td style = "width: 15%;">제조일자</td>
        <td>
        	<input type="text" class="form-control" id="prod_date" readonly/>
         	<input type="hidden" id = "prod_cd"/>
        </td>
     </tr>
     <tr>
        <td>생산량</td>
        <td>
    		<input type="text" class="form-control" id="output" readonly/>
        </td>
        <td>출고량</td>
        <td>
			<input type="text" class="form-control" id="deliveryAmount" readonly/>
        </td>
     </tr>
     <tr>
     	<table class = "table" id = "Unstoring">
     	</table>
     </tr>
     <tr>
     	<table class = "table" id = "return">
     	</table>
     </tr>
 </table>
 <table class = "table">
 	 <tr>
        <td style = "width: 15%;">처리결과</td>
       	<td>
           <textarea class="form-control" id = "action_result"></textarea>
        </td>
     </tr>
     <tr>
        <td>미회수품<br>처리계획</td>
        <td>
 	      	<textarea class="form-control" id = "action_plan"></textarea>
       	</td>
     </tr>
 </table>