/*
 * - 하드웨어 데이터를 받기 위한 프로그램
 * - 설치장소: 현장의 보조서버
 * - henesys.hj2211.subserver만 runnable jar로 export해서 
 *   보조서버에서 구동시킨다.
 */
package mes.subserver;

public class MainRunner extends Thread {
	public MainRunner() {
//		try {
//			Thread mainThread = new Thread(this);
//			mainThread.start();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
	}
	
    public static void main(String args[]) {
    	System.out.println("센서 감지 시작");
    	
    	Thread th = new Thread(new WeightChecker("Weight Checker Thread"));
		th.start();
		
		MetalDetector th2 = new MetalDetector();
		th2.start();

		ThermalServer th3 = new ThermalServer();
		th3.start();
		
		ThermalServer2 th4 = new ThermalServer2();
		th4.start();
    }
}
