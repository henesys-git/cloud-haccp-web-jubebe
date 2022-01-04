package mes.frame.database;

import java.util.Hashtable;

public class BomUtil {
	// 알파벳 순서를 정하기 위함.
	String[] alphaBetArray = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N",
								"O","P","Q","R","S","T","U","V","W","X","Y","Z"}; 
	Hashtable levelHash = null;
	
	// 해당 순위에 기록된 BOM-ID (순번)
	Hashtable recordBomId4LevelHash = new Hashtable();;
	
	public BomUtil() {
		// 알파벳의 인덱스를 정한다.
		levelHash = new Hashtable();
		for (int i=0; i<alphaBetArray.length; i++) {
			levelHash.put(alphaBetArray[i], ""+i);
		}
		// 정해진 알파벳 즉. 레벨의 BOM-ID를 저장해둔다.
		recordBomId4LevelHash = new Hashtable();;
	}
	
	// 이넘은 엑셀을 BOM으로 부어 넣으면서...
	// 특정 알파벳-레벨에 대한 BOM-ID를 기록해 둔다.
	public void recordBomId4AlphaBetLevel(String alphaBetLevel, String bomId) {
		if (recordBomId4LevelHash.containsKey(alphaBetLevel)) {
			System.out.println("이미 기록된 자료입니다. 키=" + alphaBetLevel + " / BOM-ID=" + bomId);
			return;
		}
		recordBomId4LevelHash.put(alphaBetLevel, bomId);
	}

	String getBomId4AlphaBetLevel(String alphaBetLevel) {
		return recordBomId4LevelHash.get(alphaBetLevel).toString();
	}

	int getIntLevel(String alphaBetLevel) {
		int retVal = -1;
		try {
			retVal = Integer.parseInt( levelHash.get(alphaBetLevel).toString().trim() );
		} catch (Exception e) {
			retVal = -1;
		}
		return retVal;
	}
	String getAlphaBetLevel(int intLevel) {
		String retVal = "";
		retVal = alphaBetArray[intLevel];
		return retVal;
	}

	// 현재 엑셀에서 읽은 알파벳-레벨을 파라미터로 주면...
	// 그 상위에 해당하는 레벨의 알파벳-레벨을 찾아서..
	// 그에 해당하는 BOM아이디를 리턴한다.
	public String getMyParentId(String myAlphaBetLevel) {
		String resultBomIdString = "";
		String tmpStr = "";
		int myParentIntLevel = 0;
		
		// 우선 현재 나의 레벨문자가 머이고.. 그 문자보다 한단계 상위 문자가 머냐?
		int myCurrnetIntLevel = getIntLevel(myAlphaBetLevel);
		System.out.println("myCurrnetIntLevel=" + myCurrnetIntLevel);
		// 최상위 레벨이면..
		if (myCurrnetIntLevel > 1) {
			myParentIntLevel = myCurrnetIntLevel - 1;
			// 상위레벨의 알파벳레벨을 가져온다.
			tmpStr = getAlphaBetLevel(myParentIntLevel);
			// 그 알파벳레벨에 해당하는 Bom-ID를 구한다.
			resultBomIdString = getBomId4AlphaBetLevel(tmpStr.trim());
		} else {
			myParentIntLevel = 0;
			resultBomIdString = "0";
		}
		return resultBomIdString;
	}

	public String getMyChildAlphaBetLevel(String myAlphaBetLevel) {
		String resultBomAlphaBetLevel = "";
		int myParentIntLevel = 0;
		
		// 우선 현재 나의 레벨문자가 머이고.. 그 문자보다 한단계 상위 문자가 머냐?
		int myCurrnetIntLevel = getIntLevel(myAlphaBetLevel);
		System.out.println("myCurrnetIntLevel=" + myCurrnetIntLevel);

		// 현재 레벨에 하나를 더한다.
		myParentIntLevel = myCurrnetIntLevel + 1;
		// 하위레벨의 알파벳레벨을 가져온다.
		resultBomAlphaBetLevel = getAlphaBetLevel(myParentIntLevel);

		return resultBomAlphaBetLevel;
	}
}
