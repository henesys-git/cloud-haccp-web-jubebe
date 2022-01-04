<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
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
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

<script type="text/javascript">
 	  
 	
 	var vProcess_regist_no="";
 	
 	
 	

    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
    	
<%--         makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("주문목록(PO List)");

		fn_MainInfo_List();
		
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
        if ($("#ProcessInfo_seolbi").children().length > 0) {
            $("#ProcessInfo_seolbi").children().remove();
        }
        if ($("#ProcessInfo_sibang").children().length > 0) {
            $("#ProcessInfo_sibang").children().remove();
        }
        if ($("#ProcessInfo_processcheck").children().length > 0) {
            $("#ProcessInfo_processcheck").children().remove();
        }        
    }


    function fn_MainInfo_List() {
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
		var custcode = $("#txt_cust_code").val();

        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060500.jsp", 
            data: "custcode=" + custcode + "&From=" + from + "&To=" + to    + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
//                 $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        $("#SubInfo_List_contents").children().remove();
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_BOM").children().remove();
        $("#SubInfo_check").children().remove();
    }
        
	
    </script>
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">ㅌㅌㅌㅌㅌ리</button>

<!-- 	            <label style="width: 100px; clear:both; margin-left:3px;"></label> -->
            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                <!-- Default panel contents -->
                <div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle">xxxxxxx</div>
                <div class="panel-body">
                    <div style="float: left">
                        <table style="width: 100%; text-align:left">
                            <tr>
                            	<td style='vertical-align: middle'>
                                    <h5>
                                        &nbsp; 수행일자 : &nbsp;</h5>
                                </td>
                                <td style='vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control"
                                        style="width: 110px; border: solid 1px #cccccc;"/>
                                </td>
                                <td style='vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control"
                                        style="width: 110px; border: solid 1px #cccccc;" />
                                </td>
                                
                                <td style='vertical-align: middle'>
                                    <h5>
                                       &nbsp;&nbsp;&nbsp; 검색어 : &nbsp;</h5>
                                </td>
                                <td style='vertical-align: middle'>
                                    <input type="text" class="form-control" id="txt_CustName" style="width: 180px; float:left"  />
                                    <input type="hidden" class="form-control" id="txt_cust_code" style="width: 120px" />
                                    <label style="float:left">&nbsp;</label>
                                    <button type="button" onclick="pop_fn_CustName_View(0,'O')" id="btn_SearchCust" class="btn btn-info" style="float:left">
                                        검색</button>
                                </td>                                
                                <td style='vertical-align: middle'>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success"
                                        style="width: 110px;">조회</button>
                                </td>
                            </tr>
                        </table>
                        <p>
                        </p>
                        
                    </div>
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div id="MainInfo_List_contents"  style="clear:both; " >
                    </div>
                </div>

                <div id="tabs">
		         	<ul >
	                	<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>개정이력</a></li>
		                <li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="SubInfo_checklist"  href='#SubInfo_check'>공정확인표(LOT CARS)</a></li>
		            </ul>
                    <div id="SubInfo_List_contents" ></div>
                    <div id="SubInfo_List_Doc" ></div>
                    <div id="SubInfo_BOM" ></div>
                    <div id="SubInfo_check"></div>
                </div>
        	</div>
		</div>
    </div>