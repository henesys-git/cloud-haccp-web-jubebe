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
<script src="<%=Config.this_SERVER_path%>/Lib/canvas-gauges-master/gauge.min.js"></script>

<style>
    .main .content { text-align: center; }

    .swal-overlay {
        background-color: rgba(255,0,0,0.3);
    }
</style>

<div class="main" onbeforeunload="">
    <div class="wrap">
        <div class="content" id="autonixTemp">
        </div>
    </div>
</div>

<script>

//온도계 공통 옵션
var commonOpts;
var gaugeList;
var tempData;


$(document).ready(function(){
	
    // 최초 온도값을 받아온 후 1시간 단위로 적정 온도가 지켜지는지 확인
    
    //async function getData() {
    
   	//브리에잇일  경우
    if ('<%=bizNo%>' == 'B37487014970')	 {
    	commonOpts = {
    			width: 300,
    		    height: 300,
    		    units: "°C",
    		    minValue: 0,
    		    maxValue: 200,
    		    majorTicks: [ 0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200 ],
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
    	}
    }
    
    else {
    	commonOpts = {
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
    	}
    }
    	
    $.ajax({
        type: "GET",
        url: "<%=Config.this_SERVER_path%>/cpvm"
        	 + "?method=" + 'monitoring'
        	 + "&processCode=PC60",
        success: function (data) {
        	tempData = data;
        	console.log(data);
        	console.log(data[0].sensorId);
        	for(let i in data) {
        		var censor_no = data[i].sensorId;
        		$('#autonixTemp').append('<canvas id="' + censor_no + '" class="test"></canvas>');
        		gaugeBuilder(censor_no, commonOpts).draw();
        	}
        	
        	gaugeList = document.gauges;
            
            for(var i = 0; i < gaugeList.length; i++) {
            	var temperature = data[i].sensorValue;
            	var location = data[i].sensorName;
            	var minValue = data[i].minValue;
            	var maxValue = data[i].maxValue;

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
        }
    });
	
    //}
    
    //getData();
    
    // Check and update temperature on screen
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
