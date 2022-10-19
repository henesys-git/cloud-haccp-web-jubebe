<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.stream.*"%>
<script>

    $(document).ready(function () {
    	
    	async function getData() {
    		
    		var nowDate = new Date();
    		
    		var year = nowDate.getFullYear();
    		var month = nowDate.getMonth() + 1;
    		var day = nowDate.getDate();
    		
    		if(month < 10) {
    			month = "0" + month;
    		}
    		
    		if(day < 10) {
    			day = "0" + day;
    		}
    		
    		var toDay = year + "-" + month + "-" + day;
    		var processCode = "PC15";
	        var fetchedData = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/ccpvm",
			            data: "method=monitoring" +
			            	  "&toDay=" + toDay + 
			            	  "&processCode=" + processCode,
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedData;
	    };
    	
    	
    	async function initChart() {
    	
	    	$('#title').append("<h4 style ='text-align:center;'>금일 금속검출기 운영 현황</h4>");
	    	
	    	var dataArr = await getData();
	    	console.log(dataArr);
	    	var labelArr = new Array();
	    	var valueArr = new Array();
	    	var valueArr2 = new Array();
	    	var valueSum = 0;
	    	var stepVal = 0;
	    	
	    	for(x in dataArr) {
	    		labelArr.push(dataArr[x].sensorName);
	    		valueArr.push(dataArr[x].countAll);
	    		valueArr2.push(dataArr[x].countDetect);
	    		valueSum += parseInt(dataArr[x].countAll);
	    	}
	    	var testVal = 1150;
	    	var testLength = 0;
	    	var testVal2 = 0;
	    	
	    	if(valueSum == null || valueSum <= 1000) {
	    		valueSum = 1000;
	    		stepVal = 50;
	    		testVal2 = valueSum;
	    	} 
	    	else {
	    		testLength = valueSum.toString().length;
	    		testVal2 = parseInt(valueSum) - parseInt(valueSum.toString().substr(testLength - 3)) + parseInt(1000);
	    		stepVal = parseInt(testVal2 / 20);
	    	}
	    	console.log(valueSum);
	    	console.log(stepVal);
	    	console.log(valueArr);
	    	console.log(valueArr2);
	    	console.log(testVal2);
	    	new Chart(document.getElementById("canvas"), {
	    	    type: 'horizontalBar',
	    	    data: {
	    	    	labels: labelArr,
	    	        datasets: [{
	    	            label: '운영횟수',
	    	            data: valueArr,
	    	            borderColor: "rgba(255, 201, 14, 1)",
	    	            backgroundColor: "rgba(255, 201, 14, 0.5)",
	    	            fill: false
	    	        },  
	    	        {
	    	        	label: '검출횟수',
	     	            data: valueArr2,
	     	            borderColor: "rgba(255, 0, 0, 1)",
	     	            backgroundColor: "rgba(255, 0, 0, 0.5)",
	     	            fill: false
	    	        }]
	    	    },
	    	    options: {
	    	        tooltips: {
	    	            mode: 'index',
	    	            intersect: false,
	    	        },
	    	        hover: {
	    	            mode: 'nearest',
	    	            intersect: true
	    	        },
	    	        scales: { 
			            xAxes: [{
			            	ticks: {
	        	        		stepSize: stepVal,
	       	        	        min: 0,
	       	        	        max: testVal2
			            	}
	    	            }]
	    	        } // scales
	    	    } // options
	    	});
       }
    	
       initChart();
    });

</script>
<div>
	<div id="title" class="title"></div>
	<canvas id="canvas"></canvas>
</div>