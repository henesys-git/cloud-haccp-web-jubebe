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
	if(loginID == null || loginID.equals("")) {										// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");		// 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	
%>

<script type="text/javascript">
	var censor_no = "";
	var censor_rev_no = "";

    $(document).ready(function () {
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("센서목록");

		fn_MainInfo_List();
	    fn_tagProcess('<%=JSPpage%>');
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
        
    // 센서 정보 목록 조회
    function fn_MainInfo_List() {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S170100.jsp",
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
                $("#Main_contents").hide().html(html).fadeIn(100);
            }
    	});
    }
    
    // 센서 정보 등록
    function pop_fn_Censor_Insert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S170101.jsp";
    	var footer = '<button id="btn_Save" class="btn btn-info"'
    					   + 'onclick="SaveOderInfo();">저장</button>';
    	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    }
    
 	// 센서 정보 수정
	function pop_fn_Censor_Update(obj) {
       	if(censor_no.length < 1) {
       		heneSwal.warning("수정할 센서 정보를 선택하세요");
 			return false;
   		}
       	
       	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S170102.jsp"
					+ "?censor_no="		+ censor_no
					+ "&censor_rev_no="	+ censor_rev_no;
		var footer = '<button id="btn_Save" class="btn btn-info"'
						   + 'onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
	// 센서 정보 삭제
	function pop_fn_Censor_Delete(obj) {
		if(censor_no.length < 1){
			heneSwal.warning("삭제할 센서 정보를 선택하세요");
 			return false;
		}
		
		// 주문번호를 json 형식으로 만듬
		var obj = {
					"censor_no":censor_no,
					"censor_rev_no":censor_rev_no
				  };
		
		var objStr = JSON.stringify(obj);
		
		var chekrtn = confirm('해당 센서 정보를 삭제하시겠습니까?');
		
		if(chekrtn){
	    	executeQuery(objStr, "M909S170100E103");
	    } else{
    		return false;
    	}
	}
		
	function executeQuery(prmtr, pid){
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : prmtr, "pid" : pid},
	        success: function (rcvData) {
	        	if(rcvData < 0) {
	        		heneSwal.errorTimer("주문 삭제 실패했습니다, 다시 시도해주세요");
	        	} else {
	        		heneSwal.successTimer("해당 센서 정보가 삭제되었습니다");
		        	parent.fn_MainInfo_List();
		 	     	$('#modalReport').modal('hide');
	        	}
	        }
		});
	}
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
	<div class="container-fluid">
		<div class="row mb-2">
     		<div class="col-sm-6">
       			<h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
     		</div>
     		<div class="col-sm-6">
     			<div class="float-sm-right">
	     			<button type="button" onclick="pop_fn_Censor_Insert(this)" id="insert" class="btn btn-outline-dark">센서정보등록</button>
		     	  	<button type="button" onclick="pop_fn_Censor_Update(this)" id="update" class="btn btn-outline-success">센서정보수정</button>
		     	  	<button type="button" onclick="pop_fn_Censor_Delete(this)" id="delete" class="btn btn-outline-danger">센서정보삭제</button>
     			</div>
      		</div>
		</div><!-- /.row -->
    </div><!-- /.container-fluid -->
</div>
<!-- /.content-header -->
    
    
<!-- Main content -->
<div class="content">
	<div class="container-fluid">
    	<div class="row">
      		<div class="col-md-12">
        		<div class="card card-primary card-outline">
          			<div class="card-header">
          				<h3 class="card-title">
          					<i class="fas fa-edit" id="InfoContentTitle"></i>
          				</h3>
          			</div>
          			<div class="card-body" id="Main_contents">
          			</div> 
        		</div>
      		</div> <!-- /.col-md-6 -->
    	</div> <!-- /.row -->
	</div> <!-- /.container-fluid -->
</div> <!-- /.content -->