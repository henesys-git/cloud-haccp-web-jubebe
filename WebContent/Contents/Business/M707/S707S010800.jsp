<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.stream.*"%>
<!-- 
작성자 : 최현수
최초 작성일 : 20210121
최종 수정일 : 20210527
프로그램 : 온도 기록지
사용 라이브러리 : ChartJS
-->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String date = "";
	
	if(request.getParameter("date") != null) {
		date = request.getParameter("date");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("date", date);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M707S010800E004", jArray);
	DoyosaeTableModel table_temp = new DoyosaeTableModel("M707S010800E005", jArray);
	Vector v = table.getVector();
	VectorToJson vj = new VectorToJson();
	String jsonStr = vj.vectorToJson(v);
%>

<style>
	.chart > canvas {
		min-height: 250px;
		height: 250px;
		max-height: 250px;
		max-width: 100%;
	}
</style>

<!-- Main content -->
<section class="content">
  <div class="container-fluid">
  
  <% for(int i = 0; i < table_temp.getRowCount(); i++) {
	  
	  if(i%3==0){ %>
		  <div class="row">
  <%  } %>
	  <div class="col-md-4">
    	<!-- CHART NO.1 -->
      <div class="card card-success">
        <div class="card-header">
          <h3 class="card-title"><%= table_temp.getValueAt(i, 3) %></h3>
        </div>
        <div class="card-body">
          <div class="temperatureChart">
            <canvas id="<%= table_temp.getValueAt(i, 0) %>"></canvas>
          </div>
        </div>
        <!-- /.card-body -->
      </div>
      <!-- /.card -->
    </div>	  
 <%  if((i+1)%3==0){ %>
		</div><!-- /.row -->  
 <% } 
 
  }%>
  
  </div><!-- /.container-fluid -->
</section>
<!-- /.content -->

<!-- page script -->
<script>

	$(document).ready(function () {
		
		let processEachCensorData = function(arr) {
			
			console.log('======FUNC processEachCensorData START======');
			console.log(arr);
			
			var newObj = new Object();
		    
		    var censorName = arr[0][1];
		    newObj.name = censorName;
		    newObj.time = arr.map(x => x[2]);
		    newObj.value = arr.map(x => x[3]);
			
		    return newObj;
		};
		
		let processCensors = function(arr, keys) {
			
			console.log('=========FUNC processCensors START==========');
			
			let outerArr = [];
			
			for(let i = 0; i < keys.length; i++) {
				console.log('>> inner array in for loop:');
				console.log(arr[i]);
				
				var temp = arr.filter(x => x[0] == keys[i]);
				
				console.log(">> same censor's arr after filtering:");
				console.log(temp);
				
				let eachCensor = processEachCensorData(temp);
				outerArr.push(eachCensor);
			}
			
			return outerArr;
		};
		
		let chartFactory = function(ctx, arr) {
			let customOptions = {
				legend: { display: false },
				scales: {
			        yAxes: [{
			            display: true,
			            stacked: true,
			            ticks: {
			                min: -50,
			                max: 50
			            }
			        }]
			    }
			}
			
			new Chart(ctx, { 
				type: 'line',
				data: {
					labels: arr.time,
					datasets: [{
						data: arr.value,
						fill: false,
						borderColor: "#8e5ea2"
					}]
				},
				options: customOptions
			})
		};
		
		/* MAIN LOGIC START */
		console.log('==============MAIN LOGIC START==================');
		
		let temperatureList = <%=jsonStr%>;
		
		console.log('>> temperature from db:');
		console.log(temperatureList);
		
		let keys = [];
		
		temperatureList.forEach(function(each, idx) {
			var tempDevId = each[0];
			
			if(!keys.includes[tempDevId]) {
				keys.push(tempDevId);
			}
		});

		let outerArr = processCensors(temperatureList, keys);
		
		console.log('================OUTER ARRAY GENERATED===========');
		console.log(outerArr);
		
		console.log('=================DRAW CANVAS START==============');

		keys.forEach(function(key, idx) {
			let ctx = $('#' + key).get(0).getContext('2d');
			chartFactory(ctx, outerArr[idx]);
		});
		
		/* MAIN LOGIC END */
		console.log('=================MAIN LOGIC END=================');
	});
</script>