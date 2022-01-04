<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<script src="<%=Config.this_SERVER_path%>/Lib/canvas-gauges-master/gauge.min.js"></script>

<style>
/*     header { color: white; text-align: center;}
    #title { font-size: 5vw; }
    #digital-clock { font-size: 4vw; }
 */
    .main .content { text-align: center; }

    .swal-overlay {
        background-color: rgba(255,0,0,0.3);
    }
</style>

    <!-- <audio id="alertsound" src="sound/beep.wav" muted></audio> -->

    <div class="main" onbeforeunload="clearInterval(onClock)">
        <div class="wrap">
            <div class="content" id="autonixTemp">
            </div>
        </div>
    </div>

<script>
$(document).ready(function(){
	let gaugeList;
	let tempData;
	
	let intervalsibal;
	console.log(intervalsibal);
	
	//0603 서승헌
	// 페이지 벗어나면 clearInterval 실행 --> 문제점 : 페이지 안 벗어나도 clear 됨 
	// beep() ? -> error 나옴
 	$(window).focusout(function(){
	 	clearInterval(intervalsibal);
	});
	
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
        url: heneServerPath + "/Contents/CommonView/select_json.jsp",
        data: "pid=M707S010600E034",
        success: function (data) {
        	tempData = data;
        	
        	for(let i in data) {
        		var censor_no = data[i][0];
        		$('#autonixTemp').append('<canvas id="' + censor_no + '" class="test"></canvas>');
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
            
            let time = 1000 * 60 * 1;	                
            alertIfTempLastsForCertainTime(time);
        }
    });

    // Check and update temperature on screen
    var checkAndUpdateTempOnScreen = function() {
	    intervalsibal = setInterval(function() {
	        $.ajax({
	            type: "GET",
	            url: heneServerPath + "/Contents/CommonView/select_json.jsp",
	            data: "pid=M707S010600E034",
	            success: function (data) {
	                gaugeList = document.gauges;
	                
	                for(var i=0; i<gaugeList.length; i++) {
	                    gaugeList[i].value = data[i][1];
	                    //judgeTemp(i);
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
	            }, idx*1000);
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
	       	clockScreen.innerHTML = currentTime;
	   	}, 1000*1);

    	if(clockScreen.innerHTML != null) {
			
    	} else {
    		clearInterval(onClock);
    	}
    }
    
    //displayClock();
    
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
        console.log("started checking device"+idx);
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
                console.log("device"+idx+"   first check passed");
                return; // do nothing   
            }
        }, 1000*55*1);
    }

    function warningIfTempNotMatch(index) {
        console.log("index checking : " + index);
        
        beep();
        
        var censorLocation = tempData[idx][2];
        
        heneSwal.warningTimer(censorLocation, "온도 확인 요망");
    }
    
    function beep() {
    //	document.getElementById('alertSound').muted = false;
    	document.getElementById('alertSound').play();
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
});
</script>