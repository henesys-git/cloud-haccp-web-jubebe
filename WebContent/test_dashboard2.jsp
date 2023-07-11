<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<% 
	String bizNo = session.getAttribute("bizNo").toString();
%>

<%-- 	<!-- Font Awesome -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/fontawesome-free/css/all.min.css">
	<!-- Ionicons -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/ionicons-2.0.1/css/ionicons.min.css">
	<!-- Tempusdominus Bbootstrap 4 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css">
	<!-- iCheck -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
	<!-- JQVMap -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jqvmap/jqvmap.min.css">
	<!-- Theme style -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/css/adminlte.min.css">
	<!-- overlayScrollbars -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
	<!-- Daterange picker -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.css">
	<!-- summernote -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/summernote/summernote-bs4.css">
	<!-- Google Font: Source Sans Pro -->
	<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
	<!-- Henesys Icon -->
	<link rel="shotcut icon" type="image/x-icon" href="<%=Config.this_SERVER_path%>/images/henesys.jpg"/>
	<!-- SweetAlert2 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.css">
 	<!-- DataTables -->
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/css/select.bootstrap4.min.css">
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/cdnjs/select2.min.css">
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-buttons/css/buttons.bootstrap4.min.css">
  	<!-- FullCalendar CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/fullcalendar-5.5.0/lib/main.css">
  	<!-- Henesys CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/css/henesys.css">
  	<!-- TimePicker -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-timepicker/jquery.timepicker.css">
  	<!-- datetimepicker -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datetimepicker/css/bootstrap-datetimepicker.css">
  		<!-- Date Picker -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css"></link>
	
	 <!-- Font Awesome Icons -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/fontawesome-free/css/all.min.css">
  	<!-- IonIcons -->
  	<link rel="stylesheet" href="http://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
  	<!-- Google Font: Source Sans Pro -->
  	<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
	

<!-- jQuery -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.js"></script>
	<!-- jQuery UI 1.11.4 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-ui/jquery-ui.js"></script>
	<!-- jQuery -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.min.js"></script>
	<!-- jQuery Mapael -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-mousewheel/jquery.mousewheel.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/raphael/raphael.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-mapael/jquery.mapael.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-mapael/maps/usa_states.min.js"></script>
<script src="<%=Config.this_SERVER_path%>/Lib/canvas-gauges-master/gauge.min.js"></script>
<!-- Bootstrap 4 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
	<!-- ChartJS -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/chart.js/Chart.min.js"></script>
	<!-- Sparkline -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sparklines/sparkline.js"></script>
	<!-- JQVMap -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jqvmap/jquery.vmap.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jqvmap/maps/jquery.vmap.usa.js"></script>
	<!-- jQuery Knob Chart -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-knob/jquery.knob.min.js"></script>
	<!-- daterangepicker -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/moment/moment.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.js"></script>
	<!-- Tempusdominus Bootstrap 4 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>
	<!-- Summernote -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/summernote/summernote-bs4.min.js"></script>
	<!-- overlayScrollbars -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
	<!-- AdminLTE App -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/js/adminlte.js"></script>
	<!-- DataTables -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables/jquery.dataTables.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/js/dataTables.select.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
	<!-- DataTables Buttons -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-buttons/js/dataTables.buttons.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-buttons/js/buttons.html5.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-buttons/js/buttons.print.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jszip/jszip.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/pdfmake/pdfmake.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/pdfmake/vfs_fonts.js"></script>
	<!-- Bootstrap -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
	<!-- OPTIONAL SCRIPTS -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/js/demo.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/js/pages/dashboard3.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/ottogiDashboard.js"></script> --%>
	
 
<style>
    .main .content { text-align: center; }

    .swal-overlay {
        background-color: rgba(255,0,0,0.3);
    }
    .content-wrapper {
     	margin-left : 0;
    }
</style>

<div class="main">
    <div class="content-wrapper" style = "margin-left:0;">
        <div class="row" id="autonixTemp2"></div>
                <div class="position-relative mb-4">
                  <canvas id="ottogi-heating-chart" height="200"></canvas>
                </div>

                <div class="d-flex flex-row justify-content-end">
                  <span class="mr-2">
                    <i class="fas fa-square text-primary"></i> 1차측Hz
                  </span>
                  <span class="mr-2">
                    <i class="fas fa-square text-gray"></i> 1차측온도
                  </span>
                   <span class="mr-2">
                    <i class="fas fa-square text-red"></i> 2차측Hz
                  </span>
                   <span class="mr-2">
                    <i class="fas fa-square text-yellow"></i> 2차측온도
                  </span>
                </div>
            </div>
</div>

<script>



//온도계 공통 옵션
var commonOpts;
var gaugeList;
var tempData;
var sulbiName = new Array("만두동 1라인", "만두동 2라인", "만두동 3라인", "만두동 4라인", "만두동 5라인");
var firstHz = new Array("23.5", "23.5", "23.6", "23.7", "23.8");
var firstTemp = new Array("53", "55", "57", "57", "57");
var secondHz = new Array("23.6", "23.6", "23.7", "23.8", "23.9");
var secondTemp = new Array("10.2", "10.4", "10.5", "10.6", "10.6");

$(document).ready(function(){
	
	$('#autonixTemp2').append('<div class="col-lg-1"></div');
	
	for(var i = 0; i < 5; i++) {
 		$('#autonixTemp2').append('<div class="col-lg-2"><div class="info-box mb-3 bg-warning"><div class="info-box-content"><span class="info-box-text"></span><span class="info-box-number">' + sulbiName[i] + '</span></div></div><div class="info-box mb-3 bg-success"><div class="info-box-content"><span class="info-box-text">1차측 Hz</span><span class="info-box-number">' + firstHz[i] + '</span></div></div><div class="info-box mb-3 bg-success"><div class="info-box-content"><span class="info-box-text">1차측 온도</span><span class="info-box-number">' + firstTemp[i] + '</span></div></div><div class="info-box mb-3 bg-info"><div class="info-box-content"><span class="info-box-text">2차측 Hz</span><span class="info-box-number">' + secondHz[i] + '</span></div></div><div class="info-box mb-3 bg-info"><div class="info-box-content"><span class="info-box-text">2차측 온도</span><span class="info-box-number">' + secondTemp[i] + '</span></div></div></div>');
	
 	} 
	
	$('#autonixTemp2').append('<div class="col-lg-1"></div');
	
 	 $(function () {
		  'use strict'

		  var ticksStyle = {
		    fontColor: '#495057',
		    fontStyle: 'bold'
		  }

		  var mode      = 'index'
		  var intersect = true

		  var $salesChart = $('#ottogi-heating-chart')
		  var salesChart  = new Chart($salesChart, {
		    type   : 'bar',
		    data   : {
		      labels  : ['만두동1라인', '만두동2라인', '만두동3라인', '3층라인', '5층라인'],
		      datasets: [
		        {
		          backgroundColor: '#007bff',
		          borderColor    : '#007bff',
		          data           : [0.2, 0.3, 0.4, 0.5, 0.6]
		        },
		        {
		          backgroundColor: '#ced4da',
		          borderColor    : '#ced4da',
		          data           : [0.5, 0.6, 0.7, 0.8, 0.9]
		        },
				{
		          backgroundColor: '#eb3434',
		          borderColor    : '#eb3434',
		          data           : [1, 1, 1, 1, 1]
		        },
				{
		          backgroundColor: '#ebdf34',
		          borderColor    : '#ebdf34',
		          data           : [1.2, 1.2, 1.2, 1.2, 1.2]
		        }
		      ]
		    },
		    options: {
		      maintainAspectRatio: false,
		      tooltips           : {
		        mode     : mode,
		        intersect: intersect
		      },
		      hover              : {
		        mode     : mode,
		        intersect: intersect
		      },
		      legend             : {
		        display: false
		      },
		      scales             : {
		        yAxes: [{
		          // display: false,
		          gridLines: {
		            display      : true,
		            lineWidth    : '4px',
		            color        : 'rgba(0, 0, 0, .2)',
		            zeroLineColor: 'transparent'
		          },
		          ticks    : $.extend({
		            beginAtZero: true,
					suggestedMax: 1.2
		          

		          }, ticksStyle)
		        }],
		        xAxes: [{
		          display  : true,
		          gridLines: {
		            display: false
		          },
		          ticks    : ticksStyle
		        }]
		      }
		    }
		  })
		})
	
    //}
    
    //getData();
    
    <%-- // Check and update temperature on screen
    var checkAndUpdateTempOnScreen = function() {
	    interVal = setInterval(function() {
	        $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/cpvm"
	           	 + "?method=" + 'monitoring'
	           	 + "&processCode=PC60",
	            success: function (data) {
	                gaugeList = document.gauges;
	                
	                for(var i=0; i<gaugeList.length; i++) {
	                    gaugeList[i].value = data[i].sensorValue;
	                    //judgeTemp(i);
	                }
	            }
	        });
	    }, 1000*10*1);
    }
     --%>
 	
     
});

//Check temperature and change circle color as red or blue in the gauge
function judgeTemp(index) {
	var gauge = gaugeList[index];

	// this will draw red or blue circle on a gauge plate depending on
    // current value
    gauge.on('beforeNeedle', function () {
    	var curTemp = Number(this.options.value);
    	var min = Number(this.minLimit);
    	var max = Number(this.maxLimit);
    	
        // getting canvas 2d drawing context
        var context = this.canvas.context;
 
        // we can use gauge context special 'max' property which represents
        // gauge radius in a real pixels and calculate size of relative pixel
        // for our drawing needs
        var pixel = context.max / 100;

        // step out our circle center coordinate by 30% of its radius from
        // gauge center
        var centerX = 30 * pixel;
        // stay in center by Y-coordinate
        var centerY = 0;
        // use circle radius equal to 5%
        var radius = 5 * pixel;
        // save previous context state
        context.save();

        // draw circle using canvas JS API
        context.beginPath();
        context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);

        var gradient = context.createRadialGradient(
			            centerX, centerY, 0,
			            centerX, centerY, radius);
        
        if(curTemp <= max && curTemp >= min) {
            gradient.addColorStop(0, '#aaf');
            gradient.addColorStop(0.82, '#00f');
            gradient.addColorStop(1, '#88a');
        } else {
            gradient.addColorStop(0, '#faa');
            gradient.addColorStop(0.82, '#f00');
            gradient.addColorStop(1, '#a88');
        }
        
        context.fillStyle = gradient;
        context.fill();
        context.closePath();

        // restore previous context state to prevent break of
        // further drawings
        context.restore();
	});

    // redraw the gauge if it has been already drawn
    gauge.draw();
}

function mergeOptions(obj1, obj2) {
	var newObj = new Object();
	
	return Object.assign(newObj, obj1, obj2);
}

function setHighlightsValue(min, max) {
	var highlights = [
		{"from": -50, "to": min, "color": "rgba(255, 0, 0, .3)"},
        {"from": min, "to": max, "color": "rgba(0, 0, 255, .3)"},
        {"from": max, "to": 50, "color": "rgba(255, 0, 0, .3)"}	
	];
	
	return highlights;
}

function gaugeBuilder(canvasId, additionalOption) {
	return new RadialGauge(
				mergeOptions({ renderTo: canvasId }, additionalOption)
     	   );
}

</script>
