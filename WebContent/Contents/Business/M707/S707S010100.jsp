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

	String[] strColumnHead = {"제품명","모니터링일자","진척율","현단계수","총단계수", "수행일자", "시작일자", "완료일자"};

	String Fromdate="",Todate="";
	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "from", Fromdate);
	jArray.put( "to", Todate);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M707S010100E104", jArray);
 	int RowCount =TableModel.getRowCount();	
 	int inx = 0;

%>
<script>
	var charData = [] ;

	$(document).ready(function () {
		
		var datasetlabel="";
		var start='0';
		var Yaxlstart = 0;
		var lineChartData_dataset_orinal = {
			label: '',
			fillColor : "rgba(220,220,220,0.2)",
			strokeColor : "rgba(220,220,220,1)",
			pointColor : 'rgb(54, 162, 235)', //"rgba(220,220,220,1)",
			pointStrokeColor : "#fff",
			pointHighlightFill : "#fff",
			pointHighlightStroke : "rgba(220,220,220,1)",
			data : []
		};
		var lineChartData_dataset = $.extend({}, lineChartData_dataset_orinal);
				
		var prod_name, current_sts, all_sts,  view_rate, reg_no, exe_date;
		var prev_prod_name="";
		var inxddd = 0;

		var colorNames = Object.keys(window.chartColors);
		var colorName;
		var vlegendTemplate;
		
		<%for(inx=0; inx < RowCount; inx++){%>
			prod_name 	= '<%=TableModel.getValueAt(inx,0).toString().trim()%>';
			view_rate 	= '<%=TableModel.getValueAt(inx,2).toString().trim()%>';
			exe_date 	= '<%=TableModel.getValueAt(inx,5).toString().trim()%>';
			
			current_sts	= '<%=TableModel.getValueAt(inx,3).toString().trim()%>';
			all_sts		= '<%=TableModel.getValueAt(inx,4).toString().trim()%>';
			datasetlabel = prod_name; // + '(' + current_sts + '/' + all_sts + ')' ;

			if(prod_name == prev_prod_name){

// 				if(inxddd==0){
// 					lineChartData_dataset.data.push(datasetlabel);
					lineChartData_dataset.data.push(view_rate);
// 				}
// 				if(inxddd==1){
// 					lineChartData_dataset1.data.push(view_rate);
// 				}
// 				if(inxddd==2){
// 					lineChartData_dataset2.data.push(view_rate);
// 				}
				if(Yaxlstart==0){
					lineChartData.labels.push( exe_date );
				}
			}

			else{
				if(start=='1'){

					if(inxddd  > 7){
						colorName = colorNames[inxddd % colorNames.length ];
					}
					else{
						colorName = colorNames[inxddd];					
					}
					newColor = window.chartColors[colorName];					
					lineChartData_dataset.strokeColor		= newColor;	
					lineChartData_dataset.pointColor		= newColor;
					
					lineChartData.datasets.push(lineChartData_dataset);

// 					console.log( lineChartData.datasets[inxddd].label + "[" + inxddd + "]  lineChartData.datasets.data=" + lineChartData.datasets[inxddd].data);
// 					console.log("lineChartData.datasets.length [" + inxddd + "]  = " + lineChartData.datasets.length);
					lineChartData_dataset = $.extend({}, lineChartData_dataset_orinal);
					lineChartData_dataset.data = [];
// 						
					inxddd ++; //단지 데이터를 확인하기위한 변수
					if(Yaxlstart==0){
						lineChartData.labels.push( exe_date );
					}
					Yaxlstart='1';
				}
				else{
					start ='1';
				}		
				
				lineChartData_dataset.data.push(view_rate);
				lineChartData_dataset.label = datasetlabel;
					
				if(Yaxlstart==0){
					lineChartData.labels.push( exe_date );
				}
			}
			prev_prod_name 		= prod_name;
		<%}%>
		
		if(inxddd  > 7){
			colorName = colorNames[inxddd % colorNames.length ];
		}
		else{
			colorName = colorNames[inxddd];					
		}
		newColor = window.chartColors[colorName];					
		lineChartData_dataset.strokeColor		= newColor;	
		lineChartData_dataset.pointColor		= newColor;

		lineChartData.datasets.push(lineChartData_dataset);
	
// 		inxddd=0;
// 		for(inxddd=0;inxddd<lineChartData.datasets.length;inxddd++){
// 	// 		console.log("lineChartData.labels =" + lineChartData.labels);
// 			console.log("[" + inxddd + "] lineChartData.datasets.label =" + lineChartData.datasets[inxddd].label);
// 			console.log("[" + inxddd + "] lineChartData.datasets.data =" + lineChartData.datasets[inxddd].data);
// // 			console.log("[" + inxddd + "] lineChartData.datasets.label =" + lineChartData.datasets[1].label);
// 		}


		var ctx = document.getElementById("canvas").getContext("2d");
		window.myLine = new Chart(ctx).Line(
				lineChartData, 
				{
					responsive: true
// 					scaleLabel : "askajdhakdhjasdhjdjhsadhj"
				}
		);
	});
	var lineChartData = {
			labels : [],
// 			legendTemplate : vlegendTemplate,
// 			labels : ["January","February","March","April","May","June","July"],
			datasets : []
// 				{
// 					label: "My Second dataset",
// 					fillColor : "rgba(151,187,205,0.2)",
// 					strokeColor : "rgba(151,187,205,1)",
// 					pointColor : "rgba(151,187,205,1)",
// 					pointStrokeColor : "#fff",
// 					pointHighlightFill : "#fff",
// 					pointHighlightStroke : "rgba(151,187,205,1)",
// 					data : [randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor()]
// 				}
// 			]

	};
	
	var randomScalingFactor = function(){ return Math.round(Math.random()*100)};


//     Chart.defaults.global.pointHitDetectionRadius = 1;
//     Chart.defaults.global.customTooltips = function(tooltip) {

//         var tooltipEl = $('#chartjs-tooltip');

//         if (!tooltip) {
//             tooltipEl.css({
//                 opacity: 0
//             });
//             return;
//         }

//         tooltipEl.removeClass('above below');
//         tooltipEl.addClass(tooltip.yAlign);

//         var innerHtml = '';
//         for (var i = tooltip.labels.length - 1; i >= 0; i--) {
//         	innerHtml += [
//         		'<div class="chartjs-tooltip-section">',
//         		'	<span class="chartjs-tooltip-key" style="background-color:' + tooltip.legendColors[i].fill + '"></span>',
//         		'	<span class="chartjs-tooltip-value">' + tooltip.labels[i] + '</span>',
//         		'</div>'
//         	].join('');
//         }
//         tooltipEl.html(innerHtml);

//         tooltipEl.css({
//             opacity: 1,
//             left: tooltip.chart.canvas.offsetLeft + tooltip.x + 'px',
//             top: tooltip.chart.canvas.offsetTop + tooltip.y + 'px',
//             fontFamily: tooltip.fontFamily,
//             fontSize: tooltip.fontSize,
//             fontStyle: tooltip.fontStyle,
//         });
//     };
</script>
				<div id="canvas-holder" style="width:90%;">
					<canvas id="canvas"></canvas>
				</div>
				
<!--     <div id="chartjs-tooltip"></div> -->
    
    