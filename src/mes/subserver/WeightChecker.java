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

public class WeightChecker implements Runnable {
	
	private String threadName;
	private String status;
	private String deviceCode = InterfaceConstants.WEIGHT_CHECKER;
	private String serverAddr = InterfaceConstants.SERVER_IP;
	private String weightCheckerIp = InterfaceConstants.WEIGHT_CHECKER_IP;
	private int weightCheckerPort = InterfaceConstants.WEIGHT_CHECKER_PORT;
	private int slaveId = 1;
	
	private byte[] readData = new byte[256];
	private byte[] writeBuffer = new byte[10];
	
	private Socket sock = null;
	private BufferedInputStream bis = null;
	private BufferedOutputStream bos = null;
    
	private boolean machineOn;
	
	WeightChecker(String name) {
		this.threadName = name;
	}
	
	// �߷� ������ ���¸� Ȯ���ϱ� ���� ������ �����.
    private byte[] makePacketforStatusCheck(int slaveId) {
		byte[] resultBytes = new byte[8];
		Byte bSlaveId = Byte.parseByte(""+(slaveId));
		
		resultBytes[0] = (byte)bSlaveId; // Slave ID
		resultBytes[1] = (byte)0x02; 	 // 0x04 (Function Code)
		resultBytes[2] = (byte)0x00; 	 // Register Address Hi
		resultBytes[3] = (byte)0x41; 	 // Register Address Lo
		resultBytes[4] = (byte)0x00; 	 // Numbers of Read Data Hji
		resultBytes[5] = (byte)0x08; 	 // Numbers of Read Data Lo
		
		int[] crc = ModbusUtil.calculateCRC(resultBytes, 0, 6);
		resultBytes[6] = (byte)crc[0];
		resultBytes[7] = (byte)crc[1];

		return resultBytes;
	}
    
    // ���� �߷� Ȯ���� ��ǰ�� ���̵� ��� ���� ������ �����
    private byte[] makeReqeustMsgToGetProductId(int slaveId) {
		byte[] resultBytes = new byte[8];
		Byte bSlaveId = Byte.parseByte(""+(slaveId));
		
		resultBytes[0] = (byte)bSlaveId; // Slave ID
		resultBytes[1] = (byte)0x03; 	 // Function Code
		resultBytes[2] = (byte)0x00; 	 // Register Address Hi
		resultBytes[3] = (byte)0x00; 	 // Register Address Lo
		resultBytes[4] = (byte)0x00; 	 // Numbers of Read Data Hji
		resultBytes[5] = (byte)0x01; 	 // Numbers of Read Data Lo
		
		int[] crc = ModbusUtil.calculateCRC(resultBytes, 0, 6);
		resultBytes[6] = (byte)crc[0];
		resultBytes[7] = (byte)crc[1];

		return resultBytes;
	}
    
    // �� ���跮�� ���� �����͸� ��� ���� ������ �����
    private byte[] makeReqeustMsgToGetResult(int slaveId) {
		byte[] resultBytes = new byte[8];
		Byte bSlaveId = Byte.parseByte(""+(slaveId));
		
		resultBytes[0] = (byte)bSlaveId; // Slave ID
		resultBytes[1] = (byte)0x04; 	 // Function Code
		resultBytes[2] = (byte)0x00; 	 // Register Address Hi
		resultBytes[3] = (byte)0x2B; 	 // Register Address Lo
		resultBytes[4] = (byte)0x00; 	 // Numbers of Read Data Hji
		resultBytes[5] = (byte)0x04; 	 // Numbers of Read Data Lo
		
		int[] crc = ModbusUtil.calculateCRC(resultBytes, 0, 6);
		resultBytes[6] = (byte)crc[0];
		resultBytes[7] = (byte)crc[1];

		return resultBytes;
	}
	
    // check and get status of machine
    private String getBeltStatus() {
		try {
			// ��û ������ �����.
			byte[] writeBuffer = makePacketforStatusCheck(slaveId);
			
			// ��û ������ ������.
			bos.write(writeBuffer);
			bos.flush();
			
			int readSize = bis.read(readData);
			String dataFromMachine = ModbusUtil.toHex(readData, 0, readSize);
			
			String[] splittedData = dataFromMachine.split(" ");
			String returnVal = splittedData[3];
			
			if(returnVal.equals("40")) {
				status = "beltOn";
			} else {
				status = "beltOff";
			}
			
			return status;
		} catch (SocketException e) {
			status = "[�߷� ������] ���� ���� ����";
			return status;
		} catch (IOException e) {
			e.printStackTrace();
			status = "[�߷�������] ERROR";
			return status;
		}
	}
	
	private int sendRequestForProductId(byte[] reqMsg) {
		int prodId = -1;
		
		try {
			writeBuffer = reqMsg;
			
			bos.write(writeBuffer);
			bos.flush();
			
			int readSize = bis.read(readData);
			
			String dataFromMachine = ModbusUtil.toHex(readData, 0, readSize);
			String[] splittedData = dataFromMachine.split(" ");
			
			prodId = Integer.parseInt(splittedData[4]);
		} catch(IOException e) {
			e.printStackTrace();
		}
		
		return prodId;
	}
	
	private int[] sendRequestAndRcvData(byte[] reqMsg) {
		int[] result = new int[2];
		
		try {
			writeBuffer = reqMsg;
			
			bos.write(writeBuffer);
			bos.flush();
			
			int readSize = bis.read(readData);
			String dataFromMachine = ModbusUtil.toHex(readData, 0, readSize);
			System.out.println(dataFromMachine);
			
			String[] splittedData = dataFromMachine.split(" ");
			
			System.out.println(splittedData.toString());
			
			String result1 = splittedData[5] + splittedData[6];
			String result2 = splittedData[9] + splittedData[10];
			
			int decimal1 = Integer.parseInt(result1, 16);  
			int decimal2 = Integer.parseInt(result2, 16);  
					
			result[0] = decimal1;
			result[1] = decimal2;
		} catch(IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	private int getProductId() {
		int prodId = 0;
		
		byte[] reqMsg = makeReqeustMsgToGetProductId(slaveId); 
		
		prodId = sendRequestForProductId(reqMsg);
		
		return prodId;
	}
	
	private int[] receiveResult() {
		int[] result = new int[2];
		
		byte[] reqMsg = makeReqeustMsgToGetResult(slaveId);
		
		result = sendRequestAndRcvData(reqMsg);
		
		return result;
	}
	
	private boolean sendResultToServer(int[] result, int prodId) {
		int totalCount = result[0];
		int passCount = result[1];
		boolean sendSuccess = false;
		
		String servletAddr = serverAddr+"/WeightCheckerServlet"
				+"?censor_no="+deviceCode
				+"&censor_data_type=WEIGHT"
				+"&prodId="+prodId
				+"&censor_value0="+totalCount
				+"&censor_value1="+passCount;
		
		try {
			URL url = new URL(servletAddr);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			System.out.println("	[�߷�������] �����ڵ� : " + conn.getResponseCode());
			sendSuccess = true;
		} catch (Exception e) {
			e.printStackTrace();
			sendSuccess = false;
		}
		
		return sendSuccess;
	}
	
	public void run() {
		try {
			machineOn = false;
			
			while(true) {
				try {
					sock = new Socket(weightCheckerIp, weightCheckerPort);
					sock.setSoTimeout(3*1000);
					bis = new BufferedInputStream(sock.getInputStream());
			    	bos = new BufferedOutputStream(sock.getOutputStream());
			    	
			    	machineOn = sock.isConnected();
			    	
			    	while(machineOn) {
			    		// start checking machine status
						System.out.println("	[�߷�������] ��Ʈ ���� Ȯ����");
						status = getBeltStatus();
						
						if(status.equals("beltOff")) {
							System.out.println("	[�߷�������] ��Ʈ�� �����ֽ��ϴ�");
							// do nothing
						} else if(status.equals("beltOn")) {
							System.out.println("	[�߷�������] ��Ʈ�� �۵��� �����߽��ϴ�");

							int prodId = getProductId();
							if(prodId == -1) {
								System.out.println("	[�߷�������] ���� �������� ��ǰ�� ���̵� �������� �� �����߽��ϴ�");
							} else {
								System.out.println("	[�߷�������] ���� �������� ��ǰ�� ���̵�� " + prodId + "�Դϴ�");
							}
							
							while(status.equals("beltOn")) {
								// 1 sec break
								Thread.sleep(1000);
								// wait till belt stops
								status = getBeltStatus();
								System.out.println("	[�߷�������] ���� �߷� ���� ���Դϴ�");
							}

							System.out.println("	[�߷�������] �߷� ������ �Ϸ��ϰ� ��Ʈ�� ������ϴ�");

							System.out.println("	[�߷�������] �� ���� ������ ������ �������� ���Դϴ�");
							int[] result = new int[2];
							result = receiveResult();
							
							System.out.println("	[�߷�������] ����� �����Խ��ϴ�");
							System.out.println("	[�߷�������] �� �跮 �� : " + result[0]);
							System.out.println("	[�߷�������] �� ���� �� : " + result[1]);
							
							// send result to server
							sendResultToServer(result, prodId);
						}
						
						// 3 sec break
						Thread.sleep(1000 * 3);
			    	}
				} catch (UnknownHostException e) {
					System.out.println("	[�߷�������] ���� ����");
					machineOn = false;
					Thread.sleep(1000*1*5);
				} catch (IOException e) {
					System.out.println("	[�߷�������] ���� OFF");
					machineOn = false;
					Thread.sleep(1000*1*5);
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
		Thread th = new Thread(new WeightChecker("WeightChecker Thread"));
		th.start();
	}
}