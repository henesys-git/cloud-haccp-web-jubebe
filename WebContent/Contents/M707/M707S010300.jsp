<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	DoyosaeTableModel TableModel;
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
		return;
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
<style>
	canvas {
		-moz-user-select: none;
		-webkit-user-select: none;
		-ms-user-select: none;
	}
	.chart-container {
		width: 70%;
		margin-left: 40px;
		margin-right: 40px;
		margin-bottom: 40px;
	}
	.container {
		display: flex;
		flex-direction: row;
		flex-wrap: wrap;
		justify-content: center;
	}
</style>
<script type="text/javascript">

	var charData = [] ;
	var ctx;
	var ChartName;
    var vChart_Style = $(':input[name="Chart_Style"]:radio:checked').val();
    $(document).ready(function () {
    	new SetSingleDate("dateFrom", -180);
    	new SetSingleDate("dateTo", 1);
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        		
      //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});

        fn_tagProcess();
        
		$("input[name='Chart_Style']").on("change", function(){
			ChartData.type =$(':input[name="Chart_Style"]:radio:checked').val();
		    vChart_Style = $(':input[name="Chart_Style"]:radio:checked').val();
		    horizontalBarChart.update();
	    });

        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();

        fn_MainInfo_List()
        $("#InfoContentTitle").html("품질모니터링");

        var $container = $("#MainInfo_List_contents");
// 		REFRESHTIMEID = setInterval(function()
//          {	
<%-- 			$container.load("<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010300.jsp?From=" + from + "&To=" + to   +"&Chart_Style=" + vChart_Style); --%>
//          }, 60000);
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
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
       
    }

    function fn_MainInfo_List() {
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        var vChart_Style = $(':input[name="Chart_Style"]:radio:checked').val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010300.jsp", 
            data: "From=" + from + "&To=" + to   +"&Chart_Style=" + vChart_Style,
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
    
     <!-- Content Header (Page header) -->
	<div class="content-header">
  		<div class="container-fluid">
    		<div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
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
          			<div class="card-tools">
          	  		 <label style="width: ; float: left; margin-left:3px;"></label>
				<label style="width:auto ; float: left; margin-left:3px; margin-top:8px;"> 모니터링 조회일 </label>
				<input type="text" data-date-format="yyyy-mm-dd" id="dateFrom"  style="width: 100px; float: left; margin-left:3px;margin-top:5px;border: solid 1px #cccccc;"/>
				<label style="width:auto ; float: left; margin-left:3px;margin-top:8px;"> ~ </label>
				<input type="text" data-date-format="yyyy-mm-dd" id="dateTo"  style="width: 100px; float: left; margin-left:3px; margin-top:5px;border: solid 1px #cccccc;" />
				<button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success" 
					style="width: 110px; float: left; margin-left:30px; " >조회</button>
  				<p style="width: auto;  float: left">
				<input type="radio"  id="rdo_QA_report0"  name="Chart_Style" value="line" style="margin-left:20px;margin-top:12px;" > Line</input>
            	<input type="radio"  id="rdo_QA_report1"  name="Chart_Style" value="bar" style="margin-left:20px;margin-top:12px;" checked>Bar</input>
          	  	</div>
          	  </div>
          	</div>
          </div> <!-- /.col-md-6 -->
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div> <!-- /.row -->
   </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
 
 <%--   
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">ㅌㅌㅌㅌㅌ</button>
	            <label style="width: ; float: left; margin-left:3px;"></label>

	            <label style="width:auto ; float: left; margin-left:3px; margin-top:8px;"> 모니터링 조회일 </label>
				<input type="text" data-date-format="yyyy-mm-dd" id="dateFrom"  style="width: 100px; float: left; margin-left:3px;margin-top:5px;border: solid 1px #cccccc;"/>
				<label style="width:auto ; float: left; margin-left:3px;margin-top:8px;"> ~ </label>
				<input type="text" data-date-format="yyyy-mm-dd" id="dateTo"  style="width: 100px; float: left; margin-left:3px; margin-top:5px;border: solid 1px #cccccc;" />
				<button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success" 
					style="width: 110px; float: left; margin-left:30px; " >조회</button>
  				<p style="width: auto;  float: left">
				<input type="radio"  id="rdo_QA_report0"  name="Chart_Style" value="line" style="margin-left:20px;margin-top:12px;" > Line</input>
            	<input type="radio"  id="rdo_QA_report1"  name="Chart_Style" value="bar" style="margin-left:20px;margin-top:12px;" checked>Bar</input>
<!--             	<input type="radio"  id="rdo_QA_report2"  name="Chart_Style" value="radar" style="margin-left:20px;margin-top:12px;" checked>Radar</input> -->
            	</p>
            </div>
            <p style="width: auto; clear:both;">
            </p>

<!--             <div class="panel panel-default"> -->
<!--                 Default panel contents -->
<!--                 <div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>	 -->
<!--         	</div> -->
        	
             <div style="clear:both" id="MainInfo_List_contents" >
             </div>
		</div>
		
--%> 
    </div>