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
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	


	String  GV_JSPPAGE="", GV_HEALTH_EXM_YEAR="", GV_QUAT1="", GV_QUAT2="", GV_QUAT3="", GV_QUAT4="", GV_WRITOR_NAME;

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	
	if(request.getParameter("healthExmYear")== null)
		GV_HEALTH_EXM_YEAR="";
	else
		GV_HEALTH_EXM_YEAR = request.getParameter("healthExmYear");
	
	if(request.getParameter("quat1")== null)
		GV_QUAT1="";
	else
		GV_QUAT1 = request.getParameter("quat1");
	if(request.getParameter("quat2")== null)
		GV_QUAT2="";
	else
		GV_QUAT2 = request.getParameter("quat2");
	if(request.getParameter("quat3")== null)
		GV_QUAT3="";
	else
		GV_QUAT3 = request.getParameter("quat3");
	if(request.getParameter("quat4")== null)
		GV_QUAT4="";
	else
		GV_QUAT4 = request.getParameter("quat4");
	if(request.getParameter("writorName")== null)
		GV_WRITOR_NAME="";
	else
		GV_WRITOR_NAME = request.getParameter("writorName");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "healthExmYear", GV_HEALTH_EXM_YEAR);
	jArray.put( "quat1", GV_QUAT1);
	jArray.put( "quat2", GV_QUAT2);
	jArray.put( "quat3", GV_QUAT3);
	jArray.put( "quat4", GV_QUAT4);
	jArray.put( "writorName", GV_WRITOR_NAME);

    // 데이터를 가져온다.
    

	
    TableModel = new DoyosaeTableModel("M838S050200E114", jArray);
 	int RowCount =TableModel.getRowCount();
	
//  	Vector targetVector = (Vector)(TableModel.getVector().get(0));;
//  	Vector targetVector1 = (Vector)(TableModel.getVector().get(1));;
 	

	Vector[] targetVector = new Vector[RowCount];
 	
 	for(int i = 0; i < RowCount; i++){
//  		targetVector[i] = new Vector();
 		targetVector[i] = (Vector)(TableModel.getVector().get(i));
 	}
%>    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M838S050200E113 = {
			PID:  "M838S050200E113", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M838S050200E113", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	var vOrderNo101 = "";
    var detail_seq=1;
	var vproduct_delete_table;
    var vproduct_delete_table_Row_index = -1;
	var vproduct_delete_table_info;
    var vproduct_delete_table_RowCount=0;

    $(document).ready(function () {
    	
    	detail_seq=1;
<%-- 
		<%for(int i=0; i < RowCount; i++ ){%>
			alert("<%=targetVector[i].get(0).toString()%>");
		<%}%>
 		
 --%>		
	    vproduct_delete_table = $('#product_delete_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    columnDefs: [	// 데이터부분 크기조정
		    	{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:2%;'); 
		       		}
				},
		    	{
		       		'targets': [1,2,3,5],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:10%;'); 
		       		}
				},
		    	{
		       		'targets': [4],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:40%;'); 
		       		}
				}
/* 		    	{
		       		'targets': [8],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:8%;'); 
		       		}
				} */
            ],
            language: { 
            	url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});	
	    // 날짜선택부
        $("#writeDate").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#checkDate').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#approveDate').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });


        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        today.setDate(today.getDate()+180);
        
        checkQuat();
        exmData();
        
        $('#writeDate').datepicker('update', fromday);
        $('#checkDate').datepicker('update', fromday);
        $('#approveDate').datepicker('update', fromday);
	            
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body();
	    }); 
	    $("#btn_mius").click(function(){ 
	    	fn_mius_body(); 
	    }); 
		
    });
    
    function select_product(obj){
    	var tr = $(obj).parent().parent();
    	var trNum = $(tr).closest('tr').prevAll().length;
    	
    	vproduct_delete_table_Row_index = vproduct_delete_table
        .row( trNum )
        .index();
// 	alert(vproduct_delete_table_Row_index);
    }
	
	function SetRecvData(){
		DataPars(M838S050200E113,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	// 라디오박스 선택 체크
	function checkQuat(){
		if("<%=GV_QUAT1%>" == 'Y'){
			$("#radio_quat1").prop('checked', true);
		}
		if("<%=GV_QUAT2%>" == 'Y'){
			$("#radio_quat2").prop('checked', true);
		}
		if("<%=GV_QUAT3%>" == 'Y'){
			$("#radio_quat3").prop('checked', true);
		}
		if("<%=GV_QUAT4%>" == 'Y'){
			$("#radio_quat4").prop('checked', true);
		}
	}
	// 하단테이블 : 성명, 검진일, 차기검진일, 비고 기존데이터
	function exmData(){
		<%for(int i=0; i < RowCount; i++ ){%>
	    	vproduct_delete_table.row.add( [
	    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:30px;' readonly></input>",
	    		"	<input type='text' class='form-control' id='txt_HealthExmName" + <%=i%> + "' style='float:left; width:70%;' disabled value='"+ "<%=targetVector[i].get(0).toString()%>" +"' readonly></input>" +
	    		"	<button type='button' onclick='parent.pop_fn_UserList_View(1, \"txt_HealthExmName" + <%=i%> +"\")' id='btn_SearchProd' disabled class='btn btn-info' style='float:left;width:30%;'>검색</button> ",
	    		"	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' disabled id='txt_HealthExmDate" + <%=i%> + "' style='width:100%;' value='"+ "<%=targetVector[i].get(1).toString()%>" +"' disabled></input>",
	    		"	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' disabled id='txt_HealthExmNextDate" + <%=i%> + "' style='width:100%;' value='"+ "<%=targetVector[i].get(2).toString()%>" +"' disabled></input>",
				"	<input type='text' class='form-control' id='txt_bigo" + <%=i%> + "' style='width:105%;' disabled value='"+ "<%=targetVector[i].get(20).toString()%>" +"'></input>",	    		
	    		""
	        ] ).draw();
	    	product_delete_table_config();
		<%}%>
		
	} 
		
	function SaveOrderInfo() {        
		var WebSockData="";
		var len = $("#product_tbody tr").length;
		
        vproduct_delete_table_info = vproduct_delete_table.page.info();
        vproduct_delete_table_RowCount = vproduct_delete_table_info.recordsTotal; 	

		var parmHead= '<%=Config.HEADTOKEN %>' ;
		// HACCP에서는 사용하지 않는 값이다.
		//var qa1 = $(':input[name="txt_gubun"]:radio:checked').val();
		//var qa2 = $(':input[name="txt_part_source"]:radio:checked').val();
		var qa1 = "";
		var qa2 = "";
		var qa3 = $(':input[name="txt_RoHS"]:radio:checked').val();
		
		var jArray = new Array(); // JSON Array 선언
		
		if($("#txt_writerName").val() == '') { 
			alert("작성자를 선택하세요.");
			return false;
		} 		
		if($("#txt_checkerName").val() == '') { 
			alert("작성자를 선택하세요.");
			return false;
		} 
		if($("#txt_approveName").val() == '') { 
			alert("작성자를 선택하세요.");
			return false;
		} 
		
		
		var chk = $(':radio[name="chk_quat"]:checked').val();
		if(chk == undefined){
			alert('분기를 선택하세요');
			return false;
		}

		if(vproduct_delete_table_RowCount == 0) { 
			alert("건강진단 대상자가 없습니다.");
			return false;
		}
		
        for(var i=0; i<vproduct_delete_table_RowCount; i++){
    		var trInput = $($("#product_tbody tr")[i]).find(":input");
    		qa3 = $(':input[name="txt_RoHS'+i+'"]:radio:checked').val();

    		if(trInput.eq(1).val()== '' ) { 
    			alert("검진대상자를 선택해 주세요");
    			return false;
    		}
    		
    		if(trInput.eq(5).val()== '' ) { 
    			alert("검진일을 선택해 주세요");
    			return false;
    		}
    		if(trInput.eq(6).val()== '' ) { 
    			alert("차기검진일을 선택해 주세요");
    			return false;
    		}
    		var dataJson = new Object(); // jSON Object 선언 
    		dataJson.member_key 		= "<%=member_key%>";
    		dataJson.jsp_page 			= '<%=GV_JSPPAGE%>'; 
			dataJson.writor_main 		= $("#txt_writer").val();
			dataJson.writor_cd 			= $("#txt_writer_cd").val();
			dataJson.writor_main_rev 	= $("#txt_writer_rev").val();
			dataJson.write_date			= $("#writeDate").val();
			dataJson.checker_name 		= $("#txt_checker").val();
			dataJson.checker_cd 		= $("#txt_checker_cd").val();
			dataJson.checker_name_rev 	= $("#txt_checker_rev").val();
			dataJson.check_date			= $("#checkDate").val();
			dataJson.approval_name 		= $("#txt_approve").val();
			dataJson.approval_cd 		= $("#txt_approve_cd").val();
			dataJson.approval_name_rev 	= $("#txt_approve_rev").val();			
			dataJson.approval_date 		= $("#approveDate").val();
			if(chk == 'quat1'){
				dataJson.quat_1					= 'Y';
				dataJson.quat_2					= 'N';
				dataJson.quat_3					= 'N';
				dataJson.quat_4					= 'N';
			} 
			if(chk == 'quat2'){
				dataJson.quat_1					= 'N';
				dataJson.quat_2					= 'Y';
				dataJson.quat_3					= 'N';
				dataJson.quat_4					= 'N';
			} 
			if(chk == 'quat3'){
				dataJson.quat_1					= 'N';
				dataJson.quat_2					= 'N';
				dataJson.quat_3					= 'Y';
				dataJson.quat_4					= 'N';
			} 
			if(chk == 'quat4'){
				dataJson.quat_1					= 'N';
				dataJson.quat_2					= 'N';
				dataJson.quat_3					= 'N';
				dataJson.quat_4					= 'Y';
			} 
			dataJson.uniqueness				= $("#txt_uniqueness").val();
			
			dataJson.health_exm_name		= $("#txt_HealthExm" + i ).val();
			dataJson.health_exm_cd			= $("#txt_HealthExm" + i +"_cd").val();
			dataJson.health_exm_rev			= $("#txt_HealthExm" + i +"_rev").val();
			dataJson.health_exm_date		= $("#txt_HealthExmDate" + i).val();
			dataJson.health_exm_next_date	= $("#txt_HealthExmNextDate" + i).val();
			dataJson.bigo					= $("#txt_bigo" + i).val();
    		
			console.log(dataJson);			
			jArray.push(dataJson); // 데이터를 배열에 담는다.
			
        }

        var work_complete_delete_check = confirm("삭제하시겠습니까?");
        if(work_complete_delete_check == false)   return;
        
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}

	function SendTojsp(bomdata, pid){		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         success: function (html) {	
	        		 parent.fn_MainInfo_List();
	 	             parent.$("#ReportNote").children().remove();
	 	         	 parent.$('#modalReport').hide(); 
	 	         	 console.log("성공");
	         },
	         error: function (xhr, option, error) {
	        	 console.log("user_id, 작성일 중복");
	         }
	     });		
	}  

    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetCustName_code(name, code, rev){
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);
		
    }
    function SetUser_Select(user_id, revision_no, user_nm){    	
		$("#"+ rowId).val(user_nm);
		$("#"+ rowId + "_cd").val(user_id);
		$("#"+ rowId + "_rev").val(revision_no);
	}


    function fn_plus_body(){
    	vproduct_delete_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:30px;' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_HealthExm" + vproduct_delete_table_RowCount + "' style='float:left; width:70%;' readonly></input>" +
    		"	<input type='text' class='form-control' id='txt_HealthExm" + vproduct_delete_table_RowCount + "_cd' style='float:left; width:70%; display:none;' readonly></input>" +
    		"	<input type='text' class='form-control' id='txt_HealthExm" + vproduct_delete_table_RowCount + "_rev' style='float:left; width:70%; display:none;' readonly></input>" +
    		"	<button type='button' onclick='parent.pop_fn_UserList_View(2, \"txt_HealthExm" + vproduct_delete_table_RowCount +"\")' id='btn_SearchProd' class='btn btn-info' style='float:left;width:30%;'>검색</button> ",
    		"	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_HealthExmDate" + vproduct_delete_table_RowCount + "' style='width:100%;' ></input>",
    		"	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_HealthExmNextDate" + vproduct_delete_table_RowCount + "' style='width:100%;' ></input>",
			"	<input type='text' class='form-control' id='txt_bigo" + vproduct_delete_table_RowCount + "' style='width:105%;' ></input>",	    		
    		""
        ] ).draw();
    	
    	product_delete_table_config();
		
    }
	function product_delete_table_config(){
        $('#txt_HealthExmDate'+ vproduct_delete_table_RowCount).datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_HealthExmNextDate'+ vproduct_delete_table_RowCount).datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
        vproduct_delete_table_info = vproduct_delete_table.page.info();
        vproduct_delete_table_RowCount = vproduct_delete_table_info.recordsTotal; 	
        
		var trInput = $($("#product_tbody tr")[vproduct_delete_table_RowCount-1]).find(":input");
		trInput.eq(0).val(vproduct_delete_table_RowCount);
		var vSerialNo =  "00000" + "1";
		var vLotNo = trInput.eq(6).val();
		
// 		trInput.eq(5).val($("#txt_LOTNo").val() + "-" + vSerialNo.slice(-4));
// 		vproduct_delete_table.draw();

// 		$("#txt_LOTCount").val(vproduct_delete_table_RowCount);

// 	    $('input[id=dateDelevery]').eq(vproduct_delete_table_RowCount-1).datepicker({
// 	        	format: 'yyyy-mm-dd',
// 	        	autoclose: true,
// 	        	language: 'ko'
// 	    });	
	    
	    for(i=0;i<vproduct_delete_table_RowCount;i++){
	    	$('input[id=dateDelevery]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }
	    
	    for(i=0;i<vproduct_delete_table_RowCount;i++){
	    	$('input[id=dateChulgo]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }	

		$("#txt_LOTNo"+(vproduct_delete_table_RowCount-1)).on('change', function(){ 
	        vproduct_delete_table_info = vproduct_delete_table.page.info();
	        vproduct_delete_table_RowCount = vproduct_delete_table_info.recordsTotal; 
	    		
	        vLotNo = trInput.eq(6).val();
	        
// 	    	trInput.eq(5).val($("input[id=txt_LOTNo]").eq(vproduct_delete_table_RowCount-1).val() + "-" + vSerialNo.slice(-4));
	    	trInput.eq(5).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		$("#txt_LOTCount"+(vproduct_delete_table_RowCount-1)).on('change', function(){ 
	        vproduct_delete_table_info = vproduct_delete_table.page.info();
	        vproduct_delete_table_RowCount = vproduct_delete_table_info.recordsTotal; 
	    	
	        vLotNo = trInput.eq(6).val();
	    	vSerialNo =  "00000" + trInput.eq(7).val();
	    		
// 	    	trInput.eq(14).val($("input[id=txt_LOTNo]").eq(vproduct_delete_table_RowCount-1).val() + "-" + vSerialNo.slice(-4));
	    	trInput.eq(14).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
	}
    
    function fn_name_search_pop(){
		var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050204.jsp?OrderNo=" + vOrderNo
    	
    }
    
    function fn_mius_body(){  	        
        vproduct_delete_table
        .row( vproduct_delete_table_RowCount-1 )
        .remove()
        .draw();

        vproduct_delete_table_info = vproduct_delete_table.page.info();
        vproduct_delete_table_RowCount = vproduct_delete_table_info.recordsTotal;
        
//         $("#txt_LOTCount").val(vproduct_delete_table_RowCount);
    }   
    </script>

   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 47%;">
   			<table class="table " style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
					<td style=" font-weight: 900; font-size:14px; text-align:left">작성자명</td>
					<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_writer" style="width: 200px; float:left" readonly value="<%=targetVector[0].get(18).toString()%>"/>
						<input type="text" class="form-control" id="txt_writer_cd" style="width: 200px; float:left; display:none;" value="<%=targetVector[0].get(16).toString()%>" readonly />
						<input type="text" class="form-control" id="txt_writer_rev" style="width: 200px; float:left; display:none;" value="<%=targetVector[0].get(17).toString()%>" readonly />
						<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_writer')" id="btn_SearchUser" class="btn btn-info" style="float:left" disabled> 검색</button> 
		           	</td>
					<td style=" font-weight: 900; font-size:14px; text-align:left">작성일자</td>
		            <td ><input type="text" data-date-format="yyyy-mm-dd" id="writeDate" class="form-control" style="width: 200px; border: solid 1px #cccccc;" value="<%=targetVector[0].get(15).toString()%>" disabled/></td>
				</tr>
				<tr style="background-color: #fff;">
					<td style=" font-weight: 900; font-size:14px; text-align:left">점검자명</td>
					<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_checker" style="width: 200px; float:left" value="<%=targetVector[0].get(10).toString()%>" readonly />
						<input type="text" class="form-control" id="txt_checker_cd" style="width: 200px; float:left; display:none;" value="<%=targetVector[0].get(8).toString()%>" readonly />
						<input type="text" class="form-control" id="txt_checker_rev" style="width: 200px; float:left; display:none;" value="<%=targetVector[0].get(9).toString()%>" readonly />
						<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_checker')" id="btn_SearchUser" class="btn btn-info" style="float:left" disabled> 검색</button>
		           	</td>		
					<td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">점검일자</td>
					<td ><input type="text" data-date-format="yyyy-mm-dd" id="checkDate" class="form-control" style="width: 200px; border: solid 1px #cccccc;" value="<%=targetVector[0].get(7).toString()%>" disabled/></td>					
				</tr>
				<tr style="background-color: #fff;">
					<td style=" font-weight: 900; font-size:14px; text-align:left">승인자명</td>
					<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_approve" style="width: 200px; float:left" value="<%=targetVector[0].get(14).toString()%>" readonly />
						<input type="text" class="form-control" id="txt_approve_cd" style="width: 200px; float:left; display:none;" value="<%=targetVector[0].get(12).toString()%>" readonly />
						<input type="text" class="form-control" id="txt_approve_rev" style="width: 200px; float:left; display:none;" value="<%=targetVector[0].get(13).toString()%>" readonly />
						<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_approve')" id="btn_SearchUser" class="btn btn-info" style="float:left" disabled> 검색</button> 
		           	</td>					
					<td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">승인일자</td>
					<td ><input type="text" data-date-format="yyyy-mm-dd" id="approveDate" class="form-control" style="width: 200px; border: solid 1px #cccccc;"  value="<%=targetVector[0].get(11).toString()%>" disabled/></td>										
				</tr>
				<tr style="background-color: #fff;">
					<td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">해당분기</td>
					<td>
						<input type='radio' name='chk_quat' id='radio_quat1' value='quat1' disabled/>1/4분기<label style='width:40px;'/>
						<input type='radio' name='chk_quat' id='radio_quat2' value='quat2' disabled/>2/4분기<label style='width:40px;'/>
						<input type='radio' name='chk_quat' id='radio_quat3' value='quat3' disabled/>3/4분기<label style='width:40px;'/>
						<input type='radio' name='chk_quat' id='radio_quat4' value='quat4' disabled/>4/4분기<label style='width:40px;'/>							
					</td>					
				</tr>	
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="4">특이사항</td>
		        </tr>
		        <tr>
		            <td colspan="4"><textarea class="form-control" id="txt_uniqueness"  style="cols:10;rows:4; resize:none;" disabled><%=targetVector[0].get(19).toString()%></textarea></td>
		        </tr>
        	</table>
        	    <table class="table " id="product_delete_table" style="width: 100%; margin: 0 auto; align:left">
		<thead>
		        <tr style="vertical-align: middle">
		            <th style="width: 2%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">No.</th>
		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">성명</th>
		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">검진일</th>
		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">차기검진일</th>
		            <th style="width: 40%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
	                	<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" disabled>+</button>
	                	<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" disabled>-</button>
	                </th>
		        </tr>
		</thead>
		        <tbody id="product_tbody">
		        </tbody>
		    </table>
        </td>
		</tr>
        <tr style="height: 60px">
            <td align="center" colspan="2">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOrderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>
