<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
/* 
비금속성 이물관리
 */
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
	
	
// 	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
// 	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

 <script type="text/javascript">
 	
	var vCheckDate 		= "";

    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("점검목록");

		fn_MainInfo_List();
<%-- 		fn_HACCP_View("<%=sMenuTitle%>","<%=sProgramId%>"); --%>
        		
		//탭 클릭시 처리하는 Function
        //$( function() {$( "#tabs" ).tabs();});

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


    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }
    }
        
    //주문기본정보
    function fn_MainInfo_List() {
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070800.jsp",
            data: "From=" + from + "&To=" + to,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
                $("#SubInfo_List_contents").children().remove();
            },
            error: function (xhr, option, error) {

            }
        });
    }
    
    function fn_HACCP_View_Canvas(obj) {
    	vCheckDate	= $(obj).parent().parent().find("td").eq(1).text().trim();
    	
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070800_canvas.jsp" 
    						 + "?check_date=" + vCheckDate
    						 + "&check_gubun=" + "<%=GV_GET_NUM_PREFIX%>" ;
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S070800_canvas)", '750px', '1260px');
		return false;
    }
    
    function fn_DetailInfo_List() {    	
		$.ajax(
		{
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070810.jsp",
			data: "check_date=" + vCheckDate,
			beforeSend: function () {
// 				$("#SubInfo_List_contents").children().remove();
			},
			success: function (html) {
				$("#SubInfo_List_contents").hide().html(html).fadeIn(100);
			},
			error: function (xhr, option, error) {
	
			}
		});
	}
    
 	// 비금속성 이물관리 등록(팝업창)
    function pop_fn_NMTAL_Check_Insert(obj) {
		var pageUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070801.jsp";
    	var paramData = "check_gubun=" + "<%=GV_GET_NUM_PREFIX%>";
    	var pageTitle = obj.innerText+"(S838S070801)";
    			
		$('#pageUrl').val(pageUrl);
   		$('#paramData').val(paramData);
   		$('#pageTitle').val(pageTitle);
   		
   		window.open("<%=Config.this_SERVER_path%>/Contents/CommonView/popupPage.jsp", 
   				"popup_window", ",top=0, left=0, width=1500, height=900,fullscreen=yes, toolbars=no, status=no, scrollbars=no,resizable=yes,titlebar=no, location=no");
		$("#haccpPopform").submit();
    }
 
    </script>

 
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
<!--         Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
            <div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">zzzzzzz</button>
<%-- 	            <button data-author="select" type="button" onclick="fn_HACCP_View('<%=sMenuTitle%>','<%=sProgramId%>')" id="select" class="btn btn-outline-success"  --%>
<!-- 	            			style="width: auto;float: left; margin-left:30px;" >비금속성 이물관리 (양식)</button> -->
	            <button data-author="insert" type="button" onclick="pop_fn_NMTAL_Check_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">비금속성 이물관리 등록</button>
	            <label style="width: ;  clear:both; margin-left:3px;"></label>
            </div>
            <p style="width: auto; clear:both;">
            </p>
            <div class="panel panel-default">
<!--                 Default panel contents -->
                <div class="panel-body">
                    <div style="float:left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>점검일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                <td style="width:62%; text-align:left">
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='margin-left:10px; width:100px'>조 회</button>
                                </td>
                            </tr>
                        </table>
                        <p>
                        </p>
                    </div>				
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div style="clear:both" id="MainInfo_List_contents" >
                    </div>
                </div>
                
                <div id="tabs">
		         	<ul >
		         		<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>점검상세정보</a></li>
		            </ul>
                    <div id="SubInfo_List_contents"></div>
                </div>
	        	
            </div>
        </div>
    </div>
