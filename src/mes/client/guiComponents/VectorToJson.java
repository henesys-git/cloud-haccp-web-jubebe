package mes.client.guiComponents;

import java.util.Collections;
import java.util.List;
import java.util.Vector;

import org.json.simple.JSONArray;

public class VectorToJson {
	
	public String vectorToJson(Vector v) {
		
		List<String> list = Collections.list(v.elements());
		
		String jsonStr = JSONArray.toJSONString(list);
		
		return jsonStr;
	}
}
