package mes.frame.database;

import java.util.Hashtable;

public class BomUtil {
	// ���ĺ� ������ ���ϱ� ����.
	String[] alphaBetArray = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N",
								"O","P","Q","R","S","T","U","V","W","X","Y","Z"}; 
	Hashtable levelHash = null;
	
	// �ش� ������ ��ϵ� BOM-ID (����)
	Hashtable recordBomId4LevelHash = new Hashtable();;
	
	public BomUtil() {
		// ���ĺ��� �ε����� ���Ѵ�.
		levelHash = new Hashtable();
		for (int i=0; i<alphaBetArray.length; i++) {
			levelHash.put(alphaBetArray[i], ""+i);
		}
		// ������ ���ĺ� ��. ������ BOM-ID�� �����صд�.
		recordBomId4LevelHash = new Hashtable();;
	}
	
	// �̳��� ������ BOM���� �ξ� �����鼭...
	// Ư�� ���ĺ�-������ ���� BOM-ID�� ����� �д�.
	public void recordBomId4AlphaBetLevel(String alphaBetLevel, String bomId) {
		if (recordBomId4LevelHash.containsKey(alphaBetLevel)) {
			System.out.println("�̹� ��ϵ� �ڷ��Դϴ�. Ű=" + alphaBetLevel + " / BOM-ID=" + bomId);
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

	// ���� �������� ���� ���ĺ�-������ �Ķ���ͷ� �ָ�...
	// �� ������ �ش��ϴ� ������ ���ĺ�-������ ã�Ƽ�..
	// �׿� �ش��ϴ� BOM���̵� �����Ѵ�.
	public String getMyParentId(String myAlphaBetLevel) {
		String resultBomIdString = "";
		String tmpStr = "";
		int myParentIntLevel = 0;
		
		// �켱 ���� ���� �������ڰ� ���̰�.. �� ���ں��� �Ѵܰ� ���� ���ڰ� �ӳ�?
		int myCurrnetIntLevel = getIntLevel(myAlphaBetLevel);
		System.out.println("myCurrnetIntLevel=" + myCurrnetIntLevel);
		// �ֻ��� �����̸�..
		if (myCurrnetIntLevel > 1) {
			myParentIntLevel = myCurrnetIntLevel - 1;
			// ���������� ���ĺ������� �����´�.
			tmpStr = getAlphaBetLevel(myParentIntLevel);
			// �� ���ĺ������� �ش��ϴ� Bom-ID�� ���Ѵ�.
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
		
		// �켱 ���� ���� �������ڰ� ���̰�.. �� ���ں��� �Ѵܰ� ���� ���ڰ� �ӳ�?
		int myCurrnetIntLevel = getIntLevel(myAlphaBetLevel);
		System.out.println("myCurrnetIntLevel=" + myCurrnetIntLevel);

		// ���� ������ �ϳ��� ���Ѵ�.
		myParentIntLevel = myCurrnetIntLevel + 1;
		// ���������� ���ĺ������� �����´�.
		resultBomAlphaBetLevel = getAlphaBetLevel(myParentIntLevel);

		return resultBomAlphaBetLevel;
	}
}
