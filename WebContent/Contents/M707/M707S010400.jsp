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
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

	<script type="text/javascript" src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/bower_components/Chart.js-2.7.2/dist/Chart.bundle.js"></script> 
	<script type="text/javascript" src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/bower_components/Chart.js-2.7.2/samples/utils.js"></script> 
	<script type="text/javascript" src="<%=Config.this_SERVER_path%>/Contents/Chart/chart_function.js"></script> 

<script type="text/javascript">

	var ctxs;
	var horizontalBarChart
	var charData = [] ;
	var vChart_Style = $(':input[name="Chart_Style"]:radio:checked').val();

    var $container = $("#MainInfo_List_contents");
    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
// 		$("#InfoContentTitle").html("주문처리진척현황");
	    
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});

        fn_tagProcess();

		$("input[name='Chart_Style']").on("change", function(){
			vChart_Style = $(':input[name="Chart_Style"]:radio:checked').val();
			ChartData.type = $(':input[name="Chart_Style"]:radio:checked').val();
			horizontalBarChart.update();
	    });

        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();

        fn_MainInfo_List();
        

		REFRESHTIMEID = setInterval(function(){				
			$container.load("<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010410.jsp?From=" + from + "&To=" + to   +"&Chart_Style=" + vChart_Style);
		}, 60000);
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
    
    function fn_MainInfo_List() {
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();

        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010410.jsp", 
            data: "From=" + from + "&To=" + to + "&Chart_Style=" + vChart_Style,
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
        
	function fn_DetailInfo_List() {  

        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010400.jsp",
                data: "From=" + from + "&To=" + to  ,
    	        beforeSend: function () {
//     	            //$("#MainInfo_List_contents").children().remove();
    	        },
    	        success: function (html) {
    	            $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}

	/*
	new jsPDF(orientation, unit, format) → {jsPDF}
	{
	 orientation: 'p', 	// "portrait" or "landscape" (or shortcuts "p" (Default), "l") 
	 unit: 'mm',		//Possible values are "pt" (points), "mm" (Default), "cm", "in" or "px".
	 format: 'a4',		//Default is "a4". 
	 hotfixes: [] 		// an array of hotfix strings to enable
	}
	*/
	
	
// 	btn_PDF.onclick = function (e) {

// 		var vCanvas = document.getElementById('canvas');
		
// // 		var doc = new jsPDF('l', 'pt', 'c1'); 
// 		var doc = new jsPDF('l','pt',[vCanvas.height ,vCanvas.width]);
// 		var imagData = vCanvas.toDataURL('image/jpg');
// 		canvas_prt = vCanvas.toDataURL('image/png');
// 		doc.addImage(imagData,'JPEG',0,0);
// 		doc.autoPrint({variant: 'javascript'});
// 		var uniqueName = new Date();
// 		doc.save('M707S010400_chart_' + uniqueName.getDate()  + uniqueName.getTime() + '.pdf');		
// 	}
// 	btn_Print.onclick = function (e) {
// 		var dataUrl = document.getElementById('canvas').toDataURL('image/jpg');
// 		var windowContent = '<!DOCTYPE html>';
// 	    windowContent += '<html>'
// 	    windowContent += '<head><title>주문별 공정진척율</title></head>';
// 	    windowContent += '<body>'
// 	    windowContent += '<img src="' + dataUrl + '">';
// 	    windowContent += '</body>';
// 	    windowContent += '</html>';
// 		jQuery.print($(windowContent));
			
// 	}
	
	
    </script>
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">발주재고관리-자재발주관리</button>
<!-- 	            <button data-author="select" type="button" onclick="fn_DetailInfo_List()" id="select" class="btn btn-warning"  -->
<!-- 	            			style="width: auto; float: left; margin-left:30px;">주문처리 진척현황</button> -->
	            <label style="width: ; float: left; margin-left:30px;"></label>
	            <label style="width:auto ; float: left; margin-left:3px; margin-top:8px;">진행일자</label>
				<input type="text" data-date-format="yyyy-mm-dd" id="dateFrom"  style="width: 100px; float: left; margin-left:3px;margin-top:5px;border: solid 1px #cccccc;"/>
				<label style="width:auto ; float: left; margin-left:3px;margin-top:8px;">~ </label>
				<input type="text" data-date-format="yyyy-mm-dd" id="dateTo"  style="width: 100px; float: left; margin-left:3px; margin-top:5px;border: solid 1px #cccccc;" />
				<button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success" 
								style="width: 110px; float: left; margin-left:30px; " >조회</button>
<!-- 				<button type="button"  id="btn_Print" class="btn btn-outline-success"  -->
<!-- 								style="width: 110px; float: left; margin-left:30px; " >To Print</button> -->
<!-- 				<button type="button"  id="btn_PDF" class="btn btn-outline-success"  -->
<!-- 								style="width: 110px; float: left; margin-left:30px; " >To PDF</button> -->
				<p style="width: auto;  float: left"> 
<!-- 				<input type="radio"  id="rdo_QA_report0"  name="Chart_Style" value="horizontalBar" style="margin-left:20px;margin-top:12px;" checked>수평막대</input> -->
				<input type="radio"  id="rdo_QA_report0"  name="Chart_Style" value="line" style="margin-left:20px;margin-top:12px;" > Line</input>
            	<input type="radio"  id="rdo_QA_report1"  name="Chart_Style" value="bar" style="margin-left:20px;margin-top:12px;" checked>Bar</input>
<!--             	<input type="radio"  id="rdo_QA_report2"  name="Chart_Style" value="radar" style="margin-left:20px;margin-top:12px;">거미줄</input> -->
            	</p>
            </div>
             <div id="MainInfo_List_contents"  style="clear:both; " >
             </div>

		</div>
    </div>