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
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);		

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

 <script type="text/javascript">
	var cust_cd;
	var vRevisionNo	= "";
	var vLog_refno	= ""; //사업장관리번호(이력제)필요한 화면에 추가하여 처리해야함 2019-10-21 JH추가
	var vIoGb		= "";
	var location_nm	= "";
	var FLAG		= false;

    $(document).ready(function () {
    	<%--         makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        $("#InfoContentTitle").html("고객사정보");

    	fn_MainInfo_List();
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
			FLAG = !FLAG;
	    	
	    	if(FLAG) {
	    		alert("등록 / 수정 / 삭제 기능이 제한됩니다.");
	    		
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
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S070100.jsp",
            data: "total_rev_check=" + revCheck  ,
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
                $("#Main_contents").hide().append(html).fadeIn(100);
            }
        });
    }

	function fn_DetailInfo_List() { 
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S100110.jsp",
    	        data: "parent_menu_id=" + parent_menu_id,
    	        success: function (html) {
    	            $("#Main_contents2").html(html);
    	        }
    	    });
		return;
	}   


    function pop_fn_CustInfo_Insert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S070101.jsp";
		var footer = '<button id="btn_Save" class="btn btn-info" style="width:100px"'
							+ 'onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
     }

    function pop_fn_CustInfo_Update(obj) {
    	if(cust_cd.length < 1) {
    		heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 고객사를 선택하세요!!");
 			return false;
        }
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S070102.jsp"
					+ "?cust_cd=" + cust_cd + "&RevisionNo=" + vRevisionNo
					+ "&IoGb=" + vIoGb + "&location_nm=" + location_nm;
		var footer = '<button id="btn_Save" class="btn btn-info" style="width:100px"'
							+ 'onclick="SaveOderInfo();">수정</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
    }

    function pop_fn_CustInfo_Delete(obj) {
    	if(cust_cd.length < 1) {
    		heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 고객사를 선택하세요!!");
 			return false;
        }
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S070103.jsp"
					+ "?cust_cd=" + cust_cd + "&RevisionNo=" + vRevisionNo
					+ "&IoGb=" + vIoGb;
		var footer = '<button id="btn_Save" class="btn btn-info" style="width:100px"'
							+ 'onclick="SaveOderInfo();">삭제</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
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
      		<button type = "button" onclick = "pop_fn_CustInfo_Insert(this)" id="insert" class= "btn btn-outline-dark">고객사등록</button>
			<button type = "button" onclick = "pop_fn_CustInfo_Update(this)" id="update" class= "btn btn-outline-success">고객사수정</button>
			<button type = "button" onclick = "pop_fn_CustInfo_Delete(this)" id="delete" class= "btn btn-outline-danger">고객사삭제</button>
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