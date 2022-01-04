<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html>
<head>
  	<!-- Font Awesome -->
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
  	<!-- FullCalendar CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/fullcalendar-5.5.0/lib/main.css">
  	<!-- Henesys CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/css/henesys.css">
	<style>
		
	/* html, body {
    margin: 0;
    height: 100%;
    overflow: hidden;
	}  */
	
		main { color: white; text-align: center; overflow:hidden; }
	    #title { font-size: 2vw; }
	    #digital-clock { font-size: 3vw; }
	    .left{ float : left; width : 50%;}
	    .left1{ height : 50%;}
	    .left2{ height : 50%;}
	    .right{ float : right; width : 50%;}
	     
	     .up{ float : left; width : 100%; height : 10%;}
	    .up1{float : left; width : 47%; height : 10%; horizontal-align : center;}
	    .up2{float : right; width : 47%; height :10%; horizontal-align : center;}
	   
	    .down{margin-top : 3%; float : right; width : 100%; height: 70%;}
	    .main .content { text-align: center; }
	
	    .swal-overlay {
	        background-color: rgba(255,0,0,0.3);
	    }
	    
	   /*  main { color: white; text-align: center;}
	    #title { font-size: 5vw; }
	    #digital-clock { font-size: 4vw; }
	    .main .content { text-align: center; }
	
	    .swal-overlay {
	        background-color: rgba(255,0,0,0.3);
	    }
	    
	    left2 { color: white; text-align: center;}
	    #title { font-size: 5vw; }
	    #digital-clock { font-size: 4vw; }
	    .main .content { text-align: center; }
	
	    .swal-overlay {
	        background-color: rgba(255,0,0,0.3);
	    } */
	    
	</style>
</head>

<body style="background: #222">
    <main>
    	<div class = "up">
	    	<div class="up1">
	    	 <div class="wrap">
	            <div class="content">
	                <div id="title">생산계획</div>
	                <div id="prod-plan"></div>
	            </div>
	         </div>
	        </div>
	        
	         <div class="up2">
		         <div class="wrap">
		        	<div class="content">
		                <div id="title">생산현황</div>
		                <div id="prod-list"></div>
		            </div>
		        </div>
	    	</div>
    	</div>
    	
    	<div class ="down">
        	<div class="wrap">
              <div class="content">
               <!-- <div id="title">온도 현황판</div> -->
                <div id="digital-clock"></div>
                <hr>
              </div>
        	</div>
        	
      	<div class="main" onbeforeunload="clearInterval(onClock)">
        	<div class="wrap">
            	<div class="content" id="autonixTemp">
              	</div>
        	</div>
    	</div>
       </div>
    </main>

    <audio id="alertSound" src="sound/beep.wav" muted></audio>
	
    <!-- <div class="main" onbeforeunload="clearInterval(onClock)">
        <div class="wrap">
            <div class="content" id="autonixTemp">
            </div>
        </div>
    </div> -->
	
	<!-- <main>
	<section>
	 <div class="wrap">
            <div class="content">
                <div id="title">생산계획</div>
                <div id="prod-plan"></div>
            </div>
        </div>
	</section>
	 
	 <section>
	 <div class="wrap">
        	<div class="content">
                <div id="title">생산현황</div>
                <div id="prod-list"></div>
            </div>
        </div>
     </section>
     
	</main> -->
	
	<!-- jQuery -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.js"></script>
	<script src="<%=Config.this_SERVER_path%>/Lib/canvas-gauges-master/gauge.min.js"></script>
	<!-- jQuery UI 1.11.4 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-ui/jquery-ui.js"></script>
	<!-- For Date Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/setdate.js"></script>
	<!-- SweetAlert2 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.js"></script>
	<!-- Customized SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/js/sweetalert.custom.js"></script>
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
	<!-- For Date Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/setdate.js"></script>
	<!-- For DataTables Default Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/datatables.custom.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/cdnjs/select2.min.js"></script>
	<!-- Customized Modal Windows -->
	<script src="<%=Config.this_SERVER_path%>/js/modal.custom.js"></script>
	<!-- 데이터 처리 관련 기능 -->
	<script src="<%=Config.this_SERVER_path%>/js/data_control.js"></script>
	<!-- FullCalendar -->
	<script src="<%=Config.this_SERVER_path%>/fullcalendar-5.5.0/lib/main.js"></script>
	<!-- 환경 설정 -->
	<script src="<%=Config.this_SERVER_path%>/js/config.js"></script>
	<!-- 숫자 관련 기능 -->
	<script src="<%=Config.this_SERVER_path%>/js/hene.number.js"></script>
	<!-- JavaScript 공통 함수 -->
    <script src="<%=Config.this_SERVER_path%>/js/common/common.func.js"></script>
	
	<script>
		$(document).ready(function(){
			let gaugeList;
			let tempData;
			let heneSwal = new SweetAlert();
			
			displayClock();
			displayProdPlan();
			displayProdList();
			
		    // 온도계 공통 옵션
		    var commonOpts = {
		    	    width: 300,
		    	    height: 300,
		    	    units: "°C",
		    	    minValue: -50,
		    	    maxValue: 50,
		    	    majorTicks: [ -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50 ],
		    	    minorTicks: 2,
		    	    strokeTicks: true,
		    	    ticksAngle: 225,
		    	    startAngle: 67.5,
		    	    colorMajorTicks: "#ddd",
		    	    colorMinorTicks: "#ddd",
		    	    colorTitle: "#eee",
		    	    colorUnits: "#ccc",
		    	    colorNumbers: "#eee",
		    	    colorPlate: "#222",
		    	    borderShadowWidth: 0,
		    	    borders: true,
		    	    needleType: "arrow",
		    	    needleWidth: 2,
		    	    needleCircleSize: 7,
		    	    needleCircleOuter: true,
		    	    needleCircleInner: false,
		    	    animationDuration: 1500,
		    	    animationRule: "linear",
		    	    colorBorderOuter: "#333",
		    	    colorBorderOuterEnd: "#111",
		    	    colorBorderMiddle: "#222",
		    	    colorBorderMiddleEnd: "#111",
		    	    colorBorderInner: "#111",
		    	    colorBorderInnerEnd: "#333",
		    	    colorNeedleShadowDown: "#333",
		    	    colorNeedleCircleOuter: "#333",
		    	    colorNeedleCircleOuterEnd: "#111",
		    	    colorNeedleCircleInner: "#111",
		    	    colorNeedleCircleInnerEnd: "#222",
		    	    valueBoxBorderRadius: 0,
		    	    colorValueBoxRect: "#222",
		    	    colorValueBoxRectEnd: "#333"
		    	    /* fontValue:"Led",
		            fontNumbers:"Led",
		            fontTitle:"Led",
		            fontUnits:"Led" */
		    };
		    
		    // 최초 온도값을 받아온 후 1시간 단위로 적정 온도가 지켜지는지 확인
		    $.ajax({
		        type: "GET",
		        url: "<%=Config.this_SERVER_path%>" + "/Contents/CommonView/select_json.jsp",
		        data: "pid=M707S010600E034",
		        success: function (data) {
		        	tempData = data;
		        	
		        	for(let i in data) {
		        		var censor_no = data[i][0];
		        		$('#autonixTemp').append('<canvas id="' + censor_no + '" class="test"></canvas>'+ (i==3?"<br>":""));
		        		gaugeBuilder(censor_no, commonOpts).draw();
		        	}
		        	
		        	gaugeList = document.gauges;
		            
		            for(var i = 0; i < gaugeList.length; i++) {
		            	var temperature = data[i][1];
		            	var location = data[i][2];
		            	var minValue = data[i][3];
		            	var maxValue = data[i][4];
		
		            	gaugeList[i].update({
		            		value: temperature,
		            		title: location,
		            		highlights: setHighlightsValue(minValue, maxValue)
		            	});
		            	
		            	gaugeList[i].minLimit = minValue;
		            	gaugeList[i].maxLimit = maxValue;
		            	
		            	judgeTemp(i);
		            }
		            
	                checkAndUpdateTempOnScreen();
	                
	                let time = 1000 * 60 * 60;	                
	                alertIfTempLastsForCertainTime(time);
	                
		        }
		    });
		
		    // Check and update temperature on screen
		    var checkAndUpdateTempOnScreen = function() {
			    setInterval(function() {
			        $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
			            data: "pid=M707S010600E034",
			            success: function (data) {
			                gaugeList = document.gauges;
			                
			                for(var i = 0; i < gaugeList.length; i++) {
			                    gaugeList[i].value = data[i][1];
			                    judgeTemp(i);
			                }
			            }
			        });
			    }, 1000*10*1);
		    }
		    
		    var alertIfTempLastsForCertainTime = function(interval) {
		    	for(var i = 0; i < gaugeList.length; i++) {
		    		function timer(idx) {
			            setTimeout(function() {
			                setIntervalImmediately(firstCheckValue, interval, idx);
			            }, idx*idx*1000);
			        };
			        
			        timer(i);
			    }
		    }
		    
		    // Display date&time
		    function displayClock() {
		    	var clockScreen = document.getElementById("digital-clock");
		    	
		    	var heneDate = new HeneDate();
		    	
		    	var onClock = setInterval(function(){
			       	currentTime = heneDate.getDateTime();
			       	clockScreen.innerHTML = "온도 현황판 &nbsp&nbsp&nbsp"  + currentTime;
			   	}, 1000*1);
		
		    	if(clockScreen.innerHTML != null) {
					
		    	} else {
		    		clearInterval(onClock);
		    	}
		    }
		    
		    // Check temperature and change circle color as red or blue in the gauge
		    function judgeTemp(index) {
		    	var gauge = gaugeList[index];
		 
				// this will draw red or blue circle on a gauge plate depending on
			    // current value
			    gauge.on('beforeNeedle', function () {
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
		            gradient.addColorStop(0, this.options.value >= this.minLimit && 
		            						 this.options.value <= this.maxLimit ? '#aaf' : '#faa');
		   	        gradient.addColorStop(0.82, this.options.value >= this.minLimit && 
		   	                                    this.options.value <= this.maxLimit ? '#00f' : '#f00');
		   	        gradient.addColorStop(1, this.options.value >= this.minLimit && 
		   	                                 this.options.value <= this.maxLimit ? '#88a' : '#a88');
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
		    
		    function firstCheckValue(idx) {
		        console.log("started checking censor "+idx);
		        var gauge = document.gauges[idx];
		        
		        var value = gauge.options.value;
		        var min = gauge.minLimit;
		        var max = gauge.maxLimit;
		        
		        var firstResult = value < min || value > max ? true : false;
		        console.log("censor"+idx+" 1st result failed? " + firstResult);
		
		        setTimeout(function() {
		            if(firstResult == true){
		                var gauge = document.gauges[idx];
		                var secondResult = gauge.options.value < gauge.minLimit || gauge.value > gauge.maxLimit ? true : false;
		                
		                if(secondResult == true) {
		                    console.log("device"+idx+"   beep!! beep!!");
		                    warningIfTempNotMatch(idx);
		                } else {
		                    console.log("device"+idx+"   first check failed but second check passed fortunately");
		                    return; // do nothing
		                }
		            } else {
		                console.log("censor"+idx+" first check passed");
		                return; // do nothing   
		            }
		        }, 1000*55*1);
		    }
		
		    function warningIfTempNotMatch(idx) {
		        console.log("index checking : " + idx);
		        
		        //beep();
		        
		        var censorLocation = tempData[idx][2];
		        
		        heneSwal.warningTimer(censorLocation, "온도 확인 요망");
		    }
		    
		    function beep() {
		    	//document.getElementById('alertSound').muted = false;
		    	//document.getElementById('alertSound').play();
		        /* var snd = new Audio("sound/beep.wav");
		        snd.play(); */
		    }
		
		    function setIntervalImmediately(func, interval, index) {
		        func(index);
		        return setInterval(func, interval, index);
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
		    
		    function displayProdPlan() {
		        $.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/js/realtime-board/tempDisplay_ProdPlan.jsp",
		            beforeSend: function () {
		    			$("#prod-plan").children().remove();
		            },
		            success: function (html) {
		                $("#prod-plan").hide().html(html).fadeIn(100);
		            }
		        });
		    }
		    
		    function displayProdList() {
		    	var sysdate = new Date();
		    	var year = sysdate.getFullYear();
		    	var month = sysdate.getMonth() + 1;
		    	var date = sysdate.getDate();
		    	
		    	if(month < 10){
		    	month = '0' + month;	
		    	}
		    	else{
		    	month = month;	
		    	}
		    	
		    	var today = year + '-' + month + '-' + date; 
		    	
		    	console.log(today);
		    	
		    	
		        $.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/js/realtime-board/tempDisplay_ProdList.jsp",
		            data : "date=" + today,
		            beforeSend: function () {
		    			$("#prod-list").children().remove();
		            },
		            success: function (html) {
		                $("#prod-list").hide().html(html).fadeIn(100);
		            }
		        });
		    }
		});
		
		setTimeout(function(){ // 일정 시간마다 생산계획, 생산현황 갱신 위해 페이지 새로고침
			
		location.reload();
			
		}, 360000); //1시간마다
		
	</script>

</body>
</html>