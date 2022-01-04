<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
출고/출하 집계표 조회
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
	
	Vector LocationCode = null;
	Vector LocationName = null;
	Vector LocationVector = CommonData.getDeliverLocation();
	
	

%>  
<style>

table {
  border-spacing: 10px;
  border-collapse: separate;
}

</style>

<script type="text/javascript">

	var vChulhaNo = "";
	var vChulhaRevNo = "";
	var vChulhaDate = "";
	var vOrderNo = "";

	var location_nm = "";
	var toDate = "";
	
    $(document).ready(function () {
	  	
    	new SetSingleDate2("", "#dateRange", 0);
    	
    	toDate = $("#dateRange").val();
    	
    	
		$("#InfoContentTitle").html("출하 목록");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");        	
	    fn_tagProcess();
	    
	    fn_MainInfo_List(toDate);
	    
	    $("#select_Location").on("change", function() {
	    
	    location_type = $(this).val();
	    toDate = $("#dateRange").val();
	 	fn_MainInfo_List(toDate);
	 	return;
	 	   
	   	});
	    
	    $('#dateRange').change(function() {
	    	toDate = $("#dateRange").val();
           	fn_MainInfo_List(toDate);
        });
	    
		$("#btn_Search").on("click", function(){
			toDate = $("#dateRange").val();
	    	fn_MainInfo_List(toDate);
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

    function fn_MainInfo_List(toDate) {
    	
    	var location_type = $("#select_Location").val();
    	toDate = $("#dateRange").val();
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010400.jsp",
            data : "location_type=" + location_type + "&toDate=" + toDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }
    
	function fn_DetailInfo_List() {    	
    
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010410.jsp",
            data: "chulhaNo=" + vChulhaNo + "&chulhaRevNo=" + vChulhaRevNo
            	 + "&orderNo=" + vOrderNo,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
	        error: function (xhr, option, error) {
	        }
        });
    }
	
	
	 // 출고집계표 조회
    function displaychulgo(element) {
    	
    	location_type = $("#select_Location").val();
    	location_type_nm = $("#select_Location option:selected").text().trim();
    	chulha_date = $("#dateRange").val();
    	
    			const format = 'images/chulha/20210423_chulgo_doc_img.jpg';	// 이미지 파일
    			const page = '/Contents/Business/M858/S858S010401.jsp';		// jsp 페이지
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    					+ '?format=' + format
			    				+ '&location_type=' + location_type
			    				+ '&location_type_nm=' + location_type_nm
			    				+ '&chulha_date=' + chulha_date;
		    				   
				const footer = "<button type='button' class='btn btn-outline-primary'"
					 + "onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		
    }
	 
    // 출하집계표 조회
    function displaychulha(element) {
    	
    	location_type = $("#select_Location").val();
    	chulha_date = $("#dateRange").val();
    			const format = 'images/chulha/20210525_chulha_doc_img.jpg';	// 이미지 파일
    			const page = '/Contents/Business/M858/S858S010402.jsp';	// jsp 페이지
    			
    			console.log('이미지파일:' + format);
    			console.log('JSP페이지:' + page);
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    					+ '?format=' + format
			    				+ '&location_type=' + location_type
			    				+ '&chulha_date=' + chulha_date;
		    				   
				const footer = "<button type='button' class='btn btn-outline-primary'"
					 + "onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		
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
      	<div class="float-sm-right">
      		<button type="button" onclick="displaychulgo(this)" id="select" class="btn btn-outline-dark">출고집계표 조회</button>
			<button type="button" onclick="displaychulha(this)" id="select" class="btn btn-outline-dark">출하집계표 조회</button>
      	</div>
      </div><!-- /.col -->
     </div> <!-- /.row -->
	</div> <!-- /.container-fluid -->
  </div> <!-- /.content-header -->
    
    
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
          			<div class="input-group input-group-sm">
          				
          		<div class="input-group float-right" id="dateParent">
          					
          			<table>
          				<tr>
          				
          				<td>구분</td>
          				
                			<td>
	              				<select class="form-control" id="select_Location">
									<% LocationCode = (Vector)LocationVector.get(1);%>
									<% LocationName = (Vector)LocationVector.get(2);%>
										<% for(int i=0; i<LocationName.size();i++){ %>
									<option value='<%=LocationCode.get(i).toString()%>'>
									<%=LocationName.get(i).toString()%>
									</option>
									<% } %>
								</select>
							</td>
							
							<td>일자<td>
							<td>
							<div class="input-group">
								<input type="text" class="form-control float-right" id="dateRange">
							</div>
							</td>
							<td>
								<button type="button" id="btn_Search" class="btn btn-default">
										<i class="fas fa-search"></i>
									</button>
							</td>
						</tr>
          				</table>
	          	  		</div>	
          			</div>
		          </div>
					</div>
					<div class="card-body" id="MainInfo_List_contents">
					</div> 
				</div>
			</div> <!-- /.col-md-6 -->
		</div> <!-- /.row -->
		
		<div class="card card-primary card-outline">
	   	<div class="card-header">
	   		<h3 class="card-title">
	   			<i class="fas fa-edit">세부 정보</i>
	   		</h3>
	   	</div>
	   	<div class="card-body" id="SubInfo_List_contents"></div>
	  </div>
	</div> <!-- /.container-fluid -->
</div> <!-- /.content -->