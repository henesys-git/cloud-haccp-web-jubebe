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
 * 기계 : 포장기
 * 업체 : 
 * 목적 : 협진 프로젝트 포장기 사용
 * 프로토콜 : RS485/MODBUS
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
	
	// 포장기 상태를 확인하기 위한 전문을 만든다.
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
    
    // (only 개발용) 포장기 상태 확인 편의를 위한 메서드
    public void displayMachineStatusInConsole(String[] arr) {
    	for(int i=0; i<arr.length; i++) {
    		switch(i) {
    			case 0:
    				System.out.println("생산수량리셋신호 = "+arr[i]);
    				break;
    			case 1:
    				System.out.println("생산완료신호 = "+arr[i]);
    				break;
    			case 2:
    				System.out.println("알람상태 = "+arr[i]);
    				break;
    			case 3:
    				System.out.println("정지상태 = "+arr[i]);
    				break;
    			case 4:
    				System.out.println("자동운전중 = "+arr[i]);
    				break;
    		}
    	}
    }
    
    /*
     * 함수명 : analizeDataFromMachine
     * 작성자 : 최현수
     * 작성일 : 2020.09.09
     * 자세한 포장기 프로토콜은 플로우 협진 프로젝트에서 '포장기'로 검색
     * 
     * ================== 설 명 ====================
     * 
     * 10000번지로 request할 때 받는 데이터(펑션코드는 02)가
     * 1 2 1 6 33 138 라고 하면, 이 중 포장기 상태값을 나타내는건 6(4번째)
     * 
     * 위 데이터를 1부터 bit로 변환 시 데이터 : 
     * 00000001 (1)
     * 00000010 (2)
     * 00000001 (1)
     * 00000110 (6)
     * 00100001 (33)
     * 10001010 (138)
     * 
     * 4번째 줄의 하위 5비트를 보면 00110인데, 여기서 생산량 리셋을 
     * 하고 다시 데이터를 받아보면 00010110이 됩니다.
     * 
     * 00010110을 마지막 비트부터 5비트를 보면,
     * 0 - 자동운전중이 아님
     * 1 - 정지 상태임
     * 1 - 알람이 있음
     * 0 - 생산 완료 신호 없음
     * 1 - 리셋 버튼을 눌렀음
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
		
    	if(statusArr[3].equals("1") && statusArr[0].equals("0") && statusArr[1].equals("0")) { status = "정지 상태"; } 
    	else if(statusArr[4].equals("1")) { status = "자동 운전중"; } 
    	else if(statusArr[3].equals("1") && statusArr[1].equals("1")) { status = "생산 완료"; } 
    	else if(statusArr[3].equals("1") && statusArr[0].equals("1")) { status = "수량 리셋"; } 
    	else { status = "ERROR"; }
    }
	
    // check and get status of machine
	public String checkMachineStatus() {
		try {
			// 요청 전문을 만든다.
			byte[] writeBuffer = makePacketforStatusCheck(1);
			
			// 요청 전문을 보낸다.
			bos.write(writeBuffer);
			bos.flush();
			
			// 포장기 상태를 받고 분석(byte[3]만 필요, 자세한건 이 페이지 맨 아래 주석 참고!)
			bis.read(bArr);
			analizeDataFromMachine(bArr[3]);
			
			// 포장기 상태 반환
			System.out.println("포장기 상태 = "+ status);
			return status;
//		} catch(IOException e) {
//			e.printStackTrace();
//			status = "ERROR";
//			return status;
		} catch (SocketException e) {
			status = "포장기 오프상태";
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
		
		// 1.생산모델번호
		String modelNum = Integer.valueOf(splittedList[4], 16).toString();
		list.add(modelNum);
		
		// 2.생산량
		sb.append(splittedList[5])
		  .append(splittedList[6]);
		
		String tempProdOutput = Integer.valueOf(sb.toString(), 16).toString();
		list.add(tempProdOutput);
		sb.setLength(0);
		
		// 3.완제품 포장기 측 품목코드 (1-100 중 하나)
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
		
		// 4구 8구별로 생산량 조정. 나중에 함수로 빼기 (2020 09 15)
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
			System.out.println("응답코드 : " + conn.getResponseCode());
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
						System.out.println("포장기 상태 확인중");
						System.out.println("최근 생산량 = "+prevOutput);
						status = checkMachineStatus();
						
						if(status.equals("정지 상태")) {
							// do nothing, just 1 sec break and check status again
							System.out.println("포장기 현재 미작동\n==========");
							Thread.sleep(1000);
						} else if(status.equals("자동 운전중")) {
							// 포장 결과 데이터를 받고 이전 생산량과 다르면 DB에 추가
							System.out.println("포장기 작동중\n==========");
							prevOutput = doCycle(prevOutput);
							Thread.sleep(500);
						} else if(status.equals("생산 완료")) {
							System.out.println("생산 완료, 마지막으로 업데이트 중\n==========");
							prevOutput = doCycle(prevOutput);
							Thread.sleep(1000*3);
						} else if(status.equals("수량 리셋")) {
							System.out.println("수량 리셋, 생산량 0으로 초기화 됨\n==========");
							prevOutput = 0;
							Thread.sleep(1000*3);
						} else if(status.equals("포장기 오프상태")) {
							System.out.println("포장기 오프상태\n==========");
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