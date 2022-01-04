package mes.subserver;

import net.wimpi.modbus.util.ModbusUtil;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.SocketException;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

/*
 * ��� : �����
 * ��ü : 
 * ���� : ���� ������Ʈ ����� ���
 * �������� : RS485/MODBUS
 * 
 * */

public class PackingServer implements Runnable {
	private String threadName;
	private String status;
	private String deviceCode = "xgt_pack01";
	private String serverAddr = "http://113.60.245.156:8080/HJFS_MES";
//	private String hf2211_ip_addr = "192.168.1.25";
	private String hf2211_ip_addr = "192.168.0.20";
	private int hf2211_port_no = 8899;
	
	byte[] bArr = new byte[10];
	byte[] readData = new byte[256];
	byte[] writeBuffer = new byte[10];
	
	Socket sock = null;
	BufferedInputStream bis = null;
    BufferedOutputStream bos = null;
	StringBuilder sb = new StringBuilder();
	List<String> parsedArr = new ArrayList<String>();
    
	PackingServer(String name) {
		this.threadName = name;
	}
	
	// ����� ���¸� Ȯ���ϱ� ���� ������ �����.
    public byte[] makePacketforStatusCheck(int slaveId) {
		byte[] resultBytes = new byte[8];
		Byte bSlaveId = Byte.parseByte(""+(slaveId) );
		
		resultBytes[0] = (byte)bSlaveId; // Slave ID
		resultBytes[1] = (byte)0x02; 	 // 0x02 (Function Code)
		resultBytes[2] = (byte)0x00; 	 // Register Address Hi
		resultBytes[3] = (byte)0x00; 	 // Register Address Lo
		resultBytes[4] = (byte)0x00; 	 // Numbers of Read Data Hi
		resultBytes[5] = (byte)0x05; 	 // Numbers of Read Data Lo
		
		int[] crc = ModbusUtil.calculateCRC(resultBytes, 0, 6);
		resultBytes[6] = (byte)crc[0];
		resultBytes[7] = (byte)crc[1];

		return resultBytes;
	}
    
    // (only ���߿�) ����� ���� Ȯ�� ���Ǹ� ���� �޼���
    public void displayMachineStatusInConsole(String[] arr) {
    	for(int i=0; i<arr.length; i++) {
    		switch(i) {
    			case 0:
    				System.out.println("����������½�ȣ = "+arr[i]);
    				break;
    			case 1:
    				System.out.println("����Ϸ��ȣ = "+arr[i]);
    				break;
    			case 2:
    				System.out.println("�˶����� = "+arr[i]);
    				break;
    			case 3:
    				System.out.println("�������� = "+arr[i]);
    				break;
    			case 4:
    				System.out.println("�ڵ������� = "+arr[i]);
    				break;
    		}
    	}
    }
    
    /*
     * �Լ��� : analizeDataFromMachine
     * �ۼ��� : ������
     * �ۼ��� : 2020.09.09
     * �ڼ��� ����� ���������� �÷ο� ���� ������Ʈ���� '�����'�� �˻�
     * 
     * ================== �� �� ====================
     * 
     * 10000������ request�� �� �޴� ������(����ڵ�� 02)��
     * 1 2 1 6 33 138 ��� �ϸ�, �� �� ����� ���°��� ��Ÿ���°� 6(4��°)
     * 
     * �� �����͸� 1���� bit�� ��ȯ �� ������ : 
     * 00000001 (1)
     * 00000010 (2)
     * 00000001 (1)
     * 00000110 (6)
     * 00100001 (33)
     * 10001010 (138)
     * 
     * 4��° ���� ���� 5��Ʈ�� ���� 00110�ε�, ���⼭ ���귮 ������ 
     * �ϰ� �ٽ� �����͸� �޾ƺ��� 00010110�� �˴ϴ�.
     * 
     * 00010110�� ������ ��Ʈ���� 5��Ʈ�� ����,
     * 0 - �ڵ��������� �ƴ�
     * 1 - ���� ������
     * 1 - �˶��� ����
     * 0 - ���� �Ϸ� ��ȣ ����
     * 1 - ���� ��ư�� ������
    */
    public void analizeDataFromMachine(byte data) {
    	// byte to bit
    	String machineStatus = Integer.toBinaryString(data & 255 | 256).substring(1);
		// only use last 5 bits
    	machineStatus = machineStatus.substring(3);
    	System.out.println(machineStatus);
    	// split and insert into array
    	String statusArr[] = machineStatus.split("");
		// just for developer to check
    	displayMachineStatusInConsole(statusArr);
		
    	if(statusArr[3].equals("1") && statusArr[0].equals("0") && statusArr[1].equals("0")) { status = "���� ����"; } 
    	else if(statusArr[4].equals("1")) { status = "�ڵ� ������"; } 
    	else if(statusArr[3].equals("1") && statusArr[1].equals("1")) { status = "���� �Ϸ�"; } 
    	else if(statusArr[3].equals("1") && statusArr[0].equals("1")) { status = "���� ����"; } 
    	else { status = "ERROR"; }
    }
	
    // check and get status of machine
	public String checkMachineStatus() {
		try {
			// ��û ������ �����.
			byte[] writeBuffer = makePacketforStatusCheck(1);
			
			// ��û ������ ������.
			bos.write(writeBuffer);
			bos.flush();
			
			// ����� ���¸� �ް� �м�(byte[3]�� �ʿ�, �ڼ��Ѱ� �� ������ �� �Ʒ� �ּ� ����!)
			bis.read(bArr);
			analizeDataFromMachine(bArr[3]);
			
			// ����� ���� ��ȯ
			System.out.println("����� ���� = "+ status);
			return status;
//		} catch(IOException e) {
//			e.printStackTrace();
//			status = "ERROR";
//			return status;
		} catch (SocketException e) {
			status = "����� ��������";
			return status;
		} catch (IOException e) {
			e.printStackTrace();
			status = "ERROR";
			return status;
		}
	}
	
	private static byte[] makeRequestMsgToRcvData(int slaveId) {
		byte[] resultBytes = new byte[8];
		Byte bSlaveId = Byte.parseByte(""+(slaveId) );
		
		resultBytes[0] = (byte)bSlaveId; // Slave ID
		resultBytes[1] = (byte)0x04; 	 // 0x04
		resultBytes[2] = (byte)0x00; 	 // Register Address Hi
		resultBytes[3] = (byte)0x00; 	 // Register Address Lo
		resultBytes[4] = (byte)0x00; 	 // Numbers of Read Data Hi
		resultBytes[5] = (byte)0x15; 	 // Numbers of Read Data Lo
		
		int[] crc = ModbusUtil.calculateCRC(resultBytes, 0, 6);
		resultBytes[6] = (byte)crc[0];
		resultBytes[7] = (byte)crc[1];

		return resultBytes;
	}
	
	private String sendRequestAndRcvData() {
		String returnData = "";
		try {
			writeBuffer = makeRequestMsgToRcvData(1);
			
			bos.write(writeBuffer);
			bos.flush();
			
			int readSize = bis.read(readData);
			returnData = ModbusUtil.toHex(readData, 0, readSize);
			//returnData = returnData.trim().replaceAll(" ", "-");
		} catch(IOException e) {
			e.printStackTrace();
		}
		return returnData;
	}
	
	private List<String> parseReturnData(String returnData, List<String> list) {
		String[] splittedList = returnData.split(" ");
		
		// 1.����𵨹�ȣ
		String modelNum = Integer.valueOf(splittedList[4], 16).toString();
		list.add(modelNum);
		
		// 2.���귮
		sb.append(splittedList[5])
		  .append(splittedList[6]);
		
		String tempProdOutput = Integer.valueOf(sb.toString(), 16).toString();
		list.add(tempProdOutput);
		sb.setLength(0);
		
		// 3.����ǰ ����� �� ǰ���ڵ� (1-100 �� �ϳ�)
		String prodPackCode = Integer.valueOf(splittedList[44], 16).toString();
		list.add(prodPackCode);
		
		return list;
	}
	
	private boolean compareWithPrevData(int prevOutput, int curOutput) {
		if(prevOutput < curOutput) {
			return true;
		} else {
			return false;
		}
	}
	
	private void insertIntoDB(int prevOutput, int curOutput, List<String> parsedArr) {
		String modelNum = parsedArr.get(0);
		int output = curOutput - prevOutput;
		String prodPackCode = parsedArr.get(2);
		
		// 4�� 8������ ���귮 ����. ���߿� �Լ��� ���� (2020 09 15)
		if(modelNum.equals("1") || modelNum.equals("3")) {
			output = output * 2;
		} else if(modelNum.equals("2") || modelNum.equals("4")) {
			output = output * 4;
		}
		
		String servletAddr = serverAddr+"/PackServlet?censor_no="+deviceCode
							 +"&censor_data_type=PACK&censor_value0="+output
							 +"&censor_value1="+modelNum+"&censor_value2="+prodPackCode;
		
		try {
			URL url = new URL(servletAddr);
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			System.out.println("�����ڵ� : " + conn.getResponseCode());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private int doCycle(int prevOutput) {
		String returnData = sendRequestAndRcvData();
		
		parseReturnData(returnData, parsedArr);
		
		int curOutput = Integer.parseInt(parsedArr.get(1));
		
		if(compareWithPrevData(prevOutput, curOutput)) { 
			insertIntoDB(prevOutput, curOutput, parsedArr);
		}
		
		parsedArr.clear();
		
		return curOutput;
	}
	
	public void run() {
		try {
			int prevOutput = 0;
			boolean packOn = false;
			
			while(true) {
				try {
					sock = new Socket(hf2211_ip_addr, hf2211_port_no);
					sock.setSoTimeout(3*1000);
					bis = new BufferedInputStream(sock.getInputStream());
			    	bos = new BufferedOutputStream(sock.getOutputStream());
			    	
			    	packOn = sock.isConnected();
			    	
			    	while(packOn) {
			    		// start checking machine status
						System.out.println("����� ���� Ȯ����");
						System.out.println("�ֱ� ���귮 = "+prevOutput);
						status = checkMachineStatus();
						
						if(status.equals("���� ����")) {
							// do nothing, just 1 sec break and check status again
							System.out.println("����� ���� ���۵�\n==========");
							Thread.sleep(1000);
						} else if(status.equals("�ڵ� ������")) {
							// ���� ��� �����͸� �ް� ���� ���귮�� �ٸ��� DB�� �߰�
							System.out.println("����� �۵���\n==========");
							prevOutput = doCycle(prevOutput);
							Thread.sleep(500);
						} else if(status.equals("���� �Ϸ�")) {
							System.out.println("���� �Ϸ�, ���������� ������Ʈ ��\n==========");
							prevOutput = doCycle(prevOutput);
							Thread.sleep(1000*3);
						} else if(status.equals("���� ����")) {
							System.out.println("���� ����, ���귮 0���� �ʱ�ȭ ��\n==========");
							prevOutput = 0;
							Thread.sleep(1000*3);
						} else if(status.equals("����� ��������")) {
							System.out.println("����� ��������\n==========");
							packOn = false;
						} else {
							// do nothing
						}
			    	}
				} catch (UnknownHostException e) {
					System.out.println("### unknown host exception");
					Thread.sleep(1000*30);
				} catch (IOException e) {
					System.out.println("### io exception, packing machine power off now");
					Thread.sleep(1000*30);
				}
			}
		} catch(InterruptedException e) {
			System.out.println(threadName + "interrupted");
		} finally {
			try {
				sock.close();
				bis.close();
				bos.close();
				System.out.println(threadName + "exiting");
			} catch(IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void main(String args[]) {
		Thread th = new Thread(new PackingServer("Pack Thread"));
		th.start();
	}
}