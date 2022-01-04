<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
// 	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
		
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

%>

 <script type="text/javascript">
	var seolbi_cd;
	var vRevisionNo	= "";
	var FLAG		= false;
	
	// 캐시 비적용
	<%-- <%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	%> --%>
	
    $(document).ready(function () {
    	<%--         makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("설비정보");

    	fn_MainInfo_List();
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
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S050100.jsp",
            data: "total_rev_check=" + revCheck  ,
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
                $("#Main_contents").hide().append(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }

    function pop_fn_SulbiInfo_Insert(obj) {
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S050101.jsp";
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'auto', title+"(S909S050101)", footer);
     	heneModal.open_modal();
     }

    function pop_fn_SulbiInfo_Update(obj) {

    	if(seolbi_cd.length < 1){
//     	if(seolbi_cd==undefined){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 설비를 선택하세요!!");
	 		return false;
    	}
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S050102.jsp?seolbi_cd=" + seolbi_cd + "&RevisionNo=" + vRevisionNo;
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'auto', title+"(S909S050102)", footer);
     	heneModal.open_modal();
    }

    function pop_fn_SulbiInfo_Delete(obj) {
    	if(seolbi_cd.length < 1){
//     	if(seolbi_cd==undefined){
	    	heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 설비를 선택하세요!!");
	 		return false;
    	}
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S050103.jsp?seolbi_cd=" + seolbi_cd + "&RevisionNo=" + vRevisionNo;
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'auto', title+"(S909S050103)", footer);
     	heneModal.open_modal();
    }

    </script>

<!--     캐시 비적용 -->
    <meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Pragma" content="no-cache"/>
	
	 <!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col-->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type = "button" onclick = "pop_fn_SulbiInfo_Insert(this)" id="insert" class= "btn btn-outline-dark">설비정보등록</button>
			<button type = "button" onclick = "pop_fn_SulbiInfo_Update(this)" id="update" class= "btn btn-outline-success">설비정보수정</button>
			<button type = "button" onclick = "pop_fn_SulbiInfo_Delete(this)" id="delete" class= "btn btn-outline-danger">설비정보삭제</button>
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