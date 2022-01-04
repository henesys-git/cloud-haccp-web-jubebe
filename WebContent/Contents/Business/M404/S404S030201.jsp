﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	String member_key = session.getAttribute("member_key").toString();

	String GV_PROC_PLAN_NO="", GV_PROD_CD = "",GV_PROD_REV = "",GV_PRODUCT_NM="", GV_START_DT= "", GV_END_DT="", GV_DEFAULT_WEIGHT = "", GV_SEOLBI_NM="", GV_ORDER_NO="", GV_LOTNO="", GV_CHECK_DATE="";

	if(request.getParameter("Proc_plan_no")== null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("Proc_plan_no");
	
	if(request.getParameter("Prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("Prod_cd");
	
	if(request.getParameter("Prod_rev")== null)
		GV_PROD_REV = "";
	else
		GV_PROD_REV = request.getParameter("Prod_rev");
	
	if(request.getParameter("Product_nm")== null)
		GV_PRODUCT_NM = "";
	else
		GV_PRODUCT_NM = request.getParameter("Product_nm");

	if(request.getParameter("Start_dt")== null)
		GV_START_DT = "";
	else
		GV_START_DT = request.getParameter("Start_dt");

	if(request.getParameter("End_dt")== null)
		GV_END_DT = "";
	else
		GV_END_DT = request.getParameter("End_dt");
	
	if(request.getParameter("Seolbi_nm")== null)
		GV_SEOLBI_NM = "";
	else
		GV_SEOLBI_NM = request.getParameter("Seolbi_nm");
	
	if(request.getParameter("default_weight")== null)
		GV_DEFAULT_WEIGHT = "";
	else
		GV_DEFAULT_WEIGHT = request.getParameter("default_weight");
	
	int check_start_time = Integer.parseInt(GV_START_DT.substring(11,13));
	int check_end_time = Integer.parseInt(GV_END_DT.substring(11,13));
	int check_length = check_end_time - check_start_time;
	// 최소값(min), 최대값(max), 간격(step)
	// 기본적으로 최소값 = 기준/100, 최대값 = 기준*2, 간격 = 기준/100
	int min = Integer.parseInt(GV_DEFAULT_WEIGHT)/100;
	if(min < 1) min = 1;
	int[] Std_value = {min, Integer.parseInt(GV_DEFAULT_WEIGHT)*2, Integer.parseInt(GV_DEFAULT_WEIGHT)/100};
	// 점검시간
//	int[] Time_rate = {7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};	
	int[] Time_rate = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};	
	// 9시부터 시작하고 싶으면 모든 -7 을 -9로 바꿀것 
	for(int i = check_start_time; i < check_end_time; i++) {
		Time_rate[i-7] = i;
	}
	String check_dt = GV_START_DT.substring(0,10);
/* 	StringBuffer html = new StringBuffer();
	html.append("$('#txt_10_1').html('66');\n"); */
%>
<script type="text/javascript">
	var SQL_Param = {
			PID:  "M404S030100E201", 
			excute: "queryProcess",
			stream: "N",
			params: ""
	}; 
	
    $(document).ready(function () {
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    console.log("<%=GV_START_DT%>" +" : "+ '<%=check_start_time%>'+ " ~ " + "<%=GV_START_DT%>"+ " : "+ '<%=check_end_time%>'+" ~ "+ '<%=check_length%>');
    });	

	function SaveOderInfo() {
		var WebSockData = "";
		var jArray = new Array(); // JSON Array 선언
		
		if($("#txt_manager").val() == '') { 
			alert("점검자를 선택하세요.");
			return false;
		} 
		if($("#txt_approver").val() == '') { 
			alert("승인자를 선택하세요.");
			return false;
		} 
		
		var dataJson = new Object(); // jSON Object 선언				
			dataJson.proc_plan_no 	= $('#txt_proc_plan_no').val();
			dataJson.prod_cd 		= $('#txt_prod_cd').val();
			dataJson.prod_cd_rev 	= $('#txt_prod_cd_rev').val();
			dataJson.product_nm		= $('#txt_product_nm').val();
			dataJson.seolbi_nm  	= $('#txt_seolbi_nm').val();
			dataJson.default_weight	= $('#txt_default_weight').val();
			dataJson.manager 		= $("#txt_manager").val();
			dataJson.check_date 	= $("#txt_check_date").val();
			dataJson.approver 		= $("#txt_approver").val();
			dataJson.user_id		= '<%=loginID%>';			

		var cst = <%=check_start_time%>;
		var cet = <%=check_end_time%>;
		var ct  = <%=check_length%>;
		var duration = 0; 			
		var wei_check = ['1','1','1','1','1','1','1','1','1','1','1','1','1','1','1','1'];
		for(var i = cst-7; i < cet-7; i++){
			wei_check[i] = '0';
		}
//			console.log(wei_check);

		if(wei_check[0] == '0'){
		dataJson.weight1	= $('#txt_weight_1').html();
		dataJson.weight2	= $('#txt_weight_2').html();
		dataJson.weight3	= $('#txt_weight_3').html();
		} if(wei_check[1] == '0'){
		dataJson.weight4	= $('#txt_weight_4').html();
		dataJson.weight5	= $('#txt_weight_5').html();
		dataJson.weight6	= $('#txt_weight_6').html();
		} if(wei_check[2] == '0'){
		dataJson.weight7	= $('#txt_weight_7').html();
		dataJson.weight8	= $('#txt_weight_8').html();
		dataJson.weight9	= $('#txt_weight_9').html();
		} if(wei_check[3] == '0'){
		dataJson.weight10	= $('#txt_weight_10').html();
		dataJson.weight11	= $('#txt_weight_11').html();
		dataJson.weight12	= $('#txt_weight_12').html();	
		} if(wei_check[4] == '0'){
		dataJson.weight13	= $('#txt_weight_13').html();
		dataJson.weight14	= $('#txt_weight_14').html();
		dataJson.weight15	= $('#txt_weight_15').html();		
		} if(wei_check[5] == '0'){
		dataJson.weight16	= $('#txt_weight_16').html();
		dataJson.weight17	= $('#txt_weight_17').html();
		dataJson.weight18	= $('#txt_weight_18').html();
		} if(wei_check[6] == '0'){
		dataJson.weight19	= $('#txt_weight_19').html();			
		dataJson.weight20	= $('#txt_weight_20').html();
		dataJson.weight21	= $('#txt_weight_21').html();
		} if(wei_check[7] == '0'){
		dataJson.weight22	= $('#txt_weight_22').html();
		dataJson.weight23	= $('#txt_weight_23').html();
		dataJson.weight24	= $('#txt_weight_24').html();
		} if(wei_check[8] == '0'){
		dataJson.weight25	= $('#txt_weight_25').html();
		dataJson.weight26	= $('#txt_weight_26').html();
		dataJson.weight27	= $('#txt_weight_27').html();
		} if(wei_check[9] == '0'){
		dataJson.weight28	= $('#txt_weight_28').html();
		dataJson.weight29	= $('#txt_weight_29').html();
		dataJson.weight30	= $('#txt_weight_30').html();
		} if(wei_check[10] == '0'){
		dataJson.weight31	= $('#txt_weight_31').html();
		dataJson.weight32	= $('#txt_weight_32').html();
		dataJson.weight33	= $('#txt_weight_33').html();
		} if(wei_check[11] == '0'){
		dataJson.weight34	= $('#txt_weight_34').html();
		dataJson.weight35	= $('#txt_weight_35').html();
		dataJson.weight36	= $('#txt_weight_36').html();	
		} if(wei_check[12] == '0'){
		dataJson.weight37	= $('#txt_weight_37').html();
		dataJson.weight38	= $('#txt_weight_38').html();
		dataJson.weight39	= $('#txt_weight_39').html();
		} if(wei_check[13] == '0'){
		dataJson.weight40	= $('#txt_weight_40').html();
		dataJson.weight41	= $('#txt_weight_41').html();
		dataJson.weight42	= $('#txt_weight_42').html();	
		} if(wei_check[14] == '0'){
		dataJson.weight43	= $('#txt_weight_43').html();
		dataJson.weight44	= $('#txt_weight_44').html();
		dataJson.weight45	= $('#txt_weight_45').html();		
		} if(wei_check[15] == '0'){
		dataJson.weight46	= $('#txt_weight_46').html();
		dataJson.weight47	= $('#txt_weight_47').html();
		dataJson.weight48	= $('#txt_weight_48').html();
		} if(wei_check[16] == '0'){
		dataJson.weight49	= $('#txt_weight_49').html();			
		dataJson.weight50	= $('#txt_weight_50').html();
		dataJson.weight51	= $('#txt_weight_51').html();
		}
			dataJson.member_key	= "<%=member_key%>";						
			jArray.push(dataJson); // 데이터를 배열에 담는다.
			
			console.log(dataJson);	
			
			var dataJsonMulti = new Object();
	 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
	 		
			var work_complete_insert_check = confirm("등록하시겠습니까?");
			if(work_complete_insert_check == false)   return;  
			
			var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	         	 //alert(bomdata);
	         },
	         success: function (html) {
	        	 if(html>-1){
	        		parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	 	         	console.log("성공");
	         	}
	         },
	         error: function (xhr, option, error) {
	        	 
	         }
	     });		
	}
    function SetUser_Select(user_id, revision_no, user_nm){
//    	console.log("??? : " + user_id +" ~ "+ revision_no + " ~ " + user_nm);
		$("#"+ rowId).val(user_nm);
		$("#"+ rowId + "_rev").val(revision_no);
	}
	function SetSeolbiInfo(txt_seolbi_cd,txt_seolbi_rev, txt_seolbi_nm){
		$('#txt_seolbi_cd').val(txt_seolbi_cd);
		$('#txt_seolbi_rev').val(txt_seolbi_rev);
		$('#txt_seolbi_nm').val(txt_seolbi_nm);
    }
</script>
 <div id="PrintAreaP"  style="overflow:auto; width:100%; height:650px; text-align:center;">
	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr  style="background-color: #fff; ">
            <td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">제품명</td>
            <td style="width: 0.81%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">            
	            <input type="hidden" class="form-control" id="txt_proc_plan_no" style="width: 300px;" value="<%=GV_PROC_PLAN_NO%>" readonly></input>
            	<input type="hidden" class="form-control" id="txt_prod_cd" style="width: 300px;" value="<%=GV_PROD_CD%>" readonly></input>
            	<input type="hidden" class="form-control" id="txt_prod_cd_rev" style="width: 300px;" readonly value="<%=GV_PROD_REV%>"></input>
            	<input type="text" class="form-control" id="txt_product_nm" style="width: 300px;" value="<%=GV_PRODUCT_NM%>" readonly></input>
            </td>
            <td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left;" >기본중량(g)</td>
            <td style="width: 0.81%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">
            	<input type="text" class="form-control" id="txt_default_weight" style="width: 300px;" value="<%=GV_DEFAULT_WEIGHT%>" readonly></input>
            </td>
        </tr>  
		<tr style="background-color: #fff;">
			<td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">점검자명</td>
			<td style="width: 0.81%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">
				<input type="text" class="form-control" id="txt_manager" style="width: 300px; float:left" readonly></input>
				<input type="text" class="form-control" id="txt_manager_rev" style="width: 300px; float:left; display:none" readonly />
				<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_manager')" id="btn_SearchUser" class="btn btn-info" style="float:left"> 검색</button> 
			</td>					
			<td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">점검일자</td>
			<td style="width: 0.81%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">
			<input type="text" data-date-format="yyyy-mm-dd" id="txt_check_date" class="form-control" style="width: 300px; border: solid 1px #cccccc;" value ="<%=check_dt%>" readonly/></td>											
		</tr>
		<tr style="background-color: #fff;">
			<td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">승인자명</td>
			<td style="width: 0.81%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">
				<input type="text" class="form-control" id="txt_approver" style="width: 300px; float:left" readonly></input>
				<input type="text" class="form-control" id="txt_approver_rev" style="width: 300px; float:left; display:none" readonly />
				<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_approver')" id="btn_SearchUser" class="btn btn-info" style="float:left"> 검색</button> 
			</td>										
			<td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">설비명</td>
			<td style="width: 0.81%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">
				<input type="text" data-date-format="yyyy-mm-dd" id="txt_seolbi_nm" class="form-control" style="width: 300px; border: solid 1px #cccccc; float:left;" value ="" readonly/>
				&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="pop_fn_SeolbiList_View(1)" value="검색"></input>
			</td>				
		</tr>  
	</table>
	<br/>
	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
        <tr  style="background-color: #fff; ">
        <%if(check_length == 0) {%>
	        <td style="width: 0.5%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; "><label> 생산시작시간과 생산완료시간이 같습니다.</label></td>
        <%}%>
        <%for(int i = 0; i < check_length; i++) { if(i < 6){%>
            <td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; "><%=Time_rate[check_start_time-7+i]%>:00</td>
            <td style="width: 0.5%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">
				<label>
			        <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+1%>" 
			        min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
			        oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+1%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+1%>" style="float:none; width:30%; margin-left:5%;"><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
	    	    <label>
		    	    <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+2%>" 
		    	    min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
		    	    oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+1%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+2%>" style="float:none; width:30%; margin-left:5%;"><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
	    	    <label>	    	    
		    	    <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+3%>" 
		    	    min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
		    	    oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+3%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+3%>" style="float:none; width:30%; margin-left:5%;"><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
            </td>
		<%}}%>
		</tr>
		<!-- 생산시간 6시간 이상 -->
		<tr  style="background-color: #fff; ">
        <%for(int i = 6; i < check_length; i++) { if(i < 12) {%>
            <td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; "><%=Time_rate[i]%>:00</td>
            <td style="width: 0.5%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">
				<label>
			        <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+1%>" 
			        min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
			        oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+1%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+1%>" style="float:none; width:30%; margin-left:5%;" ><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
	    	    <label>
		    	    <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+2%>" 
		    	    min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
		    	    oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+2%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+2%>" style="float:none; width:30%; margin-left:5%;" ><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
	    	    <label>	    	    
		    	    <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+3%>" 
		    	    min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
		    	    oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+3%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+3%>" style="float:none; width:30%; margin-left:5%;" ><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
            </td>
		<%}}%>
		</tr>
		<!-- 생산시간 12시간 이상 -->
		<tr  style="background-color: #fff; ">
        <%for(int i = 12; i < check_length; i++) { if(i < 18) { %>
            <td style="width: 0.1%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; "><%=Time_rate[i]%>:00</td>
            <td style="width: 0.5%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left; ">
				<label>
			        <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+1%>" 
			        min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
			        oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+1%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+1%>" style="float:none; width:30%; margin-left:5%;" ><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
	    	    <label>
		    	    <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+2%>" 
		    	    min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
		    	    oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+2%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+2%>" style="float:none; width:30%; margin-left:5%;" ><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
	    	    <label>	    	    
		    	    <input style="float:left; width:65%;" type="range" name="weight<%=(Time_rate[check_start_time-7+i]-7)*3+3%>" 
		    	    min="<%=Std_value[0]%>" max="<%=Std_value[1]%>" step="<%=Std_value[2]%>" value="<%=GV_DEFAULT_WEIGHT%>" 
		    	    oninput="document.getElementById('txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+3%>').innerHTML=this.value;">
		    	    <span id="txt_weight_<%=(Time_rate[check_start_time-7+i]-7)*3+3%>" style="float:none; width:30%; margin-left:5%;" ><%=GV_DEFAULT_WEIGHT%></span>
	    	    </label>
            </td>
		<%}} %>
		</tr>			
	</table>
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>	
</div>	