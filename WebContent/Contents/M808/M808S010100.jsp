<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%

/* 
yumsam
CCP데이터관리(M808S010100.jsp)
 */
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect("../index.jsp");    // 로그인 페이지로 리다이렉트 한다.
		return;
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	Vector optName = null;
    Vector optType = null;
    Vector optLocation = null;

	String[] strArr = {"TEMPERATURE","SOURCE"};
	
    Vector Censor_gubunVector_Name = CommonData.getCensorGubun_Name(strArr);
    Vector Censor_gubunVector_Type = CommonData.getCensorGubun_Type(strArr);
    Vector Censor_gubunVector_Location = CommonData.getCensorGubun_Location(strArr);
%>

<script type="text/javascript">
	var vCheckGubunName	= "";
	var vCheckGubunType	= "";
	var vCheckGubunLocation	= "";
	var vCheckGubunBreakaway = "";
	var startDate;
	var endDate;
 	
    $(document).ready(function () {
        
        var date = new SetRangeDate("dateParent", "dateRange", 7);
    	startDate = date.start.format('YYYY-MM-DD');
       	endDate = date.end.format('YYYY-MM-DD');
	    
       	fn_MainInfo_List(startDate, endDate);
    	
        $('#dateRange').change(function() {
           	fn_MainInfo_List(startDate, endDate);
        });
      	
    	$("#InfoContentTitle").html("CCP 데이터 목록");
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        fn_tagProcess();
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
    
    function fn_MainInfo_List(startDate, endDate) {
    	
    	vCheckGubunName = $("#select_check_gubun_name").val();
        if(vCheckGubunName=="전체") 
        	vCheckGubunName="";
        
        vCheckGubunType = $("#select_check_gubun_type").val();
        if(vCheckGubunType=="전체") 
        	vCheckGubunType="";
        
        vCheckGubunLocation = $("#select_check_gubun_location").val();
        if(vCheckGubunLocation=="전체") 
        	vCheckGubunLocation="";
        
        vCheckGubunBreakaway = $("#select_check_gubun_breakaway").val();
        
        $.ajax({
			type: "POST",
           	url: "<%=Config.this_SERVER_path%>/Contents/Business/M808/S808S010100.jsp",
           	data: "From=" + startDate + "&To=" + endDate + 
           		  "&CheckGubunName=" + vCheckGubunName +
           		  "&CheckGubunType=" + vCheckGubunType +
           		  "&CheckGubunLocation=" + vCheckGubunLocation +
           		  "&CheckGubunBreakaway=" + vCheckGubunBreakaway,
           	success: function (html) {
           		$("#MainInfo_List_contents").hide().html(html).fadeIn(100);
           	}
		});    	
    }
</script>
<style>
.form-inline {
	margin-right: 2%;
}

.row {
	align-items: center;
}

label:[name^='select_check_gubun']{
	width:75px;
}
</style>
<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">메뉴 타이틀</h1>
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
						<div class="row">
							<div class="col-sm-2 card-title">
								<i class="fas fa-edit" id="InfoContentTitle"></i>
							</div>
							<div class="col-sm-8">
								<div class="row">
									<div class="form-inline">
										<label for="select_check_gubun_name">센서명:</label>
										<select class="form-control ml-3" id="select_check_gubun_name" name="check_gubun_name">
											<%optName = (Vector)Censor_gubunVector_Name.get(0);%>
										    <%for(int i=0; i<optName.size();i++){ %>
												<option value='<%=optName.get(i).toString()%>'>
													<%=optName.get(i).toString()%>
												</option>
											<%} %>
										</select>
									</div>
									<div class="form-inline">
										<label for="select_check_gubun_type">센서종류:</label>
										<select class="form-control ml-3" id="select_check_gubun_type" name="check_gubun_type">
											<%optType = (Vector)Censor_gubunVector_Type.get(0);%>
										    <%for(int i=0; i<optType.size();i++){ %>
												<option value='<%=optType.get(i).toString()%>'>
													<%=optType.get(i).toString()%>
												</option>
											<%} %>
										</select>
									</div>
									<div class="form-inline">
										<label for="select_check_gubun_location">센서위치:</label>
										<select class="form-control ml-2" id="select_check_gubun_location" name="check_gubun_location">
											<%optLocation = (Vector)Censor_gubunVector_Location.get(0);%>
											<%for(int i=0; i<optLocation.size();i++){ %>
												<option value='<%=optLocation.get(i).toString()%>'>
													<%=optLocation.get(i).toString()%>
												</option>
											<%} %>
										</select>
									</div>
									<div class="form-inline">
										<label for="select_check_gubun_breakaway">정상/이탈:</label>
										<select class="form-control ml-2" id="select_check_gubun_breakaway" name="select_check_gubun_breakaway" style = "width:93px;">
											<option value=''>전체</option>
											<option value='0'>정상</option>
											<option value='1'>이탈</option>
										</select>
									</div>
									<div class="form-inline">
										<button type="button" onclick="fn_MainInfo_List(startDate,endDate)" id="btn_Search" 
												class="btn btn-outline-dark">
											<i class="fas fa-search"></i>
										</button>
									</div>
								</div>
							</div>
							<div class="col-sm-2">
								<div class="input-group float-right" id="dateParent">
				          	  		<input type="text" class="form-control float-right" id="dateRange">
				          	  		<div class="input-group-append">
				          	  	  		<button type="submit" class="btn btn-default">
				          	  	    		<i class="fas fa-calendar"></i>
				          	  	 		</button>
				          	  		</div>
				          	  	</div>
				          	</div>
						</div>
					</div>
	      			<div class="card-body" id="MainInfo_List_contents">
	      			</div> 
       			</div>
     		</div>
     		<!-- /.col-md-12 -->
   		</div>
   		<!-- /.row -->
 	</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
          