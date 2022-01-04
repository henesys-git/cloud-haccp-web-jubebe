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
	
	Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);
	
%>

 <script type="text/javascript">
 	var vDocGubunDefault = "";
 
 	var vDocGubun			= "";
 	var vDistribute_no		= "";
 	var vDocument_no		= "";
 	var vRegist_no			= "";
 	var vRegist_no_rev		= "";
 	
    $(document).ready(function () {
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("배포문서정보");

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

 
    //등록문서정보
    function fn_MainInfo_List() {
    	//버그 방지용////////////
    	vDocGubun = vDocGubunDefault;
    	////////////////////
        if(vDocGubun == "ALL")
        	vDocGubun="";
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S040100.jsp",
            data: "DocGubun_code=" + vDocGubun + "&jspPageName=" + "<%=JSPpage%>" ,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    //배포 등록
    function pop_fn_DocInfo_Insert(obj) {
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S040101.jsp?jspPage=" + '<%=JSPpage%>' ;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
     	heneModal.open_modal();
    	
     }

    //문서 수정
    function pop_fn_DocInfo_Update(obj) {

 		/* if(vRegist_no.length < 1){
 			heneSwal.warning("PO List 하나를 선택하세요");
 			return false;
 		} */
		
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S040102.jsp?jspPage=" + '<%=JSPpage%>'
    			+ "&Distribute_no=" + vDistribute_no  + "&Gubun_code=" + vDocGubun + "&Document_no=" + vDocument_no
    			+ "&Regist_no=" + vRegist_no + "&Regist_no_rev=" + vRegist_no_rev ;
		
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S606S040102)", footer);
     	heneModal.open_modal();
    	
    }
    

    function pop_fn_DocInfo_Delete(obj) {
 	 	/* if(vRegist_no.length < 1){
 	 		heneSwal.warning("PO List 하나를 선택하세요");
 	 		return false;
	 	} */
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S040103.jsp?jspPage=" + '<%=JSPpage%>'
		+ "&Distribute_no=" + vDistribute_no  + "&Gubun_code=" + vDocGubun + "&Document_no=" + vDocument_no
		+ "&Regist_no=" + vRegist_no + "&Regist_no_rev=" + vRegist_no_rev  ;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S606S040103)", footer);
     	heneModal.open_modal();
    	
    }

    //
    function pop_fn_JumunInfo_Comlete(obj) {
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S040103.jsp?jspPage=" + '<%=JSPpage%>'
		+ "&Distribute_no=" + vDistribute_no  + "&Gubun_code=" + vDocGubun + "&Document_no=" + vDocument_no
		+ "&Regist_no=" + vRegist_no + "&Regist_no_rev=" + vRegist_no_rev  ;
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S040122)", '400px', '550px');
		return false;
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
      	  <button type="button" onclick="pop_fn_DocInfo_Insert(this)" id="insert" class="btn btn-outline-dark">문서배포등록</button>
      	  <button type="button" onclick="pop_fn_DocInfo_Update(this)" id="update" class="btn btn-outline-success">문서배포수정</button>
      	  <button type="button" onclick="pop_fn_DocInfo_Delete(this)" id="delete" class="btn btn-outline-danger">문서배포삭제</button>
      	 
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
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
    
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->