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
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("", member_key);

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
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S110100E116", strColumnHead, jArray);
    Vector partInfo = (Vector)(TableModel.getVector().get(0));
    
    String partGubunBig = partInfo.get(0).toString();
    String partGubunMid = partInfo.get(1).toString();
    String partCode = partInfo.get(2).toString();
    String partName = partInfo.get(3).toString();
    String partPackingQty = partInfo.get(4).toString();
    String partUnitType = partInfo.get(5).toString();
    String partUnitPrice = partInfo.get(6).toString();
    String partStockSafety = partInfo.get(7).toString();
    String partRevNo = partInfo.get(8).toString();
    String partStartDate = partInfo.get(9).toString();
    String partGyugyeok = partInfo.get(10).toString();
%>

<script type="text/javascript">
	
	$(document).ready(function () {
		
		var partBigGubun = '<%=partGubunBig%>';
		
		$('#partGubunBigSelector').attr('disabled', true);
		$('#partGubunMidSelector').attr('disabled', true);
		$('#txt_PartCd').attr('disabled', true);
		
		$("#partGubunBigSelector").val('<%=partGubunBig%>').prop("selected", true);
        $("#partGubunMidSelector").val('<%=partGubunMid%>').prop("selected", true);
		$("#txt_PartCd_big").val("<%=partGubunBig%>");
		$("#txt_PartCd_mid").val("<%=partGubunMid%>");
        $("#txt_PartCd").val('<%=partCode%>');
        $("#txt_PartName").val('<%=partName%>');
        $("#txt_packing_qtty").val('<%=partPackingQty%>');
        $("#gyugyeok").val('<%=partGyugyeok%>');
        $("#unitType").val('<%=partUnitType%>');
        $("#txt_UnitPrice").val('<%=partUnitPrice%>');
        $("#txt_saftyCount").val('<%=partStockSafety%>');
        //$("#txt_StartDate").val('<%=partStartDate%>');
		
		// set gubun mid list as per initial gubun big value
		$.ajax({
	    	type: "POST",
	    	url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
	        data: "partgubun_big="+partBigGubun,
	        success: function (html) {
                $("#partGubunMidSelector > option").remove();
                
                var changMidResult = html.split("|");
                
                for(var i=0; i<changMidResult.length; i++) {
                	var value = changMidResult[i].split(",")[0]
                	var name  = changMidResult[i].split(",")[1].trim();
	                $("#partGubunMidSelector").append("<option value="+value+">"+name+"</option>");
                }
                
                if($("#partGubunBigSelector").val() == "ALL") {
                	$("#partGubunMidSelector").prepend("<option value='ALL'>전체</option>");
                	$('#partGubunMidSelector').attr('disabled', true);
                }
                
                if($("#partGubunBigSelector").val() != null
                			&&$("#partGubunBigSelector").val() != "ALL") {
	                $("#txt_PartCd_big").val($("#partGubunBigSelector").val());
	                $("#txt_PartCd_mid").val($("#partGubunMidSelector > option:eq(0)").val());
                }
			}
		});
    	
		$("#partGubunBigSelector").on("change", function() {
			$("#txt_PartCd_big").val("");
    		$("#txt_PartCd_mid").val("");
    		$("#txt_PartCd").val("");
    		
    		$('#partGubunMidSelector').attr('disabled', false);
    		
    		var partBigGubun = $("#partGubunBigSelector").val();
    		
    		if($("#partGubunBigSelector").val() == "ALL") {
    			partBigGubun = "";
    		}
        	
    		//대분류 선택시 part_cd에 값 셋팅
    		$.ajax({
		    	type: "POST",
		    	url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
		        data: "partgubun_big="+ partBigGubun,
		        success: function (html) {
	                $("#partGubunMidSelector > option").remove();
	                
	                var changMidResult = html.split("|");
	                
	                for(var i=0; i<changMidResult.length; i++) {
	                	var value = changMidResult[i].split(",")[0]
	                	var name = changMidResult[i].split(",")[1].trim();
		                $("#partGubunMidSelector").append("<option value="+value+">"+name+"</option>");
	                }

	                if($("#partGubunBigSelector").val() == "ALL") {
	                	$("#partGubunMidSelector").prepend("<option value='ALL'>전체</option>");
	                	$('#partGubunMidSelector').attr('disabled', true);
	                	$("#txt_PartCd").val('');
	                }
	                
	                if($("#partGubunBigSelector").val() != null
	                			&& $("#partGubunBigSelector").val() != "ALL") {
		                $("#txt_PartCd_big").val($("#partGubunBigSelector").val());
		                $("#txt_PartCd_mid").val($("#partGubunMidSelector > option:eq(0)").val());
		                //$("#txt_PartCd").val($("#partGubunMidSelector > option:eq(0)").val());
	                }
	                
	                $("#partGubunMidSelector > option:eq(0)").prop("selected",true);
	                
	                // 자동으로 원부자재 코드 세팅
                	<%-- $.ajax({
      		            type: "POST",
      		            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
      		            data: "partgubun_big=" + $("#partGubunBigSelector").val() +
      		            	  "&partgubun_mid=" + $("#partGubunMidSelector").val() +"&max=1",
      		            success: function (maxValue) {
      		            	var al = maxValue.substr(0,1);
      		            	var no = numpad(parseInt(maxValue.substr(1,3))+1,3);
      		            	$("#txt_PartCd").val(al+no);                  	
      		            }
        		    }); --%>
 				}
 			});
	    });
    	
		$("#partGubunMidSelector").on("change", function() {
			$("#txt_PartCd_mid").val("");
     		$("#txt_PartCd").val("");
     		
     		//중분류 선택시 part_cd에 값 셋팅
         	if($("#partGubunMidSelector").val() != null 
         				&& $("#partGubunMidSelector").val() != "ALL") {
         		$("#txt_PartCd_mid").val($("#partGubunMidSelector").val());        	
         	}
     		
         	<%--
     		var big = $("#partGubunBigSelector").val();
     		var mid = $("#partGubunMidSelector").val();
     		
         	$.ajax({
   		    	type: "POST",
   		        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
   		        data: "partgubun_big=" + big +"&partgubun_mid=" + mid + "&max=1",
				success: function (maxValue) {
 					var al = maxValue.substr(0,1);
 		            var no = numpad(parseInt(maxValue.substr(1,3))+1,3);
 		            $("#txt_PartCd").val(al+no);                          	
 				}
   			}); --%>
 		});
    });

	function SaveOderInfo() {
		
		var revision_no = Number($('#txt_RevisionNo').val()) ;
		
   		var dataJson = new Object();
   			dataJson.member_key = "<%=member_key%>";
		 	dataJson.partgubun_big = $("#partGubunBigSelector option:selected").val();
		 	dataJson.partgubun_mid = $("#partGubunMidSelector option:selected").val();
		 	dataJson.PartCd = $("#txt_PartCd").val();
		 	dataJson.packing_qtty = $('#txt_packing_qtty').val();
		 	dataJson.gyugyeok = $("#gyugyeok").val();
		 	dataJson.unit_type = $("#unitType").val();
			dataJson.revision_no = '<%=partInfo.get(8).toString()%>';
         	dataJson.PartName = $('#txt_PartName').val();
         	dataJson.UnitPrice = $('#txt_UnitPrice').val();
         	dataJson.saftyCount = $('#txt_saftyCount').val();
         	//dataJson.StartDate = $('#txt_StartDate').val();
         	dataJson.user_id = "<%=loginID%>";
         	dataJson.SerialNum = $('#txt_SerialNum').val();
    		
   		if(confirm("수정하시겠습니까?")) {
			sendToServer(JSON.stringify(dataJson), "M909S110100E112");
   		}
	}
 
	function sendToServer(bomdata, pid) {
		
	    $.ajax({
			type: "POST",
			dataType: "json",
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			data:  "bomdata=" + bomdata + "&pid=" + pid,
			success: function (html) {
				if(html>-1){
	        		heneSwal.success('원부자재 정보 수정에 성공했습니다');
	        		$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	         	} else {
		        	heneSwal.error('수정에 실패했습니다. 입력한 내용을 다시 확인해 주세요.')
		    	}
	        },
		    error: function (xhr, option, error) {
		    	heneSwal.error('수정에 실패했습니다. 입력한 내용을 다시 확인해 주세요.')
		    }
		});		
	}
</script>

<form id="formId">
	<table class="table table-hover">
        <tr>
            <td>
            	제품대분류
            </td>
            <td>
            </td>
           	<td>
	           	<div class= "input-group">			
	           		<select class="form-control" id="partGubunBigSelector">
						<%optCode = (Vector)partgubun_bigVector.get(0);%>
						<%optName = (Vector)partgubun_bigVector.get(1);%>
						<%for(int i=0; i<optName.size(); i++){ %>
						  <%if (optCode.get(i).equals(partGubunBig)) {%>
							<option value='<%=optCode.get(i).toString()%>' selected="selected"><%=optName.get(i).toString()%></option>
						  <%} else{%>
							<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
						  <%} %>
						<%}%>
					</select>
				</div>
       		</td>
		</tr>

		<tr>
            <td>
            	제품중분류
            </td>
            <td>
            </td>
            <td> 
            <div class="input-group">
				<select class="form-control" id="partGubunMidSelector">
					<% optCode = (Vector)partgubun_midVector.get(0);%>
					<% optName = (Vector)partgubun_midVector.get(1);%>
					<%for(int i=0; i<optName.size();i++){ %>
					  <%if (optCode.get(i).equals(partGubunMid)) {%>
						<option value='<%=optCode.get(i).toString()%>' selected="selected"><%=optName.get(i).toString()%></option>
					  <%} else{%>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
					  <%} %>
					<%}%>
				</select>
			</div>
       		</td>
        </tr>
        
        <tr>
            <td>
            	대분류코드
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="txt_PartCd_big" readonly/>
           	</td>
        </tr>
        
        <tr>
            <td>
            	중분류코드
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="txt_PartCd_mid" readonly/>
           	</td>
        </tr>

        <tr>
            <td>
            	원자재코드
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="txt_PartCd"/>
           	</td>
        </tr>
        
         <tr>
            <td>
            	원자재명
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="txt_PartName"  />
           	</td>
        </tr>
        
        <tr>
		    <td>
		    	포장 단위
		    </td>
		    <td>
		    </td>
		    <td>
		    	<input type="number" class="form-control" id="txt_packing_qtty"
		    				placeholder="포장 단위 수량을 입력해주세요" />
		   	</td>
		</tr>
       
		<tr>
			<td>
		   		개별 규격 
		   	</td>
		   	<td>
		   	</td>
		   	<td>
		   		<input type="number" class="form-control" 
		   				id="gyugyeok" placeholder="ex) 0.65"/>
	       	</td>
	    </tr>

		<tr>
			<td>
		   		개별 규격 단위
		   	</td>
		   	<td>
		   	</td>
		   	<td>
		   		<input type="text" class="form-control" 
		   				id="unitType" placeholder="ex) kg/수"/>
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
			      <input type="number" class="form-control" id="txt_saftyCount" name="txt_saftyCount">
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
			     <input type="text" class="form-control" id="txt_UnitPrice" />
			      <div class="input-group-append">
			        <span class="input-group-text">원</span>
			      </div>
			    </div>
           	</td>
        </tr>
    </table>
</form>