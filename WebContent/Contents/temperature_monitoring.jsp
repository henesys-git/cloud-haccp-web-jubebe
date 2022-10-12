<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>

<script src="<%=Config.this_SERVER_path%>/Lib/canvas-gauges-master/gauge.min.js"></script>

<style>
    .main .content { text-align: center; }

    .swal-overlay {
        background-color: rgba(255,0,0,0.3);
    }
</style>

<script>
$(document).ready(function () {
	
	fn_MainInfo_List();
	$("#InfoContentTitle").html("실시간 온도 현황판");
    fn_MainSubMenuSelect("온도모니터링");
});

function fn_MainInfo_List() {
    $.ajax({
        type: "POST",
        url: "<%=Config.this_SERVER_path%>/Contents/temperature_monitoring_detail.jsp",
        beforeSend: function () {
			$("#MainInfo_List_contents").children().remove();
        },
        success: function (html) {
            $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
        }
    });
}
</script>
<link rel="stylesheet" href="Lib/canvas-gauges-master/fonts/fonts.css">

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div>
      <div class="col-sm-6">
      	<div class="float-sm-right">
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
          	<div class="card-tools">
          	  <div id="digital-clock">
          	  	
          	  </div>
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div>
      <!-- /.col-md-12 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->