package mes.frame.database;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.sql.Connection;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


import mes.client.common.Common;
import mes.frame.common.EventDefine;

/*
 * 0=순번 (sys_bom_id)
 * 1=자료번호 (jaryo_bunho)
 * 2=원부자재번호 (bupum_bunho)
 * 3=파트코드 (part_cd)
 * 4=자료명 (jaryo_irum)
 * 5=수량 (part_count)
 * 6=매수 (maesu)
 * 7=구분 (* BOM의 모자관계를 A,B,C순으로 나타낸다.) : (level_gubun)
 * 8=QAR (--)
 * 9=검사장비 (--)
 * 10=포장자료 (--)
 * 11=수정 (--)
 * 12=구매처 (gumae_cheo)
 * 13=비고 (bigo)
 */
 
/*
SELECT bd_number, ref_number, COALESCE(LPAD(' ', 4 * (LEVEL-1)),'') || bd_title, bd_memo , LEVEL
FROM tbm_notice_board
--WHERE user_cd='park'
WHERE bd_pwd='1234'
START WITH ref_number IS NULL
CONNECT BY PRIOR bd_number=ref_number
----------------------------------------
SELECT sys_bom_id, sys_bom_parentid, COALESCE(LPAD(' ', 4 * (LEVEL-1)),'') || jaryo_irum, bupum_bunho, jaryo_bunho , LEVEL, level_gubun
FROM tbm_bom_info
WHERE bom_cd='581-A42000'
	AND bom_cd_rev='0'
START WITH sys_bom_parentid='0'
CONNECT BY PRIOR sys_bom_id=sys_bom_parentid
ORDER  BY sys_bom_id;
*/
public class Excel2MBom {
	
	String sqlPath = "";
	String sqlPathFile = "";
	String sqlBomCdRev = "";
	String sqlBomNm = "";
	String sqlMemberKey = "";
	
	//String sqlPathFile = "F80001200-자료목록.xlsx";

	// 엑셀
	FileInputStream fis = null;
	XSSFWorkbook workbook = null;
	XSSFSheet sheet = null;
	XSSFRow row = null;
	XSSFCell cell = null;
	
	// 쓰기
	FileWriter fout = null;
	
	DatabaseUtil database = null;
	Connection con = null;
	
	int HEAD_ROW_INDEX = 1;
	
	public Excel2MBom(String path , String pathFile, String bomCdRev, String bomNm, String memberKey) {
		this.sqlPath = path;
		this.sqlPathFile = pathFile;
		this.sqlBomCdRev = bomCdRev;
		this.sqlBomNm = bomNm;
		this.sqlMemberKey = memberKey;
		
	}
	
	public void Excel2MBom() {
		try {
			String mainPath =  sqlPathFile;
			File dataFile = new File(mainPath);

			//Excel2MBom e2d = new Excel2MBom(dataFile);
			
			System.out.println("\ndataFile==" + dataFile);
			fis = new FileInputStream(dataFile);
			workbook = new XSSFWorkbook(fis);
			System.out.println("workbook==" + workbook.getNumberOfSheets());
			database = new DatabaseUtil();
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			
			doExcelProcess(dataFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
//	public Excel2MBom(File dataFile) {
//		try {
//			
//			System.out.println("\ndataFile==" + dataFile);
//			System.out.println("CCCCCCCCCCCCCCCCCCCCCCCCCCC" + sqlPath);
//			fis = new FileInputStream(dataFile);
//			workbook = new XSSFWorkbook(fis);
//			System.out.println("workbook==" + workbook.getNumberOfSheets());
//			database = new DatabaseUtil();
//			con = JDBCConnectionPool.getConnection();
//			con.setAutoCommit(false);
//		} catch(Exception e) {
//			e.printStackTrace();
//		}
//	}
	
	private void doExcelProcess(File targetFile) {
		int sheetCount= 0;
		int rowCount = 0;
		int cellCount = 0;
		int columnIndex = 0;
		String FILE_NAME = "";
		String SHEET_NAME = "";
		String cellData = "";
		StringBuffer sqlBuffer = new StringBuffer();
		// 이미존재하는 동일 거래처명의 갯수.
		int EXIST_ROW_COUNT = 0;
		

		try {
			FILE_NAME = targetFile.getName();
			System.out.println("--[시작]==========="+ FILE_NAME);
			// 이미 파일이 만들어져 있으면 지운다.
			File checkFile = new File(sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql");
			if (checkFile.exists()) {
				System.out.println("이미 파일이 존재합니다. 삭제하고 진행하겠습니다.");
				checkFile.delete();
			}
			System.out.println("OutFilename=" + sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql");
			//fout = new FileWriter(mainPath + targetFile + ".out", true);
			//fout = new FileWriter(sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql", true);
			
			sheetCount = workbook.getNumberOfSheets();
			System.out.println("--sheetCount==="+sheetCount);
			if (sheetCount > 1) {
				sheetCount = 1;
			}
			//BOM CODE
			System.out.println("======="+sqlPath+"========");
			String BOM_CODE = sqlPath.substring(0,sqlPath.toUpperCase().indexOf(".XLS"));
			//BOM 개정번호
			String BOM_CD_REV = sqlBomCdRev;
			//BOM 명칭
			String BOM_NM = sqlBomNm;
			// 순번
			String SYS_BOM_ID = "";
			// 품번
			String PART_CD	= "";
			// 품명
			String PART_NM = "";
			//실장 위치
			String LOCATION_XY = "";
			// 수량
			String PART_COUNT = "";
			// 제조사
			String GUMAE_CHEO = "";
			// 거래처 코드
			String CUSTCD_CODE = "";
			//습도민감자재
			String HUMI_MINGAM = "";
			//정전기민감자재
			String STATIC_ELE_MINGAM = "";
			//멤버키
			String MEMBER_KEY = sqlMemberKey;
			
			
			for (int i=0; i<sheetCount; i++) {
				// SHEET의 속성을 구한다.
				sheet = workbook.getSheetAt(i);
				SHEET_NAME = sheet.getSheetName();
				rowCount = sheet.getPhysicalNumberOfRows();
				System.out.println("rowCount=" + rowCount);
				
				//fout.write("-- " + SHEET_NAME + " / " + FILE_NAME + "\n");
				
				for (int r=0; r<rowCount; r++) {
					//행을 읽는다
				    row = sheet.getRow(r);
				    //셀의 수
			        cellCount = row.getPhysicalNumberOfCells();
			        
					//첫번째 로우는 명칭이 들어감으로 패스한다.
					if (r < HEAD_ROW_INDEX) {
						continue;
					}
					System.out.println("Row-Number===> [" + r + "]");
					
					
					// 아래의 조건이면 더 이상 for문을 돌릴 필요가 없다.
					if (SYS_BOM_ID.equals("0") && r > rowCount) {
						System.out.println("FINISHED...");
						break;
					}
			        
					// 순번(SYS_BOM_ID)
					cell = row.getCell(0);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					if(cellData.trim().equals("0.0")) {
						SYS_BOM_ID = "";
					}else {
						SYS_BOM_ID = ""+(int)(Common.getDouble( cellData.trim()));
					}
					if (SYS_BOM_ID.length() <= 0) {
						System.out.println("순번 자료가 정확하지 않습니다.");
						continue;
					}
					
					// 품번 (BUPUM_BUNHO)
					cell = row.getCell(1);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					if(cellData.trim().equals("0.0")) {
						PART_CD = "";
					}else {
						PART_CD = cellData.trim();
					}
					if (PART_CD.length() <= 0) {
						System.out.println("품번자료가 정확하지 않습니다.");
						continue;
					}
					
					// 품명 (BUPUM_NAME)
					cell = row.getCell(2);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					if(cellData.trim().equals("0.0")) {
						PART_NM = "";
					}else {
						PART_NM = cellData.trim();
					}
					PART_NM = cellData.trim();
					if (PART_NM.length() <= 0) {
						System.out.println("품명자료가 정확하지 않습니다.");
						continue;
					}
					
					// 실장 위치 (SILJANG_DER)
					cell = row.getCell(4);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					if(cellData.trim().equals("0.0")) {
						LOCATION_XY = "";
					}else {
						LOCATION_XY = cellData.trim();
					}
					
					// 수량 (PART_COUNT)
					cell = row.getCell(6);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					PART_COUNT = ""+(int)(Common.getDouble( cellData.trim()));
					if (PART_COUNT.length() <= 0) {
						if (r <= rowCount) {
							System.out.println("수량이 정확하지 않습니다. 필요 수량이 '0'일 경우 0으로 입력해주세요. ");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					
					// 제조사 (MADE_BY)
					cell = row.getCell(7);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					if(cellData.trim().equals("0.0")) {
						GUMAE_CHEO = "";
					}else {
						GUMAE_CHEO = cellData.trim();
					}
				
					// 거래처 코드 (CUSTCD_CODE)
					cell = row.getCell(8);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					if(cellData.trim().equals("0.0")) {
						CUSTCD_CODE = "";
					}else {
						CUSTCD_CODE = cellData.trim();
					}
					
					// 습도민감자재 코드 (HUMI_MINGAM)
					cell = row.getCell(9);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					if(cellData.trim().equals("0.0")) {
						HUMI_MINGAM = "";
					}else {
						HUMI_MINGAM = cellData.trim();
					}
					
					// 정전기민감자재 코드 (STATIC_ELE_MINGAM)
					cell = row.getCell(10);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					if(cellData.trim().equals("0.0")) {
						STATIC_ELE_MINGAM = "";
					}else {
						STATIC_ELE_MINGAM = cellData.trim();
					}
					
					//로직이 모두 수행 되어 문제가 없을때 sql문을 만든다.
					sqlBuffer.append("INSERT INTO tbm_bom_info (	");
					sqlBuffer.append("bom_cd			");
					sqlBuffer.append(",bom_cd_rev		");
					sqlBuffer.append(",sys_bom_id		");
					sqlBuffer.append(",sys_bom_parentid	");
					sqlBuffer.append(",part_cd		");
					sqlBuffer.append(",part_cd_rev		");
					sqlBuffer.append(",bom_nm			");
					sqlBuffer.append(",part_count		");
					sqlBuffer.append(",maesu			");
					sqlBuffer.append(",cust_cd			");
					sqlBuffer.append(",cust_rev			");
					sqlBuffer.append(",gumae_cheo		");
					sqlBuffer.append(",location_xy		");
					sqlBuffer.append(",member_key		)");
					sqlBuffer.append("VALUES (\n ");
					sqlBuffer.append("'" + BOM_CODE +				"'");
					sqlBuffer.append("," + BOM_CD_REV +				"");
					sqlBuffer.append("," + SYS_BOM_ID +				"");
					sqlBuffer.append("," + 		0 		+			"");
					sqlBuffer.append(",'" + PART_CD 	+			"'");
					sqlBuffer.append(","  + 	0 		+ 			"");
					sqlBuffer.append(",'" + BOM_NM		+ 			"'");
					sqlBuffer.append(",'" + PART_COUNT + 			"'");
					sqlBuffer.append(","  + 	0 		+ 			"");
					sqlBuffer.append(",'" +	CUSTCD_CODE + 			"'");
					sqlBuffer.append(","  +		 0 		+ 			"");
					sqlBuffer.append(",'" + GUMAE_CHEO		 + 		"'");
					sqlBuffer.append(",'" + LOCATION_XY + 			"'");
					sqlBuffer.append(",'" + MEMBER_KEY + 			"')\n");
					
					// 파일에 쓴다.
					//fout.write(sqlBuffer.toString());
					//fout.flush();
					System.out.println(sqlBuffer);
					if(database.doUpdate(con, sqlBuffer.toString())>0) {
						con.rollback();
						System.out.println(EventDefine.E_DOEXCUTE_ERROR);
						return;
					}
					
					// 초기화
					//doarr.add(sqlBuffer.toString());
					sqlBuffer.delete(0, sqlBuffer.length());
					
					
					//원부자재정보(tbm_part_list)에 BOM에 필요한 원부자재 추가
					sqlBuffer.append("MERGE INTO tbm_part_list mm \n");
					sqlBuffer.append("USING (	\n");
					sqlBuffer.append("	SELECT \n");
					sqlBuffer.append("		'" + "01" 		+ "' AS part_gubun_b,	\n"); // 원부자재 대분류 : 01(사급자재)
					sqlBuffer.append("		'" + "9999" 	+ "' AS part_gubun_m,	\n"); // 원부자재 중분류 : 9999(기타)
					sqlBuffer.append("		'" + PART_CD 	+ "' AS part_cd,		\n");
					sqlBuffer.append("		'" + "0" 		+ "' AS revision_no,	\n");
					sqlBuffer.append("		'" + PART_NM	+ "' AS part_nm,		\n");
					sqlBuffer.append("		"  + "SYSDATE" 	+ "  AS start_date,		\n");
					sqlBuffer.append("		'" + MEMBER_KEY	+ "' AS member_key		\n");
					sqlBuffer.append("	FROM db_root ) mQ \n");
					sqlBuffer.append("ON ( mm.part_cd = mQ.part_cd AND mm.revision_no = mQ.revision_no AND mm.member_key = mQ.member_key ) \n");
					sqlBuffer.append("WHEN MATCHED THEN		\n");
					sqlBuffer.append("	UPDATE SET \n"); //part_cd & revision_no(0) 있으면 갱신 안하도록
					sqlBuffer.append("		mm.part_cd = mQ.part_cd, 		\n");
					sqlBuffer.append("		mm.revision_no = mQ.revision_no \n");
					sqlBuffer.append("WHEN NOT MATCHED THEN \n");
					sqlBuffer.append("	INSERT ( \n");
					sqlBuffer.append("		mm.part_gubun_b,	\n");
					sqlBuffer.append("		mm.part_gubun_m,	\n");
					sqlBuffer.append("		mm.part_cd,			\n");
					sqlBuffer.append("		mm.revision_no,		\n");
					sqlBuffer.append("		mm.part_nm,			\n");
					sqlBuffer.append("		mm.start_date,		\n");
					sqlBuffer.append("		mm.member_key		\n");
					sqlBuffer.append("	) VALUES (\n");
					sqlBuffer.append("		mQ.part_gubun_b,	\n");
					sqlBuffer.append("		mQ.part_gubun_m,	\n");
					sqlBuffer.append("		mQ.part_cd,			\n");
					sqlBuffer.append("		mQ.revision_no,		\n");
					sqlBuffer.append("		mQ.part_nm,			\n");
					sqlBuffer.append("		mQ.start_date,		\n");
					sqlBuffer.append("		mQ.member_key		\n");
					sqlBuffer.append("	)\n");
					
					if(database.doUpdate(con, sqlBuffer.toString())>0) {
						con.rollback();
						return;
					}
					
					// 초기화
					//doarr.add(sqlBuffer.toString());
					sqlBuffer.delete(0, sqlBuffer.length());
					
				}
			}
			con.commit();
			con.close();
			//fout.flush();
			//fout.close();
		} catch (Exception e) {
			e.printStackTrace();
			return ;
		} finally {
			try {
				fis.close();
				con.close();
				//fout.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		System.out.println("[완료]==========="+ targetFile.getAbsolutePath());
		return;
	}
}
