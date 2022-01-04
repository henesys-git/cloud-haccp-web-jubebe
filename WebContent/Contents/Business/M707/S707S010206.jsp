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

	String[] strColumnHead = {"regist_no", "view_cnt", "all_cnt", "rate", "document_no", "doc_name", "file_view_name","regist_no_rev"};

	String Fromdate="",Todate="";
	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	

	String param = Fromdate + "|" + Todate + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M707S010100E204", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	

//     int ColCount =TableModel.getColumnCount()+1;
//     out.println(zhtml);
%>

				<div style="width:90%;">
					<canvas id="canvas"></canvas>
				</div>         
	<script>
	
<%-- 	prod_name 	= '<%=TableModel.getValueAt(inx,4).toString().trim()%>' + '(<%=TableModel.getValueAt(inx,5).toString().trim()%>)'; --%>
<%-- 	proc_rate 	= '<%=TableModel.getValueAt(inx,2).toString().trim()%>'; --%>
<%-- 	process_dt 	= '<%=TableModel.getValueAt(inx,0).toString().trim()%>'; --%>
	window.chartColors = {
		red: 'rgb(255, 99, 132)',
		orange: 'rgb(255, 159, 64)',
		yellow: 'rgb(255, 205, 86)',
		green: 'rgb(75, 192, 192)',
		blue: 'rgb(54, 162, 235)',
		purple: 'rgb(153, 102, 255)',
		grey: 'rgb(201, 203, 207)'
	};
	var vlabels=[];
	var vdata=[];
    $(document).ready(function () {
//     	{"regist_no", "view_cnt", "all_cnt", "rate", "document_no", "doc_name", "file_view_name","regist_no_rev"};
		var doc_name, view_cnt, all_cnt,  view_rate, reg_no,document_no
		<%for(int inx=0; inx < RowCount; inx++){%>
			reg_no 		= '<%=TableModel.getValueAt(inx,0).toString().trim()%>';
			view_cnt	= '<%=TableModel.getValueAt(inx,2).toString().trim()%>';
			all_cnt		= '<%=TableModel.getValueAt(inx,2).toString().trim()%>';
			view_rate 	= '<%=TableModel.getValueAt(inx,3).toString().trim()%>';
			document_no = '<%=TableModel.getValueAt(inx,4).toString().trim()%>';
			doc_name 	= '<%=TableModel.getValueAt(inx,4).toString().trim()%>'+ '(<%=TableModel.getValueAt(inx,5).toString().trim()%>)';
			vlabels.push(doc_name);
			vdata.push(view_cnt);
		<%}%>	
    	var ctx = document.getElementById("canvas").getContext("2d");
		window.myBar = new Chart(ctx).Bar(barChartData, {
			responsive : true
		});
    });
	var randomScalingFactor = function(){ return (Math.round(Math.random()*10)%7)};

	var barChartData = {
// 			labels : ["January","February","March","April","May","June","July"], tbi_seolbi_repare
		labels : vlabels,
		datasets : [
// 			{
// 				fillColor : "rgba(220,220,220,0.5)",
// 				strokeColor : "rgba(220,220,220,0.8)",
// 				highlightFill: "rgba(220,220,220,0.75)",
// 				highlightStroke: "rgba(220,220,220,1)",
// 				data : [randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor()]
// 			},
			{
				fillColor 		: 'rgba(255, 159, 64)',
				strokeColor 	: 'rgba(54, 162, 235)',
				highlightFill 	: "rgba(151,187,205,0.75)",
				highlightStroke : "rgba(151,187,205,1)",
				data : vdata
			}
		]

	}
	window.onload = function(){
		var ctx = document.getElementById("canvas").getContext("2d");
		window.myBar = new Chart(ctx).Bar(barChartData, {
			responsive : true
		});
	}

	</script>
