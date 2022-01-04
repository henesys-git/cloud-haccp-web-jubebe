<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	// 	DoyosaeTableModel TableModel;
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	
	int startPageNo = 1;
// 	final int PageSize=15; 

	String[] strColumnHead = {"open_date","regist_no", "document_no","document_NAME", "file_view_name", "view_cnt"};

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
	
    TableModel = new DoyosaeTableModel("M707S010100E204", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	

%>
		<div id="canvas-holder" style="position: relative; width:100%;height:720px">
			<canvas id="canvas" style="width:100%;height:100%"></canvas>
		</div>
	 
<script>

	var contain_charData = [] ;
	var newColor = [];
	$(document).ready(function () {
		
        fn_Chart_Config_Set();
//      chart 초기데이터 세팅
		ChartData.type ='<%=Chart_Style%>';
//		type: 'line',
//			type: 'bar',
//			type: 'radar',

//		타이틀
		ChartData.options.title.text = '문서 열람 현황';
		xAxes_scaleLabel.labelString = '열람 일자';
		xAxes_scaleLabel.fontColor= "red";
		yAxes_scaleLabel.labelString = '열람 회수';
		yAxes_scaleLabel.fontColor= "red";				
		ChartData.options.scales.xAxes.scaleLabel = xAxes_scaleLabel;
 		ChartData.options.scales.yAxes.scaleLabel = yAxes_scaleLabel;
 		
 		newColor = [contain_charData.length];
 		
		for(var indx=0; indx < contain_charData.length; indx++){	
			var nColr =  Get_color(indx);
// 			console.log(nColr);
			datasets_element = {
					label: contain_charData[indx][0],
					backgroundColor: nColr,
					borderColor: nColr,
					data: [],
					fill: false
			};
			
			for (var index = 1; index < contain_charData[indx].length; index++) {
				datasets_element.data.push(contain_charData[indx][index]);
			}
			
			ChartData.data.datasets.push(datasets_element);
		}
		
     	ctx = document.getElementById('canvas').getContext('2d');
     	docLineChart = new Chart(ctx, ChartData);
     	docLineChart.generateLegend();
	});
	
	
	// Define a plugin to provide data labels
	Chart.plugins.register({
		afterDatasetsDraw: function(chart) {
			var ctx = chart.ctx;

			chart.data.datasets.forEach(function(dataset, i) {
				var meta = chart.getDatasetMeta(i);
				if (!meta.hidden) {
					meta.data.forEach(function(element, index) {
						// Draw the text in black, with the specified font
						ctx.fillStyle = 'rgb(0, 0, 0)';

						var fontSize = 16;
						var fontStyle = 'normal';
						var fontFamily = 'Helvetica Neue';
						ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);

						// Just naively convert to string for now
						var dataString = dataset.data[index].toString();
						
						// Make sure alignment settings are correct
						ctx.textAlign = 'center';
						ctx.textBaseline = 'middle';

						var padding = 5;
						var position = element.tooltipPosition();
						if(dataset.data[index]>0)					//2018-11-13 JH 추가
							ctx.fillText(dataString, position.x, position.y - (fontSize / 2) - padding);
					});
				}
			});
		}
	});
	
    function fn_Chart_Config_Set(){
		var charData_sub =[];
		var TIMES_sub=[];
		var prod_name="", prev_prod_name="";
		var Doc_name;
		var proc_rate;
		var process_dt;
		var start='0';
		var timestart='0';
		var datestart='0';
		ChartData.data.labels=[];
		ChartData.data.datasets=[];
// 		String[] strColumnHead = {"open_date","regist_no", "document_no","document_NAME", "file_view_name", "view_cnt"};
		<%for(int inx=0; inx < RowCount; inx++){%>
<%-- 			prod_name 	= '<%=TableModel.getValueAt(inx,3).toString().trim()%>'; --%>
			prod_name	= '<%=TableModel.getValueAt(inx,1).toString().trim()%>'+'<%=TableModel.getValueAt(inx,2).toString().trim()%>'+'(<%=TableModel.getValueAt(inx,4).toString().trim()%>)';
<%-- 			prod_name	= '<%=TableModel.getValueAt(inx,3).toString().trim()%>'+'(<%=TableModel.getValueAt(inx,4).toString().trim()%>)'; --%>
			Doc_name	= '<%=TableModel.getValueAt(inx,3).toString().trim()%>'+'<%=TableModel.getValueAt(inx,1).toString().trim()%>'+'(<%=TableModel.getValueAt(inx,4).toString().trim()%>)';
			proc_rate 	= '<%=TableModel.getValueAt(inx,5).toString().trim()%>';
			process_dt 	= '<%=TableModel.getValueAt(inx,0).toString().trim()%>';

			if(prev_prod_name==prod_name){
				charData_sub.push(proc_rate);
				if(timestart=='0'){
					TIMES.push(process_dt);
					ChartData.data.labels.push(process_dt);
// 					console.log(process_dt);
				}
			}
			else{
				if(start=='1') {
					contain_charData.push(charData_sub);

// 					console.log("ChartData.data.labels=" + ChartData.data.labels);
// 					console.log("charData_sub=" + charData_sub);
					timestart='1';
					charData_sub = [];					
				}
				else{ 
					start='1';
				}
				if(timestart=='0'){
					TIMES.push(process_dt);
					ChartData.data.labels.push(process_dt);
// 					charData_sub.push(process_dt);
				}
// 				charData_sub.push(process_dt);
				charData_sub.push(Doc_name);
				charData_sub.push(proc_rate);
			}
			prev_prod_name = prod_name;
		<%}%>
		contain_charData.push(charData_sub);
    }
        
	</script>
