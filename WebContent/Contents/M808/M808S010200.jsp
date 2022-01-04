<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.frame.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	/* 금속검출기 관리(M808S010200.jsp) */
	
	String[] strArr = {"METAL"};
	Vector Censor_gubunVector_Name = CommonData.getCensorGubun_Name(strArr);
    Vector metal_name = (Vector) Censor_gubunVector_Name.get(0);
%>
<script type="text/javascript">
	var startDate;
	var endDate;
	var metalName;
	var checkBreakaway;
 	
    $(document).ready(function () {
        
        var date = new SetRangeDate("dateParent", "dateRange", 7);
    	startDate = date.start.format('YYYY-MM-DD');
       	endDate = date.end.format('YYYY-MM-DD');
	    
       	fn_MainInfo_List(startDate, endDate);
    	
        $('#dateRange').change(function() {
           	fn_MainInfo_List(startDate, endDate);
        });
      	
    	fn_MainSubMenuSelect("금속검출 관리");
    	$("#InfoContentTitle").html("금속검출 데이터 목록");
    	
        $('#metalTestBtn').click(function() {
        	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M808/S808S010201.jsp";
		 	var footer = '<div class="layer">' +
					 	 '		<button id="sendServerBtn" class="btn btn-info btn-lg" style="margin-right:1px;"> '+ 
					 	 '			서버 전송</button>' +
					 	 '		<button id="closeBtn" class="btn btn-info btn-lg" style="margin-left:1px;">닫기</button>' +
					 	 '</div>';
    		var title = "금속검출 테스트";
    		var heneModal = new HenesysModal(url, 'xlarge', title, footer);
    		heneModal.open_modal();
        });
        
    });
    
    function fn_MainInfo_List(startDate, endDate) {
    	
    	metalName = $("#selectMetal").val();
       	checkBreakaway = $("#select_check_gubun_breakaway").val();
    	
    	if(metalName.trim() == "전체" || metalName == null){
    		metalName = "";
    	}
    	
    	if(checkBreakaway.trim() == "전체" || checkBreakaway == null){
    		checkBreakaway = "";
    	}
    	
        $.ajax({
			type: "POST",
           	url: "<%=Config.this_SERVER_path%>/Contents/Business/M808/S808S010200.jsp",
           	data: {startDate: startDate, endDate: endDate, metalName : metalName, checkBreakaway : checkBreakaway},
           	success: function (html) {
           		$("#MainInfo_List_contents").hide().html(html).fadeIn(100);
           	}
		});
    }
</script>
    
<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">메뉴 타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      	  	<button type="button" id="metalTestBtn" class="btn btn-outline-dark">금속검출 테스트</button>
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
						<div class="row">
							<div class="col-sm-4 card-title">
								<i class="fas fa-edit" id="InfoContentTitle"></i>
							</div>
							<div class="col-sm-6" align="right" style = 'display: flex; align-items: center; justify-content: flex-end;'>
								<b>금속검출기 명 :</b> &nbsp;&nbsp;
								<select id = "selectMetal" class = "form-control" style = "width:200px; display: inline-block;">
									<!-- <option value=''>전체</option> -->
									<% for(int i = 0; i < metal_name.size(); i++) { %>
										<option value='<%=metal_name.get(i).toString()%>'>
										<%=metal_name.get(i).toString()%>
										</option>
									<% } %>			
								</select>
								<div class="form-inline" style = "margin-left:3%;">
									<label for="select_check_gubun_breakaway">정상/이탈 :</label>
									<select class="form-control ml-2" id="select_check_gubun_breakaway" name="select_check_gubun_breakaway" style = "width:93px;">
										<option value=''>전체</option>
										<option value='0'>정상</option>
										<option value='1'>이탈</option>
									</select>
								</div>
								<div class="form-inline" style = "margin:0 3% 0 4%;">
									<button type="button" onclick="fn_MainInfo_List(startDate, endDate)" id="btn_Search" class="btn btn-outline-dark">
										<i class="fas fa-search"></i>
									</button>
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
     		</div><!-- /.col-md-12 -->
   		</div><!-- /.row -->
 	</div><!-- /.container-fluid -->
</div>
<!-- /.content -->