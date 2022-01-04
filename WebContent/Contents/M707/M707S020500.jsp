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

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

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

	var ctx;
	var horizontalBarChart
//	var barChartData = [] ;
	var vChart_Style = $(':input[name="Chart_Style"]:radio:checked').val();

    $(document).ready(function () {
    	new SetSingleDate("dateFrom", -180);
    	new SetSingleDate("dateTo", 0);
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		/* $("#InfoContentTitle").html("주문제품별 납기준수율 현황"); */
		fn_MainInfo_List();
		
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});

        fn_tagProcess();
	    
        $("input[name='Chart_Style']").on("change", function(){
        	ChartData.type =$(':input[name="Chart_Style"]:radio:checked').val();
// 			vChart_Style = $(':input[name="Chart_Style"]:radio:checked').val();
			horizontalBarChart.update();
	    });
        
        $("#dateFrom").change(function(){
			var date = $(this).val();
			var year = parseInt(date.split("-")[0]);
			var month = parseInt(date.split("-")[1]);
        	var day = parseInt(date.split("-")[2]);  
        	fromday = new Date(year, month-1, day);

        	today = new Date(fromday);
        	today.setDate(today.getDate() + 30);
        	$('#dateTo').datepicker('update', today); 
        });
        
        $("#dateTo").change(function(){
			var date = $(this).val();
			var year = parseInt(date.split("-")[0]);
			var month = parseInt(date.split("-")[1]);
        	var day = parseInt(date.split("-")[2]);  
        	today = new Date(year, month-1, day);

        	fromday = new Date(today);
        	fromday.setDate(fromday.getDate() - 30);
        	$('#dateFrom').datepicker('update', fromday); 
        });
        
        $("#InfoContentTitle").html("납기준수율 모니터링");
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
        var vChart_Style = $(':input[name="Chart_Style"]:radio:checked').val();

        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S020500.jsp", 
            data: "From=" + from + "&To=" + to + "&Chart_Style=" + vChart_Style ,
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
          	  		 <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:15%; vertical-align: middle;'>

                            	</td>
                            	<td style='width:10%; vertical-align: middle'>생산시작일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                                               


                                <td style='width:55%;vertical-align: middle ;text-align: left;'>

                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='margin-top: 12px; margin-left:30px;float:left'>조 회</button>
                                    <p style="width: auto;  float: left">
										<input type="radio"  id="rdo_QA_report0"  name="Chart_Style" value="line" style="margin-left:20px;margin-top:10px;" >Line Chart</input>
            							<input type="radio"  id="rdo_QA_report1"  name="Chart_Style" value="bar" style="margin-left:20px;margin-top:10px;" checked>Bar Chart</input>
            						</p>
                                 </td>  
                                
                            </tr>
                        </table>
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
        
<!--         	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">발주재고관리-자재발주관리</button>

	            <label style="width: 100px; clear:both; margin-left:3px;"></label>
            </div> -->
<!--             <p style="width: auto; clear:both;">
            </p> -->

            <div class="panel panel-default">
                <!-- Default panel contents -->
<!--                 <div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle">자재발주정보</div> -->
                <div class="panel-body">
                    <div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:15%; vertical-align: middle;'>
                            		<!-- <div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div> -->
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>출하완료일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                <td style = 'width:55%; vertical-align:middle; text-align:left;'>
<!--                                         	원부자재사 검색</button>  -->
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='width: 110px; margin-top:12px; margin-left:30px; float:left'>조 회</button>
                                    <p style="width: auto;  float: left">
									<input type="radio"  id="rdo_QA_report0"  name="Chart_Style" value="line" style="margin-left:20px;margin-top:12px;" > Line Chart</input>
            						<input type="radio"  id="rdo_QA_report1"  name="Chart_Style" value="bar" style="margin-left:20px;margin-top:12px;" checked>Bar Chart</input>
            						</p>
                                 </td>                                  
                            </tr>
                        </table>
<!--                         <p>
                        </p> -->
                        
                    </div>
 					<div style = "clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div id="MainInfo_List_contents" style="clear:both;">
                    </div>
                </div>


        	</div>
		</div>
    </div>
 --%>