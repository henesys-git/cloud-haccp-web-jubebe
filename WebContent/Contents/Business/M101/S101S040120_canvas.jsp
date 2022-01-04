<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
거래명세서뷰_canvas.jsp
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;

	String GV_ORDERNO="",GV_CHULHANO="",GV_LOTNO="",GV_PROD_CD="",GV_PROD_REV="", GV_POPUPLEVEL="", GV_CHULHA_SEQ="",GV_CUSTCD="",GV_CHUHADT="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("ChulhaNo")== null)
		GV_CHULHANO="";
	else
		GV_CHULHANO = request.getParameter("ChulhaNo");
	
	if(request.getParameter("ChulhaSeq")== null)
		GV_CHULHA_SEQ="";
	else
		GV_CHULHA_SEQ = request.getParameter("ChulhaSeq");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");
	
	if(request.getParameter("popUpLevel")== null)
		GV_POPUPLEVEL="";
	else
		GV_POPUPLEVEL = request.getParameter("popUpLevel");

	if(request.getParameter("cust_cd")== null)
		GV_CUSTCD="";
	else
		GV_CUSTCD = request.getParameter("cust_cd");
	
	if(request.getParameter("chuha_dt")== null)
		GV_CHUHADT="";
	else
		GV_CHUHADT = request.getParameter("chuha_dt");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_rev", GV_PROD_REV);
	jArray.put( "chulhano", GV_CHULHANO);
	jArray.put( "chulha_seq", GV_CHULHA_SEQ);
	jArray.put( "cust_cd", GV_CUSTCD);
	jArray.put( "chuha_dt", GV_CHUHADT);
	jArray.put( "member_key", member_key);
	
	System.out.println("GV_CUSTCD : " + GV_CUSTCD);
	
    TableModel = new DoyosaeTableModel("M101S040100E124", jArray);	
    int RowCount =TableModel.getRowCount();
	
 	// tbm_our_company_info 데이터 불러오기
    JSONObject jArrayE125 = new JSONObject();
    jArrayE125.put( "member_key", member_key);
    DoyosaeTableModel TableModelE125 = new DoyosaeTableModel("M101S040100E125", jArrayE125);
    int RowCountE125 =TableModelE125.getRowCount();
    
    // 납품일자,발주서번호,공급자정보,공급받는자정보
    String GV_CHUHA_DT="",GV_CUST_PONO="",GV_CUST_CD="",
    		GV_CUST_NM="",GV_BOSS_NAME="",GV_ADDRESS="",
    		GV_OUR_BIZNO="",GV_OUR_CUST_NM="",GV_OUR_BOSS_NAME="",
    		GV_OUR_ADDRESS="",GV_IMAGE_FILENAME="", 
    		GV_OUR_TELNO="", GV_OUR_FAXNO="" ;
    
    if(RowCount>0) {
    	GV_CHUHA_DT = TableModel.getValueAt(0,8).toString().trim();
    	GV_CUST_PONO = TableModel.getValueAt(0,9).toString().trim();
    	GV_CUST_CD = TableModel.getValueAt(0,10).toString().trim();
    	GV_CUST_NM = TableModel.getValueAt(0,11).toString().trim();
    	GV_BOSS_NAME = TableModel.getValueAt(0,12).toString().trim();
    	GV_ADDRESS = TableModel.getValueAt(0,13).toString().trim();
    }
    if(RowCountE125>0) { //우리회사
    	GV_OUR_BIZNO = TableModelE125.getValueAt(0,0).toString().trim();
    	GV_OUR_CUST_NM = TableModelE125.getValueAt(0,2).toString().trim();
    	GV_OUR_BOSS_NAME = TableModelE125.getValueAt(0,5).toString().trim();
    	GV_OUR_ADDRESS = TableModelE125.getValueAt(0,3).toString().trim();
    	GV_IMAGE_FILENAME = TableModelE125.getValueAt(0,18).toString().trim();
    	GV_OUR_TELNO = TableModelE125.getValueAt(0,4).toString().trim();
    	GV_OUR_FAXNO = TableModelE125.getValueAt(0,8).toString().trim();
    	
    }
	
    String temp_str = ""; 
    String tot_amt_str = "";
	int TOT_AMT = 0;
	for(int i = 0; i < TableModel.getRowCount(); i++) {
		temp_str = (TableModel.getValueAt(i, 6).toString()).replaceAll(",", "");
		TOT_AMT += Integer.parseInt(temp_str);
	}
	TOT_AMT = TOT_AMT + (int) (TOT_AMT/10);
	tot_amt_str = Common.getFormatData(TOT_AMT, "###,###,###");

    // 하단 테이블표 데이터
	String chulha_month = GV_CHUHA_DT.substring(5, 7);
	String chulha_date = GV_CHUHA_DT.substring(8, 10);

    StringBuffer DATA_LIST = new StringBuffer(); // 표1에 들어갈 데이터
	DATA_LIST.append("[");
	for(int i=0; i<RowCount; i++) {
		StringBuffer data_sub = new StringBuffer();
		data_sub.append("[");
		for(int j=0; j<8; j++) {
			if (j == 0) {
				data_sub.append("'" + chulha_month + "',");	// month
			} else if (j == 1) {
				data_sub.append("'" + chulha_date + "',");	// date
			} else {
				data_sub.append("'" + TableModel.getValueAt(i, j).toString().trim() + "',"); // 칼럼3~7
			}
		}
		if(i==RowCount-1) data_sub.append( "]");
		else data_sub.append( "],");
		DATA_LIST.append(data_sub);
	}
	DATA_LIST.append("]");
	
	System.out.println("DATA_LIST : " + DATA_LIST);
	
%>

<script type="text/javascript">
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 50; // 헤드텍스트 영역 종료 높이
	
	// 상단 텍스트2 영역
	var HeadText2_HeightStart = HaedText_HeightEnd; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText2_HeightEnd = HeadText2_HeightStart + 150; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 15px 맑은고딕';
	var DataGrid1_RowHeight1st = 25; // 표1의 1번째 행 높이
	var DataGrid1_RowHeight = 25; // 표1의 행 높이
	var DataGrid1_RowCount = 10; // 표1의 행 개수
	var DataGrid1_Width = 0 ; // document ready에서 표1칼럼너비 전부 합쳐서 구함
	var DataGrid1_HeightStart = HaedText2_HeightEnd;
	var DataGrid1_HeightEnd = DataGrid1_HeightStart + DataGrid1_RowHeight1st 
						 	  + (DataGrid1_RowCount * DataGrid1_RowHeight); // 표1 높이
	
	// 캔버스 other options
   	var lineClr = '#0F6624';	// 테두리 색깔
   	var lnThck = '1';	// 라인 두께
	
    $(document).ready(function() {// 캔버스영역 너비 계산
        for(i = 0; i < DataGrid1.col_head_width.length; i++){
           	DataGrid1_Width += DataGrid1.col_head_width[i] ;
        }
    						 
    	// 캔버스 전체 크기 영역
        var CanvasPadding = 10; // 캔버스영역 안쪽 여백
        var CanvasWidth = DataGrid1_Width + CanvasPadding*2; // 캔버스영역 너비
        var CanvasHeight = DataGrid1_HeightEnd + CanvasPadding*2; // 캔버스영역 높이(테이블표 가장 아래부분)
        
     	// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding; // 끝좌표y
    	
    	// 공급자용
		document.getElementById("myCanvas").width = CanvasWidth;
   		document.getElementById("myCanvas").height = CanvasHeight;
   		var sub_title1 = '(공급자용)';
   		
   		var ctx = document.getElementById("myCanvas").getContext("2d"); 
   		HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd, sub_title1);
   	    HeadText2.drawText(ctx, pointSX, pointSY + HeadText2_HeightStart, pointEX, pointSY + HaedText2_HeightEnd);
   		DataGrid1.drawGrid(ctx, pointSX, pointSY + DataGrid1_HeightStart, pointEX, pointSY + DataGrid1_HeightEnd);
   		
   		// 공급받는자용
   		document.getElementById("myCanvas2").width = CanvasWidth;
   		document.getElementById("myCanvas2").height = CanvasHeight;
   		var sub_title2 = '(공급받는자용)';

   		var dtx = document.getElementById("myCanvas2").getContext("2d");
   		HeadText.drawText(dtx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd, sub_title2);
   		HeadText2.drawText(dtx, pointSX, pointSY + HeadText2_HeightStart, pointEX, pointSY + HaedText2_HeightEnd);
   		DataGrid1.drawGrid(dtx, pointSX, pointSY + DataGrid1_HeightStart, pointEX, pointSY + DataGrid1_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey, sub_title) {
			var blank_tab = '    '; // 4칸 공백
			var head_title = '거 래 명 세 표';
			var col_head_y = sy + (ey-sy)/2;
			var col_head_x_1st_width = 200; // 1번째 칸너비 200
			var col_head_x_1st = sx + col_head_x_1st_width;
			
			ctx_Box(ctx, sx, sy, ex, ey, lineClr, 1); // 표 전체 틀(사각형)
			ctx_Line(ctx, sx, col_head_y, col_head_x_1st, col_head_y, lineClr, lnThck); 	// 가로선
			ctx_Line(ctx, col_head_x_1st, sy, col_head_x_1st, ey, lineClr, lnThck); 		// 세로선
			ctx_fillText(ctx, sx+(ex-sx)/2, col_head_y, head_title, lineClr, 
						 'bold 25px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, sx+(ex-sx)/2+80, col_head_y+3, sub_title, lineClr, 
					 	 '15px 맑은고딕', 'left','middle');
			ctx_fillText(ctx, col_head_x_1st-col_head_x_1st_width/2, sy+(ey-sy)/4, 
						 '거래일자', lineClr, vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, col_head_x_1st-col_head_x_1st_width/2, col_head_y+(ey-sy)/4, 
						 '<%=GV_CHUHA_DT%>', lineClr, vTextStyle, 'center','middle');
		} // HeadText.drawText function end
	} ;
 	
	// 상단 텍스트2 정의
	var HeadText2 = {
		col_head:["상호 (법인명)","사업장 주소","전화번호","합계 (VAT포함)","등록 번호","상호 (법인명)","사업장 주소","전화","성명","팩스"],
		col_data:["<%=GV_CUST_NM%>","<%=GV_ADDRESS%>","<%=GV_CUST_CD%>", "<%=tot_amt_str%>",
				  "<%=GV_OUR_BIZNO%>","<%=GV_OUR_CUST_NM%>","<%=GV_OUR_ADDRESS%>","<%=GV_OUR_TELNO%>",
				  "<%=GV_OUR_BOSS_NAME%>","<%=GV_OUR_FAXNO%>"],
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, lineClr, lnThck); // 표 전체 틀(사각형)
			var col_head_y_height = 50;
			var col_head_x_width1 = 40;
			var col_head_x_width2 = (ex-sx)/2-col_head_x_width1*2;
			var col_head_x_1st = sx + col_head_x_width1;
			
			var col_head_x_cut = (ex-sx) / 24;
			var col_head_x_2nd = col_head_x_1st + col_head_x_width1 * 2;
			var col_head_x_3rd = col_head_x_2nd + col_head_x_width2;
			var col_head_x_4th = col_head_x_3rd + col_head_x_width1;
			var col_head_x_5th = col_head_x_4th + col_head_x_width1;
			
			// 공급받는자 라인
			ctx_Line(ctx, col_head_x_cut, sy, col_head_x_cut, ey, lineClr, lnThck); 					  // 세로선
			ctx_Line(ctx, col_head_x_cut*2.7, sy, col_head_x_cut*2.7, ey, lineClr, lnThck); 			  // 세로선
			ctx_Line(ctx, col_head_x_cut*11.5, sy, col_head_x_cut*11.5, sy+(ey-sy)*1/4, lineClr, lnThck); // 세로선
			ctx_Line(ctx, col_head_x_cut*13, sy, col_head_x_cut*13, ey, lineClr, lnThck); 				  // 세로선 센터
			ctx_Line(ctx, col_head_x_cut, sy+(ey-sy)*1/4, col_head_x_cut*13, sy+(ey-sy)*1/4, lineClr, lnThck); // 가로선
			ctx_Line(ctx, col_head_x_cut, sy+(ey-sy)*2/4, col_head_x_cut*13, sy+(ey-sy)*2/4, lineClr, lnThck); // 가로선
			ctx_Line(ctx, col_head_x_cut, sy+(ey-sy)*3/4, col_head_x_cut*13, sy+(ey-sy)*3/4, lineClr, lnThck); // 가로선
			
			// 공급받는자 메뉴 텍스트
			ctx_wrapText_space(ctx, col_head_x_cut*1.85, sy+(ey-sy)*1/8, this.col_head[0], lineClr, 
							   vTextStyle, 'center', 'middle', col_head_x_cut*1.5, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*1.85, sy+(ey-sy)*3/8, this.col_head[1], lineClr, 
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*1.5, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*1.85, sy+(ey-sy)*5/8, this.col_head[2], lineClr, 
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*1.5, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*1.85, sy+(ey-sy)*7/8, this.col_head[3], lineClr, 
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*1.5, col_head_y_height/3);
			
			// 공급받는자 메뉴 값 텍스트
			ctx_wrapText(ctx, col_head_x_cut*0.6, sy+(ey-sy)/2, '공급받는자', lineClr, vTextStyleBold, 
					     'center','middle', 10, col_head_y_height/2);
			ctx_wrapText_space(ctx, col_head_x_cut*7.1, sy+(ey-sy)*1/8, this.col_data[0], lineClr, 
							   vTextStyle, 'center', 'middle', col_head_x_cut*7.1, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*7.85, sy+(ey-sy)*3/8, this.col_data[1], lineClr, 
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*7.85, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*7.85, sy+(ey-sy)*5/8, this.col_data[2], lineClr, 
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*7.85, col_head_y_height/3);
			
			if(this.col_data[3] == '0') {
				ctx_wrapText_space(ctx, col_head_x_cut*7.85, sy+(ey-sy)*7/8, '', lineClr, 
						   		   vTextStyle, 'center', 'middle', col_head_x_cut*7.85, col_head_y_height/3);
			} else {
				ctx_wrapText_space(ctx, col_head_x_cut*7.85, sy+(ey-sy)*7/8, this.col_data[3], lineClr, 
				   		   vTextStyle, 'center', 'middle', col_head_x_cut*7.85, col_head_y_height/3);
			}
			
			// 공급자 라인
			ctx_Line(ctx, col_head_x_cut*13.8, sy, col_head_x_cut*13.8, ey, lineClr, lnThck); // 세로선 ('공급자'우측)
			ctx_Line(ctx, col_head_x_cut*15.5, sy, col_head_x_cut*15.5, ey, lineClr, lnThck); // 세로선 (메뉴 우측)
			
			ctx_Line(ctx, col_head_x_cut*13.8, sy+(ey-sy)*1/4, col_head_x_cut*24+10, sy+(ey-sy)*1/4, lineClr, lnThck); // 가로선1
			ctx_Line(ctx, col_head_x_cut*13.8, sy+(ey-sy)*2/4, col_head_x_cut*24+10, sy+(ey-sy)*2/4, lineClr, lnThck); // 가로선2
			ctx_Line(ctx, col_head_x_cut*13.8, sy+(ey-sy)*3/4, col_head_x_cut*24+10, sy+(ey-sy)*3/4, lineClr, lnThck); // 가로선3
			
			var regLineArr = [];
			var regNumX = col_head_x_cut*15.5;
			var regNumSlice = this.col_data[4];
			for(i = 0; i < regNumSlice.length; i++) {	// 등록번호 라인 + 텍스트
				var regLine = (col_head_x_cut*24+10 - col_head_x_cut*15.5) / 12;
				
				regNumX += regLine;
				regLineArr.push(regNumX);
				
				if(i == 0) {	// 등록번호 중앙정렬을 위한 x좌표
					var regNumCenter = regLineArr[i] - (regLineArr[i] - col_head_x_cut*15.5)/2;
				} else {
					regNumCenter = regLineArr[i] - (regLineArr[i] - regLineArr[i-1])/2;
				}
				
				
				
				ctx_Line(ctx, regLineArr[i], sy, regLineArr[i], sy+(ey-sy)*1/4, lineClr, lnThck);
 				ctx_wrapText_space(ctx, regNumCenter, sy+(ey-sy)*1/8, regNumSlice.charAt(i), lineClr,
 						   vTextStyle, 'center', 'middle', col_head_x_cut*7.1, col_head_y_height/3);
 				
				
				if(i == 6) {	// 팩스 라인+텍스트
					ctx_Line(ctx, regLineArr[i-1], sy+(ey-sy)*3/4, regLineArr[i-1], ey, lineClr, lnThck);
					ctx_Line(ctx, regLineArr[i], sy+(ey-sy)*3/4, regLineArr[i], ey, lineClr, lnThck);
					ctx_wrapText_space(ctx, regLineArr[i]-(regLineArr[i]-regLineArr[i-1])/2, sy+(ey-sy)*7/8,
					   		   this.col_head[9], lineClr, vTextStyle, 'center', 'middle',
					   	       col_head_x_cut*1.5, col_head_y_height/3);
				}
				if(i == 7) {	// 성명 라인+텍스트 메뉴,값 & 상호(법인명) 값
					ctx_Line(ctx, regLineArr[i-1], sy+(ey-sy)*1/4, regLineArr[i-1], sy+(ey-sy)*2/4, lineClr, lnThck);
					ctx_Line(ctx, regLineArr[i], sy+(ey-sy)*1/4, regLineArr[i], sy+(ey-sy)*2/4, lineClr, lnThck);
					ctx_wrapText_space(ctx, regLineArr[i]-(regLineArr[i]-regLineArr[i-1])/2, sy+(ey-sy)*3/8,	// 성명 메뉴
							   		   this.col_head[8], lineClr, vTextStyle, 'center', 'middle',
							   		   regLineArr[i]-regLineArr[i-1], col_head_y_height/3);
					
					ctx_wrapText_space(ctx, col_head_x_cut*22.8, sy+(ey-sy)*3/8, this.col_data[8], 	// 성명 값
							   		   lineClr, vTextStyle, 'center', 'middle', col_head_x_cut*7.85, 
							   		   col_head_y_height/3);
					
					ctx_wrapText_space(ctx, col_head_x_cut*18, sy+(ey-sy)*3/8, this.col_data[5], // 상호(법인명) 값
									   lineClr, vTextStyle, 'center', 'middle', col_head_x_cut*7.85, 
									   col_head_y_height/3);
				}
			}
			
			// 공급자 메뉴 텍스트
			ctx_wrapText_space(ctx, col_head_x_cut*14.65, sy+(ey-sy)*1/8, this.col_head[4], lineClr, 
							   vTextStyle, 'center', 'middle', col_head_x_cut*1.5, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*14.65, sy+(ey-sy)*3/8, this.col_head[5], lineClr, 
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*1.5, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*14.65, sy+(ey-sy)*5/8, this.col_head[6], lineClr, 
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*1.5, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*14.65, sy+(ey-sy)*7/8, this.col_head[7], lineClr, 
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*1.5, col_head_y_height/3);
			
			// 공급자 메뉴 값 텍스트
			ctx_wrapText_space(ctx, col_head_x_cut*20, sy+(ey-sy)*5/8, this.col_data[6], lineClr, 			// 사업장 주소
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*7.85, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*18, sy+(ey-sy)*7/8, this.col_data[7], lineClr, 			// 전화
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*7.85, col_head_y_height/3);
			ctx_wrapText_space(ctx, col_head_x_cut*22, sy+(ey-sy)*7/8, this.col_data[9], lineClr, 			// 팩스
					   		   vTextStyle, 'center', 'middle', col_head_x_cut*7.85, col_head_y_height/3);
			ctx_wrapText(ctx, col_head_x_cut*13.4, sy+(ey-sy)/2, '공급자', lineClr, 
						 vTextStyleBold, 'center','middle', 10, col_head_y_height);
		} // HeadText.drawText function end
	};
	
	// 표1 정의
	var DataGrid1 = {
		col_head : ["월","일","품목","규격","수량","단가(VAT별도)","금액","비고"],
		col_head_width : [40,40,400,96,96,139,139,70],
		col_data : <%=DATA_LIST%>, // DB에서 읽어온 데이터
		   
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, lineClr,1); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid1_RowHeight1st ;
			var col_head_y_center = col_head_y - DataGrid1_RowHeight1st/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			ctx_Line(ctx, sx, col_head_y, ex, col_head_y, lineClr, 1); // 가로선
			for(i = 0; i < this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i < this.col_head_width.length-1)
					ctx_Line(ctx, col_head_x, sy, col_head_x, ey, lineClr, 1); // 세로선
				ctx_fillText(ctx, col_head_x_center, col_head_y_center, this.col_head[i], 
							 lineClr, vTextStyleBold, 'center','middle');
			}
			
			
			// 데이터
			var col_data_y = sy + DataGrid1_RowHeight ;
			
			for(i = 0; i < DataGrid1_RowCount-1; i++){	// 10번 반복
				col_data_y += DataGrid1_RowHeight;
				
				if(i < this.col_data.length) {
					var col_data_y_center = col_data_y - DataGrid1_RowHeight/2 ;
					var col_data_x = sx ;
					for(j=0; j<this.col_data[i].length; j++){
						col_data_x += this.col_head_width[j] ;
						var col_data_x_center = col_data_x - this.col_head_width[j]/2 ;
						if(j == 6) {
							if(this.col_data[i][5] == '') {
								ctx_wrapText(ctx, col_data_x_center, col_data_y_center,  '', lineClr, vTextStyle, 'center','middle', 
										 this.col_head_width[j], DataGrid1_RowHeight/2);
							}
						}
						else { 
							ctx_wrapText(ctx, col_data_x_center, col_data_y_center,  this.col_data[i][j], lineClr, vTextStyle, 'center','middle', 
									 this.col_head_width[j], DataGrid1_RowHeight/2);
						}
						
					}
				}
				ctx_Line(ctx, sx, col_data_y, ex, col_data_y, lineClr, 1); // 가로선
			}
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
</script>
<div style="overflow-y:auto; width:100%; height:100%; text-align:center;">
    <div id="PrintAreaP" style="overflow-y:auto; width:100%; height:90%; text-align:center;">
	    <canvas id="myCanvas"></canvas>		<!-- 공급자용 -->
	    <canvas id="myCanvas2"></canvas>	<!-- 공급받는자용 -->
	</div>
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
    	<%if(GV_POPUPLEVEL.equals("2nd")) {%>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd_2').hide();parent.$('#modalReport_nd_2').hide();">닫기</button>
        <%} else {%>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
        <%}%>
    </p>
</div>    