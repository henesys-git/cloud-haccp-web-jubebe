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
 * 0=���� (sys_bom_id)
 * 1=�ڷ��ȣ (jaryo_bunho)
 * 2=���������ȣ (bupum_bunho)
 * 3=��Ʈ�ڵ� (part_cd)
 * 4=�ڷ�� (jaryo_irum)
 * 5=���� (part_count)
 * 6=�ż� (maesu)
 * 7=���� (* BOM�� ���ڰ��踦 A,B,C������ ��Ÿ����.) : (level_gubun)
 * 8=QAR (--)
 * 9=�˻���� (--)
 * 10=�����ڷ� (--)
 * 11=���� (--)
 * 12=����ó (gumae_cheo)
 * 13=��� (bigo)
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
	
	//String sqlPathFile = "F80001200-�ڷ���.xlsx";

	// ����
	FileInputStream fis = null;
	XSSFWorkbook workbook = null;
	XSSFSheet sheet = null;
	XSSFRow row = null;
	XSSFCell cell = null;
	
	// ����
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
		// �̹������ϴ� ���� �ŷ�ó���� ����.
		int EXIST_ROW_COUNT = 0;
		

		try {
			FILE_NAME = targetFile.getName();
			System.out.println("--[����]==========="+ FILE_NAME);
			// �̹� ������ ������� ������ �����.
			File checkFile = new File(sqlPath + "/" + FILE_NAME.substring(0, FILE_NAME.lastIndexOf(".")) + ".sql");
			if (checkFile.exists()) {
				System.out.println("�̹� ������ �����մϴ�. �����ϰ� �����ϰڽ��ϴ�.");
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
			//BOM ������ȣ
			String BOM_CD_REV = sqlBomCdRev;
			//BOM ��Ī
			String BOM_NM = sqlBomNm;
			// ����
			String SYS_BOM_ID = "";
			// ǰ��
			String PART_CD	= "";
			// ǰ��
			String PART_NM = "";
			//���� ��ġ
			String LOCATION_XY = "";
			// ����
			String PART_COUNT = "";
			// ������
			String GUMAE_CHEO = "";
			// �ŷ�ó �ڵ�
			String CUSTCD_CODE = "";
			//�����ΰ�����
			String HUMI_MINGAM = "";
			//������ΰ�����
			String STATIC_ELE_MINGAM = "";
			//���Ű
			String MEMBER_KEY = sqlMemberKey;
			
			
			for (int i=0; i<sheetCount; i++) {
				// SHEET�� �Ӽ��� ���Ѵ�.
				sheet = workbook.getSheetAt(i);
				SHEET_NAME = sheet.getSheetName();
				rowCount = sheet.getPhysicalNumberOfRows();
				System.out.println("rowCount=" + rowCount);
				
				//fout.write("-- " + SHEET_NAME + " / " + FILE_NAME + "\n");
				
				for (int r=0; r<rowCount; r++) {
					//���� �д´�
				    row = sheet.getRow(r);
				    //���� ��
			        cellCount = row.getPhysicalNumberOfCells();
			        
					//ù��° �ο�� ��Ī�� ������ �н��Ѵ�.
					if (r < HEAD_ROW_INDEX) {
						continue;
					}
					System.out.println("Row-Number===> [" + r + "]");
					
					
					// �Ʒ��� �����̸� �� �̻� for���� ���� �ʿ䰡 ����.
					if (SYS_BOM_ID.equals("0") && r > rowCount) {
						System.out.println("FINISHED...");
						break;
					}
			        
					// ����(SYS_BOM_ID)
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
						System.out.println("���� �ڷᰡ ��Ȯ���� �ʽ��ϴ�.");
						continue;
					}
					
					// ǰ�� (BUPUM_BUNHO)
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
						System.out.println("ǰ���ڷᰡ ��Ȯ���� �ʽ��ϴ�.");
						continue;
					}
					
					// ǰ�� (BUPUM_NAME)
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
						System.out.println("ǰ���ڷᰡ ��Ȯ���� �ʽ��ϴ�.");
						continue;
					}
					
					// ���� ��ġ (SILJANG_DER)
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
					
					// ���� (PART_COUNT)
					cell = row.getCell(6);
					if (cell.getCellType() == cell.getCellType().STRING) {
						cellData = cell.getStringCellValue().trim();
					} else {
						cellData = "" + cell.getNumericCellValue();
					}
					PART_COUNT = ""+(int)(Common.getDouble( cellData.trim()));
					if (PART_COUNT.length() <= 0) {
						if (r <= rowCount) {
							System.out.println("������ ��Ȯ���� �ʽ��ϴ�. �ʿ� ������ '0'�� ��� 0���� �Է����ּ���. ");
							sqlBuffer.delete(0, sqlBuffer.length());
							return;
						}
					}
					
					// ������ (MADE_BY)
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
				
					// �ŷ�ó �ڵ� (CUSTCD_CODE)
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
					
					// �����ΰ����� �ڵ� (HUMI_MINGAM)
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
					
					// ������ΰ����� �ڵ� (STATIC_ELE_MINGAM)
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
					
					//������ ��� ���� �Ǿ� ������ ������ sql���� �����.
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
					
					// ���Ͽ� ����.
					//fout.write(sqlBuffer.toString());
					//fout.flush();
					System.out.println(sqlBuffer);
					if(database.doUpdate(con, sqlBuffer.toString())>0) {
						con.rollback();
						System.out.println(EventDefine.E_DOEXCUTE_ERROR);
						return;
					}
					
					// �ʱ�ȭ
					//doarr.add(sqlBuffer.toString());
					sqlBuffer.delete(0, sqlBuffer.length());
					
					
					//������������(tbm_part_list)�� BOM�� �ʿ��� �������� �߰�
					sqlBuffer.append("MERGE INTO tbm_part_list mm \n");
					sqlBuffer.append("USING (	\n");
					sqlBuffer.append("	SELECT \n");
					sqlBuffer.append("		'" + "01" 		+ "' AS part_gubun_b,	\n"); // �������� ��з� : 01(�������)
					sqlBuffer.append("		'" + "9999" 	+ "' AS part_gubun_m,	\n"); // �������� �ߺз� : 9999(��Ÿ)
					sqlBuffer.append("		'" + PART_CD 	+ "' AS part_cd,		\n");
					sqlBuffer.append("		'" + "0" 		+ "' AS revision_no,	\n");
					sqlBuffer.append("		'" + PART_NM	+ "' AS part_nm,		\n");
					sqlBuffer.append("		"  + "SYSDATE" 	+ "  AS start_date,		\n");
					sqlBuffer.append("		'" + MEMBER_KEY	+ "' AS member_key		\n");
					sqlBuffer.append("	FROM db_root ) mQ \n");
					sqlBuffer.append("ON ( mm.part_cd = mQ.part_cd AND mm.revision_no = mQ.revision_no AND mm.member_key = mQ.member_key ) \n");
					sqlBuffer.append("WHEN MATCHED THEN		\n");
					sqlBuffer.append("	UPDATE SET \n"); //part_cd & revision_no(0) ������ ���� ���ϵ���
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
					
					// �ʱ�ȭ
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
		
		System.out.println("[�Ϸ�]==========="+ targetFile.getAbsolutePath());
		return;
	}
}
