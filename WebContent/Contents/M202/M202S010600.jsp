<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="javax.swing.JComboBox" %>

<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
대체적용품목록(M202S010600)
 */
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
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

//     Vector optCode = new Vector();
//     Vector optName = new Vector();
    String machineNoData[][]= CommonData.machineNumbers;
// 	Vector gijongVector = ProductComboData.getGijongDataAll();
// 	Vector bigGubun = CommonData.getWorkClassCdData();
// 	Vector midGubun = CommonData.getMidClassCdDataAll("GPR02");
%>  

<script type="text/javascript">
	var vPartNo = "";  

    var machineNo ="";
 	
 	

    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);

        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
// 		$("#InfoContentTitle").html("대체원부자재 재고정보");
        
        
	    $("#select_machineNo").on("change", function(){
	    	machineNo = $("#select_machineNo option:selected").val();
// 	        fn_CheckBox_Chaned();
	    });
// 	    $('#select_machineNo')[0].selectedIndex = 2;
    	machineNo = $("#select_machineNo option:selected").val();
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});
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
    
	function fn_CheckBox_Chaned(){	    
		var tr = $($("tableS202S010001 tr")[0]);
		var td = tr.children();

// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		$("input[id='checkbox1']").prop("checked", false);
		$($("input[id='checkbox1']")[0]).prop("checked", true);
		
// 		$(workOrderData).attr("style", "background-color:#ffffff");
// 		tr.attr("style", "background-color:#1c86ee");
	     ProcSeq	= td.eq(10).text().trim();
	     procCD		= td.eq(12).text().trim();
	     bomCode	= td.eq(15).text().trim();
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
        machineNo = $("#select_machineNo option:selected").val();
        console.log(machineNo);
		if(machineNo=="ALL" || machineNo=="전체")
			machineNo="";
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010600.jsp", 
            data: "From=" + from + "&To=" + to  + "&machineNo=" + machineNo,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_bom").children().remove();
        $("#SubInfo_List_contents").children().remove();
    }
        
	function fn_DetailInfo_List() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010510.jsp",
    	        data: "PartNo=" + vPartNo ,
    	        beforeSend: function () {
//     	            //$("#SubInfo_List_contents").children().remove();
    	        },
    	        success: function (html) {
    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}

    //공정추가
    function pop_fn_BauljuInfo_Insert(obj) {
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010600_BauljuInfo_Insert.jsp";
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S010600_BauljuInfo_Insert)", "430px", "800px");
     }

    </script>
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">발주재고관리-자재발주관리</button>
	            	<table style="width: auto; text-align:left; float: left;">
                            <tr>
                            	<td style='width:15%; vertical-align: middle'></td>
                            	<td style='vertical-align: middle'>
                                    <h5>
                                        &nbsp; 창고번호 : &nbsp;</h5>
                                </td>
                                <td> 
                                    <select class="form-control" id="select_machineNo" style="width: 120px">
	                                <%for(int i=0; i<machineNoData.length;i++){ %>
									  <option value='<%=machineNoData[i]%>'><%=machineNoData[i]%></option>
									<%} %>
									</select>
                                </td>
                                                               
                                <td style='width:50%; vertical-align: middle'>
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success"
                                        style="width: 110px;margin-left:20px;">조회</button>
                                </td>
                            </tr>
                        </table>
	            <label style="width: 100px; clear:both; margin-left:3px;"></label>
            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                <div class="panel-body">
                    <div id="MainInfo_List_contents"  style="clear:both; overflow: hidden " >
                    </div>
                </div>
                <div id="tabs">
		         	<ul >
		                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>원부자재상세정보</a></li>
		            </ul>
                    <div id="SubInfo_List_Doc" ></div>
                    <div id="SubInfo_bom" ></div>
                    <div id="SubInfo_List_contents"></div>
                </div>
        	</div>
		</div>
    </div>