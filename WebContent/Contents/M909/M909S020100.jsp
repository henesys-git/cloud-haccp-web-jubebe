<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            			// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp"); // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);		

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN; 
%>

<script type="text/javascript">
 	var vCheckGubunCode	= "";
 	var vCheckGubunName	= "";
    var vCheckGubunMid	= "";
    var vCheckGubunSm	= "";
 	var vCheckListCd	= "";
 	var vRevisionNo		= "";
 	var vItemSeq		= "";
 	var vCheckGubun		= "";  
 	var vCheckListSeq	= "";
 	var vItemCd			= ""; 
 	var vItemRevNo		= "";
 	var FLAG			= false;
 	
 	var checklistId  = "";
 	var checklistRevNo = "";
 	var checklistName = "";
 	var checkTerm = "";

    $(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("점검표 목록");

    	fn_MainInfo_List();
        
	    $("#select_check_gubun").on("change", function(){
	    	fn_MainInfo_List();
	    });

	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
			FLAG = !FLAG;
	    	
	    	if( FLAG )
	    	{
	    		alert("등록 / 수정 / 삭제 기능이 제한됩니다.");
	    		
	    		$("#insert").prop("disabled",true);
	    		$("#update").prop("disabled",true);
	    		$("#delete").prop("disabled",true);
	    	}
	    	else
	    	{
	    		$("#insert").prop("disabled",false);
	    		$("#update").prop("disabled",false);
	    		$("#delete").prop("disabled",false);
	    	}
	    	
	    	fn_MainInfo_List();
	    });
    });

    function fn_tagProcess(){
    	
    	var vSelect = <%=prg_autho.vSelect%>;
    	var vInsert = <%=prg_autho.vInsert%>;
    	var vUpdate = <%=prg_autho.vUpdate%>;
    	var vDelete = <%=prg_autho.vDelete%>;
		
		if(vSelect == "0") {
	    	$('button[id="select"]').each(function () {
                $(this).prop("disabled",true);
            });
		}
		if(vInsert == "0") {
	    	$('button[id="insert"]').each(function () {
                $(this).prop("disabled",true);
            });
		}
		if(vUpdate == "0") {
	    	$('button[id="update"]').each(function () {
                $(this).prop("disabled",true);
                $(this).attr("onclick", " ");
            });
		}
		if(vDelete == "0") {
	    	$('button[id="delete"]').each(function () {
                $(this).prop("disabled",true);

            });
		}      	
    }

    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }        
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
    }
    
    // 점검표 목록 조회
    function fn_MainInfo_List() {
    	vCheckGubunCode = $("#select_check_gubun").val();
        if(vCheckGubunCode=="ALL") {
        	vCheckGubunCode="";
        }
        
        var revCheck = $("#total_rev_check").is(":checked");
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S020100.jsp",
            data: "check_gubun=" + vCheckGubunCode + "&total_rev_check=" + revCheck ,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    // 점검표 등록
    function openModalInsert(obj) {
    	
    	let url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S020101.jsp";
    	let footer = '<button id="btnInsert" class="btn btn-info">저장</button>';
    	let title = obj.innerText;
    	let heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    }

    // 점검표 수정
    function openModalUpdate(obj) {
    	if(checklistId.length < 1){
    	heneSwal.warning("수정할 점검표 정보를 선택하세요");
    	return false;	
    	}
    	
    	let url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S020102.jsp"
    			  + '?checklist_id='+ checklistId
    			  + '&checklist_rev_no=' + checklistRevNo
    			  + '&checklist_name=' + checklistName
    			  + '&check_term=' + checkTerm;
    	let footer = '<button id="btnUpdate" class="btn btn-info">저장</button>';
    	let title = obj.innerText;
    	let heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    }
	
    // 점검표 삭제
    function openModalDelete(obj) {
    	if(checklistId.length < 1){
        	heneSwal.warning("삭제할 점검표 정보를 선택하세요");
        	return false;	
        }
    		else{
    			SaveInfo();		
    		}
    	
    	function SaveInfo() {
        	
	        var dataJson = new Object();
			
			dataJson.checklist_id 		= checklistId;
			dataJson.checklist_rev_no 	= checklistRevNo;
		
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("삭제하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M909S020100E103");
			} else{
			       return false;
			}
		
	}

	function SendTojsp(bomdata, pid) {
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : bomdata, "pid" : pid},
			success: function (html) {	
				if(html > -1) {
					heneSwal.success('점검표 정보 삭제가 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	         	} else {
					heneSwal.error('점검표 정보 삭제에 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
    	
    }
</script>
    
<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type="button" onclick="openModalInsert(this)" id="insert" class="btn btn-outline-dark">등록</button>
			<button type="button" onclick="openModalUpdate(this)" id="update" class="btn btn-outline-success">수정</button>
			<button type="button" onclick="openModalDelete(this)" id="delete" class="btn btn-outline-danger">삭제</button>
      		<label>
            	Rev. No 전체보기
	            <input type="checkbox" id="total_rev_check">
	        </label>
      	</div>
      </div> <!-- /.col -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content-header -->

 <!-- Main content -->
<div class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">
				<div class="card card-primary card-outline">
					<div class="card-header">
               			<div class="fas fa-edit" id="InfoContentTitle">
               			</div>
          			</div>
          			<div class="card-body" id="MainInfo_List_contents">
          			</div> 
        		</div>
      		</div> <!-- /.col-md-6 -->
    	</div> <!-- /.row -->
  	</div> <!-- /.container-fluid -->
</div> <!-- /.content -->