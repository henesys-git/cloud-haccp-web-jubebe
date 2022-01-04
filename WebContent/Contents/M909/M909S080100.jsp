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

	// 	로그인한 아이디의 그룹 코드를 가져오는 벡터
	Vector UserGroupVectorID = CommonData.getUserGroupDataID(loginID,member_key);
	Vector optCodeIDVector = (Vector)UserGroupVectorID.get(0); 
	String optCodeID =  optCodeIDVector.get(0).toString();

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
	var user_id		= "";
 	var vRevisionNo	= "";
	var group_cd	= "";
 	var FLAG		= false;

    $(document).ready(function () {
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("사용자정보관리");

    	fn_MainInfo_List();
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
			FLAG = !FLAG;
	    	
	    	if( FLAG ) {
	    		heneSwal.warning("등록 / 수정 / 삭제 기능이 제한됩니다.");
	    		
	    		$("#insert").prop("disabled",true);
	    		$("#update").prop("disabled",true);
	    		$("#delete").prop("disabled",true);
	    	} else {
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

    function fn_LoadSubPage() {
        fn_clearList();
        fn_MainInfo_List();
    }

    function fn_clearList() {
        if ($("#Main_contents").children().length > 0) {
            $("#Main_contents").children().remove();
        }
        if ($("#Main_contents2").children().length > 0) {
            $("#Main_contents2").children().remove();
        }
    }
        
    //메뉴정보
    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S080100.jsp",
            data: "total_rev_check=" + revCheck  ,
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
                $("#Main_contents").hide().append(html).fadeIn(100);
            }
        });
    }

    function pop_fn_UserInfo_Insert(obj) {
    	if("<%=optCodeIDVector.get(0).toString()%>" != "GRCD001"){
        	heneSwal.warning("관리자만 등록 가능합니다");
        	return false;
        }
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S080101.jsp";
    	var footer = '<button id="btn_Save" class="btn btn-info">저장</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
	}

    function pop_fn_UserInfo_Update(obj) {
    	if(user_id.length < 1){
    		heneSwal.warning("사용자를 선택해주세요");
 			return false;
        } else if("<%=optCodeIDVector.get(0).toString()%>" !="GRCD001"){
        	heneSwal.warning("관리자만 수정 가능합니다");
 			return false;
        }
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S080102.jsp?user_id=" + user_id + "&RevisionNo=" + vRevisionNo;
    	
     	var footer = '<button id="btnUpdate" class="btn btn-info">수정</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    }

    function pop_fn_UserInfo_Delete(obj) {
	    if(user_id.length < 1){
	    	heneSwal.warning("사용자를 선택해주세요");
 			return false;  
        } else if("<%=optCodeIDVector.get(0).toString()%>" !="GRCD001"){
        	heneSwal.warning("관리자만 삭제 가능합니다");
 			return false;
        } else if ("<%=optCodeIDVector.get(0).toString()%>" == group_cd){
        	heneSwal.warning("관리자의 사용자코드는 삭제할 수 없습니다");
 			return false;
    	}
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S080103.jsp?user_id=" + user_id + "&RevisionNo=" + vRevisionNo;
    	
    	var footer = '<button id="btnDelete" class="btn btn-info">삭제</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    	
    }

    </script>
    
     <!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col-->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type="button" onclick="pop_fn_UserInfo_Insert(this)" id="insert" class="btn btn-outline-dark">사용자 등록</button>
			<button type="button" onclick="pop_fn_UserInfo_Update(this)" id="update" class="btn btn-outline-success">사용자 정보 수정</button>
			<button type="button" onclick="pop_fn_UserInfo_Delete(this)" id="delete" class="btn btn-outline-danger">사용자 정보 삭제</button>
      		<label style="width: auto; clear:both; margin-left:30px;">
	            	Rev. No 전체보기
	            	<input type="checkbox" id="total_rev_check"  />
	            </label>		
	            <label style="width: ;  clear:both; margin-left:3px;"></label>
      	</div>
      </div><!-- /.col -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid-->
</div><!--  /.content-header -->

 <!--  Main content-->
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
          <div class="card-body" id="Main_contents"></div>
          
        </div>
      </div> <!--/.col-md-6-->
    </div> <!-- /.row-->
  </div> <!--  /.container-fluid-->
</div><!-- /.content-->