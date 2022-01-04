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
	S101S030121.jsp : 공정확인표등록
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
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S030100E121 = {
			PID:  "M101S030100E121", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M101S030100E121", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;

	var vTableS101S030170;
	var TableS101S030170_info;
    var TableS101S030170_Row_Count;
    var TableS101S030170_Row_Index;
    
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
		S101S030170_query();
		
		TableS101S030170_Row_Index = -1;
		
		$('#btn_plus').on( 'click', function () {
			if( $('#txt_checklist_seq').val().length<1){
// 				alert("공정명 검색을 먼저 하세요~~~!!!")
				alert("체크리스트 검색을 먼저 하세요~~~!!!");
				return;
			}
// 			{"순번" ,"공정번호","공정명","부서", "proc_rev","체크리스코드","checklist_rev","작업표준","공구","관리항목","표준값"};
			if(TableS101S030170_Row_Index>-1){
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 0 ).data( $('#txt_checklist_seq').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 1 ).data( $('#txt_proc_cd').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 2 ).data( $('#txt_process_name').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 3 ).data( $('#txt_dept_gubun').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 4 ).data( $('#txt_proc_rev').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 5 ).data( $('#txt_checklist_cd').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 6 ).data( $('#txt_checklist_cd_rev').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 7 ).data( $('#txt_standard_guide').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 8 ).data( $('#txt_tools').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 9 ).data( $('#txt_check_note').val() );
			    vTableS101S030170.cell( TableS101S030170_Row_Index, 10 ).data( $('#txt_standard_value').val() );
// 			    vTableS101S030170.row(TableS101S030170_Row_Index).draw(); 
			}
			else{
//	 			{"순번" ,"공정번호","공정명","부서", "proc_rev","체크리스코드","checklist_rev","작업표준","공구","관리항목","표준값"};
				vTableS101S030170.row.add( [
					$('#txt_checklist_seq').val(),	//0순번
					$('#txt_proc_cd').val(),		//공정번호번호
					$('#txt_process_name').val(),	//4공정명
					$('#txt_dept_gubun').val(),		//5부서
					$('#txt_proc_rev').val(),		//proc_rev
					$('#txt_checklist_cd').val(),	//2체크리스코드
					$('#txt_checklist_cd_rev').val(),	//2체크리스코드
					$('#txt_standard_guide').val(),	//6작업표준
					$('#txt_tools').val(),			//7공구
					$('#txt_check_note').val(),		//관리항목
					$('#txt_standard_value').val(),	//표준값
					'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
		        ] ).draw(true);
			
			}
		    clear_input();
		    
	        TableS101S030170_info = vTableS101S030170.page.info();
	        TableS101S030170_Row_Count = TableS101S030170_info.recordsTotal;
	        $('#txt_seq').val( TableS101S030170_Row_Count + 1);
// 	        $('#txt_lastseq').val(TableS101S030170_Row_Count);
	        
	        TableS101S030170_Row_Index=-1;
		    $(this).html("추가");
	    } );		

    });
	
    function S101S030170_query(){

		$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030170.jsp", 
            data: "order_no=" + '<%=GV_ORDER_NO%>'  + "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>' + "&lotno=" + '<%=GV_LOT_NO%>',
            beforeSend: function () {
                $("#bom_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#bom_tbody").hide().html(html).fadeIn(100);
//     	        TableS101S030170_info = vTableS101S030170.page.info();
//    	      		TableS101S030170_Row_Count = TableS101S030170_info.recordsTotal;
   		   		rCount = TableS101S030170_Row_Count + 1;
            },
            error: function (xhr, option, error) {

            }
        });
    }
    
	function SetRecvData(){
		DataPars(M101S030100E121,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {        
		var WebSockData="";
		vTableS101S030170_info = vTableS101S030170.page.info();
		TableS101S030170_RowCount = vTableS101S030170_info.recordsTotal; 
		
        var dataJson = new Object(); // JSON Object 선언
        dataJson.member_key = "<%=member_key%>";
		
	    for(var i=0; i<TableS101S030170_RowCount; i++){   
	    	var dataJson = new Object(); // BOM Data용
	    	
	    	dataJson.jsp_page 		= '<%=JSPpage%>';
	    	dataJson.login_id 		= '<%=loginID%>';
	    	dataJson.num_profix 	= $('#txt_num_prefix').val();			// 2
	    	dataJson.orderno 		= $('#txt_orderno').val();				// 3
	    	dataJson.lotno 			= $('#txt_lotno').val(); 				// 4. GV_LOT_NO
	    	dataJson.qar 			= $('#txt_qar').val(); 					// 5. qar
	    	dataJson.spec_approval 	= $('#txt_spec_approval').val(); 		// 6. spec_approval
	    	dataJson.spec_approval_rev = $('#txt_spec_approval_rev').val(); // 7. spec_approval_rev
	    	dataJson.std_dwg = $('#txt_std_dwg').val();						// 8. std_dwg
	    	dataJson.std_dwg_rev 	= $('#txt_std_dwg_rev').val(); 			// 9. std_dwg_rev
	    	dataJson.program_rev 	= $('#txt_program_rev').val(); 			// 10. program_rev
	    	dataJson.job_guide 		= $('#txt_job_guide').val(); 			// 11. job_guide
	    	dataJson.job_guide_rev 	= $('#txt_job_guide_rev').val(); 		// 12. job_guide_rev
//          {"순번" ,"공정번호","공정명","부서", "proc_rev","체크리스코드","checklist_rev","작업표준","공구","관리항목","표준값"};
	    	dataJson.proc_cd 		= vTableS101S030170.cell(i , 1).data(); // 13. proc_cd   공정번호
	    	dataJson.proc_rev 		= vTableS101S030170.cell(i , 4).data(); // 14. proc_rev  proc_rev
	    	dataJson.checklist_cd 	= vTableS101S030170.cell(i , 5).data(); // 15. checklist_cd 체크리스코드
	    	dataJson.checklist_seq 	= vTableS101S030170.cell(i , 0).data(); // 16. checklist_seq 순번
	    	dataJson.checklist_rev 	= vTableS101S030170.cell(i , 6).data(); // 17. checklist_rev checklist_rev
	    	dataJson.standard_guide = vTableS101S030170.cell(i , 7).data(); // 18. standard_guide 작업표준
	    	dataJson.standard_value = vTableS101S030170.cell(i , 10).data();// 19. standard_value  표준값
	    	dataJson.tools 			= vTableS101S030170.cell(i , 8).data(); // 20. tools 공구
	    	dataJson.check_note 	= vTableS101S030170.cell(i , 9).data(); // 21. check_note 관리항목
	        dataJson.member_key = "<%=member_key%>";
// 			console.log(dataJson)
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
		SendTojsp(parent.urlencode(JSONparam), SQL_Param.PID);

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
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}  
	
	//pop_fn_SeolbiList_View 에서 행선택해서 값입력 함수
    function SetSeolbiInfo(txt_seolbi_cd,txt_seolbi_rev, txt_seolbi_nm){
		$('#txt_tools').val(txt_seolbi_nm);		
    }

    function SetCustName_code(name, code, rev){
		$('#txt_CustName').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);
    }

    function SetdeptName_code(txt_deptname, txt_deptcode){
		$('#txt_deptname').val(txt_deptname);
		$('#txt_deptcode').val(txt_deptcode);
    }
    
    function fn_mius_body(obj){  
    	vTableS101S030170.row($(obj).parents('tr')).remove().draw();
		vTableS101S030170_info = vTableS101S030170.page.info();
		TableS101S030170_RowCount = vTableS101S030170_info.recordsTotal; 

		clear_input();
    }   
	function clear_input(){
		$('#txt_checklist_seq').val("");
		$('#txt_proc_cd').val("");
		$('#txt_process_name').val("");
		$('#txt_dept_gubun').val("");
		$('#txt_proc_rev').val("");
		$('#txt_checklist_cd').val("");
		$('#txt_checklist_cd_rev').val("");
		$('#txt_standard_guide').val("");
		$('#txt_tools').val("");
		$('#txt_check_note').val("");
		$('#txt_standard_value').val("");
	}
    function SetCustProjectInfo(cust_cd, cust_nm,project_name,cust_pono,prod_cd, product_nm,cust_rev,projrctCnt){
		$('#txt_project_name').val(project_name);
		$('#txt_CustName').val(cust_nm);
		$('#txt_projrctCnt').val(projrctCnt);
		
		$('#txt_custcode').val(cust_cd);
		$('#txt_cust_rev').val(cust_rev);
		$('#txt_cust_poNo').val(cust_pono);		
    }
    
    function SetOderDocInfo(name, code,revision, opt){
    	switch(opt){
    	case "0":
    		$('#txt_spec_approval_name').val(name);
    		$('#txt_spec_approval').val(code);
    		$('#txt_spec_approval_rev').val(revision);
    		break;
    	case "1":
    		$('#txt_std_dwg_name').val(name);
    		$('#txt_std_dwg').val(code);
    		$('#txt_std_dwg_rev').val(revision);
        	break;
    	case "2":
    		$('#txt_job_guide_name').val(name);
    		$('#txt_job_guide').val(code);
    		$('#txt_job_guide_rev').val(revision);
        	break;
    	}
    }
    
    function fn_Process_CheckList() { /* 파라메터 알맞게 조정 필요 */
    	//caller = 1 : modalFramePopup에서 호출"Contents/Business/M101/S101S030150.jsp"
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030150.jsp"; //?caller="+caller;
    	pop_fn_popUpScr_nd(modalContentUrl, "공정별 체크리스트 조회(S101S030150)", '600px', '80%');
		return false;
     }
    
    function SetProcessInfo(txt_process_name,txt_process_cd, txt_process_rev){
		$('#txt_process_name').val(txt_process_name);
		$('#txt_process_cd').val(txt_process_cd);
		$('#txt_process_rev').val(txt_process_rev);
    }
    </script>

	<div class="container-fluid">
        <table class="table table-striped " style="width: 100%; margin: 0 ; align:left">	        
  			<tr>
	            <td style="width: 5.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">주문명</td>
	            <td colspan="3" style="width: 44.5%;  font-weight: 900; font-size:14px; text-align:lef; margin-left:10px;">
					<input type="text" class="form-control" id="txt_orderno"  style="width: 25%;float:left;" readonly/>
					<input type="text" class="form-control" id="txt_project_name" style="width: 50%;float:left;margine-left:3px" readonly />
					<input type="hidden" class="form-control" id="txt_orderdetailseq" />
					<input type="hidden" class="form-control" id="txt_num_prefix" />
	           	</td>
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">일련번호</td> -->
	            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle"></td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; margin-left:10px;">
<!-- 					<input type="text" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/> -->
					<input type="hidden" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/>
	           	</td>	           		           
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle"></td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; margin-left:10px;">
	           	</td>
	    	</tr>
  			<tr>
	            <td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품번</td>
	            <td style="width: 19%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_product_code" style="width: 60%;"/>
					<input type="hidden" class="form-control" id="txt_prod_rev"  readonly/>					
	           	</td>	   	           
				<td style="width: 6.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품명</td>
	            <td style="width: 18.5%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_productname"  readonly/>
	           	</td>         
	           	<td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">LOT번호</td>
	            <td style="width: 19%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lotno"  style="width: 60%;" readonly/>
	           	</td>
	            <td style="width: 6.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">LOT 수량</td>
	            <td style="width: 18.5%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lot_count" style="width: 60%;";  readonly/>					
	           	</td>
	        </tr>
	        <tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left ;vertical-align: middle">QAR</td>
	            <td style=" tmargin-left:10px;">
					<input type="text" class="form-control" id="txt_qar" style="width: 60%;"/>
	            </td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">사양승인원</td> <!-- tbi_order_doclist 선택 -->
	            <td style=" tmargin-left:10px;"> 
	            	<input type="text"  	id="txt_spec_approval_name" class="form-control" style="width: 60%;float:left;"/> <!-- file_view_name -->
	            	<input type="hidden"  	id="txt_spec_approval"  />
	            	<input type="hidden"  	id="txt_spec_approval_rev" />
	            	<button type="button" 	onclick="parent.pop_fn_Oder_Doc_View(1,0,'<%=GV_ORDER_NO%>')" id="btn_SearchPart"
	            	    class="form-control btn btn-info" style="width:20%;float:left;">검색</button>
	            </td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left ;vertical-align: middle">규격도면</td><!-- tbi_order_doclist 선택 -->
	            <td style=" tmargin-left:10px;">
	            	<input type="text"  	id="txt_std_dwg_name" class="form-control" style="width: 60%;float:left;"/> <!-- file_view_name -->
					<input type="hidden" 	id="txt_std_dwg"  />
					<input type="hidden" 	id="txt_std_dwg_rev"   />
					<button type="button" 	onclick="parent.pop_fn_Oder_Doc_View(1,1,'<%=GV_ORDER_NO%>')" id="btn_SearchPart" 
					class="form-control btn btn-info" style="width:20%;float:left;">검색</button>
	            </td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">작업지도서</td><!-- tbi_order_doclist 선택 -->
	            <td style=" tmargin-left:10px;"> 
	            	<input type="text"  	id="txt_job_guide_name" class="form-control" style="width: 60%;float:left;"/>
	            	<input type="hidden"  	id="txt_job_guide"  />
	            	<input type="hidden"  	id="txt_job_guide_rev"  />
	            	<button type="button" 	onclick="parent.pop_fn_Oder_Doc_View(1,2,'<%=GV_ORDER_NO%>')" id="btn_SearchPart" 
	            	class="form-control btn btn-info" style="width:20%;float:left;">검색</button>
	            </td>	        
	        </tr>
	        <tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left ;vertical-align: middle">프로그램 Rev.</td>
	            <td style=" tmargin-left:10px;" colspan="7">
					<input type="text" class="form-control" id="txt_program_rev" />
	            </td>     
	        </tr>	
       	</table>
       	
        <table class="table" style="width: 100%; margin: 0 ; align:left" id="checklistbutton">	               
	        <tr>
	            <td align="left">
	                	<button type="button" onclick="fn_Process_CheckList()" id="btn_SearchCheckList" class="form-control btn btn-info" style="width:30%;float:left;">체크리스트 검색</button>
	            </td>
	        </tr>
	    </table>
					 
        <table class="table " style="width: 100%; margin: 0 ; align:left" id="Process_check_table">
 
	        <tr style="vertical-align: middle">
<!-- 	            <td style="width:  2%; font-size:14px; text-align:center; vertical-align: middle">진행명</td> -->
	            <td style="width:  4%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">순번</td>
	            <td style="width:  9%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">공정No</td>
	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">공정명</td>
	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">관련부서</td>
	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">작업표준</td> 
	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">설비(공구)</td>
	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">관리항목</td>
	            <td style="width: 14%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">표준값</td>
	            <td style="width:  3%;vertical-align: middle"></td>
	        </tr>
	        <tr style="vertical-align: middle">			 
	        	<td style="text-align:center; vertical-align: middle">
					<input type="text" class="form-control"  id="txt_checklist_seq" readonly></input>					
				</td>
	        	<td style="text-align:center; vertical-align: middle">
					<input type="text" class="form-control"  id="txt_proc_cd" readonly></input>
					<input type="hidden" class="form-control"  id="txt_proc_rev" readonly></input>
					<input type="hidden" class="form-control"  id="txt_checklist_cd" readonly></input>
					<input type="hidden" class="form-control"  id="txt_checklist_cd_rev" readonly></input>
					
				</td>
	            <td style="text-align:center; vertical-align: middle">
					<input type="text" class="form-control"  id="txt_process_name" style="width:70%;float:left;" readonly ></input>
	           	</td>
	        	<td style="text-align:center; vertical-align: middle">
					<input type="text" class="form-control"  id="txt_dept_gubun" readonly></input>					
				</td>
	            <td style="text-align:center;vertical-align: middle">
					<input type="text" class="form-control"  id="txt_standard_guide"  readonly></input> 
	           	</td>
	            <td style="text-align:center; vertical-align: middle">
					<input type="text" class="form-control"  id="txt_tools" style="width:70%;float:left;"></input>
					<button type="button" onclick="parent.pop_fn_SeolbiList_View(1)" id="btn_SearchPart" class="form-control btn btn-info" style="width:30%;float:left;">검색</button>
	           	</td>
	            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
	            	<input type="text"   id="txt_check_note" class="form-control" readonly/>			
					
	            </td>
	            <td style="text-align:center; vertical-align: middle">
	            	<input type="text"   id="txt_standard_value" class="form-control" />		
	            </td>
	            <td style="text-align:center; vertical-align: middle">
	            	<button id="btn_plus" class="form-control btn btn-info" >수정</button>
	            </td>
	        </tr>
	    </table>
        <div id="bom_tbody">

        </div>
        <table class="table table-bordered " style="width: 100%; margin: 0 ; align:left" id="bom_table">	               
	        <tr>
	            <td align="center">
	                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
	            </td>
	        </tr>
	    </table>
	</div>