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
부족재고현황(M202S010500)
 */
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
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
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	Vector optCodeBig1 = null;
    Vector optNameBig1 = null;
    
    Vector optCodeMid1 = null;
    Vector optNameMid1 = null;
    
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("", member_key);
%>  

<script type="text/javascript">
 	var vPartNo = "";      
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
 	            data: "partgubun_big=" + vPartgubun_big ,
 	            success: function (html) {
 	                $("#PartGubun_Mid > option").remove();
 	                var changMidResult = html.split("|");
 	                for( var i = 0 ; i < changMidResult.length ; i++ ) {
 	                	var value = changMidResult[i].split(",")[0]
 	                	var name  = changMidResult[i].split(",")[1].trim();
 		                $("#PartGubun_Mid").append("<option value = " + value + ">" + name + "</option>");
 	                }
 	                
 	                vPartgubun_mid = $("#PartGubun_Mid >option:eq(0)").val();
 	                
 	                if( $("#PartGubun_Big").val() == "ALL" ) {
 	                	$("#PartGubun_Mid").prepend("<option value = 'ALL'>전체</option>"); 
 	                	$("#PartGubun_Mid > option:eq(0)").prop("selected",true);
 	                	$("#PartGubun_Mid").attr("disabled",true);
 	                	
 	                	vPartgubun_mid = "";
 					} else if( vPartgubun_mid == 'Empty_Value' ) {
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
  	    	
  	    	fn_MainInfo_List();
  	    });
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        fn_MainInfo_List();
        fn_tagProcess('<%=JSPpage%>');
        $("#InfoContentTitle").html("원부재료/자재 부족 재고 현황");
        
	   });

    function fn_tagProcess() {
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
    
	function fn_CheckBox_Chaned() {
		var tr = $($("tableS202S010001 tr")[0]);
		var td = tr.children();

		$("input[id='checkbox1']").prop("checked", false);
		$($("input[id='checkbox1']")[0]).prop("checked", true);
		
	    ProcSeq	= td.eq(10).text().trim();
	    procCD	= td.eq(12).text().trim();
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
		
		$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010500.jsp", 
            data: "partgubun_big=" + vPartgubun_big + "&partgubun_mid="	+ vPartgubun_mid,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
</script>

<!-- 캐시 비적용 -->
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      	</div>
      </div><!-- /.col -->
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
          	  <table>
                     <tr>
                     	
                     	<td style='width:40%; vertical-align: middle;'>원부재료/자재 대분류</td>
                     	<td style='width:10%; vertical-align: middle;'> 
                           <select class="form-control" id="PartGubun_Big" style="width: 120px">
	                            <%	optCodeBig1 =  (Vector)partgubun_bigVector.get(0);%>
		                        <%	optNameBig1 =  (Vector)partgubun_bigVector.get(1);%>
		                        <%	for(int i = 0; i < optNameBig1.size(); i++) { %>
									<option value='<%=optCodeBig1.get(i).toString()%>'>
										 <%=optNameBig1.get(i).toString()%>
									</option>
								<%} %>
						   </select>
                         </td>
                       
                        <td style='width:40%; vertical-align: middle;'>원부재료/자재 중분류</td> 	
                         <td style='width:10%; vertical-align: middle;'>
                         	<select class="form-control" id="PartGubun_Mid" style="width: 120px">
                         		<%	optCodeMid1 =  (Vector)partgubun_midVector.get(0);%>
				                <%	optNameMid1 =  (Vector)partgubun_midVector.get(1);%>
				                <%	for(int i=0; i<optNameMid1.size();i++){ %>
									<option value='<%=optCodeMid1.get(i).toString()%>'>
										<%=optNameMid1.get(i).toString()%>
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
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->