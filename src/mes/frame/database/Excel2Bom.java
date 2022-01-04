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
public class Excel2Bom {
	String sqlPath = "E:/HENESYS/사이언/";
	String sqlPathFile = "581-A42000-자료목록.xlsx";

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
	
	// BOM
	BomUtil bomUtil = null;
	int HEAD_ROW_COUNT = 6;
	int HEAD_ROW_INDEX = 5;

	public Excel2Bom() {
		try {
			String mainPath = sqlPath + sqlPathFile;
			File dataFile = new File(mainPath);

			Excel2Bom e2d = new Excel2Bom(dataFile);
			e2d.doExcelProcess(dataFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Excel2Bom(File dataFile) {
		try {
			bomUtil = new BomUtil();
			
			fis = new FileInputStream(dataFile);
			workbook = new XSSFWorkbook(fis);
			
			database = new DatabaseUtil();
			//con = JDBCConnectionPool.getConnection();
			//con.setAutoCommit(true);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
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
			fout = new FileWriter(sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql", true);
			
			sheetCount = workbook.getNumberOfSheets();
			System.out.println("--sheetCount==="+sheetCount);
			if (sheetCount > 1) {
				sheetCount = 1;
			}
			
			// BOM코드
			String BOM_CODE = "";
			String BOM_CODE_REV = "0";
			// 순번
			String SYS_BOM_ID = "";
			// BOM상위번호 (순번)
			String SYS_BOM_PARENTID = "";
			// 자료번호
			String JARYO_BUNHO = "";
			// 원부자재번호
			String BUPUM_BUNHO = "";
			// 파트코드 (이넘이 파트리스트의 코드와 매칭된다.)
			String part_cd = "";
			// 파트코드의 리비전번호
			String PART_CD_REV = "";
			// 자료명
			String JARYO_IRUM = "";
			// 수량
			String PART_COUNT = "";
			// 매수
			String MAESU = "";
			// 구분(레벨)
			String LEVEL_GUBUN = "";
			String OLD_LEVEL_GUBUN = "";
			// 수정
			String MODIFY_HIST = "";
			// 구매처
			String GUMAE_CHEO = "";
			// 비고
			String BIGO = "";
			
			for (int i=0; i<sheetCount; i++) {
				// SHEET의 속성을 구한다.
				sheet = workbook.getSheetAt(i);
				SHEET_NAME = sheet.getSheetName();
				rowCount = sheet.getPhysicalNumberOfRows();
				System.out.println("rowCount=" + rowCount);
				
				fout.write("-- " + SHEET_NAME + " / " + FILE_NAME + "\n");
				
				for (int r=0; r<rowCount; r++) {
					//행을 읽는다
				    row = sheet.getRow(r);
				    //셀의 수
			        cellCount = row.getPhysicalNumberOfCells();
			        
					// 5개의 로우에는 헤드정보가 있어서 뺀다.
					// 실제 등록해야할 정보들은 r=5 즉 6번째 줄부터 시작된다.
					if (r < HEAD_ROW_INDEX) {
						if ( r == 1) {
							cell = row.getCell(4);
							cellData = cell.getStringCellValue();
							BOM_CODE = cellData.trim();
							System.out.println("BOM_CODE=" + BOM_CODE);
						}
						continue;
					}
					System.out.println("Row-Number===> [" + r + "]");
					
					// 기본 등록 문장을 만들어 둔다.   
					sqlBuffer.append("INSERT INTO tbm_bom_info (	");
					sqlBuffer.append("		bom_cd				");
					sqlBuffer.append("		,bom_cd_rev			");
					sqlBuffer.append("		,sys_bom_id			");
					sqlBuffer.append("		,sys_bom_parentid	");
					sqlBuffer.append("		,jaryo_bunho		");
					sqlBuffer.append("		,bupum_bunho		");
					sqlBuffer.append("		,part_cd			");
					sqlBuffer.append("		,part_cd_rev		");
					sqlBuffer.append("		,jaryo_irum			");
					sqlBuffer.append("		,part_count			");
					sqlBuffer.append("		,maesu				");
					sqlBuffer.append("		,level_gubun		");
					sqlBuffer.append("		,modify_hist		");
					sqlBuffer.append("		,gumae_cheo			");
					sqlBuffer.append("		,bigo)				");
					sqlBuffer.append("VALUES ( ");
					

			        // 순번(SYS_BOM_ID)
					cell = row.getCell(0);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					SYS_BOM_ID = ""+(int)(Common.getDouble( cellData.trim()));
					if (SYS_BOM_ID.length() <= 0) {
						System.out.println("순번 자료가 정확하지 않습니다.");
						sqlBuffer.delete(0, sqlBuffer.length());
						return;
					}
					// 아래의 조건이면 끝이다...
					if (SYS_BOM_ID.equals("0") && r > (rowCount-HEAD_ROW_COUNT)) {
						System.out.println("FINISHED...");
						break;
					}
			        
					// 자료번호 (JARYO_BUNHO)
					cell = row.getCell(1);
					cellData = cell.getStringCellValue();
					JARYO_BUNHO = cellData.trim();
					if (JARYO_BUNHO.length() <= 0) {
						if (r <= (rowCount-HEAD_ROW_COUNT)) {  
							System.out.println("자료번호가 정확하지 않습니다.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					// BOM의 처음 로우(r==5)의 자료번호는 BOM코드와 같다.
					if (r == HEAD_ROW_INDEX) {
						if (!BOM_CODE.equals(JARYO_BUNHO)) {
							System.out.println("자료번호와 BOM코드가 일치하지 않습니다.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					
					// 원부자재번호 (BUPUM_BUNHO)
					cell = row.getCell(2);
					cellData = cell.getStringCellValue();
					BUPUM_BUNHO = cellData.trim();
					if (BUPUM_BUNHO.length() <= 0) {
						if (r <= (rowCount-HEAD_ROW_COUNT)) {  
							System.out.println("원부자재번호가 정확하지 않습니다.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					// BOM의 처음 로우(r==5)의 원부자재번호는 BOM코드와 같다.
					if (r == HEAD_ROW_INDEX) {
						if (!BOM_CODE.equals(BUPUM_BUNHO)) {
							System.out.println("원부자재번호와 BOM코드가 일치하지 않습니다.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					
					// 파트코드 (part_cd)
					cell = row.getCell(3);
					cellData = cell.getStringCellValue();
					part_cd = cellData.trim();
					// 파트코드가 결정되어져 있으면...
					if (part_cd.length() > 0) {
						// 쿼리해서 리비전번호를 가져온다.
						String cntSql = "select REVISION_NO from TBM_PART_LIST where PART_CD ='" + part_cd + "' order by REVISION_NO desc";
						//------------ 우선 막아둔다.
						//PART_CD_REV = database.getColumnValue(con, cntSql).trim();
						if ("".equals(PART_CD_REV) ) {
							PART_CD_REV = "0";
						}
					} else {
						// 기본은 "0"이다.
						PART_CD_REV = "0";
					}
					
					// 자료명
					cell = row.getCell(4);
					cellData = cell.getStringCellValue();
					JARYO_IRUM = cellData.trim();
					JARYO_IRUM = JARYO_IRUM.replaceAll("'", "");

					// 수량
					cell = row.getCell(5);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					System.out.println("PART_COUNT=" + cellData);
					try {
						PART_COUNT = ""+(int)(Common.getDouble( cellData.trim()));
					} catch (Exception e) {
						PART_COUNT = "0";
					}

					// 매수
					cell = row.getCell(6);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					try {
						MAESU = ""+(int)(Common.getDouble( cellData.trim()));
					} catch (Exception e) {
						MAESU = "0";
					}
					
					/////////////////////////////////////////////////////////////////
					// 구분(레벨)
					cell = row.getCell(7);
					cellData = cell.getStringCellValue();
					LEVEL_GUBUN = cellData.trim();
					if (LEVEL_GUBUN.length() <= 0) {
						if (r <= (rowCount-HEAD_ROW_COUNT)) {  
							System.out.println("구분(레벨) 자료가 정확하지 않습니다.");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					
					// 기록해둔다.
					bomUtil.recordBomId4AlphaBetLevel(LEVEL_GUBUN, SYS_BOM_ID);
					// 상위 BOM-ID를 구해서 적는다.
					SYS_BOM_PARENTID = bomUtil.getMyParentId(LEVEL_GUBUN);
					
					//////////////////////////////////////////////////////////////////
					
					// QAR
					cell = row.getCell(8);
					// 검사장비	
					cell = row.getCell(9);
					// 포장자료
					cell = row.getCell(10);

					// 수정
					cell = row.getCell(11);
					cellData = cell.getStringCellValue();
					MODIFY_HIST = cellData.trim();
					MODIFY_HIST = MODIFY_HIST.replaceAll("'", "");

					// 구매처
					cell = row.getCell(12);
					try {
						cellData = cell.getStringCellValue();
					} catch (Exception e) {
						cellData = "";
					}
					GUMAE_CHEO = cellData.trim();
					GUMAE_CHEO = GUMAE_CHEO.replaceAll("'", "");
					
					// 비고
					cell = row.getCell(13);
					cellData = cell.getStringCellValue();
					BIGO = cellData.trim();
					BIGO = BIGO.replaceAll("'", "");

					//===================================================
					//===================================================

					// 문장을 완성한다.
					sqlBuffer.append("'" + BOM_CODE + "'			");
					sqlBuffer.append(",'" + BOM_CODE_REV + "'		");
					sqlBuffer.append(",'" + SYS_BOM_ID + "'			");
					sqlBuffer.append(",'" + SYS_BOM_PARENTID + 	"'	");
					sqlBuffer.append(",'" + JARYO_BUNHO + "'		");
					sqlBuffer.append(",'" + BUPUM_BUNHO + "'		");
					sqlBuffer.append(",'" + part_cd + "'			");
					sqlBuffer.append(",'" + PART_CD_REV + "'		");
					sqlBuffer.append(",'" + JARYO_IRUM + "'			");
					sqlBuffer.append(",'" + PART_COUNT + "'			");
					sqlBuffer.append(",'" + MAESU + "'				");
					sqlBuffer.append(",'" + LEVEL_GUBUN + "'		");
					sqlBuffer.append(",'" + MODIFY_HIST + "'		");
					sqlBuffer.append(",'" + GUMAE_CHEO + "'			");
					sqlBuffer.append(",'" + BIGO + "');\n			");

					// 파일에 쓴다.
					fout.write(sqlBuffer.toString());
					fout.flush();
					
					//database.doUpdate(con, sqlBuffer.toString());
										
					// 초기화
					sqlBuffer.delete(0, sqlBuffer.length());
				}
			}
			fout.flush();
			fout.close();
			//con.close();
		} catch (Exception e) {
			e.printStackTrace();
			return;
		} finally {
			try {
				fis.close();
				fout.close();
				//con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		System.out.println("[완료]==========="+ targetFile.getAbsolutePath());
	}
	
	public static void main(String args[]) {
		new Excel2Bom();
	}
}
