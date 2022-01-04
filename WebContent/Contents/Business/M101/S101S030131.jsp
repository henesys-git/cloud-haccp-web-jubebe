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
	S101S030131.jsp : 주문별 제품검사체크리스트 등록 화면
*/
	DoyosaeTableModel TableModel,hurTableModel;
	String zhtml = "";
// 	GetProcessGubun
	String[] strColumnHead 	= {"주문명", "LOT No","prod_cd","lot_count","제품명", "product_serial_no","order_detail_seq",
			"업체","납품일자","고객사PO번호","프로젝트수량","주문수량","완납수량", "잔여수량","현황","비고",
			"order_no","order_date","cust_cd","cust_rev","order_status"};

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_ORDER_NO="",GV_ORDER_DETAIL_SEQ="", GV_PROD_CD="", GV_PRODUCT_NAME="",GV_PROJECT_NAME="";
	String GV_LOT_NO="", GV_PROD_SERIAL_NO="", GV_LOT_COUNT="" ;
	String OrderDetailNo="";
	
	if(request.getParameter("OrderDetailNo")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailNo");
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("Project_name")== null)
		GV_PROJECT_NAME="";
	else
		GV_PROJECT_NAME = request.getParameter("Project_name");
	

	if(request.getParameter("Prod_serial_no")== null)
		GV_PROD_SERIAL_NO="";
	else
		GV_PROD_SERIAL_NO = request.getParameter("Prod_serial_no");
	
	if(request.getParameter("Prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("Prod_cd");
	
	if(request.getParameter("Product_name")== null)
		GV_PRODUCT_NAME="";
	else
		GV_PRODUCT_NAME = request.getParameter("Product_name");

	if(request.getParameter("lotno")== null)
		GV_LOT_NO="";
	else
		GV_LOT_NO = request.getParameter("lotno");

	if(request.getParameter("lot_count")== null)
		GV_LOT_COUNT="";
	else
		GV_LOT_COUNT = request.getParameter("lot_count");

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	Vector optCode =  null; 
    Vector optName =  null;
// 	Vector CheckGubunVector = CommonData.getProductCheckGubun_Code();
// 	Vector check_gubunVector = CommonData.getChecklistGubun_CodeALL(member_key);
	Vector check_gubunVector = CommonData.getChecklistGubun_PIN_SHIP_CodeALL(member_key);
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S030100E131 = {
			PID:  "M101S030100E131", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M101S030100E131", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;

	var vTableS101S030190;
	var TableS101S030190_info;
    var TableS101S030190_Row_Count;
    var TableS101S030190_Row_Index;
    var vinspect_gubun=""; 
    $(document).ready(function () {
    	detail_seq=0;


		$('#txt_orderno').val('<%=GV_ORDER_NO%>');
		$('#txt_orderdetailseq').val('<%=GV_ORDER_DETAIL_SEQ%>');
		$('#txt_productname').val('<%=GV_PRODUCT_NAME%>');
		$('#txt_product_code').val('<%=GV_PROD_CD%>');
		$('#txt_project_name').val('<%=GV_PROJECT_NAME%>');
		$('#txt_lotno').val('<%=GV_LOT_NO%>');
		$('#txt_lot_count').val('<%=GV_LOT_COUNT%>');
		$('#txt_product_serial_no').val('<%=GV_PROD_SERIAL_NO%>');
		
		$('#txt_num_prefix').val('<%=GV_GET_NUM_PREFIX%>');

	    $("#select_CheckGubunCode").on("change", function(){
	    	vinspect_gubun = $(this).val();
// 	    	Get_S101S030190();
	    });
	    vinspect_gubun = $("#select_CheckGubunCode").val();
	    
	    Get_S101S030190();
	    
		TableS101S030190_Row_Index = -1;
		
		$('#btn_plus').on( 'click', function () {
			if( $('#txt_pic_seq').val().length<1){
				alert("목록번호 검색을 먼저 하세요~~~!!!")
				return;
			}

		    vTableS101S030190.cell( TableS101S030190_Row_Index, 9 ).data( $('#txt_part_cnt').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 10 ).data( $('#txt_maesu').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 11 ).data( $('#txt_gubun').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 12 ).data( $('#txt_qar').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 13 ).data( $('#txt_inspectequep').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 14 ).data( $('#txt_package').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 15 ).data( $('#txt_modify').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 16 ).data( $('#txt_bom_custcode').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 17 ).data( $('#txt_bom_CustName').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 18 ).data( $('#txt_cust_rev').val() );
		    vTableS101S030190.cell( TableS101S030190_Row_Index, 19 ).data( $('#txt_bigo').val() );
// 			    vTableS101S030190.row(TableS101S030190_Row_Index).draw(); 

		    clear_input();
		    
	        TableS101S030190_info = vTableS101S030190.page.info();
	        TableS101S030190_Row_Count = TableS101S030190_info.recordsTotal;
	        $('#txt_seq').val( TableS101S030190_Row_Count + 1);
// 	        $('#').val(TableS101S030190_Row_Count);

	    } );		

    });
    
	function Get_S101S030190(){

		$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030190.jsp", 
            data: "order_no=<%=GV_ORDER_NO%>" + "&order_detail_seq=" + "<%=GV_ORDER_DETAIL_SEQ%>"+ "&lotno=" + vLotNo ,  // + "&inspect_gubun=" + vinspect_gubun,
            beforeSend: function () {
                $("#bom_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#bom_tbody").hide().html(html).fadeIn(100,function(){
        	        TableS101S030190_info = vTableS101S030190.page.info();
   	      			TableS101S030190_Row_Count = TableS101S030190_info.recordsTotal;
	   		   		rCount = TableS101S030190_Row_Count + 1;
      				right_btn_disable();
      			});

            },
            error: function (xhr, option, error) {

            }
        });
	}
	
	function right_btn_disable(){
        for(var i=1; i<=TableS101S030190_Row_Count; i++){
			var trInput = $($("#TableS101S030190 tr")[i]).find(":button")
			trInput.eq(0).remove();
        }
    }
	
	function SetRecvData(){
		DataPars(M101S030100E131,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {        
		var WebSockData="";
		vTableS101S030190_info = vTableS101S030190.page.info();
		TableS101S030190_RowCount = vTableS101S030190_info.recordsTotal; 
		
		if(TableS101S030190_RowCount == 0 ) { 
			alert("체크리스트 검색하여 선택하세요");
			return false;
		}
		
		var jArray = new Array(); // JSON Array 선언
		
	    for(var i=0; i<TableS101S030190_RowCount; i++){   
	    	var dataJson = new Object(); 
	    	
	    	dataJson.jsp_page 	= '<%=JSPpage%>';
	    	dataJson.login_id 	= '<%=loginID%>';
	    	dataJson.num_gubun 	= '<%=GV_GET_NUM_PREFIX%>' ;			// 2
	    	dataJson.order_no 	= $('#txt_orderno').val();				// 3. 주문번호
	    	dataJson.lotno 		= $('#txt_lotno').val(); 
	    	
//          {"순번" ,"공정번호","공정명","부서", "proc_rev","체크리스코드","checklist_rev","작업표준","공구","관리항목","표준값"};
	    	dataJson.prod_cd 		= vTableS101S030190.cell(i , 6).data(); //5 prod_cd
	    	dataJson.prod_rev 		= vTableS101S030190.cell(i , 8).data(); //6 prod_rev  prod_cd_rev
	    	dataJson.checklist_cd 	= vTableS101S030190.cell(i , 9).data(); //7 checklist_cd 체크코드
	    	dataJson.checklist_seq 	= vTableS101S030190.cell(i ,10).data(); //8 checklist_seq checklist_seq
	    	dataJson.checklist_rev 	= vTableS101S030190.cell(i ,11).data(); //9 checklist_rev checklist_rev
	    	dataJson.standard_guide = vTableS101S030190.cell(i ,12).data(); //10 standard_guide 작업표준
	    	dataJson.standard_value = vTableS101S030190.cell(i ,13).data(); //11 standard_value 	표준값
	    	dataJson.check_note 	= vTableS101S030190.cell(i ,14).data(); //12 check_note 	체크내용
	    	dataJson.inspect_gubun = vTableS101S030190.cell(i ,2).data(); //13 vinspect_gubun 	검사구분
	    	dataJson.order_check_no = vTableS101S030190.cell(i ,4).data(); //14 order_check_seq 	order_check_seq
	    	dataJson.order_check_seq = vTableS101S030190.cell(i ,15).data(); //15 order_check_no 	order_check_no
	        dataJson.member_key 	= "<%=member_key%>";
// 			console.log(dataJson)
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }		
		var dataJsonMulti = new Object();
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
			SendTojsp(JSONparam, SQL_Param.PID);
		}
		///////////////////////////////////////////////////////////
		
<%-- 		var parmHead= '<%=Config.HEADTOKEN %>' ; --%>

// 		var parmBody= "" ;


// 	    for(var i=0; i<TableS101S030190_RowCount; i++){  
	    		
<%--     		parmHead +=  '<%=JSPpage%>' 		+ "|" 	// 0 --%>
<%-- 			+ '<%=loginID%>' 					+ "|" 	// 1 --%>
<%-- 			+ '<%=GV_GET_NUM_PREFIX%>' 			+ "|" 	// 2 --%>
//   			+ $('#txt_orderno').val()			+ "|"	// 3주문번호
//   			+ $('#txt_lotno').val()				+ "|"	//	4GV_LOT_NO
  			
// 	    	+ vTableS101S030190.cell(i , 6).data() + "|"	//5 prod_cd   제품코드
// 	    	+ vTableS101S030190.cell(i , 8).data() + "|"	//6 prod_rev  prod_cd_rev
// 	    	+ vTableS101S030190.cell(i , 9).data() + "|"	//7 checklist_cd 체크코드
// 	    	+ vTableS101S030190.cell(i ,10).data() + "|"	//8 checklist_seq checklist_seq
// 	    	+ vTableS101S030190.cell(i ,11).data() + "|"	//9 checklist_rev checklist_rev
// 	    	+ vTableS101S030190.cell(i ,12).data() + "|"	//10 standard_guide 작업표준
// 	    	+ vTableS101S030190.cell(i ,13).data() + "|"	//11 standard_value 	표준값
// 	    	+ vTableS101S030190.cell(i ,14).data() + "|"	//12 check_note 	체크내용
// 			+ vTableS101S030190.cell(i ,2).data()  + "|" 	//13 vinspect_gubun 	검사구분
// 			+ vTableS101S030190.cell(i ,4).data()  + "|" 	//14 order_check_no 	order_check_no
// 			+ vTableS101S030190.cell(i ,15).data()  + "|" 	//15 order_check_no 	order_check_no
<%-- 			+ '<%=Config.DATATOKEN %>' 	; --%>
// 	    }		

// 		SQL_Param.param = parmHead ;
// 		SendTojsp(urlencode(parmHead),SQL_Param.PID);

	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {
	        	 if(html>-1){
// 	        		 parent.DetailInfo_List.click();
	        		 parent.Subinfo_prod_checkList.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}  

    
    function fn_mius_body(obj){  
//     	detail_seq=0;
//     	var tr = $(obj).parent();

//     	var len = $($(obj).parent()).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
// 		if(len>-1)
//     		$("#bom_tbody tr")[len].remove();
// 		var lcnt = $("#bom_tbody tr").length;
// 		for(detail_seq =0; detail_seq<lcnt; detail_seq++){
// 			var trInput = $($("#bom_tbody tr")[detail_seq]).find(":input")
// 			trInput.eq(0).val(detail_seq);
// 		}
		
		vTableS101S030190.row($(obj).parents('tr')).remove().draw();
		
		vTableS101S030190_info = vTableS101S030190.page.info();
		TableS101S030190_RowCount = vTableS101S030190_info.recordsTotal; 
		
    }   

    
    function fn_Product_inspect_CheckList() { /* 파라메터 알맞게 조정 필요 */
    	//caller = 1 : modalFramePopup에서 호출"Contents/Business/M101/S101S030150.jsp"
    	//caller = 0 : 일반화면에서 호출
    	
    	if(vinspect_gubun=="ALL")
    		vinspect_gubun="";
    	
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030195.jsp?prod_cd=<%=GV_PROD_CD%>" + "&inspect_gubun=" +vinspect_gubun;
    	pop_fn_popUpScr_nd(modalContentUrl, "제품검사 체크리스트 조회(S101S030195)", '600px', '80%');
		return false;
     }


    </script>

	<div class="container-fluid">
        <table class="table table-striped " style="width: 100%; margin: 0 ; align:left">	        
  			<tr>
<!-- 	            <td style="width: 5.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">주문명</td> -->
<!-- 	            <td colspan="3" style="width: 44.5%;  font-weight: 900; font-size:14px; text-align:lef; tmargin-left:10px;"> -->
<!-- 	           	</td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">일련번호</td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle"></td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left; tmargin-left:10px;"> -->
<!-- 					<input type="text" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/> -->
<!-- 	           	</td>	           		            -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle"></td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left; tmargin-left:10px;"> -->
<!-- 	           	</td> -->
<!-- 	    	</tr> -->
  			<tr>
	            <td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품번</td>
	            <td style="width: 19%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_product_code" style="width: 60%;" readonly/>
					<input type="hidden" class="form-control" id="txt_prod_rev"  readonly/>
					
					<input type="hidden" class="form-control" id="txt_project_name" style="width: 45%;float:left;" readonly />
					<input type="hidden" class="form-control" id="txt_orderno"  />
					<input type="hidden" class="form-control" id="txt_orderdetailseq" />
					<input type="hidden" class="form-control" id="txt_num_prefix" />
					<input type="hidden" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/>					
	           	</td>	   	           
				<td style="width: 6.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품명</td>
	            <td style="width: 18.5%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_productname"  readonly/>
	           	</td>         
	           	<td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">포장단위</td>
	            <td style="width: 19%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lotno"  style="width: 60%;" readonly/>
	           	</td>
	            <td style="width: 6.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">주문수량</td>
	            <td style="width: 18.5%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lot_count" style="width: 60%;";  readonly/>					
	           	</td>
	        </tr>
	        	        
       	</table>
       	
        <table class="table table-bordered " style="width: 100%; margin: 0 ; align:left" id="bom_table">
	        <tr style="vertical-align: middle">
	        	<td style="width:  9%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">검사구분</td>
	            <td style="width:  100%; font-weight: 900; font-size:14px; text-align: left; vertical-align: middle">
					<select class="form-control" id="select_CheckGubunCode" style="float:left; width: 120px">
<%-- 						<%	optCode =  (Vector)CheckGubunVector.get(0);%> --%>
<%-- 						<%	optName =  (Vector)CheckGubunVector.get(1);%> --%>
<%-- 						<%for(int i=0; i<optName.size();i++){ %> --%>
<%-- 							<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option> --%>
<%-- 						<%} %> --%>
						
						<%optCode =  (Vector)check_gubunVector.get(0);%>
						<%optName =  (Vector)check_gubunVector.get(1);%>
						<%for(int i=0; i<optName.size();i++){ %>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
							<%} %>
					</select>	
					<button type="button" onclick="fn_Product_inspect_CheckList()" 
						id="btn_SearchCheckList" class="btn btn-info" style="margin-left:10px;float:left;">검사구분별 체크리스트</button>
					
	            </td>	            
	        </tr>
	    </table>

<!-- 나중에 사용가능성 있음 -->					
<!--         <table class="table " style="width: 100%; margin: 0 ; align:left" id="Process_check_table"> -->
<!-- 	        <tr style="vertical-align: middle"> -->
<!-- 	            <td style="width:  4%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">순번</td> -->
<!-- 	            <td style="width:  9%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품코드</td> -->
<!-- 	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">제품명</td> -->
<!-- 	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">체크코드</td> -->
<!-- 	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">표준지침</td>  -->
<!-- 	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">체크내용</td> -->
<!-- 	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">표준값</td> -->
<!-- 	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">항목유형</td> -->
<!-- 	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</td> -->
<!-- 	            <td style="width:  3%;vertical-align: middle"></td> -->
<!-- 	        </tr> -->
<!-- 	        <tr style="vertical-align: middle">			             -->
<!-- 	        	<td style="text-align:center; vertical-align: middle">			 -->
<!-- 					<input type="text" class="form-control"  id="txt_pic_seq" readonly></input>		 -->
<!-- 				</td> -->
<!-- 	        	<td style="text-align:center; vertical-align: middle"> -->
<!-- 					<input type="text" class="form-control"  id="txt_prod_cd"></input> -->
<!-- 					<input type="hidden" class="form-control"  id="txt_prod_cd_rev" readonly></input>				 -->
<!-- 				</td> -->
<!-- 	        	<td style="text-align:center; vertical-align: middle"> -->
<!-- 					<input type="text" class="form-control"  id="txt_product_nm" style="width:70%;float:left;"></input>	 -->
<!-- 				</td> -->
<!-- 	        	<td style="text-align:center; vertical-align: middle"> -->
<!-- 					<input type="text" class="form-control"  id="txt_checklist_cd"></input>	 -->
<!-- 					<input type="hidden" class="form-control"  id="txt_checklist_seq" readonly></input>	 -->
<!-- 					<input type="hidden" class="form-control"  id="checklist_cd_rev" readonly></input>		 -->
<!-- 				</td> -->
<!-- 	            <td style="text-align:center;vertical-align: middle"> -->
<!-- 					<input type="text" class="form-control"  id="txt_standard_guide"  readonly></input>  -->
<!-- 	           	</td>	 -->
<!-- 	            <td style="text-align:center; vertical-align: middle"> -->
<!-- 					<input type="text" class="form-control"  id="txt_check_note" readonly ></input>					  -->
<!-- 	           	</td> -->
<!-- 	            <td style="text-align:center; vertical-align: middle"> -->
<!-- 	            	<input type="text"   id="txt_standard_value" class="form-control" />		체크항목 -->
<!-- 	            </td> -->
<!-- 	            <td style="text-align:center; vertical-align: middle"> -->
<!-- 	            	<input type="text"   id="txt_item_type" class="form-control" />		 -->
<!-- 	            </td> -->
<!-- 	            <td style="text-align:center; vertical-align: middle"> -->
<!-- 	            	<button id="btn_plus" class="form-control btn btn-info" >수정</button> -->
<!-- 	            </td> -->
<!-- 	        </tr> -->
<!-- 	    </table> -->

        <div id="bom_tbody">

        </div>
        <p style="text-align:center;">
	    	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
	       	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>

