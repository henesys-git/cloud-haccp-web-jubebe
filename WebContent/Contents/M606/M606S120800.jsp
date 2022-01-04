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

    $(document).ready(function () {        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("양식정보");

    	fn_MainInfo_List();
        
	    $("#select_DocGubunCode").on("change", function(){
	    	vDocGubun = $(this).val();
	    });

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


    //문서기본정보
    function fn_MainInfo_List() {
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S120800.jsp",
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

    </script>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">여기에메뉴버튼</button>
<!-- 	            <button data-author="insert" type="button" onclick="pop_fn_DocInfo_Insert(this)" id="insert" class="btn btn-default"  -->
<!-- 	            			style="width: auto;float: left; margin-left:30px;" >문서배포등록</button> -->
<!-- 	            <button data-author="update" type="button" onclick="pop_fn_DocInfo_Update(this)" id="update" class="btn btn-outline-success"  -->
<!-- 	            			style="width: auto; float: left; margin-left:3px;">문서배포수정</button> -->
<!-- 	            <button data-author="delete" type="button" onclick="pop_fn_DocInfo_Delete(this)" id="delete" class="btn btn-danger"  -->
<!-- 	            			style="width: auto; float: left; margin-left:3px;">문서배포삭제</button> -->
<!-- 	            <label style="width: ; float: left; margin-left:3px;"></label> -->

	            <label style="width: ;  clear:both; margin-left:3px;"></label>
            </div>
            
            <p style="width: ;  clear:both; margin-left:3px;">
            </p>
            <div class="panel panel-default">
                <!-- Default panel contents -->
                <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">문서기본정보</div>
                <div class="panel-body">
                    
                    <!-- Table --> 					
                    <div  style="clear:both; height:10px" >
                        <p>
                        </p>
                    </div>
                    <div style="clear:both" id="MainInfo_List_contents" >
                    </div>
 
                </div>
                
                
	                <div id="tabs">
			         	<ul >
<!-- 			                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>양식정보</a></li> -->
<!-- 			                <li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>주문문서목록</a></li> -->
<!-- 			                <li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_bom'>주문별BOM</a></li> -->
<!-- 			                <li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="Subinfo_Process_checkList"  href='#Subinfo_Process_check'>공정확인표</a></li> -->
			            </ul>
	                    <div id="SubInfo_List_contents"></div>
	                    <div id="SubInfo_List_Doc" ></div>
<!-- 	                    <div id="SubInfo_bom" ></div> -->
<!-- 	                    <div id="Subinfo_Process_check"></div> -->
	                </div>
            </div>
        </div>
    </div>
