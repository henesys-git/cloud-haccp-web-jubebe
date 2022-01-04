<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;	
	String zhtml = "";
	
    Vector optCodeInfo =  null;
    Vector optCodeSeq =  null;
    Vector optCodeRevNo =  null;

	String[] strColumnHead = {"", "", "", "", "", "" };
	
	String GV_PART_CD="", GV_PART_CD_REV="", GV_PART_NAME="";

	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");

	if(request.getParameter("part_cd_rev")== null)
		GV_PART_CD_REV="";
	else
		GV_PART_CD_REV = request.getParameter("part_cd_rev");

	if(request.getParameter("part_name")== null)
		GV_PART_NAME="";
	else
		GV_PART_NAME = request.getParameter("part_name");	
	
	Vector optCode =  null;
    Vector optName =  null;
//     Vector check_gubunVector = CommonData.getChecklistGubun_Code(member_key);
	Vector check_gubunVector = CommonData.getChecklistGubun_IMPORT_Code(member_key);
	
	
%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S124100E101 = {
			PID: "M909S124100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S124100E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

// 체크항목 분할변수
	var totItemInfo = "";
	var arrayItemInfo;
	
	var partItemCode;
	var partItemDesc;
	var partItemBigo;
	var partItemSeq;
	var partItemRevNo;
	
	var vcheck_gubun = "";

    var docGubunCode = "";
    var JOB_GUBUN = "";

	var vTableS909S124170 = "";
	var TableS909S124170_info;
    var TableS909S124170_Row_Count;
    var TableS909S124170_Row_Index;
    
    $(document).ready(function () {
    	
    	console.log('<%=GV_PART_CD%>');
    	console.log('<%=GV_PART_CD_REV%>');
    	console.log('<%=GV_PART_NAME%>');
    	
    	
    	setTimeout(function(){
    	
    	$('#txt_code_cd').val("<%=GV_PART_CD%>");
    	$('#txt_code_name').val("<%=GV_PART_NAME%>");
    	
		$("#select_CheckGubunCode1").on("change", function(){
	    	vcheck_gubun = $(this).val();
// 	    	Get_S101S030190();
	    });
	    vcheck_gubun = $("#select_CheckGubunCode1").val();
    	
		S909S124170_query();
		
		TableS909S124170_Row_Index = -1;
    	// 특정 로우를 선택하고 들어오면... 그 문항코드를 뿌려준다...
<%--     	$('#txt_checklist_cd').val("<%=GV_PART_CD%>"); --%>

	$("#txt_StartDate").datepicker({
		format: 'yyyy-mm-dd',
		autoclose: true,
		language: 'ko'
	});  
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        

        $('#txt_StartDate').datepicker('update', fromday);
    	
    	},200);	    
    });
    
    function S909S124170_query(){

		$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S124170.jsp", 
            data: "part_cd=" + '<%=GV_PART_CD%>'  + "&part_cd_rev=" + '<%=GV_PART_CD_REV%>',
            beforeSend: function () {
                $("#part_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#part_tbody").hide().html(html).fadeIn(100);
   		   		rCount = TableS909S124170_Row_Count + 1;
            }
        });
    }

	
	function SaveOderInfo() {
		
		if (vTableS909S124170.cell( 0, 6 ).data( )==undefined) {
			alert("체크문항검색을 클릭해서 체크문항을 추가하세요.");
			return;
		}
		var jArray = new Array(); // JSON Array 선언
		for(var i=0; i<vTableS909S124170.rows().count(); i++){
			var dataJson = new Object(); // jSON Object 선언 
				dataJson.member_key = "<%=member_key%>";
				dataJson.user_id 			= "<%=loginID%>";
				dataJson.part_cd 			= "<%=GV_PART_CD%>";
				dataJson.part_cd_rev		= "<%=GV_PART_CD_REV%>";
				dataJson.checklist_cd 		= vTableS909S124170.cell( i, 5 ).data( ); // checklist_cd
				dataJson.checklist_cd_rev 	= vTableS909S124170.cell( i, 6 ).data( ); // checklist_cd_rev
				dataJson.checklist_seq 		= vTableS909S124170.cell( i, 0 ).data( ); // checklist_seq
				dataJson.item_cd 			= vTableS909S124170.cell( i, 7 ).data( ); // item_cd
				dataJson.item_cd_rev 		= vTableS909S124170.cell( i, 8 ).data( ); // item_cd_rev
				dataJson.item_seq 			= vTableS909S124170.cell( i, 9 ).data( ); // item_seq
				dataJson.standard_guide 	= vTableS909S124170.cell( i,10 ).data( ); // standard_guide
				dataJson.standard_value 	= vTableS909S124170.cell( i,11 ).data( ); // standard_value
				dataJson.check_note 		= vTableS909S124170.cell( i,12 ).data( ); // check_note
				
				jArray.push(dataJson); // 데이터를 배열에 담는다.
				
				console.log(dataJson.user_id);
		}
		
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
		
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
		}
	}
 
	function SendTojsp(bomdata, pid){		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('정보 등록에 성공하였습니다.');
	        	   	parent.DetailInfo_List.click();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide'); 
	         	}
	        	 else{
	        		 heneSwal.error('정보 등록에 실패하였습니다.'); 
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
	

	function SetCodeBook(txt_code_cd,txt_code_value, txt_code_name,txt_revision_no){
		$('#txt_code_cd').val(txt_code_cd);
		$('#txt_code_value').val(txt_code_value);
		$('#txt_code_name').val(txt_code_name);
		$('#txt_revision_no').val(txt_revision_no);
	}
	
    function fn_Product_inspect_CheckList() { /* 파라메터 알맞게 조정 필요 */
    	//caller = 1 : modalFramePopup에서 호출"Contents/Business/M101/S101S030150.jsp"
    	//caller = 0 : 일반화면에서 호출
    	if(vcheck_gubun=="ALL")
    		vcheck_gubun="";
  
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/CheckListView.jsp?part_cd=<%=GV_PART_CD%>" + "&check_gubun=" +vcheck_gubun;
    	
    	var footer = "";
    	var title = "수입검사 체크리스트 조회";
    	var heneModal = new HenesysModal2(modalContentUrl, 'large', title, footer);
    	heneModal.open_modal();
    	
    	//pop_fn_popUpScr_nd(modalContentUrl, "수입검사 체크리스트 조회(CheckListView)", '600px', '80%');
		//return false;
     }
	
    </script>
	<div class="container-fluid">
   		<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	        <tr style="background-color: #fff; height: 40px">
	            <td>원부자재코드</td>
	            <td>
	            	<input type="text" class="form-control" id="txt_code_cd" style="width: 70%; float:left"  readonly/>
	            </td>
	        	<td>원부자재명</td>
	            <td>
	            	<input type="text" class="form-control" id="txt_code_name" style="width: 70%; float:left"  readonly/>
	            	<input type="hidden" class="form-control" id="txt_pic_seq" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_checklist_cd" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_revision_no" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_checklist_seq" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_item_cd" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_item_cd_rev" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_item_seq" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_standard_guide" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_standard_value" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_check_note" style="width: 200px; float:left"  readonly/> 
	            	<input type="hidden" class="form-control" id="txt_start_date" style="width: 200px; float:left"  readonly/> 
	            </td>
	        </tr>
	        <tr style="background-color: #fff; height: 40px">
	            <td>검사구분</td>
				<td>
			    	<select class="form-control" id="select_CheckGubunCode1" style="width: 140px">
						<%optCode =  (Vector)check_gubunVector.get(0);%>
						<%optName =  (Vector)check_gubunVector.get(1);%>
						<%for(int i=0; i<optName.size();i++){ %>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
							<%} %>
					</select>
				</td>
	        </tr>
	    </table>
	    <table class="table" style="width: 100%; margin: 0 ; align:right" id="checklistbutton">	               
	        <tr>
	            <td align="left">
	                <button type="button" 	onclick="fn_Product_inspect_CheckList()" id="btn_SearchPart" class="btn btn-info" style="float:right;">체크문항검색</button></td>
	        </tr>
	    </table>
        <div id="part_tbody">

        </div>
	</div>
    