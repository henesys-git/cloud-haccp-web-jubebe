<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
원부자재재고현황
 */
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
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
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
    
    Vector optCode =  null;
    Vector optName =  null;
    
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("", member_key);
%>  

<script type="text/javascript">
	var vPartNo = "";  
	var vPartRev = "";
	var vPartgubun_big	= "";
	var vPartgubun_mid	= "";

    $(document).ready(function () {
    	
    	$("#PartGubun_Mid").attr("disabled", true);
    	
    	$("#PartGubun_Big").on("change", function(){
    		vPartgubun_big = $(this).val();
    		
    		if(vPartgubun_big == "ALL") {
				vPartgubun_big = "";
    		}
	    
	    	 $.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S050250.jsp",
	            <%-- url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp", --%>
	            data: "partgubun_big=" + vPartgubun_big ,
	            success: function (html) {
	                $("#PartGubun_Mid > option").remove();
	                var changMidResult = html.split("|");
	                for( var i = 0 ; i < changMidResult.length ; i++ ) {
	                	var value = changMidResult[i].split(",")[0]
	                	var name  = changMidResult[i].split(",")[1].trim();
		                $("#PartGubun_Mid").append("<option value="+value+">"+name+"</option>");
	                }
	                
	                vPartgubun_mid = $("#PartGubun_Mid >option:eq(0)").val();
	                
	                if( $("#PartGubun_Big").val() == "ALL" ) {
	                	$("#PartGubun_Mid").prepend("<option value='ALL'>전체</option>"); 
	                	$("#PartGubun_Mid > option:eq(0)").prop("selected",true);
	                	$("#PartGubun_Mid").attr("disabled",true);
	                	
	                	vPartgubun_mid = "";
					}
	                
	                //vPartgubun_mid=$("#partgubun_mid >option:eq(0)").val();
	                
	                 else if( vPartgubun_mid == 'Empty_Value' ) {
		            	$("#PartGubun_Mid").attr("disabled",true);
	                } else {
		            	$("#PartGubun_Mid").attr("disabled",false);
	                } 
		                
	    			fn_MainInfo_List();
 		    	}
    		});
	    });
    	
    	 $("#PartGubun_Mid").on("change", function() {
 	    	vPartgubun_big = $("#PartGubun_Big").val();
 	    	vPartgubun_mid = $(this).val();
 	    	
 	    	if($("#partgubun_mid").val()=="ALL") {
	    		fn_MainInfo_List();
	    		return;
 	    	}
 	    	
 	    	fn_MainInfo_List();
 	    });
    	
    	new SetSingleDate("dateFrom", -180);
    	new SetSingleDate("dateTo", 0);
		
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		fn_MainInfo_List();

        fn_tagProcess('<%=JSPpage%>');
        $("#InfoContentTitle").html("원부자재재고현황");
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

    function fn_MainInfo_List(startDate, endDate) {
        
		var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S050200.jsp", 
            data: "From=" + from + "&To=" + to + "&partgubun_big=" + vPartgubun_big
				  + "&partgubun_mid=" + vPartgubun_mid,  
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
		});
        
        $("#SubInfo_List_contents").children().remove();         
    }
        
	function fn_DetailInfo_List() {     
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010510.jsp",
   	        data: "PartNo=" + vPartNo + "&PartRev=" + vPartRev  ,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
    	});
		
    	//return;
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
      	<div class="float-sm-left">
      		
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
          	<div class ="card-tools">
				 <table>
                     <tr>
                     	
                     	<td style='width:40%; vertical-align: middle;'>원부재료/자재 대분류</td>
                     	<td style='width:10%; vertical-align: middle;'> 
                           <select class="form-control" id="PartGubun_Big" style="width: 120px">
	                            <%	optCode =  (Vector)partgubun_bigVector.get(0);%>
		                        <%	optName =  (Vector)partgubun_bigVector.get(1);%>
		                        <%	for(int i = 0; i < optName.size(); i++) { %>
									<option value='<%=optCode.get(i).toString()%>'>
										 <%=optName.get(i).toString()%>
									</option>
								<%} %>
						   </select>
                         </td>
                       
                        <td style='width:40%; vertical-align: middle;'>원부재료/자재 중분류</td> 	
                         <td style='width:10%; vertical-align: middle;'>
                         	<select class="form-control" id="PartGubun_Mid" style="width: 120px">
                         		<%	optCode =  (Vector)partgubun_midVector.get(0);%>
				                <%	optName =  (Vector)partgubun_midVector.get(1);%>
				                <%	for(int i=0; i<optName.size();i++){ %>
									<option value='<%=optCode.get(i).toString()%>'>
										<%=optName.get(i).toString()%>
									</option>
								<%	} %>
							</select>
                         </td>
                  	</tr>
                 </table>       	
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
    <div class="card card-primary card-outline">
    	<div class="card-header">
    		<h3 class="card-title">
    			<i class="fas fa-edit">세부 정보</i>
    		</h3>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">원부자재상세정보</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     	</div>
        </div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->   