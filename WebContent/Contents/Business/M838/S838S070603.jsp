<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	
	String GV_CORRECTION_MANAGE_NO = "", GV_CORRECTION_MANAGE_REV = "", GV_CORRECTION_EQUIPMENT_NAME = ""; 
	String GV_PID = "M838S070600E114";
	
	if(request.getParameter("Correction_manage_no")== null)
		GV_CORRECTION_MANAGE_NO = "";
	else
		GV_CORRECTION_MANAGE_NO = request.getParameter("Correction_manage_no");
	
	if(request.getParameter("Correction_manage_rev")== null)
		GV_CORRECTION_MANAGE_REV = "";
	else
		GV_CORRECTION_MANAGE_REV = request.getParameter("Correction_manage_rev");
	
	if(request.getParameter("Correction_epuipment_name")== null)
		GV_CORRECTION_EQUIPMENT_NAME = "";
	else
		GV_CORRECTION_EQUIPMENT_NAME = request.getParameter("Correction_epuipment_name");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "correction_manage_no", GV_CORRECTION_MANAGE_NO);
	jArray.put( "correction_manage_rev", GV_CORRECTION_MANAGE_REV);
	jArray.put( "correction_epuipment_name", GV_CORRECTION_EQUIPMENT_NAME);
	jArray.put( "member_key", member_key);
	TableModel = new DoyosaeTableModel(GV_PID, jArray);	
	
	String correction_manage_no = TableModel.getValueAt(0,0).toString().trim();
	String correction_manage_rev = TableModel.getValueAt(0,1).toString().trim();
	System.out.println("확인 : " + correction_manage_no + " - " + correction_manage_rev);
 	int RowCount =TableModel.getRowCount();
	StringBuffer html = new StringBuffer();
	if(RowCount>0){
		html.append("$('#txt_correction_manage_no').val('" 	+ correction_manage_no + "');\n");
		html.append("$('#txt_correction_manage_rev').val('" 	+ correction_manage_rev + "');\n");
		html.append("$('#txt_correction_epuipment').val('" 	+ TableModel.getValueAt(0,2).toString().trim() + "');\n");
		html.append("$('#txt_correction_model').val('" 	+ TableModel.getValueAt(0,3).toString().trim() + "');\n");
		html.append("$('#txt_correction_making_cop').val('" 	+ TableModel.getValueAt(0,4).toString().trim() + "');\n");
		html.append("$('#txt_correction_period').val('" 	+ TableModel.getValueAt(0,5).toString().trim() + "');\n");
		html.append("$('#txt_correction_date').val('" 	+ TableModel.getValueAt(0,6).toString().trim() + "');\n");
		html.append("$('#txt_correction_duedate').val('" 	+ TableModel.getValueAt(0,7).toString().trim() + "');\n");
		html.append("$('#txt_using_location').val('" 	+ TableModel.getValueAt(0,8).toString().trim() + "');\n");
		html.append("$('#txt_writor').val('" 	+ TableModel.getValueAt(0,9).toString().trim() + "');\n");
		html.append("$('#txt_writor_rev').val('" 	+ TableModel.getValueAt(0,10).toString().trim() + "');\n");
		html.append("$('#txt_write_date').val('" 	+ TableModel.getValueAt(0,11).toString().trim() + "');\n");
		html.append("$('#txt_approval').val('" 	+ TableModel.getValueAt(0,12).toString().trim() + "');\n");
		html.append("$('#txt_approval_rev').val('" 	+ TableModel.getValueAt(0,13).toString().trim() + "');\n");
		html.append("$('#txt_approve_date').val('" 	+ TableModel.getValueAt(0,14).toString().trim() + "');\n");
	}	
	
	//로그인한 아이디의 개정번호(rev)를 가져오는 벡터
	Vector UserIDrev = CommonData.getUserRevDataID(loginID,member_key);
	Vector optCodeVector = (Vector)UserIDrev.get(0); 
	String optCode =  optCodeVector.get(0).toString();
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID: "M838S070600E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	$(document).ready(function () {
		$("#txt_writor_main").val("<%=loginID%>"); //로그인한 유저
		$("#txt_writor_main_rev").val("<%=optCode%>"); //로그인한 유저rev	
		
		// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	    new SetSingleDate2("","#txt_correction_date",0);
        new SetSingleDate2("","#txt_correction_duedate",0);
        new SetSingleDate2("","#txt_write_date",0);
        new SetSingleDate2("","#txt_approve_date",0);
		
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        today.setDate(today.getDate()+180);
        
        

	    <%=html%>
	    null_chk();
	});
	
	function SaveOderInfo() {
		
     	var null_chk_name = ['#txt_correction_manage_no', '#txt_correction_model', '#txt_correction_period', '#txt_using_location'];
        if($(null_chk_name[0]).val() == ''){	
	        	alert('관리번호를 입력해주세요'); 
	        	return false;
        }
        if($(null_chk_name[1]).val() == ''){	
        	alert('모델명을 입력해주세요'); 
        	return false;
    	}
        if($(null_chk_name[2]).val() == ''){	
        	alert('교정주기를 입력해주세요'); 
        	return false;
    	}
        if($(null_chk_name[3]).val() == ''){	
        	alert('사용장소를 입력해주세요'); 
        	return false;
    	}
		var jArray = new Array(); // JSON Array 선언
		// JSON 파라미터 세팅
		var dataJson = new Object(); // jSON Object 선언 
		dataJson.member_key = "<%=member_key%>";
		dataJson.correction_manage_no      = $("#txt_correction_manage_no").val();
		dataJson.correction_manage_rev     = <%=correction_manage_rev%>;
		dataJson.correction_epuipment_name = $("#txt_correction_epuipment").val();
		dataJson.correction_model          = $("#txt_correction_model").val();
		dataJson.correction_making_cop     = $("#txt_correction_making_cop").val();
		dataJson.correction_period         = $("#txt_correction_period").val();
		dataJson.correction_date           = $("#txt_correction_date").val();
		dataJson.correction_duedate        = $("#txt_correction_duedate").val();
		dataJson.using_location            = $("#txt_using_location").val();
		dataJson.writor                    = $("#txt_writor").val();
		dataJson.writor_rev                = $("#txt_writor_rev").val();
		dataJson.write_date                = $("#txt_write_date").val();
		dataJson.approval                  = $("#txt_approval").val();
		dataJson.approval_rev              = $("#txt_approval_rev").val();
		dataJson.approve_date              = $("#txt_approve_date").val();
		jArray.push(dataJson); // 데이터를 배열에 담는다.  
		
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
		
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
 		
		var work_complete_insert_check = confirm("삭제하시겠습니까?");
		if(work_complete_insert_check == false)   return;
		
		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data: {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}
	
    function SetUser_Select(user_id, revision_no, user_nm){
    	 //   	console.log("??? : " + user_id +" ~ "+ revision_no + " ~ " + user_nm);
    			$("#"+ rowId).val(user_nm);
    			$("#"+ rowId + "_rev").val(revision_no);
    }

	function SetSeolbiInfo(txt_seolbi_cd,txt_seolbi_rev, txt_seolbi_nm){
//		console.log(txt_seolbi_cd +" - "+ txt_seolbi_rev +" - "+ txt_seolbi_nm);
		$('#txt_correction_epuipment').val(txt_seolbi_nm);
		$('#txt_correction_epuipment_cd').val(txt_seolbi_cd);
		$('#txt_correction_epuipment_rev').val(txt_seolbi_rev);
    }
	
	function SetCustName_code(name, code, rev){
		$('#txt_correction_making_cop').val(name);
		$('#txt_correction_making_cop_cd').val(code);
		$('#txt_correction_making_cop_rev').val(rev);
	}
    function null_chk(){
     	var null_chk_name = ['txt_correction_manage_no', 'txt_correction_model', 'txt_correction_period', 'txt_using_location'];
    	var null_chk_no = ['txt_null_chk_manage', 'txt_null_chk_model', 'txt_null_chk_period', 'txt_null_chk_location'];
/*   	for(var i = 0; i < null_chk_name.length; i++){
    		var chk = '#' + null_chk_name[i];
    		var null_chk = '#' + null_chk_no[i];
    		if($(chk).val() == ''){
    			$(null_chk).val(" ✘");	
    	    	$(null_chk).css("background-color", "tomato");	
    		} else {
            	$(null_chk).val(" ✔");
    	        $(null_chk).css("background-color", "lightgreen");	
    		}	 	    
    	    $(chk).on('change',function(){	    	
    	        if($(chk).val() != ''){	        	
    	        	$(null_chk).val(" ✔");
    		        $(null_chk).css("background-color", "lightgreen");
    	        } else {
    	        	$(null_chk).val(" ✘");
    	        	$(null_chk).css("background-color", "tomato");
    	        }	    	
    	    });
    	} */
    	
    	// 
		var chk0 = '#' + null_chk_name[0];
		var null_chk0 =  '#' + null_chk_no[0];
		if($(chk0).val() == ''){
			$(null_chk0).val(" ✘");	
	    	$(null_chk0).css("background-color", "tomato");	
		} else {
        	$(null_chk0).val(" ✔");
	        $(null_chk0).css("background-color", "lightgreen");	
		}	 	    
	    $(chk0).change(function(){	    	
	        if($(chk0).val() != ''){	        	
	        	$(null_chk0).val(" ✔");
		        $(null_chk0).css("background-color", "lightgreen");	
	        } else {
	        	$(null_chk0).val(" ✘");
	        	$(null_chk0).css("background-color", "tomato");	
	        }	    	
	    });
	    // 
		var chk1 = '#' + null_chk_name[1];
		var null_chk1 =  '#' + null_chk_no[1];
		if($(chk1).val() == ''){
			$(null_chk1).val(" ✘");	
	    	$(null_chk1).css("background-color", "tomato");	
		} else {
        	$(null_chk1).val(" ✔");
	        $(null_chk1).css("background-color", "lightgreen");	
		}	 	    
	    $(chk1).change(function(){	    	
	        if($(chk1).val() != ''){	        	
	        	$(null_chk1).val(" ✔");
		        $(null_chk1).css("background-color", "lightgreen");	
	        } else {
	        	$(null_chk1).val(" ✘");
	        	$(null_chk1).css("background-color", "tomato");	
	        }	    	
	    });
	    // 
		var chk2 = '#' + null_chk_name[2];
		var null_chk2 =  '#' + null_chk_no[2];
		if($(chk2).val() == ''){
			$(null_chk2).val(" ✘");	
	    	$(null_chk2).css("background-color", "tomato");	
		} else {
        	$(null_chk2).val(" ✔");
	        $(null_chk2).css("background-color", "lightgreen");	
		}	 	    
	    $(chk2).change(function(){	    	
	        if($(chk2).val() != ''){	        	
	        	$(null_chk2).val(" ✔");
		        $(null_chk2).css("background-color", "lightgreen");	
	        } else {
	        	$(null_chk2).val(" ✘");
	        	$(null_chk2).css("background-color", "tomato");	
	        }	    	
	    });
	    //
		var chk3 = '#' + null_chk_name[3];
		var null_chk3 =  '#' + null_chk_no[3];
		if($(chk3).val() == ''){
			$(null_chk3).val(" ✘");	
	    	$(null_chk3).css("background-color", "tomato");	
		} else {
        	$(null_chk3).val(" ✔");
	        $(null_chk3).css("background-color", "lightgreen");	
		}	 	    
	    $(chk3).change(function(){	    	
	        if($(chk3).val() != ''){	        	
	        	$(null_chk3).val(" ✔");
		        $(null_chk3).css("background-color", "lightgreen");	
	        } else {
	        	$(null_chk3).val(" ✘");
	        	$(null_chk3).css("background-color", "tomato");	
	        }	    	
	    });
    }
    </script>
</head>
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        <tr style="background-color: #fff; height: 40px">
        	<td style=" font-weight: 900; font-size:14px; text-align:left" >교정계획서 관리번호</td>
			<td colspan="3">
			<input type="text" id="txt_correction_manage_no" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" disabled/>
			<input type="text" id="txt_correction_manage_rev" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" value="0" />		            	        
			<input type="text" id="txt_null_chk_manage" class="form-control" style="width: 35px; border: solid 1px #cccccc;" disabled/>
			</td>
        	<td style=" font-weight: 900; font-size:14px; text-align:left" >검사설비명</td>
			<td colspan="3">
				<input type="text" id="txt_correction_epuipment" class="form-control" style="width: 400px; border: solid 1px #cccccc; float: left;" readonly/>
				<input type="text" id="txt_correction_epuipment_cd" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" readonly/>
				<input type="text" id="txt_correction_epuipment_rev" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" value="0" readonly/>
				&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="pop_fn_SeolbiList_View(1)" value="검색" disabled></input>
           	</td>

        </tr>
        <tr style="background-color: #fff; height: 40px">
    		<td style=" font-weight: 900; font-size:14px; text-align:left" >모델/규격</td>
			<td colspan="3">
			<input type="text" id="txt_correction_model" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" disabled/>		            	        
			<input type="text" id="txt_null_chk_model" class="form-control" style="width: 35px; border: solid 1px #cccccc;" disabled/>
			</td>
			<td style=" font-weight: 900; font-size:14px; text-align:left" >제작회사</td>
			<td colspan="3">
				<input type="text" id="txt_correction_making_cop" class="form-control" style="width: 400px; border: solid 1px #cccccc; float: left;" disabled/>
				<input type="text" id="txt_subcontractor_cd" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" readonly/>
				<input type="text" id="txt_subcontractor_rev" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" value="0" readonly/>
				&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_CustName_View(1,'I');" value="검색"></input>
			</td>		          
        </tr>

        <tr style="background-color: #fff; height: 40px">
    		<td style=" font-weight: 900; font-size:14px; text-align:left" >교정주기</td>
			<td colspan="3">
			<input type="text" id="txt_correction_period" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" numberOnly disabled/>		            	        
			<input type="text" id="txt_null_chk_period" class="form-control" style="width: 35px; border: solid 1px #cccccc;" disabled/>
			</td>
           	<td style=" font-weight: 900; font-size:14px; text-align:left" >교정일자</td>
		    <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_correction_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>
        </tr>
        
        <tr style="height: 40px">
           	<td style=" font-weight: 900; font-size:14px; text-align:left" >교정예정일자</td>
		    <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_correction_duedate" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>
    		<td style=" font-weight: 900; font-size:14px; text-align:left" >사용장소</td>
			<td colspan="3">
			<input type="text" id="txt_using_location" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" disabled/>		            	        
			<input type="text" id="txt_null_chk_location" class="form-control" style="width: 35px; border: solid 1px #cccccc;" disabled/>
        </tr>

        <tr style="height: 40px">
            <td style=" font-weight: 900; font-size:14px; text-align:left" >작성자</td>
			<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
				<input type="text" class="form-control" id="txt_writor" style="width: 400px; float:left" readonly />
				<input type="text" class="form-control" id="txt_writor_rev" style="width: 400px; float:left; display:none;" readonly />				
				&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_writor')" value="입력" disabled></input></td>		           	
            <td style=" font-weight: 900; font-size:14px; text-align:left" >작성일</td>
            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_write_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>		       
        </tr>
       <tr class="subcontractor" style="background-color: #fff" >
            <td style=" font-weight: 900; font-size:14px; text-align:left" >승인자</td>
            					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
				<input type="text" class="form-control" id="txt_approval" style="width: 400px; float:left" readonly />						
				<input type="text" class="form-control" id="txt_approval_rev" style="width: 400px; float:left; display:none;" readonly />
				&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_approval')" value="입력" disabled></input></td>
            <td style=" font-weight: 900; font-size:14px; text-align:left" >승인일</td>
            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_approve_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>		       
        </tr>
        
        <tr style="height: 60px">
            <td colspan="10" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick=" $('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>

    </table>
<!-- </form>     -->
</body>
</html>