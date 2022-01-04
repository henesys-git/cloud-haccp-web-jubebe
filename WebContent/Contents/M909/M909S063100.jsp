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
// 	makeMenu MainMenu = new makeMenu(loginID);

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
	var vProdCd="";
	var vProdCdRev="";
	var vProdNm="";
	var vPartCd="";
	var vPartCdRev="";

    $(document).ready(function () {
    	<%--         makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        $("#InfoContentTitle").html("제품목록");

    	fn_MainInfo_List();
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
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

    //BOM정보
    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked");
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S063100.jsp",
	        data: "total_rev_check="	+ revCheck ,
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
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S063110.jsp",
    	        data: "prod_cd=" + vProdCd +"&prod_cd_rev=" + vProdCdRev ,
    	        beforeSend: function () {
//     	            $("#Main_contents2").children().remove();
    	        },
    	        success: function (html) {
    	            $("#Main_contents2").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}   


    function pop_fn_SubPart_Insert(obj) {
    	if (vProdCd.length < 1) {
    		alert("제품을 선택하세요");
    		return false;
    	}

    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S063101.jsp"
    					+ "?prod_cd=" + vProdCd 
    					+ "&prod_cd_rev=" + vProdCdRev
    					+ "&prod_nm=" + vProdNm;
    	    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S063101)", "400px", "680px");
     }

    function pop_fn_SubPart_Update(obj) {
    	if (vPartCd.length < 1) {
    		alert("제품별 부자재를 선택하세요");
    		return false;
    	}
    	
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S063102.jsp"
			    		+ "?prod_cd=" + vProdCd 
						+ "&prod_cd_rev=" + vProdCdRev
    					+ "&part_cd=" + vPartCd
    					+ "&part_cd_rev=" + vPartCdRev;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S063102)", "450px", "680px");
		return false;
    }

    function pop_fn_SubPart_Delete(obj) {
    	if (vPartCd.length < 1) {
    		alert("제품별 부자재를 선택하세요");
    		return false;
    	}
    	
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S063103.jsp"
			    		+ "?prod_cd=" + vProdCd 
						+ "&prod_cd_rev=" + vProdCdRev
						+ "&part_cd=" + vPartCd
						+ "&part_cd_rev=" + vPartCdRev;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S063103)", "450px", "680px");
		return false;
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
      		<button type = "button" onclick = "pop_fn_SubPart_Insert(this)" id="insert" class= "btn btn-outline-dark">제품별 부자재 등록</button>
			<button type = "button" onclick = "pop_fn_SubPart_Update(this)" id="update" class= "btn btn-outline-success">제품별 부자재 수정</button>
			<button type = "button" onclick = "pop_fn_SubPart_Delete(this)" id="delete" class= "btn btn-outline-danger">제품별 부자재 삭제</button>
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

    <!-- <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        Default panel contents
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에타이틀</div>
        <div class="panel-body">
            <div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">기준관리-제품별부자재관리</button>
	            <button data-author="insert" type="button" onclick="pop_fn_SubPart_Insert(this)" id="insert" class="btn btn-warning" 
	            			style="width: auto; float: left; margin-left:30px;">제품별 부자재 등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_SubPart_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">제품별 부자재 수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_SubPart_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; clear:both;  margin-left:3px;">제품별 부자재 삭제</button>
	            <label style="width: auto; clear:both; margin-left:30px;">
	            	Rev. No 전체보기
	            	<input type="checkbox" id="total_rev_check"  />
	            </label>
            </div>
            <p style="width: auto; clear:both;">
            </p>
            <div class="panel panel-default">
                Default panel contents
                <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">BOM코드목록</div>
                <div class="panel-body">
                    <div style="clear:both" id="Main_contents" >
                    </div>
                </div>
                
                <div class="panel-heading" style="font-size:16px; font-weight: bold " id="JumunInfoContentTitle2">제품별 부자재 목록</div>
                <div class="panel-body">
                    <div id="Main_contents2">
                    </div>
            	</div>
            </div>
        </div>
    </div> -->
