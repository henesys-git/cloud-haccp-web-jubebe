package mes.edms.server;
public class OvenThread implements Runnable{

	public OvenThread() {
		ByteSet.setData(); // 배열 데이터 셋팅    

	}
	
	
	public void run() {
		int i =0;
		while(!Thread.currentThread().isInterrupted()) {
			try {
				if(i>4) i =0;
				OvenTemp.measure(i);				
				Thread.sleep(3000);
			} catch (Exception ex) {
				System.out.println("catch..."); 
			}
			i++;
		}
		
	}
	
	public static void main(String[] args) {
		OvenThread ot = new OvenThread();
		ot.run();
	}
	
}
