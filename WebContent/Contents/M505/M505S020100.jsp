<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}
// 	makeMenu MainMenu = new makeMenu(loginID);

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
// 	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

%>

 <script type="text/javascript">
	var vSeolbiCd="";
	var vSeqNo="";
	var vRevisionNo="";

    $(document).ready(function () {
    	<%--         makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("측정장비목록");
		$("#JumunInfoContentTitle2").html("측정장비관리이력");

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
        
    //측정장비정보
    function fn_MainInfo_List() {
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M505/S505S020100.jsp",
	        data: "SeolbiCd=" + vSeolbiCd ,
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
                $("#Main_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }

	function fn_DetailInfo_List() {
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M505/S505S020110.jsp",
    	        data: "SeolbiCd=" + vSeolbiCd +"&RevisionNo=" + vRevisionNo ,
    	        beforeSend: function () {
//     	            $("#ProcessInfo_bom").children().remove();
    	        },
    	        success: function (html) {
    	            $("#Main_contents2").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}   


    function pop_fn_SeolbiInfo_Insert(obj) {
    	
    	if(vSeolbiCd.length < 1){
    		heneSwal.warning("상단 측정장비목록 설비정보 중 하나를 선택하세요  !!!");
 			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M505/S505S020111.jsp?SeolbiCd=" + vSeolbiCd + "&RevisionNo=" + vRevisionNo;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S505S020111)", footer);
     	heneModal.open_modal();
     	
     }

    function pop_fn_SeolbiInfo_Update(obj) {
    	if(vSeolbiCd.length < 1){
    		heneSwal.warning("하단 측정장비관리이력 정보 중 하나를 선택하세요  !!!");
 			return false;
		}
    	if(vSeqNo.length < 1){
    		heneSwal.warning("하단 측정장비관리이력 정보 중 하나를 선택하세요  !!!");
 			return false;
		}
    	var modalContentUrl;
    	//alert("aaa-program_id=" + program_id);
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M505/S505S020112.jsp?SeolbiCd=" + vSeolbiCd + "&SeqNo=" + vSeqNo + "&RevisionNo=" + vRevisionNo;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S505S020112)", footer);
     	heneModal.open_modal();
    	
    }

    function pop_fn_SeolbiInfo_Delete(obj) {
    	if(vSeolbiCd.length < 1){
    		heneSwal.warning("하단 측정장비관리이력 정보 중 하나를 선택하세요  !!!");
 			return false;
		}
    	if(vSeqNo.length < 1){
    		heneSwal.warning("하단 측정장비관리이력 정보 중 하나를 선택하세요  !!!");
 			return false;
		}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M505/S505S020113.jsp?SeolbiCd=" + vSeolbiCd + "&SeqNo=" + vSeqNo + "&RevisionNo=" + vRevisionNo;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S505S020113)", footer);
     	heneModal.open_modal();
    }

    function pop_fn_MeasureDetail_Info(obj) {
    	if(vSeolbiCd.length < 1){
    		heneSwal.warning("상단 측정장비목록 설비정보 중 하나를 선택하세요  !!!");
 			return false;
		}
    	// S909S050104.jsp를 호출하다보니 파라미터이름을 그에 맞게 맞춰줘야한다.
       	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S050104.jsp?seolbi_cd=" + vSeolbiCd + "&RevisionNo=" + vRevisionNo;
		
       	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'xlarge', title+"(S909S050104)", footer);
     	heneModal.open_modal();
       	
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
      	  <button type="button" onclick="pop_fn_MeasureDetail_Info(this)" id="insert" class="btn btn-outline-dark">측정장비상세조회</button>
      	  <button type="button" onclick="pop_fn_SeolbiInfo_Insert(this)" id="insert" class="btn btn-outline-dark">측정장비관리이력등록</button>
      	  <button type="button" onclick="pop_fn_SeolbiInfo_Update(this)" id="update" class="btn btn-outline-success">측정장비관리이력수정</button>
      	  <button type="button" onclick="pop_fn_SeolbiInfo_Delete(this)" id="delete" class="btn btn-outline-danger">측정장비관리이력관리삭제</button>
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
          <div class="card-body" id="Main_contents"></div>
          </div>
         </div> <!-- /.col-md-12 -->
      				
      
    </div> <!-- /.row -->
    		<div class="card card-primary card-outline">
      				<div class="card-header">
          					<h3 class="card-title">
          						<i class="fas fa-edit" id="JumunInfoContentTitle2">세부 정보</i>
          					</h3>
          			</div>
          			<div class="card-body" id="Main_contents2"></div>
          	</div>		
   </div> <!-- /.container-fluid -->
  </div> <!-- /.content -->
