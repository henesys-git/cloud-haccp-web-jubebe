/*
 * - �ϵ���� �����͸� �ޱ� ���� ���α׷�
 * - ��ġ���: ������ ��������
 * - henesys.hj2211.subserver�� runnable jar�� export�ؼ� 
 *   ������������ ������Ų��.
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
    	System.out.println("���� ���� ����");
    	
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
