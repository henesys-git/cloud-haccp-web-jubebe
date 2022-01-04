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
// 	makeMenu MainMenu = new makeMenu(loginID);

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
// 	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();	

	Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);
// 	Vector midGubun = CommonData.getMidClassCdDataAll("GPR02");
%>

 <script type="text/javascript">
 
 	var vDocGubunDefault = "";
 
 	var vDocGubun 	= "";
 	var vReg_gubun	= "";
 	var vDestroy_no = "";
 	var vRegNo		= "";
 	var vRegNo_rev	= "";
 	var vDocNo		= "";
 	var vDocNo_rev	= "";
 	var vFile_name  = "";
   
    $(document).ready(function () {        
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("폐기 등록 리스트");

    	fn_MainInfo_List();
        
// 	    $("#select_DocGubunCode").on("change", function(){
// 	    	vDocGubun = $(this).val();
// 	        //fn_CheckBox_Chaned();
// 	    });
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
    
    //문서기본정보
    function fn_MainInfo_List() {
        if(vDocGubun=="ALL")
        	vDocGubun="";
        vDocGubun = vDocGubunDefault;
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S060100.jsp",
            data: "DocGubun=" + vDocGubun ,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }

    //문서폐기등록 (PopUp)
    function pop_fn_DocInfo_Insert(obj) {
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S060101.jsp?jspPage=" + '<%=JSPpage%>';
   		
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S606S060101)", footer);
     	heneModal.open_modal();
            
     }
	
    //문서복구
    function pop_fn_DocInfo_Update(obj) {

// 		if(vStatus > GV_PROCESS_DELETE){
<%--     			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 현재 삭제할 수 없는 상태 입니다  !!!!!"); --%>
//     			$('#modalalert').show();
//     			return;
//     	}
 		if(vRegNo.length < 1){
 			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! PO List 하나를 선택하세요!!");
 			return false;
 		}
		
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S060102.jsp?jspPage=" + '<%=JSPpage%>' + "&RegNo=" + vRegNo
    			+ "&DocNo=" + vDocNo + "&File_name=" + vFile_name + "&Destroy_no=" + vDestroy_no + "&RegNo_rev=" + vRegNo_rev 
    			+ "&DocNo_rev=" + vDocNo_rev + "&Reg_gubun=" + vReg_gubun;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S606S060102)", footer);
     	heneModal.open_modal();
        
    }
	//호출되지 않음
	<%--
    function pop_fn_DocInfo_Delete(obj) {
// 		if(vStatus > GV_PROCESS_DELETE){
    	     			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 현재 삭제할 수 없는 상태 입니다  !!!!!");
//    	     			$('#modalalert').show();
//    	     			return;
//    	     	}
//    	 		if(vDocNo.length < 1){
    	 			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> PO List 하나를 선택하세요!!"); 
//    	 			$('#modalalert').show();
//    	 			return;
//    	 		}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S060103.jsp?jspPage=" + '<%=JSPpage%>'+ "&DocNo=" + vDocNo;

        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S060103)", '400px', '550px');
		return false;
    }
 --%>
    //
    function pop_fn_JumunInfo_Comlete(obj) {
// 		if(vDocNo.length < 1){
<%-- 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
    	var modalContentUrl;
    	//상황에 맞게 추후 수정릏 반드시 할 것
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010122.jsp?DocNo=" + vDocNo 
			+ "&jspPage=" + "<%=JSPpage%>";

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S060122)", '400px', '550px');
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
      	  <button type="button" onclick="pop_fn_DocInfo_Insert(this)" id="insert" class="btn btn-outline-dark">문서폐기등록</button>
      	  <button type="button" onclick="pop_fn_DocInfo_Update(this)" id="update" class="btn btn-outline-success">문서복구</button>
      	  
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