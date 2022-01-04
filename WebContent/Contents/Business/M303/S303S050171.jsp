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
/*
	S101S030111.jsp : 주문별BOM등록 Service Delegator START
*/

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	Vector optCode =  null;
	Vector optName =  null;
	Vector tIncongVector = CommonData.getDeptCode(member_key);	

	String zhtml = "";

	String  GV_JSPPAGE="", GV_ORDER_NO,GV_ORDER_DETAIL_SEQ, GV_PROD_CD, GV_PRODUCT_NAME="", GV_LOTNO="", GV_PROD_CD_REV="",
			GV_PROC_PLAN_NO="",GV_MIX_RECIPE_CNT = "";
	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");

	if(request.getParameter("OrderDetailNo")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailNo");

	if(request.getParameter("Prod_cd")== null)
		GV_PROD_CD ="";
	else
		GV_PROD_CD = request.getParameter("Prod_cd");
	
	if(request.getParameter("Prod_cd_rev")== null)
		GV_PROD_CD_REV ="";
	else
		GV_PROD_CD_REV = request.getParameter("Prod_cd_rev"); 

	if(request.getParameter("Product_name")== null)
		GV_PRODUCT_NAME = "";
	else
		GV_PRODUCT_NAME = request.getParameter("Product_name");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("proc_plan_no")== null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");
	
	if(request.getParameter("Mix_recipe_cnt")== null)
		GV_MIX_RECIPE_CNT="";
	else
		GV_MIX_RECIPE_CNT = request.getParameter("Mix_recipe_cnt");
	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	//생산완료수량(배합단위)
	JSONObject jArray = new JSONObject();
	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put( "proc_exec_no", "");
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
		
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S050100E114", jArray);
 	int RowCount =TableModel.getRowCount();
 	int GV_MIX_RECIPE_CNT_COMPLETED = 0;
	for(int i=0; i<RowCount; i++) {
		GV_MIX_RECIPE_CNT_COMPLETED += Integer.parseInt(TableModel.getValueAt(i,6).toString().trim());
	}
	
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S030100E111 = {
			PID:  "M101S030100E111", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M101S030100E111", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

	var vTableS303S050170;
	var TableS303S050170_info;
    var TableS303S050170_Row_Count = 0;
    var TableS303S050170_Row_Index = -1;
    
    $(document).ready(function () {
        $("#approval_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
        $('#approval_date').datepicker('update', today);

		$('#txt_orderno').val('NON');
		$('#txt_orderdetailseq').val('');
		$('#txt_lotno').val('NON');
		$('#txt_num_prefix').val('<%=GV_GET_NUM_PREFIX%>');
		$('#txt_bom_name').val('<%=GV_PRODUCT_NAME%>');
		$('#txt_bom_cd').val('<%=GV_PROD_CD%>');
		$('#txt_bom_cd_rev').val('<%=GV_PROD_CD_REV%>');
		
		$('#txt_proc_plan_no').val('<%=GV_PROC_PLAN_NO%>');
		$('#txt_mix_recipe_cnt').val('<%=GV_MIX_RECIPE_CNT_COMPLETED%>');

		call_S303S050170();
		
		TableS303S050170_Row_Index = -1;
		
		
		$('#btn_plus').on( 'click', function () {
// 			if( $('#txt_lastseq').val().length<1){
// 				alert("목록번호 검색을 먼저 하세요~~~!!!")
// 				return;
// 			}

			if( $('#txt_part_cd').val().length<1){
				alert("원부자재 검색을 먼저 하세요~~~!!!")
				return;
			}
			
			if( $('#txt_part_cnt').val().length<1){
				alert("중량을 입력하세요~~~!!!")
				return;
			}
			
			if(TableS303S050170_Row_Index>-1){ //수정
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 7 ).data( $('#txt_part_cnt').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 8 ).data( $('#txt_maesu').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 9 ).data( $('#txt_gubun').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 10 ).data( $('#txt_qar').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 11 ).data( $('#txt_inspectequep').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 12 ).data( $('#txt_package').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 13 ).data( $('#txt_modify').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 14 ).data( $('#txt_bom_custcode').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 15 ).data( $('#txt_bom_CustName').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 16 ).data( $('#txt_cust_rev').val() );
			    vTableS303S050170.cell( TableS303S050170_Row_Index, 17 ).data( $('#txt_bigo').val() );
// 			    vTableS303S050170.row(TableS303S050170_Row_Index).draw();
			    clear_input();
			} else { //추가
				// part_cd 비교해서 이미 등록된 원부자재는 패스
	   			var v_part_cd = $('#txt_part_cd').val();
	   			var jungbok_chk = false;
	   			for(i=0; i<TableS303S050170_Row_Count; i++) {
	   				if(v_part_cd==vTableS303S050170.cell(i,3).data()) {
	   					jungbok_chk = true;
	       			}
	   			}
	   			if(!jungbok_chk){
	   				vTableS303S050170.row.add( [
						$('#txt_seq').val(),				//0순번
						$('#txt_bom_cd').val(),			//1BOM번호
						$('#txt_bom_cd_rev').val(),		//2개정번호
						$('#txt_part_cd').val(),		//5파트코드
						$('#txt_part_nm').val(),		//6자료이름
						$('#txt_part_nm').val(),		//6자료이름
						$('#txt_part_cd_rev').val(),		//8part_cd_rev
						$('#txt_part_cnt').val(),		//9중량
						$('#txt_maesu').val(),			//0매수
						$('#txt_gubun').val(),			//1구분
		
						$('#txt_qar').val(),				//2구분
						$('#txt_inspectequep').val(),	//3구분
						$('#txt_package').val(),			//4구분	            	
						
						$('#txt_modify').val(),			//5수정
						$('#txt_bom_custcode').val(),	//6cust_cd
						$('#txt_bom_CustName').val(),	//7거래처
						$('#txt_cust_rev').val(),		//8거래처
						$('#txt_bigo').val(),			//9비고
						'',
						'',
						'',
						'',
						'',
						'',
						$('#txt_jaego').val(),			//재고
						'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
			        ] ).draw(true);
	   				
	   				clear_input();
	   			    
	   		        TableS303S050170_info = vTableS303S050170.page.info();
	   		        TableS303S050170_Row_Count = TableS303S050170_info.recordsTotal;
	   		        
	   		        var max_seq = 0;
	   		        for(i=0; i<TableS303S050170_Row_Count; i++) {
	   		        	if(max_seq < parseInt(vTableS303S050170.cell( i, 0 ).data()))
	   		        		max_seq = parseInt(vTableS303S050170.cell( i, 0 ).data());
	   		        }
	   		        $('#txt_seq').val( max_seq + 1);
	   		        $('#txt_lastseq').val(max_seq);
	   			} else {
	   				alert("이미 등록된 원재료 입니다.");
	   			}
			}
	        
			TableS303S050170_Row_Index=-1;
		    $(this).html("추가");
	    });

		clear_input();
		
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
// 	 		$(this).val($(this).val().replace(/^[0-9]*.[0-9]*[1-9]+$/g,""));
	 	});
		
    });
    
    function call_S303S050170() {
    	$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050170.jsp", 
            data: "proc_plan_no=" + '<%=GV_PROC_PLAN_NO%>' 
            	+ "&prod_cd=" + '<%=GV_PROD_CD%>'
            	+ "&prod_cd_rev=" + '<%=GV_PROD_CD_REV%>',
            beforeSend: function () {
                $("#bom_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#bom_tbody").hide().html(html).fadeIn(100,function(){ // S303S050170페이지 테이블 다 불러오고 나서
          			TableS303S050170_info = vTableS303S050170.page.info();
       	      		TableS303S050170_Row_Count = TableS303S050170_info.recordsTotal;
       	      		
	       	      	var max_seq = 0;
	    	        for(i=0; i<TableS303S050170_Row_Count; i++) {
	    	        	if(max_seq < parseInt(vTableS303S050170.cell( i, 0 ).data()))
	    	        		max_seq = parseInt(vTableS303S050170.cell( i, 0 ).data());
	    	        }
       	        	$('#txt_seq').val(max_seq+1);
//         	        right_btn_disable();
      			});
            },
            error: function (xhr, option, error) {
            }
        });
    }
    
    function fn_mius_body(obj){  
		vTableS303S050170.row($(obj).parents('tr')).remove().draw();
		
	    TableS303S050170_info = vTableS303S050170.page.info();
	    TableS303S050170_Row_Count = TableS303S050170_info.recordsTotal;
	    
	    var max_seq = 0;
        for(i=0; i<TableS303S050170_Row_Count; i++) {
        	if(max_seq < parseInt(vTableS303S050170.cell( i, 0 ).data()))
        		max_seq = parseInt(vTableS303S050170.cell( i, 0 ).data());
        }
        
        $('#txt_seq').val( max_seq+1);
	    $('#txt_lastseq').val(max_seq);
	    
	    TableS303S050170_Row_Index=-1;
	    
	    clear_input();
	    
	    $("#btn_plus").text("추가");
    } 
    
	function clear_input(){
		$('#txt_bom_cd_click').val("");
		$('#txt_part_cd').val("");
		$('#txt_part_nm').val("");
		$('#txt_part_cd_rev').val("");
		$('#txt_part_cnt').val("");
		$('#txt_maesu').val("");
		$('#txt_gubun').val("");
		$('#txt_qar').val("");			//2구분
		$('#txt_inspectequep').val("");	//3구분
		$('#txt_package').val("");		//4구분	   
		$('#txt_modify').val("");
		$('#txt_bom_custcode').val("");
		$('#txt_bom_CustName').val("");
		$('#txt_cust_rev').val("");
		$('#txt_bigo').val("");
		$('#txt_jaego').val("");
	}        
		
	function SaveOderInfo() {      
		var WebSockData="";		
		
	    TableS303S050170_info = vTableS303S050170.page.info();
	    TableS303S050170_Row_Count = TableS303S050170_info.recordsTotal;
	    
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.member_key = "<%=member_key%>";
        
		if($('#txt_bom_cd').val()== '' ) { 
			alert("BOM을 검색하여 선택하세요");
			return false;
		}
        if(TableS303S050170_Row_Count==0) {
        	alert("원부자재를 하나이상 등록하세요");
			return false;
        }

		try {
	        var jArray = new Array(); // JSON Array 선언
		    for(var i=0; i<TableS303S050170_Row_Count; i++){    		
	    		var trInput = $($("#TableS303S050170 tr")[i]).children();
	    		
		    	var dataJson = new Object(); 
		    	dataJson.proc_plan_no	= $('#txt_proc_plan_no').val();
		        dataJson.jsp_page 		= '<%=GV_JSPPAGE%>';
		        dataJson.login_id 		=  '<%=loginID%>';
		        dataJson.num_prorfix	= $('#txt_num_prefix').val(); //2
		        dataJson.order_no		= $('#txt_orderno').val(); //3 order_no
		        dataJson.bom_cd			= $('#txt_bom_cd').val(); //4 bom_cd
		        dataJson.bom_cd_rev		= $('#txt_bom_cd_rev').val(); //5 bom_cd_rev
		        dataJson.bom_name		= $('#txt_bom_name').val(); //6 bom_name
		        dataJson.lotno			= $('#txt_lotno').val(); //7 lotno
		        dataJson.last_no		= $('#txt_lastseq').val(); //8 last_no
		        dataJson.type_no		= $('#txt_type_code').val(); //9 type_no 형식번호
		        dataJson.geukyongpoommok= $('#txt_A_productname').val(); //10 geukyongpoommok 적용품목
		        dataJson.dept_code		= $('#txt_deptcode').val(); //11 dept_code 부서코드
		        dataJson.approval_date	= $('#approval_date').val(); //12 approval_date 승인일자 
		        dataJson.approval		= $('#approval').val(); //13 approval 승인
		        dataJson.sys_bom_id 	= vTableS303S050170.cell( i, 0 ).data(); //14 sys_bom_id
		        dataJson.part_cd		= vTableS303S050170.cell( i, 3 ).data(); //17 part_cd
		        dataJson.part_nm			= vTableS303S050170.cell( i, 5 ).data(); //18 part_nm
		        dataJson.part_cd_rev	= vTableS303S050170.cell( i, 6 ).data(); //19 part_cd_rev
		        dataJson.part_cnt		= vTableS303S050170.cell( i, 7 ).data(); //20 part_cnt
// 		        dataJson.mesu			= vTableS303S050170.cell( i, 8 ).data(); //21 mesu
		        dataJson.mesu			= '0'; //21 mesu
		        dataJson.gubun			= vTableS303S050170.cell( i, 9 ).data(); //22 gubun
		        dataJson.qar			= vTableS303S050170.cell( i, 10 ).data(); //23 qar
		        dataJson.inspect_selbi	= vTableS303S050170.cell( i, 11 ).data(); //24 inspect_selbi
		        dataJson.packing_jaryo	= vTableS303S050170.cell( i, 12 ).data(); //25 packing_jaryo
		        dataJson.modify_note	= vTableS303S050170.cell( i, 13 ).data(); //26 modify_note
		        dataJson.cust_code		= vTableS303S050170.cell( i, 14 ).data(); //27 cust_code
// 		        dataJson.cust_rev		= vTableS303S050170.cell( i, 16 ).data(); //28 cust_rev
		        dataJson.cust_rev		= '0'; //28 cust_rev
		        dataJson.bigo 			= vTableS303S050170.cell( i, 17 ).data(); //29 bigo
				dataJson.member_key 	= "<%=member_key%>";
				jArray.push(dataJson); // 데이터를 배열에 담는다.		

	        }
			var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
			dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

			var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			var chekrtn = confirm("등록하시겠습니까?"); 
			if(chekrtn){
				SendTojsp(JSONparam, M101S030100E111.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄		
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


    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function select_Product_Bom_List(){
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S303S050175.jsp"
    						+ "?bom_cd=" + "<%=GV_PROD_CD%>"
    						+ "&bom_cd_rev=" + "<%=GV_PROD_CD_REV%>" ;
    	
    	pop_fn_popUpScr_nd(modalContentUrl, "배합(BOM)목록조회(S303S050175)", '600px', '80%');
		return false;
	}
    
    function right_btn_disable(){
        for(var i=0; i<TableS303S050170_Row_Count; i++){
			var trInput = $($("#TableS303S050170 tr")[i]).find(":button")
			trInput.eq(0).prop("disabled", true);
        }
    }
    
    function SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_jaego){
		$('#txt_bom_cd_click').val(txt_part_cd);
		$('#txt_part_nm').val(txt_part_name);
		$('#txt_part_cd').val(txt_part_cd);
		$('#txt_part_cd_rev').val(txt_part_revision_no);	
		$('#txt_jaego').val(txt_jaego);	
    	
    }

    function SetCustName_code(name, code, rev){
		$('#txt_bom_CustName').val(name);
		$('#txt_bom_custcode').val(code);
		$('#txt_cust_rev').val(rev);
    }
    
    function fn_inspect_result_delete(obj) {
		var tr = $(obj).parent().parent();
		var td = tr.children();
		var chekrtn = confirm("이미 등록된 데이터입니다"+"\n"+"삭제 하시겠습니까?"); 

		if(chekrtn){
			TableS303S050170_info = vTableS303S050170.page.info();
		    TableS303S050170_Row_Count = TableS303S050170_info.recordsTotal;
		    if(TableS303S050170_Row_Count > 0) {
		    	var dataJson = new Object();
		    	dataJson.proc_plan_no	= $('#txt_proc_plan_no').val();
		    	dataJson.order_no		= $('#txt_orderno').val();
		    	dataJson.lotno			= $('#txt_lotno').val();
		    	dataJson.bom_cd			= $('#txt_bom_cd').val();
		        dataJson.bom_cd_rev		= $('#txt_bom_cd_rev').val();
		        dataJson.sys_bom_id 	= td.eq(0).text(); // sys_bom_id
		        dataJson.part_cd		= td.eq(3).text(); // part_cd
		        dataJson.part_cd_rev	= td.eq(6).text(); // part_cd_rev
		        dataJson.member_key 	= "<%=member_key%>";
		    	
		        var jArray = new Array(); // JSON Array 선언
		        jArray.push(dataJson); // 데이터를 배열에 담는다
		        var dataJsonMulti = new Object();
				dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
				var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		        
// 				console.log(JSONparam);
		        SendTojspDelete(JSONparam, "M101S030100E113");
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
	      		call_S303S050170();
	      		
	      		TableS303S050170_info = vTableS303S050170.page.info();
			    TableS303S050170_Row_Count = TableS303S050170_info.recordsTotal;
			    
	      		TableS303S050170_Row_Index=-1;
	    	    
	    	    clear_input();
	         },
	         error: function (xhr, option, error) {
	
	         }
	     });		
	}   
    </script>


	<div class="container-fluid">
        <table class="table table-striped table-bordered" style="width: 100%; margin: 0 ; align:left">	       
	        <tbody id="bom_main_tbody"> 
  				<tr>  				
		            <td style="width: 15%;  font-weight: 900; font-size:14px; text-align:right;vertical-align: middle">제품명</td> <!-- 제품코드 -->
		            <td style="width: 35%;  font-weight: 900; font-size:14px; text-align:lef;">
						<input type="text" 		class="form-control" id="txt_bom_name" style="width:60%; float:left;" readonly/>
						<input type="hidden" 	class="form-control" id="txt_bom_cd"></input>
						<input type="hidden" 	class="form-control" id="txt_bom_cd_rev"></input>
						
						<input type="hidden" 	class="form-control" id="txt_proc_plan_no" />
						<input type="hidden" 	class="form-control" id="txt_num_prefix" />
						
						<input type="hidden" class="form-control" id="txt_lastseq" style="width:20%;" value="0"/>
						
						<input type="hidden" 	class="form-control" id="approval_date"/>
						<input type="hidden" 	class="form-control" id="txt_type_code"/>
						<input type="hidden" 	class="form-control" id="txt_A_productname"/>
						<input type="hidden" 	class="form-control" id="txt_deptcode"/>
						<input type="hidden" 	class="form-control" id="approval"/>
						<input type="hidden" 	class="form-control" id="txt_orderno" value="NON"/>
						<input type="hidden" 	class="form-control" id="txt_orderdetailseq" />
						<input type="hidden" 	class="form-control" id="txt_lotno" value="NON"/>
						
						<button type="button" onclick="select_Product_Bom_List();" id="btn_SearchPart" class="form-control btn btn-info" style="width:40%;float:left;">배합(레시피) 검색</button>
						
		           	</td>
	
		            <td style="width: 15%;  font-weight: 900; font-size:14px; text-align:right;vertical-align: middle">생산완료수량(배합단위)</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_mix_recipe_cnt" style="float:left;" />
		           	</td>
		        </tr>
			</tbody>	        
       	</table>
		<div class="modal-content panel panel-default" style="overflow:auto;">
	        <table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="bom_table">
	 
		        <tr style="vertical-align: middle">
		            <td style="width:  6%; font-size:14px; text-align:center; vertical-align: middle">순번</td>
<!-- 		            <td style="width:  9%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">배합(BOM)번호</td> -->
<!-- 		            <td style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">원부자재번호</td> -->
		            <td style="width: 7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">원부자재코드</td>
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">원부자재명</td>
		            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">중량(g)</td>
<!-- 		            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">매수</td> -->

<!-- 		            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">구분</td> -->
<!-- 		            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">QAR</td> -->
<!-- 		            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">검사장비</td> -->
<!-- 		            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">포장자료</td> -->
<!-- 		            <td style="width:  4%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">수정</td> -->

<!-- 		            <td style="width: 13%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">구매처</td> -->
		            <td style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</td>
<!-- 		            <td style="width: 3%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">재고</td> -->
		            <td style="width:  2%;vertical-align: middle"></td>
		        </tr>
			
		        <tbody id="bom_head_tbody">
		        <tr style="vertical-align: middle">			            
		        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
						<input type="text" class="form-control" id="txt_seq" readonly></input>
					</td>
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
						<input type="text" 	 class="form-control" id="txt_part_cd" readonly ></input>
						<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly></input>
						<input type="hidden" class="form-control" id="txt_bom_cd_click" readonly></input>
		           
		           	</td>
		            <td style="text-align:right;vertical-align: middle ;margin: 0 ;">
						<input type="text" class="form-control" id="txt_part_nm"  readonly style="width:62%;float:left;"></input> 
						<button type="button" onclick="parent.pop_fn_PartList_View(3)" id="btn_SearchPart" class="btn btn-info"  style="width:38%;float:left;">원부자재검색</button> 
								
		           	</td>
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
						<input type="text" numberPoint class="form-control"  id="txt_part_cnt" ></input>
						<input type="hidden"  id="txt_maesu" class="form-control" />
						
						<input type="hidden"  id="txt_gubun" class="form-control" />
						<input type="hidden"  id="txt_qar" class="form-control" />
						<input type="hidden"  id="txt_inspectequep" class="form-control" />
						<input type="hidden"  id="txt_package" class="form-control" />
						<input type="hidden"  id="txt_modify" class="form-control" />
						<input type="hidden"  id="txt_bom_custcode" class="form-control" />
		            	<input type="hidden"  id="txt_cust_rev" class="form-control" />
		            	<input type="hidden"    id="txt_bom_CustName" class="form-control" readonly style="width:75%;float:left;"/>
		           	</td>
<!-- 		            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="text"  maxlength="5" id="txt_maesu" class="form-control" /> -->
<!-- 		            </td> -->
<!-- 		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="text"  maxlength="5" id="txt_gubun" class="form-control" /> -->
<!-- 		            </td> -->
<!-- 		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="text"  maxlength="5" id="txt_qar" class="form-control" /> -->
<!-- 		            </td> -->
<!-- 		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="text"  maxlength="5" id="txt_inspectequep" class="form-control" /> -->
<!-- 		            </td> -->
<!-- 		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="text"  maxlength="5" id="txt_package" class="form-control" /> -->
<!-- 		            </td> -->
<!-- 		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="text"  maxlength="5" id="txt_modify" class="form-control" /> -->
<!-- 		            	<input type="hidden"  id="txt_bom_custcode" class="form-control" /> -->
<!-- 		            	<input type="hidden"  id="txt_cust_rev" class="form-control" /> -->
<!-- 		            	<input type="hidden"    id="txt_bom_CustName" class="form-control" readonly style="width:75%;float:left;"/> -->
<!-- 		            </td> -->
<!-- 		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="hidden"  id="txt_bom_custcode" class="form-control" /> -->
<!-- 		            	<input type="hidden"  id="txt_cust_rev" class="form-control" /> -->
<!-- 		            	<input type="text"    id="txt_bom_CustName" class="form-control" readonly style="width:75%;float:left;"/> -->
<!-- 						<button type="button" onclick="parent.pop_fn_CustName_View(1,'I')" id="btn_SearchProd"  -->
<!-- 						class="form-control btn btn-info" style="width:25%;float:left;">검색</button> -->
<!-- 		            </td> -->
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
		            	<input type="text"  id="txt_bigo" class="form-control"/>
		            	<input type="hidden"  id="txt_jaego" class="form-control" readonly/>
		            </td>
<!-- 		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="text"  id="txt_jaego" class="form-control" readonly/> -->
<!-- 		            </td> -->
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
		            	<button id="btn_plus" class="form-control btn btn-info" >추가</button></td>
		        </tr>
		        </tbody>
		    </table>

		</div>        
		<div id="bom_tbody"></div>
         <p style="text-align:center; vertical-align: middle ;margin: 0 ;">
         	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
            	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
         </p>
	</div>
