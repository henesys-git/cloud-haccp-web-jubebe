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
조도 점검표 canvas (S838S010300_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
	DoyosaeTableModel TableModelPre;
	DoyosaeTableModel PersonModel;
	DoyosaeTableModel ProductModel;
	DoyosaeTableModel PermissionModel;
	DoyosaeTableModel EquipmentModel;

	String GV_SUBCONSTRACTOR_NO = "", GV_SUBCONSTRACTOR_REV = "", GV_SUBCONSTRACTOR_SEQ = "", GV_IO_GB = "";
	
	if(request.getParameter("Subcontractor_no")== null)
		GV_SUBCONSTRACTOR_NO ="";
	else
		GV_SUBCONSTRACTOR_NO = request.getParameter("Subcontractor_no");
	
	if(request.getParameter("Subcontractor_rev")== null)
		GV_SUBCONSTRACTOR_REV ="";
	else
		GV_SUBCONSTRACTOR_REV = request.getParameter("Subcontractor_rev");
	
	if(request.getParameter("Subcontractor_seq")== null)
		GV_SUBCONSTRACTOR_SEQ ="";
	else
		GV_SUBCONSTRACTOR_SEQ = request.getParameter("Subcontractor_seq");
	
	if(request.getParameter("Io_gb")== null)
		GV_IO_GB ="";
	else
		GV_IO_GB = request.getParameter("Io_gb");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "subcontractor_no", GV_SUBCONSTRACTOR_NO);
	jArray.put( "subcontractor_rev", GV_SUBCONSTRACTOR_REV);
	jArray.put( "subcontractor_seq", GV_SUBCONSTRACTOR_SEQ);
	jArray.put( "io_gb", GV_IO_GB);
	jArray.put( "member_key", member_key);

    TableModel = new DoyosaeTableModel("M838S060200E154", jArray);	
    TableModelPre = new DoyosaeTableModel("M838S060200E164", jArray);
    PersonModel = new DoyosaeTableModel("M838S060200E114", jArray);
    ProductModel = new DoyosaeTableModel("M838S060200E124", jArray);
    PermissionModel = new DoyosaeTableModel("M838S060200E134", jArray);
    EquipmentModel = new DoyosaeTableModel("M838S060200E144", jArray);
	
 	int RowCount =TableModel.getRowCount();
 	int RowCountPre =TableModelPre.getRowCount();
 	int PersonRowCount =PersonModel.getRowCount();
 	int ProductRowCount =ProductModel.getRowCount();
 	int PermissionRowCount =PermissionModel.getRowCount();
 	int EquipmentRowCount =EquipmentModel.getRowCount();
 	
	String cust_cd 				= "";
	String revision_no 			= "";
	String cust_nm 				= "";
	String address 				= "";
	String telno 				= "";
	String boss_name 			= "";
	String bizno 				= "";
	String uptae 				= "";
	String jongmok 				= "";
	String faxno 				= "";
	String homepage 			= "";
	String zipno 				= "";
	String dangsa_damdangja 	= "";
	String cust_damdangja 		= "";
	String damdangja_dno 		= "";
	String damdangja_hpno 		= "";
	String damdangja_email 		= "";
	String visit_jugi_day 		= "";
	String io_gb 				= "";
	String old_cust_cd 			= "";
	String start_date 			= "";
	String create_date 			= "";
	String create_user_id 		= "";
	String modify_date 			= "";
	String modify_user_id 		= "";
	String duration_date 		= "";
	String modify_reason 		= "";
	String refno 				= "";
    
	String subcontractor_seq 				= "";
	String subcontractor_factory_address 	= "";
	String subcontractor_factory_phone 		= "";
	String establish_date 					= "";
	String factory_scale 					= "";
	String checker 							= "";
	String check_date 						= "";
	String approval 						= "";
	String approve_date 					= "";
	String appraisal_means 					= "";
	String present_rev 						= "";
	
	StringBuffer PersonArray = new StringBuffer();
	StringBuffer ProductArray = new StringBuffer();
	StringBuffer PermissionArray = new StringBuffer();
	StringBuffer EquipmentArray = new StringBuffer();
	if(RowCount>0) {
		cust_cd 			 = TableModel.getValueAt(0, 0).toString().trim();
		revision_no 		 = TableModel.getValueAt(0, 1).toString().trim();
		cust_nm 			 = TableModel.getValueAt(0, 2).toString().trim();
		address 			 = TableModel.getValueAt(0, 3).toString().trim();
		telno 				 = TableModel.getValueAt(0, 4).toString().trim();
		boss_name 			 = TableModel.getValueAt(0, 5).toString().trim();
		bizno 				 = TableModel.getValueAt(0, 6).toString().trim();
		uptae 				 = TableModel.getValueAt(0, 7).toString().trim();
		jongmok 			 = TableModel.getValueAt(0, 8).toString().trim();
		faxno 				 = TableModel.getValueAt(0, 9).toString().trim();
		homepage 			 = TableModel.getValueAt(0, 10).toString().trim();
		zipno 				 = TableModel.getValueAt(0, 11).toString().trim();
		dangsa_damdangja 	 = TableModel.getValueAt(0, 12).toString().trim();
		cust_damdangja 		 = TableModel.getValueAt(0, 13).toString().trim();
		damdangja_dno 		 = TableModel.getValueAt(0, 14).toString().trim();
		damdangja_hpno 		 = TableModel.getValueAt(0, 15).toString().trim();
		damdangja_email 	 = TableModel.getValueAt(0, 16).toString().trim();
		visit_jugi_day 		 = TableModel.getValueAt(0, 17).toString().trim();
		io_gb 				 = TableModel.getValueAt(0, 18).toString().trim();
		old_cust_cd 		 = TableModel.getValueAt(0, 19).toString().trim();
		start_date 			 = TableModel.getValueAt(0, 20).toString().trim();
		create_date 		 = TableModel.getValueAt(0, 21).toString().trim();
		create_user_id 		 = TableModel.getValueAt(0, 22).toString().trim();
		modify_date 		 = TableModel.getValueAt(0, 23).toString().trim();
		modify_user_id 		 = TableModel.getValueAt(0, 24).toString().trim();
		duration_date 		 = TableModel.getValueAt(0, 25).toString().trim();
		modify_reason 		 = TableModel.getValueAt(0, 26).toString().trim();
		refno 				 = TableModel.getValueAt(0, 27).toString().trim();
           
		if(RowCountPre>0){
			subcontractor_seq 				= TableModelPre.getValueAt(0, 2).toString().trim();
			subcontractor_factory_address 	= TableModelPre.getValueAt(0, 3).toString().trim();
			subcontractor_factory_phone 	= TableModelPre.getValueAt(0, 4).toString().trim();
			establish_date 					= TableModelPre.getValueAt(0, 5).toString().trim();
			factory_scale 					= TableModelPre.getValueAt(0, 6).toString().trim();
			checker 						= TableModelPre.getValueAt(0, 7).toString().trim();
			check_date 						= TableModelPre.getValueAt(0, 8).toString().trim();
			approval 						= TableModelPre.getValueAt(0, 9).toString().trim();
			approve_date 					= TableModelPre.getValueAt(0, 10).toString().trim();
			appraisal_means 				= TableModelPre.getValueAt(0, 11).toString().trim();
			present_rev 					= TableModelPre.getValueAt(0, 13).toString().trim();
		}
		
		for(int i = 0; i < PersonRowCount; i++){
			PersonArray.append("[");			
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 2).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 3).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 4).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 5).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 6).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 7).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 8).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 9).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 10).toString().trim()  + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 11).toString().trim() + "',");
		    PersonArray.append("'"+ PersonModel.getValueAt(i, 12).toString().trim() + "'");
			if(i==PersonRowCount-1) {
				PersonArray.append( "]");
			} else {
				PersonArray.append( "],");
			}
		}
		for(int i = 0; i < ProductRowCount; i++){
			ProductArray.append("[");	
		    ProductArray.append("'"+ ProductModel.getValueAt(i, 2).toString().trim()  + "',"); // product_division
		    ProductArray.append("'"+ ProductModel.getValueAt(i, 3).toString().trim()  + "',"); // product_measure 
		    ProductArray.append("'"+ ProductModel.getValueAt(i, 4).toString().trim()  + "',"); // product_capacity
		    ProductArray.append("'"+ ProductModel.getValueAt(i, 5).toString().trim()  + "',"); // product_bigo    
		    ProductArray.append("'"+ ProductModel.getValueAt(i, 7).toString().trim()  + "',"); // product_rev 
		    ProductArray.append("'"+ ProductModel.getValueAt(i, 8).toString().trim()  + "',"); // product_seq 
			if(i==ProductRowCount-1) {
				ProductArray.append( "]");
			} else {
				ProductArray.append( "],");
			}
		}
		for(int i = 0; i < PermissionRowCount; i++){
			PermissionArray.append("[");
			PermissionArray.append("'"+ PermissionModel.getValueAt(i, 2).toString().trim()  + "',"); // permission_division 
			PermissionArray.append("'"+ PermissionModel.getValueAt(i, 3).toString().trim()  + "',"); // permission_name     
			PermissionArray.append("'"+ PermissionModel.getValueAt(i, 4).toString().trim()  + "',"); // permission_institute
			PermissionArray.append("'"+ PermissionModel.getValueAt(i, 5).toString().trim()  + "',"); // permission_date     
			PermissionArray.append("'"+ PermissionModel.getValueAt(i, 6).toString().trim()  + "',"); // permission_bigo     
			PermissionArray.append("'"+ PermissionModel.getValueAt(i, 8).toString().trim()  + "',"); // permission_rev      
			PermissionArray.append("'"+ PermissionModel.getValueAt(i, 9).toString().trim()  + "',"); // permission_seq       
			if(i==PermissionRowCount-1) {
				PermissionArray.append( "]");
			} else {
				PermissionArray.append( "],");
			}
		}
		for(int i = 0; i < EquipmentRowCount; i++){
			EquipmentArray.append("[");
			EquipmentArray.append("'"+ EquipmentModel.getValueAt(i, 2).toString().trim()  + "',"); // equipment_name        
			EquipmentArray.append("'"+ EquipmentModel.getValueAt(i, 3).toString().trim()  + "',"); // equipment_standard    
			EquipmentArray.append("'"+ EquipmentModel.getValueAt(i, 4).toString().trim()  + "',"); // equipment_manufacturer
			EquipmentArray.append("'"+ EquipmentModel.getValueAt(i, 5).toString().trim()  + "',"); // equipment_have        
			EquipmentArray.append("'"+ EquipmentModel.getValueAt(i, 6).toString().trim()  + "',"); // equipment_bigo        
			EquipmentArray.append("'"+ EquipmentModel.getValueAt(i, 8).toString().trim()  + "',"); // equipment_rev         
			EquipmentArray.append("'"+ EquipmentModel.getValueAt(i, 9).toString().trim()  + "',"); // equipment_seq         
			if(i==EquipmentRowCount-1) {
				EquipmentArray.append( "]");
			} else {
				EquipmentArray.append( "],");
			}
		}
 
	}

%>

<script type="text/javascript">	
	

	var vTextStyle = '15px 맑은고딕';
	var vTextStyleBold = 'bold 18px 맑은고딕';

	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 120; // 헤드텍스트 영역 종료 높이
	
	// 승인자
	var CheckText_HeightStart = HaedText_HeightEnd;
	var CheckText_HeightEnd = CheckText_HeightStart + 40; // 점검관련사항 영역 종료 높이
	
	// 인계자
	var SubdataText_HeightStart = CheckText_HeightEnd;
	var SubdataText_HeightEnd = SubdataText_HeightStart + 160; // 점검관련사항 영역 종료 높이
	
	// 인원현황
	var person_row = '<%=PersonRowCount%>';
	var PersonText_HeightStart = SubdataText_HeightEnd; // 표1 시작위치(헤드텍스트영역 끝 높이)
	var PersonText_HeightEnd = PersonText_HeightStart + (parseInt(person_row)+1)*40;
//	console.log(PersonText_HeightStart + " + " + "(" + person_row + "+ 1)*40 = " + PersonText_HeightEnd);
	
	// 제품생산능력
	var product_row = '<%=ProductRowCount%>';
	var ProductText_HeightStart = PersonText_HeightEnd;
	var ProductText_HeightEnd = ProductText_HeightStart + (parseInt(product_row)+2)*40;
	
	// 인증허가관계
	var permission_row = '<%=PermissionRowCount%>';
	var PermissionText_HeightStart = ProductText_HeightEnd;
	var PermissionText_HeightEnd = PermissionText_HeightStart + (parseInt(permission_row)+2)*40; 
	
	// 제조설비현황
	var equipment_row = '<%=EquipmentRowCount%>';
	var EquipmentText_HeightStart = PermissionText_HeightEnd;
	var EquipmentText_HeightEnd = EquipmentText_HeightStart + (parseInt(equipment_row)+2)*40;
	
	// 평가방법
	var AppraisalText_HeightStart = EquipmentText_HeightEnd;
	var AppraisalText_HeightEnd = AppraisalText_HeightStart + 3*40;
	
    $(document).ready(function () {
    	// 하단 부분 높이 추가(데이터 라인수에 맞춰서)
    	var ctx_temp = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트(임시)

    	// 캔버스 전체 크기 영역
    	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
    	var CanvasWidth = PersonText.col_head_width[0]; // 캔버스영역 너비
    	var CanvasHeight = AppraisalText_HeightEnd + CanvasPadding*2; // 캔버스영역 높이
		
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		var ctx = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트
		
		// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding ; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding ; // 끝좌표y

		// 그리기
 	    HeadText.drawText(ctx, pointSX,  pointSY + HeadText_HeightStart,  pointEX, pointSY + HaedText_HeightEnd);
	    CheckText.drawText(ctx, pointSX, pointSY + CheckText_HeightStart, pointEX, pointSY + CheckText_HeightEnd);
	    SubdataText.drawText(ctx, pointSX, pointSY + SubdataText_HeightStart, pointEX, pointSY + SubdataText_HeightEnd);
 		PersonText.drawGrid(ctx, pointSX, pointSY + PersonText_HeightStart, pointEX, pointSY + PersonText_HeightEnd);
 		ProductText.drawText(ctx, pointSX, pointSY + ProductText_HeightStart, pointEX, pointSY + ProductText_HeightEnd);
 		PermissionText.drawText(ctx, pointSX, pointSY + PermissionText_HeightStart, pointEX, pointSY + PermissionText_HeightEnd);
 		EquipmentText.drawText(ctx, pointSX, pointSY + EquipmentText_HeightStart, pointEX, pointSY + EquipmentText_HeightEnd);
 		AppraisalText.drawText(ctx, pointSX, pointSY + AppraisalText_HeightStart, pointEX, pointSY + AppraisalText_HeightEnd);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var blank_tab = '    '; // 4칸 공백
			var top_info = 'TYENS-PRP-04-03 협력업체 현황서' ;
			var middle_info = '협력업체 현황서' ;
			ctx_fillText(ctx, sx, sy, top_info, 'black', '15px 맑은고딕', 'start','top');
			ctx_Box(ctx, sx, sy+15, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			ctx_fillText(ctx, (sx+ex)/2-80, sy+50, middle_info, 'black', 'bold 40px 맑은고딕', 'center','top');
			var col_approval_x_start = 2*(ex/3)+ex/7;
			var col_approval_x_end = col_approval_x_start;
			var col_approval_y_start = sy + 15;
			var col_approval_y_end = ey;
			var col_approval_x_1st_center = col_approval_x_start + (ex - col_approval_x_start)/2;
			var col_approval_x_2nd_center = col_approval_x_1st_center;
			var col_approval_y_1st_center = sy + 15;
			var col_approval_y_2nd_center = ey;

			ctx_Line(ctx, col_approval_x_start-(ex - col_approval_x_start)/2, col_approval_y_start, col_approval_x_end-(ex - col_approval_x_start)/2, col_approval_y_end, 'black', 1);
			ctx_Line(ctx, col_approval_x_start, col_approval_y_start, col_approval_x_end, col_approval_y_end, 'black', 1);
			ctx_Line(ctx, col_approval_x_1st_center, col_approval_y_1st_center, col_approval_x_2nd_center, col_approval_y_2nd_center, 'black', 1);
			var col_approval_x_1st_upper = col_approval_x_start-(ex - col_approval_x_start)/2;
			var col_approval_x_2nd_upper = ex;
			var col_approval_y_1st_upper = ey/4+40;
			var col_approval_y_2nd_upper = col_approval_y_1st_upper;
			ctx_Line(ctx, col_approval_x_1st_upper, col_approval_y_1st_upper, col_approval_x_2nd_upper, col_approval_y_2nd_upper, 'black', 1);
			var col_approval_x_1st_down = col_approval_x_start-(ex - col_approval_x_start)/2;
			var col_approval_x_2nd_down = ex;
			var col_approval_y_1st_down = ey*0.75+15;
			var col_approval_y_2nd_down = col_approval_y_1st_down;
			ctx_Line(ctx, col_approval_x_1st_down, col_approval_y_1st_down, col_approval_x_2nd_down, col_approval_y_2nd_down, 'black', 1);
			ctx_fillText(ctx, col_approval_x_start +37-(ex - col_approval_x_start)/2, col_approval_y_start +6, "작 성", 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, col_approval_x_start +37, col_approval_y_start +6, "검 토", 'black', vTextStyleBold, 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_center +37, col_approval_y_1st_center +6, "승 인", 'black', vTextStyleBold, 'center','top');

			// 작성, 승인 서명
			ctx_fillText(ctx, col_approval_x_1st_upper +40, col_approval_y_1st_upper +20, "<%=create_user_id%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_upper +40 + (ex - col_approval_x_start)/2, col_approval_y_1st_upper +20, "<%=checker%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			ctx_fillText(ctx, col_approval_x_1st_center +40, col_approval_y_1st_upper +20, "<%=approval%>", 'black', 'bold 20px 맑은고딕', 'center','top');
			
			// write_approval, haccp_approval
			console.log('test : ' + '<%=create_date%>');
			var write_duration = '<%=create_date%>';
			var write_date = write_duration.substring(5,7) +"/"+ write_duration.substring(8,11);
			ctx_fillText(ctx, col_approval_x_1st_upper +40, col_approval_y_1st_down +5, write_date, 'black', vTextStyleBold, 'center','top');
			var check_duration = '<%=check_date%>'.split('-');
			if(check_duration[1] == null){ check_duration[1] = ''; }
			if(check_duration[2] == null){ check_duration[2] = ''; } 
			console.log(check_duration[1] +"/"+ check_duration[2]);
			var check_date = check_duration[1] +"/"+ check_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_upper +40 + (ex - col_approval_x_start)/2, col_approval_y_1st_down +5, check_date, 'black', vTextStyleBold, 'center','top');
			var approval_duration = '<%=approve_date%>'.split('-');
			if(approval_duration[1] == null){ approval_duration[1] = ''; }
			if(approval_duration[2] == null){ approval_duration[2] = ''; } 
			var approval_date = approval_duration[1] +"/"+ approval_duration[2];
			ctx_fillText(ctx, col_approval_x_1st_center +40, col_approval_y_1st_down +5, approval_date, 'black', vTextStyleBold, 'center','top');

		} // HeadText.drawText function end
	} ;

	// 회사정보 상단
	var CheckText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백

			var sub_name = '회 사 명';
			
			var sub_name_note = '<%=cust_nm%>';
			var sub_ceo 	= '대 표 자';
			var sub_ceo_note = '<%=boss_name%>';
			var sub_no 	= '업체번호';
			var sub_no_note = '<%=cust_cd%>';
			var text_hgt = sy-(CheckText_HeightStart - CheckText_HeightEnd)/2;
			var cut = ex/9;
			
			ctx_Line(ctx, sx+cut*1, sy, sx+cut*1, ey, 'black', 1);
			ctx_Line(ctx, sx+cut*3, sy, sx+cut*3, ey, 'black', 1);
			ctx_Line(ctx, sx+cut*4, sy, sx+cut*4, ey, 'black', 1);
			ctx_Line(ctx, sx+cut*6, sy, sx+cut*6, ey, 'black', 1);
			ctx_Line(ctx, sx+cut*7, sy, sx+cut*7, ey, 'black', 1);
			
			ctx_fillText(ctx, sx+cut*0.5, text_hgt , sub_name, 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*3.5, text_hgt , sub_ceo, 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*6.5, text_hgt , sub_no, 'black', vTextStyleBold, 'center','middle');
			
			ctx_fillText(ctx, sx+cut*1.5+20, text_hgt , sub_name_note, 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*4.5+20, text_hgt , sub_ceo_note, 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*7.5+20, text_hgt , sub_no_note, 'black', vTextStyleBold, 'center','middle');
		}		
		
	}
	// 회사정보
	var SubdataText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var sub_col_name = ["본사주소","본사전화번호","공장전화번호","공장주소","공장전화번호","설립일","공장규모","거래개시일"];
			var sub_data = ['<%=address%>','<%=telno%>','<%=subcontractor_factory_address%>','<%=subcontractor_factory_phone%>','<%=establish_date%>','<%=factory_scale%>'];
			var cut = ex/9;
			var text_hgt = SubdataText_HeightStart-5;
			ctx_Line(ctx, sx+cut*1, sy, sx+cut*1, ey, 'black', 1);
			ctx_Line(ctx, sx+cut*6, sy, sx+cut*6, ey-80, 'black', 1);			
			ctx_Line(ctx, sx+cut*7, sy, sx+cut*7, ey-80, 'black', 1);
			ctx_Line(ctx, sx, sy+40, ex, sy + 40, 'black', 1);
			ctx_Line(ctx, sx, sy+80, ex, sy + 80, 'black', 1);
			ctx_Line(ctx, sx, sy+120, ex, sy + 120, 'black', 1);
			ctx_Line(ctx, sx+cut*6, sy+120, sx+cut*6, ey, 'black', 1);			
			ctx_Line(ctx, sx+cut*7, sy+120, sx+cut*7, ey, 'black', 1);
			
			ctx_fillText(ctx, sx+cut*0.5, text_hgt+40*1, sub_col_name[0], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*0.5, text_hgt+40*2, sub_col_name[3], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*0.5, text_hgt+40*3, sub_col_name[5], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*0.5, text_hgt+40*4, sub_col_name[6], 'black', vTextStyleBold, 'center','middle');
			ctx_fillText(ctx, sx+cut*6.5, text_hgt+40*1-5, sub_col_name[1], 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, sx+cut*6.5, text_hgt+40*2-5, sub_col_name[2], 'black', 'bold 15px 맑은고딕', 'center','middle');
			ctx_fillText(ctx, sx+cut*6.5, text_hgt+40*4, sub_col_name[7], 'black', vTextStyleBold, 'center','middle');
			
			var account_start_date = '<%=start_date%>'.split('-');		
			var account_start_date_note = account_start_date[0] + '년 ' + account_start_date[1] + '월 ' + account_start_date[2] + '일 ';
			ctx_fillText(ctx, sx+cut*1.5-30, text_hgt+40*1, sub_data[0], 'black', vTextStyleBold, 'left','left');
			ctx_fillText(ctx, sx+cut*1.5-30, text_hgt+40*2, sub_data[2], 'black', vTextStyleBold, 'left','left');
			var establish = sub_data[4].split('-');			
			var establish_note = establish[0] + '년 ' + establish[1] + '월 ' + establish[2] + '일 ';
			if(establish[1] == null){ establish_note = ''; }
			ctx_fillText(ctx, sx+cut*1.5-30, text_hgt+40*3, establish_note, 'black', vTextStyleBold, 'left','left');
			ctx_fillText(ctx, sx+cut*1.5-30, text_hgt+40*4, sub_data[5] + '㎡', 'black', vTextStyleBold, 'left','left');
			ctx_fillText(ctx, sx+cut*7.5-30, text_hgt+40*1, sub_data[1], 'black', vTextStyleBold, 'left','left');
			ctx_fillText(ctx, sx+cut*7.5-30, text_hgt+40*2, sub_data[3], 'black', vTextStyleBold, 'left','left');
			ctx_fillText(ctx, sx+cut*7.5-30, text_hgt+40*4, account_start_date_note, 'black', vTextStyleBold, 'left','left');	
		}		
		
	}
	
	// 인원현황
	var PersonText = {		
		col_head_width:[900],		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기			
			var blank_tab = '    '; // 4칸 공백
			var col_head = ['구 분', '인 원', '사무직', '기술직', '생산직', '기 타', '계', '비 고'];			
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var start = sx+40;
			var person_data = [<%=PersonArray.toString()%>]; 
			var col_person = ['인','원','현','황'];
			var col_person_hgt = PersonText_HeightEnd - PersonText_HeightStart;
			var cut = (ex-40)/8;
			for(var i=0; i<8; i++){
				ctx_Line(ctx, start+cut*i, sy, start+cut*i, ey, 'black', 1);
				ctx_fillText(ctx, sx+cut*(i+1)-35, sy+20, col_head[i],'black', 'bold 16px 맑은고딕', 'start','middle');
				for(var j =0; j < person_row; j++){	ctx_fillText(ctx, sx+cut*(i+1)-35, sy+20+(j+1)*40, person_data[j][i],'black', 'bold 16px 맑은고딕', 'start','middle'); }
				if(person_row != 0){
					if(i<4){ ctx_fillText(ctx, sx+15, sy+(col_person_hgt/5)*(i+1), col_person[i],'black', 'bold 16px 맑은고딕', 'start','middle');}	
				}				
			}				
			for(var i=0; i<person_row; i++){ ctx_Line(ctx, sx+40, sy+40*(i+1), ex, sy+40*(i+1), 'black', 1); }
//			console.log("pd" + person_data);

		}	
	} ;
 	// 생산능력
	var ProductText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var start = sx+40;
			var col_head = ['제 품 별', '단 위', '생산능력', '비 고'];
			var product_data = [<%=ProductArray.toString()%>];
			var col_person_hgt = ProductText_HeightEnd - ProductText_HeightStart;
			var cut = (ex-20)/4;
			ctx_fillText(ctx, ex/2-start*2, sy+20, '주요 품목별 생산능력','black', vTextStyleBold, 'start','middle');
			for(var i=0; i<4; i++){
				if(i>0){ ctx_Line(ctx, 10+cut*i, sy+40, 10+cut*i, ey, 'black', 1); }
				ctx_fillText(ctx, sx+cut*(i+1)-cut/2-20, sy+60, col_head[i],'black', vTextStyleBold, 'start','middle');
				for(var j =0; j < product_row; j++){ ctx_fillText(ctx, 10+cut*(i+1)-cut/2-20, sy+60+40*(j+1), product_data[j][i],'black', 'bold 16px 맑은고딕', 'start','middle'); }
			}
			for(var i=0; i<parseInt(product_row)+1; i++){ 
				ctx_Line(ctx, sx, sy+(40*(i+1)), ex, sy+(40*(i+1)), 'black', 1);	
			}
		}	
	}; 
 	
 	// 허가관계
 		var PermissionText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var start = sx+40;
			var col_head = ['구 분', '품 명', '인증기관', '인증일자', '비 고'];
			var permission_data = [<%=PermissionArray.toString()%>];
			var col_person_hgt = PermissionText_HeightEnd - PermissionText_HeightStart;
			var cut = (ex-20)/5;
			ctx_fillText(ctx, ex/2-start*2, sy+20, '제품인증 허가관계','black', vTextStyleBold, 'start','middle');
			for(var i=0; i<5; i++){
				if(i>0){ ctx_Line(ctx, 10+cut*i, sy+40, 10+cut*i, ey, 'black', 1); }
				ctx_fillText(ctx, sx+cut*(i+1)-cut/2-20, sy+60, col_head[i],'black', vTextStyleBold, 'start','middle');
				for(var j =0; j < permission_row; j++){ ctx_fillText(ctx, 10+cut*(i+1)-cut/2-20, sy+60+40*(j+1), permission_data[j][i],'black', 'bold 16px 맑은고딕', 'start','middle'); }
			}
			for(var i=0; i<parseInt(permission_row)+1; i++){ 
				ctx_Line(ctx, sx, sy+(40*(i+1)), ex, sy+(40*(i+1)), 'black', 1);	
			}
			
		}	
	}; 
 	
 	// 설비현황
	var EquipmentText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var blank_tab = '    '; // 4칸 공백
			var start = sx+40;
			var col_head = ['순번', '설비명', '형식 및 규격', '제조회사', '보유수량', '비 고'];
			var equipment_data = [<%=EquipmentArray.toString()%>];
			var col_quipment_hgt = EquipmentText_HeightEnd - EquipmentText_HeightStart;
			var cut = (ex-20)/6;
			ctx_fillText(ctx, ex/2-start*2, sy+20, '제조설비 현황','black', vTextStyleBold, 'start','middle');
			for(var i=0; i<6; i++){
				if(i>0){ ctx_Line(ctx, 10+cut*i, sy+40, 10+cut*i, ey, 'black', 1); }
				ctx_fillText(ctx, sx+cut*(i+1)-cut/2-40, sy+60, col_head[i],'black', vTextStyleBold, 'start','middle');
				for(var j =0; j < equipment_row; j++){ 
					ctx_fillText(ctx, 10+cut-cut/2-20, sy+60+40*(j+1), j+1,'black', 'bold 16px 맑은고딕', 'start','middle');
					ctx_fillText(ctx, 10+cut*(i+2)-cut/2-20, sy+60+40*(j+1), equipment_data[j][i],'black', 'bold 16px 맑은고딕', 'start','middle'); 
				}
			}
			for(var i=0; i<parseInt(equipment_row)+1; i++){ 
				ctx_Line(ctx, sx, sy+(40*(i+1)), ex, sy+(40*(i+1)), 'black', 1);	
			}
		}	
	}; 

	var AppraisalText = {
		drawText(ctx, sx, sy, ex, ey) {
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 1); // 표 전체 틀(사각형)
			var cut = (ex-20)/4;
			var col_data = ['실사평가', '견본평가', '이력 및 서류평가'];
			ctx_Line(ctx, sx+cut, sy, sx+cut, ey, 'black', 1);	
			ctx_fillText(ctx, sx+cut/2-40, sy+40, '평가방법','black', vTextStyleBold, 'start','middle');
			for(var i =0; i < 3; i++){
				if(col_data[i] == '<%=appraisal_means%>'){
					ctx_fillText(ctx, sx+cut/2-80+(cut*(i+1)), sy+40, '■ ' + col_data[i],'black', vTextStyleBold, 'start','middle');
				} else {
					ctx_fillText(ctx, sx+cut/2-80+(cut*(i+1)), sy+40, '□ ' + col_data[i],'black', vTextStyleBold, 'start','middle');
				}
				
			}
		}
	};
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
		
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>