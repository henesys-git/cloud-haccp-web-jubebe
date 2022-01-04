package mes.frame.common;

import java.util.Enumeration;
import java.util.Hashtable;

import org.apache.log4j.Logger;

public class HashObject {
	
	static final Logger logger = Logger.getLogger(HashObject.class.getName());
	
	Hashtable ht;
    String key;
    Object value;    
    public static final int YES = 1;
    public static final int NO = 2;
    
	public HashObject(){
		ht = new Hashtable();	
	}
	
	/** HashTable에 key, value 설정
	 *@param key           key   
	 *@param Object        value
	 *@return HashObject   Hashtable
	 */	
	public HashObject put(String key, Object value) throws Exception{		
		HashObject ho = new HashObject();
		try {
			if(key == null){
				throw new Exception("HashObject put(String, Object) -> 해당되는 Key 값이 Null 입니다.");
			}
			if(value == null){
				throw new Exception("HashObject put(String, Object) -> 해당되는 value 값이 Null 입니다.");
			}
			if((key.trim()).equals("")){
				throw new Exception("HashObject put(String, Object) -> 해당되는 key 값이 blank 입니다.");
			}
			ht.put(key, value);
		}catch(Exception ex){
			logger.error("######## Exception ########\n" + ex.toString());
			ex.printStackTrace();
		}		
		return ho;		
	}
	
	/** HashTable에 key로 value값 리턴 
	 *@param key       key   
	 *@param int       status
	 *@return Object   value
	 */	
	public Object get(String key, int status) throws Exception{		
		Object value = null;
		try{			
			value = ht.get(key);
			if(value == null && status == 1){
				value = new Object();
			}
		}catch(Exception ex){
			logger.error("######## Exception ########\n" + ex.toString());
			ex.printStackTrace();
		}		
		return value;		
	}
	
	// 해쉬테이블 자체를 리턴한다.
	public Hashtable getHashtable() {
		return ht;
	}

	/** HashTable에 전체 key로 value 출력
	 */
	public void print() {     
	    try{
	    	Enumeration allKey = ht.keys();
	    	Enumeration allValue = ht.elements();
	    	
	    	logger.debug("-------------------------------------------");
	    	
	    	while(allKey.hasMoreElements()){
	    		logger.debug("-> " + allKey.nextElement() + " : " + allValue.nextElement());
	    		logger.debug("-------------------------------------------");
	    	}
	    }catch(Exception ex){
	    	logger.error("######## Exception ########\n" + ex.toString());
			ex.printStackTrace();
	    }
	}
}
