package mes.client.util;

import java.util.Vector;

import mes.client.guiComponents.DoyosaeTableModel;

public class ModelPibot {
	
	public ModelPibot() {
	}

	public DoyosaeTableModel getPibotModel(String[] columnName, DoyosaeTableModel tblModel) {
		DoyosaeTableModel tableModel = getPibotModel(columnName, tblModel, 0);
		return tableModel;
	}
	
	public DoyosaeTableModel getPibotModel(String[] columnName, DoyosaeTableModel tblModel, int checkColumn) {
		DoyosaeTableModel tableModel = null;
		Vector COMPLETE_VECTOR = new Vector();
		
		String OLD_CHECK_VALUE = "";
		String CURRENT_CHECK_VALUE = "";
		String columnValue = "";
		int MAX_COLUMN_COUNT = 0; 
		int COLUMN_COUNT = 0;
		Vector newRowVector = new Vector();
		Vector newModelVector = new Vector();
		
		try {
			Vector modelVector = tblModel.getVector();
			//System.out.println( "modelVector.size()=" + modelVector.size() );
			for (int r=0; r<modelVector.size(); r++) {
				Vector rowVector = (Vector)(modelVector.get(r));
				
				//System.out.println( "rowVector.size()=" + rowVector.size() );
				// 체크값을 가져와서...
				CURRENT_CHECK_VALUE = rowVector.get(checkColumn).toString();
				
				//System.out.println("CURRENT_CHECK_VALUE=" + CURRENT_CHECK_VALUE + "/OLD_CHECK_VALUE=" + OLD_CHECK_VALUE);
				
				
				// 비교해 본다.
				if (CURRENT_CHECK_VALUE.equals(OLD_CHECK_VALUE)) {
					// 같으면..
					newRowVector.add(rowVector);
//					System.out.println("===+++" + rowVector.toString());
					COLUMN_COUNT++;
					//System.out.println();
				} else {
					OLD_CHECK_VALUE = CURRENT_CHECK_VALUE;
					if (COLUMN_COUNT > MAX_COLUMN_COUNT) {
						MAX_COLUMN_COUNT = COLUMN_COUNT;
					}
					COLUMN_COUNT = 1;
					if (r == 0) {
						//System.out.println("000+++" + rowVector.toString());
						newRowVector.add(rowVector);
						continue;
					}
					// 바뀌었으면...
					newModelVector.add(newRowVector);
					// 초기화
					newRowVector = new Vector();
					//System.out.println("xxx+++" + rowVector.toString());
					newRowVector.add(rowVector);
				}
//				System.out.println("COLUMN_COUNT=" + COLUMN_COUNT);
//				System.out.println("MAX_COLUMN_COUNT=" + MAX_COLUMN_COUNT);
//				System.out.println("newRowVector.size()=" + newRowVector.size());
//				System.out.println("newModelVector.size()=" + newModelVector.size());
//				System.out.println("...");
			}
			
			// 마지막 로우의 처리
			newModelVector.add(newRowVector);
			if (COLUMN_COUNT > MAX_COLUMN_COUNT) {
				MAX_COLUMN_COUNT = COLUMN_COUNT;
			}

			/////////////////////////////////
			COMPLETE_VECTOR = new Vector();
			Vector dummyVector = new Vector(); 
			dummyVector.add("-"); dummyVector.add("-"); dummyVector.add("-");
			int spareCount = 0;
			for (int i=0; i<newModelVector.size(); i++) {
				Vector tmpVector = ((Vector)newModelVector.get(i));
//				System.out.println("@@@@@@@@@@@@@tmpVector.size()=" + tmpVector.size());
				if (tmpVector.size() < MAX_COLUMN_COUNT) {
					spareCount = (MAX_COLUMN_COUNT-tmpVector.size());
					for (int m=0; m<spareCount; m++) {
						tmpVector.add( dummyVector  );
					}
				}
				COMPLETE_VECTOR.add(tmpVector);
//				System.out.println("COMPLETE_VECTOR=" + COMPLETE_VECTOR.size());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		tableModel = new DoyosaeTableModel(columnName, COMPLETE_VECTOR);
		
		return tableModel;
	}
	
	public static void main(String args[]) {
		String[] columnName = new String[]{"111","222", "333","444","555","666","777","888","999","000","AAA","BBB"}; 
		
		Vector rowT1V = new Vector();
		Vector rowV1 = new Vector();
		rowV1.add("AB001");	rowV1.add("스팩확인"); rowV1.add("N/A");
		Vector rowV2 = new Vector();
		rowV2.add("AB001");	rowV2.add("스팩확인"); rowV2.add("OK");
		Vector rowV3 = new Vector();
		rowV3.add("AB001");	rowV3.add("발주"); rowV3.add("OK");
		Vector rowV4 = new Vector();
		rowV4.add("AB001");	rowV4.add("원부자재확인"); rowV4.add("OK");
		Vector rowV5 = new Vector();
		rowV5.add("AB001");	rowV5.add("작업완료"); rowV5.add("OK");
		rowT1V.add(rowV1);
		rowT1V.add(rowV2);
		rowT1V.add(rowV3);
		rowT1V.add(rowV4);
		rowT1V.add(rowV5);
		Vector rowV11 = new Vector();
		rowV11.add("AB002");	rowV11.add("발주"); rowV11.add("OK");
		Vector rowV12 = new Vector();
		rowV12.add("AB002");	rowV12.add("원부자재확인"); rowV12.add("OK");
		Vector rowV13 = new Vector();
		rowV13.add("AB002");	rowV13.add("작업완료"); rowV13.add("OK");
		rowT1V.add(rowV11);
		rowT1V.add(rowV12);
		rowT1V.add(rowV13);

		DoyosaeTableModel tblModel = new DoyosaeTableModel(columnName, rowT1V);
		
		ModelPibot modelPibot = new ModelPibot();
		
		DoyosaeTableModel newTableModel = modelPibot.getPibotModel(columnName, tblModel, 0);
		Vector mV = newTableModel.getVector();
		System.out.println( mV.toString() );
		for (int i=0; i<mV.size(); i++) {
			Vector rV = (Vector)(mV.get(i));
			for (int j=0; j<rV.size(); j++) {
				//System.out.println(rV.get(j).toString());
			}
		}
	}
}
