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
	//S303S050162.jsp : 주문별BOM등록 Service Delegator START
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String  GV_PROC_PLAN_NO="", GV_PROD_CD="", GV_PROD_CD_REV="", GV_PRODUCT_NM="",
			GV_MIX_RECIPE_CNT = "", GV_PRODUCTION_END_DT="";
	
	if(request.getParameter("proc_plan_no")== null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");

	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD ="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV ="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev"); 

	if(request.getParameter("product_nm")== null)
		GV_PRODUCT_NM = "";
	else
		GV_PRODUCT_NM = request.getParameter("product_nm");
	
	if(request.getParameter("mix_recipe_cnt")== null)
		GV_MIX_RECIPE_CNT="";
	else
		GV_MIX_RECIPE_CNT = request.getParameter("mix_recipe_cnt");

	if(request.getParameter("production_end_dt")== null)
		GV_PRODUCTION_END_DT="";
	else
		GV_PRODUCTION_END_DT = request.getParameter("production_end_dt");
	
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M303S050100E162", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

	var vTableS303S050167;
	var TableS303S050167_info;
    var TableS303S050167_Row_Count = 0;
    var TableS303S050167_Row_Index = -1;
    
    $(document).ready(function () {
        $("#txt_expiration_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
//         $('#txt_expiration_date').datepicker('update', today);
		
        $('#txt_proc_plan_no').val('<%=GV_PROC_PLAN_NO%>');
		$('#txt_prod_cd').val('<%=GV_PROD_CD%>');
		$('#txt_prod_cd_rev').val('<%=GV_PROD_CD_REV%>');
		$('#txt_product_nm').val('<%=GV_PRODUCT_NM%>');
		$('#txt_mix_recipe_cnt').val('<%=GV_MIX_RECIPE_CNT%>');
		$('#txt_production_end_dt').val('<%=GV_PRODUCTION_END_DT%>');

		call_S303S050167();
		
		TableS303S050167_Row_Index = -1;
		
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
// 	 		$(this).val($(this).val().replace(/^[0-9]*.[0-9]*[1-9]+$/g,""));
	 	});
	 	
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPointMinus]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.-]/g,""));
	 	});
    });
    
    function call_S303S050167() {
    	$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050167.jsp", 
            data: "proc_plan_no=" + '<%=GV_PROC_PLAN_NO%>' 
            	+ "&prod_cd=" + '<%=GV_PROD_CD%>' 
            	+ "&prod_cd_rev=" + '<%=GV_PROD_CD_REV%>',
            beforeSend: function () {
                $("#storage_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#storage_tbody").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });
    }
    
    function fn_plus_body(obj){ 
    	if( $('#txt_part_cd').val().length<1){
			alert("원부자재 검색을 먼저 하세요~~~!!!");
			return;
		}
		if( $('#txt_pre_amt').val().length<1){
			alert("불출 전 재고를 입력하세요~~~!!!");
			return;
		}
		if( $('#txt_post_amt').val().length<1){
			alert("불출 후 재고를 입력하세요~~~!!!");
			return;
		}
		if( $('#txt_io_amt').val().length<1){
			alert("불출수량을 입력하세요~~~!!!");
			return;
		}
		
		if(TableS303S050167_Row_Index>-1){ //수정
		    vTableS303S050167.cell( TableS303S050167_Row_Index, 2 ).data( $('#txt_expiration_date').val() );
		
		    vTableS303S050167.cell( TableS303S050167_Row_Index, 8  ).data( $('#txt_pre_amt').val() );
		    vTableS303S050167.cell( TableS303S050167_Row_Index, 9  ).data( $('#txt_post_amt').val() );
		    vTableS303S050167.cell( TableS303S050167_Row_Index, 10 ).data( $('#txt_io_amt').val() );
		    
		    vTableS303S050167.cell( TableS303S050167_Row_Index, 15 ).data( $('#txt_bigo').val() );
//			    vTableS303S050167.row(TableS303S050167_Row_Index).draw();
		    clear_input();
		    TableS303S050167_Row_Index=-1;
		} else { //추가
			// part_cd 비교해서 이미 등록된 원부자재는 패스
   			var v_part_cd = $('#txt_part_cd').val();
   			var jungbok_chk = false;
   			for(i=0; i<TableS303S050167_Row_Count; i++) {
   				if(v_part_cd==vTableS303S050167.cell(i,3).data()) {
   					jungbok_chk = true;
       			}
   			}
   			if(!jungbok_chk){
   				vTableS303S050167.row.add([
   					$('#txt_warehousing_datetime').val(),
   					$('#txt_io_gubun').val(),
   					$('#txt_expiration_date').val(),
   					$('#txt_part_cd').val(),
   					$('#txt_part_cd_rev').val(),
   					$('#txt_part_nm').val(),
   					$('#txt_gyugyeok').val(),
   					$('#txt_detail_gyugyeok').val(),
   					$('#txt_pre_amt').val(),
   					$('#txt_post_amt').val(),
   					$('#txt_io_amt').val(),
   			 		$('#txt_proc_plan_no').val(),
   			 		$('#txt_prod_cd').val(),
   			 		$('#txt_prod_cd_rev').val(),
   			 		$('#txt_product_nm').val(),
   					$('#txt_bigo').val(),
   					'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
   		        ]).draw(true);
   				
   				clear_input();
   			    
   		        TableS303S050167_info = vTableS303S050167.page.info();
   		        TableS303S050167_Row_Count = TableS303S050167_info.recordsTotal;
   		        
   		        TableS303S050167_Row_Index=-1;
   			} else {
   				alert("이미 등록된 원재료 입니다.");
   			}
		}
    }
    
    function fn_mius_body(obj){  
		vTableS303S050167.row($(obj).parents('tr')).remove().draw();
		
	    TableS303S050167_info = vTableS303S050167.page.info();
	    TableS303S050167_Row_Count = TableS303S050167_info.recordsTotal;
	    
	    TableS303S050167_Row_Index=-1;
	    clear_input();
    } 
    
	function clear_input(){
// 		$('#txt_warehousing_datetime').val("");
// 		$('#txt_io_gubun').val("");
		$('#txt_expiration_date').datepicker('update', '');
		$('#txt_part_cd').val("");
		$('#txt_part_cd_rev').val("");
		$('#txt_part_nm').val("");
		$('#txt_gyugyeok').val("");
		$('#txt_detail_gyugyeok').val("");
		$('#txt_pre_amt').val("");
		$('#txt_post_amt').val("");
		$('#txt_io_amt').val("");   
		$('#txt_bigo').val("");
		
		$("#btn_plus").text("추가");
		$('#btn_SearchPart').attr("disabled", false);
	}        
		
	function SaveOderInfo() {      
		var WebSockData="";		
		
	    TableS303S050167_info = vTableS303S050167.page.info();
	    TableS303S050167_Row_Count = TableS303S050167_info.recordsTotal;
	    
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.member_key = "<%=member_key%>";
        
        if(TableS303S050167_Row_Count==0) {
        	alert("원재료 불출정보를 하나이상 등록하세요");
			return false;
        }

		try {
	        var jArray = new Array(); // JSON Array 선언
		    for(var i=0; i<TableS303S050167_Row_Count; i++){    		
		    	var dataJson = new Object(); 
		    	
		    	dataJson.warehousing_datetime = vTableS303S050167.cell( i, 0 ).data();
		    	dataJson.io_gubun		= vTableS303S050167.cell( i, 1  ).data();
		    	dataJson.expiration_date= vTableS303S050167.cell( i, 2  ).data();
		    	dataJson.part_cd		= vTableS303S050167.cell( i, 3  ).data();
		    	dataJson.part_cd_rev	= vTableS303S050167.cell( i, 4  ).data();
		    	dataJson.part_nm		= vTableS303S050167.cell( i, 5  ).data();
		    	dataJson.pre_amt		= vTableS303S050167.cell( i, 8  ).data();
		    	dataJson.post_amt		= vTableS303S050167.cell( i, 9  ).data();
		    	dataJson.io_amt			= vTableS303S050167.cell( i, 10 ).data();
		    	dataJson.proc_plan_no	= vTableS303S050167.cell( i, 11 ).data();
		    	dataJson.prod_cd		= vTableS303S050167.cell( i, 12 ).data();
		    	dataJson.prod_cd_rev	= vTableS303S050167.cell( i, 13 ).data();
		    	dataJson.prod_nm		= vTableS303S050167.cell( i, 14 ).data();
		    	dataJson.bigo			= vTableS303S050167.cell( i, 15 ).data();
		    	dataJson.member_key		= "<%=member_key%>";
		    	
				jArray.push(dataJson); // 데이터를 배열에 담는다.		
	        }
			var dataJsonMulti = new Object();
			dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

			var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			var chekrtn = confirm("등록하시겠습니까?"); 
			if(chekrtn){
// 				console.log(JSONparam);
				SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄		
			}
		} 
		catch(err) {
			console.log(err);
	    }
	}
	
	function SendTojsp(bomdata,pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	//         	 alert(bomdata);
	         },
	         success: function (html) {
	//         	 console.log("success=" + bomdata);
// 	        	 parent.DetailInfo_List.click();
	        	 parent.SubInfo_BomList.click();
	     		parent.$("#ReportNote").children().remove();
	      		parent.$('#modalReport').hide();
	         },
	         error: function (xhr, option, error) {
	
	         }
	     });		
	}    

    function SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugyeok,txt_detail_gyugyeok,txt_jaego){
		$('#txt_part_nm').val(txt_part_name);
		$('#txt_part_cd').val(txt_part_cd);
		$('#txt_part_cd_rev').val(txt_part_revision_no);	
		$('#txt_gyugyeok').val(txt_gyugyeok);	
		$('#txt_detail_gyugyeok').val(txt_detail_gyugyeok);	
		$('#txt_pre_amt').val(txt_jaego);
    }

    function fn_production_storage_delete(obj) {
		var tr = $(obj).parent().parent();
		var td = tr.children();
		var chekrtn = confirm("이미 등록된 데이터입니다"+"\n"+"삭제 하시겠습니까?"); 

		if(chekrtn){
			TableS303S050167_info = vTableS303S050167.page.info();
		    TableS303S050167_Row_Count = TableS303S050167_info.recordsTotal;
		    if(TableS303S050167_Row_Count > 0) {
		    	var dataJson = new Object();
		    	dataJson.proc_plan_no	= $('#txt_proc_plan_no').val();
		    	dataJson.prod_cd		= $('#txt_prod_cd').val();
		        dataJson.prod_cd_rev	= $('#txt_prod_cd_rev').val();
		        dataJson.warehousing_datetime = td.eq(0).text();
		        dataJson.io_gubun 		= td.eq(1).text();
		        dataJson.expiration_date = td.eq(2).text();
		        dataJson.part_cd		= td.eq(3).text();
		        dataJson.part_cd_rev	= td.eq(4).text();
		        dataJson.member_key 	= "<%=member_key%>";
		    	
		        var jArray = new Array(); // JSON Array 선언
		        jArray.push(dataJson); // 데이터를 배열에 담는다
		        var dataJsonMulti = new Object();
				dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
				var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		        
// 				console.log(JSONparam);
		        SendTojspDelete(JSONparam, "M303S050100E163");
			}	
		}
    }
    
    function SendTojspDelete(bomdata,pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	//         	 alert(bomdata);
	         },
	         success: function (html) {
	      		call_S303S050167();
	      		
	      		TableS303S050167_info = vTableS303S050167.page.info();
	    	    TableS303S050167_Row_Count = TableS303S050167_info.recordsTotal;
	    	    
	    	    TableS303S050167_Row_Index=-1;
	    	    clear_input();
	         },
	         error: function (xhr, option, error) {
	
	         }
	     });		
	}   
    </script>


	<div class="container-fluid">
        <table class="table table-striped table-bordered" style="width: 100%; margin: 0 ; align:left">	       
 			<tr>  				
	            <td style="width: 10%;  font-weight: 900; font-size:14px; text-align:right;vertical-align: middle">제품명</td> <!-- 제품코드 -->
	            <td style="width: 23.33%;  font-weight: 900; font-size:14px; text-align:lef;">
					<input type="hidden" class="form-control" id="txt_proc_plan_no" readonly/>
					<input type="hidden" class="form-control" id="txt_prod_cd" readonly/>
					<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly/>
					<input type="text" 	 class="form-control" id="txt_product_nm" readonly/>
	           	</td>
	            <td style="width: 10%;  font-weight: 900; font-size:14px; text-align:right;vertical-align: middle">생산완료 배합수</td>
	            <td style="width: 23.33%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_mix_recipe_cnt" readonly/>
	           	</td>
	           	<td style="width: 10%;  font-weight: 900; font-size:14px; text-align:right;vertical-align: middle">생산완료일자</td>
	            <td style="width: 23.33%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_production_end_dt" readonly/>
	           	</td>
	        </tr>
       	</table>
		<div class="modal-content panel panel-default" style="overflow:auto;">
	        <table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="storage_table">
		        <tr style="vertical-align: middle">
		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">유통기한</td>
		            <td style="width:15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">원재료명</td>
		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">규격</td>
		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">규격(g단위)</td>
		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">불출 전 재고</td>
		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">불출 후 재고</td>
		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">불출수량</td>
		            <td style="width:20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</td>
		            <td style="width: 5%; vertical-align: middle"></td>
		        </tr>
		        <tr style="vertical-align: middle">			            
		        	<td style="text-align:center; vertical-align:middle; margin:0;">
		        		<input type="hidden" class="form-control" id="txt_warehousing_datetime" readonly value="TO_CHAR(SYSDATETIME,'YYYY-MM-DD HH24:MI:SS')" ></input>
		        		<input type="hidden" class="form-control" id="txt_io_gubun" readonly value="O"></input>
						<input type="text"   class="form-control" id="txt_expiration_date" readonly ></input>
					</td>
		            <td style="text-align:center; vertical-align:middle; margin:0;">
						<input type="hidden" class="form-control" id="txt_part_cd" readonly ></input>
						<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly></input>
						<input type="text"   class="form-control" id="txt_part_nm" readonly style="width:62%;float:left;"></input>
						<button type="button" onclick="parent.pop_fn_PartList_View(4)" id="btn_SearchPart" 
							class="btn btn-info"  style="width:38%;float:left;">검색</button>
		           	</td>
		            <td style="text-align:center; vertical-align:middle; margin:0;">
		            	<input type="text" class="form-control" id="txt_gyugyeok" readonly></input>
		           	</td>
		            <td style="text-align:center; vertical-align:middle; margin:0;">
		            	<input type="text" class="form-control" id="txt_detail_gyugyeok" readonly></input>
		            </td>
		            <td style="text-align:center; vertical-align:middle; margin:0;">
		            	<input type="text" class="form-control" id="txt_pre_amt" numberPointMinus readonly></input>
		           	</td>
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
		            	<input type="text" class="form-control" id="txt_post_amt" numberPointMinus readonly></input>
		            </td>
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
		            	<input type="text" class="form-control" id="txt_io_amt" numberPoint ></input>
		            </td>
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
<!-- 		            	<input type="hidden" class="form-control" id="txt_proc_plan_no" readonly ></input> -->
<!-- 		            	<input type="hidden" class="form-control" id="txt_prod_cd" readonly ></input> -->
<!-- 		            	<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly ></input> -->
<!-- 		            	<input type="hidden" class="form-control" id="txt_prod_nm" readonly ></input> -->
		            	<input type="text"   class="form-control" id="txt_bigo" ></input>
		            </td>
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
		            	<button id="btn_plus" class="form-control btn btn-info" onclick="fn_plus_body(this);">추가</button>
		            </td>
		        </tr>
		    </table>
		</div>        
		<div id="storage_tbody"></div>
        <p style="text-align:center; vertical-align: middle ;margin: 0 ;">
			<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
			<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
