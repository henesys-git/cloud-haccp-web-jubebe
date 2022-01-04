<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	// 	DoyosaeTableModel TableModel;
	DoyosaeTableModel TableModel, PivotModeTable;
    ModelPibot modelPivot = new ModelPibot();
    
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	
	int startPageNo = 1;
// 	final int PageSize=15; 

	String[] strColumnHead = {"sys_seq","process_name","CUR_POSITION","tCount","proc_rate", "order_no", "prod_name", "prd_name", "order_detail"};

	String Fromdate="",Todate="", Chart_Style;
	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	

	if(request.getParameter("Chart_Style")== null)
		Chart_Style="";
	else
		Chart_Style = request.getParameter("Chart_Style");

	String param = Fromdate + "|" + Todate + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M707S010100E414", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
%>
<script>
	var yAxes_scaleLabel={
			display: true,
			labelString:'',
	        fontColor: "red"
		};
	var xAxes_scaleLabel={
			display: true,
			labelString:'',
	        fontColor: "red"
		};
	

	
	var horizontalBarChartData = {
		labels: [],
		Zlabels: [],
		datasets: [],
		fill: true
	};
	var	horizontalBaroptions= {
			elements: {
				rectangle: {
					borderWidth: 5,
				}
			},
			responsive: true,
			legend: {
				position: 'right',
			},
			title: {
				display: true,
				fontSize: 16,
				text: '주문별 공정 진척 비율(%)'
			}
			,			
			scales: {
				xAxes: [{
					gridLines: {
						color: "green",
				        borderDash: [1, 10],
						display: true,
						drawBorder: true,
						drawOnChartArea: true
					},
					scaleLabel: {
						display: true,
						labelString:'주문번호',
				        fontColor: "red"
					}
				}],
				yAxes: [{
					gridLines: { 
						color: "black",
				        borderDash: [1, 5]
					},
					scaleLabel: {
						display: true,
						labelString:'진행위치',
				        fontColor: "red"
					}
				}]
			},
			tooltips: {				
				mode: 'index',
				intersect: false,
				yPadding: 5,
				xPadding: 5,
				caretSize: 8,
				backgroundColor: 'rgba(72, 241, 12, 1)',
				titleFontColor: window.chartColors.black,
				bodyFontColor: window.chartColors.black,
				borderColor: 'rgba(0,0,0,1)',
				borderWidth: 2
			},

			legendCallback: function(chart) {
				var text = [];
				text.push('<ul class="' + chart.id + '-legend">');
				for (var i = 0; i < chart.data.datasets.length; i++) {
					text.push('<li><span style="background-color:' + chart.data.datasets[i].backgroundColor + '"></span>');
					if (chart.data.datasets[i].label) {
						text.push(chart.data.datasets[i].label);
					}
					text.push('</li>');
				}
				text.push('</ul>');
				return text.join('');
			}
		};

	var ChartData = {
   			type:  '<%=Chart_Style%>', 
   			data: horizontalBarChartData,
   			options:horizontalBaroptions
   		}
	var contain_charData = [] ;
	var cType = '<%=Chart_Style%>';
	$(document).ready(function () {

        fn_Chart_Config_Set();
        
		
		ctxs = document.getElementById('canvas').getContext('2d');
   		
   		horizontalBarChart = new Chart(ctxs, ChartData);
   		ctxs.restore();
		

     	
	});

    function fn_Chart_Config_Set(){
		var charData_sub =[];
		var TIMES_sub=[];
		var prod_name="", prev_prod_name="";
		var prev_process_name="";
		var order_no;
		var proc_rate;
		var process_name;
		var start='0';
		var timestart='0';
		var datestart='0';

		ChartData.data.labels=[];
		ChartData.data.datasets=[];
		//{"sys_seq","process_name","CUR_POSITION","tCount","proc_rate", "order_no", "prod_name", "prd_name", "order_detail"};
	
		var newColor= "rgba(" + Math.floor((Math.random() * 255) + 0) + "," + Math.floor((Math.random() * 255) + 0) + "," + Math.floor((Math.random() * 255) + 0) + ")";
	
		var datasets_element={
				label: '',
				backgroundColor: "rgba(72, 241, 0, 1)",
				borderColor: newColor,
				borderWidth: 1,
				data: [],
				fill: false
			};

		<%for(int inx=0; inx < RowCount; inx++){%>
			prod_name 	= '<%=TableModel.getValueAt(inx,7).toString().trim()%>';  //position_num
			proc_rate 	= '<%=TableModel.getValueAt(inx,2).toString().trim()%>';
			process_name = '<%=TableModel.getValueAt(inx,1).toString().trim()%>';
			order_no 	= '<%=TableModel.getValueAt(inx,5).toString().trim()%>' + "-" + '<%=TableModel.getValueAt(inx,8).toString().trim()%>';
						
			datasets_element.data.push(proc_rate);
			horizontalBarChartData.Zlabels.push(prod_name);
			horizontalBarChartData.labels.push(order_no);
			
// 		console.log(horizontalBarChartData.labels);
		<%}%>
		datasets_element.label='차트';
		horizontalBarChartData.datasets.push(datasets_element);	
    }
    
 // Define a plugin to provide data labels
	Chart.plugins.register({
		afterDatasetsDraw: function(chart) {
			var ctx = chart.ctx;

			chart.data.datasets.forEach(function(dataset, i) {
				var meta = chart.getDatasetMeta(i);
				if (!meta.hidden) {
					meta.data.forEach(function(element, index) {
						// Draw the text in black, with the specified font
						var fontSize = 10;
						var fontStyle = 'normal';
						var fontFamily = 'Helvetica Neue';
						ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);

						// Just naively convert to string for now
						var dataString = horizontalBarChartData.Zlabels[index] +": " + dataset.data[index];
// 						var dataString = dataset.data[index];
						// Make sure alignment settings are correct
						ctx.textAlign = 'center';
						ctx.textBaseline = 'middle';
						ctx.fillStyle = "rgb(200,0,0)";
						ctx.shadowColor = "rgb(" + Math.floor((Math.random() * 255) + 0) + "," + Math.floor((Math.random() * 255) + 0) + "," + Math.floor((Math.random() * 255) + 0) + ")";;

						var padding = 5;
						var position = element.tooltipPosition();
// 						if(dataset.data[index]>0)					//2018-11-13 JH 추가
							ctx.fillText(dataString, position.x, position.y - (fontSize / 2) - padding);
					});
				}
			});
		}
	});
</script>
		<div id="canvas-holder" style="position: relative; width:100%;height:720px">
			<canvas id="canvas" style="width:100%;height:100%"></canvas>
<!-- 			<img id ='canvas_prt'></img> -->
<!-- 			<div id ='seckinCanvas'></div> -->
		</div>
				
    
    