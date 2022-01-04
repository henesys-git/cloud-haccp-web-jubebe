package mes.edms.server;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;

import org.json.simple.JSONObject;

import net.wimpi.modbus.util.ModbusUtil;

public class OvenTemp {
   static OvenTemp OvenTemp = null;
   
   static Socket sock = null;
   static DataInputStream in = null;
   static DataOutputStream out = null;   
   static byte[] sendPacket = new byte[48];
   static byte[] rcvPacket = new byte[128];
   static int rcvSize = 0;
   static String returnMsg = "";
   static String ip = "";
   static String id = "";
   static String data_type = "";
   static String[] result;
   static String[] strColumnHead 	= {"��ǰ��","��ǰ��"};
   static  URL url;
   static HttpURLConnection conn;
   public static BufferedReader br;
   
   public OvenTemp() {
      //OvenTemp = new OvenTemp();
   }

   byte[] hexBuffer = new byte[37];


   public byte getCheckSumValue() {
      int chkSum = 0;
      
      for (int i=0; i<19; i++) {
         chkSum += Integer.parseInt(ModbusUtil.toHex(hexBuffer, i, i+1).replace(" ", ""), 16);
         //System.out.println("chkSum-0="+chkSum);

         if (chkSum > 255) {
            chkSum = chkSum - 256;
            //System.out.println("chkSum-1="+chkSum);
         }
      }
      return (byte)(chkSum);
   }
   
   // ��� ���� ������ �����.
    public byte[] getHexPacket(String strData) {
//   GLOFA
//      hexBuffer[0] = (byte)0x4C;
//      hexBuffer[1] = (byte)0x47;
//      hexBuffer[2] = (byte)0x49;
//      hexBuffer[3] = (byte)0x53;
//      hexBuffer[4] = (byte)0x2D;
//      hexBuffer[5] = (byte)0x47;
//      hexBuffer[6] = (byte)0x4C;
//      hexBuffer[7] = (byte)0x4F;
//      hexBuffer[8] = (byte)0x46;
//      hexBuffer[9] = (byte)0x41;
       
       System.out.println(strData);
       String data[] = strData.split(",");
       
// XGT      
      hexBuffer[0] = (byte)0x4C;
      hexBuffer[1] = (byte)0x53;
      hexBuffer[2] = (byte)0x49;
      hexBuffer[3] = (byte)0x53;
      hexBuffer[4] = (byte)0x2D;
      hexBuffer[5] = (byte)0x58;
      hexBuffer[6] = (byte)0x47;
      hexBuffer[7] = (byte)0x54;
      hexBuffer[8] = (byte)0x00;
      hexBuffer[9] = (byte)0x00;
      hexBuffer[10] = 0x02;       						 //PLC ����
      hexBuffer[11] = 0x08;
      hexBuffer[12] = (byte)0xB0;   				     // CPU���� - B0�� XGB�Դϴ�.
      hexBuffer[13] = 0x33;       						 // '3' �����ӹ���
      hexBuffer[14] = 0x00;       						 //�����Ӽ���
      hexBuffer[15] = 0x00;
      hexBuffer[16] = 0x11;         					 // '%' ����
      hexBuffer[17] = 0x00;
      hexBuffer[18] = 0x00;         					 //��ġ ����
      hexBuffer[19] = OvenTemp.getCheckSumValue(); 		 //üũ��
      hexBuffer[20] = 0x54;         					 // ��ɾ�(�б�)  0x54
      hexBuffer[21] = 0x00;         
      hexBuffer[22] = 0x02;         					 // ������Ÿ��
      hexBuffer[23] = 0x00;         
      hexBuffer[24] = 0x00;         					 // ���� ����
      hexBuffer[25] = 0x00;
      hexBuffer[26] = 0x01;         					 // ��ϰ���
      hexBuffer[27] = 0x00;
      hexBuffer[28] = 0x07;         					 // ��������
      hexBuffer[29] = 0x00;
      hexBuffer[30] = (byte)'%';
      hexBuffer[31] = (byte)'D';
      hexBuffer[32] = (byte)'W';
      hexBuffer[33] = (byte)'3';
      hexBuffer[34] = (byte)'0';
      hexBuffer[35] = (byte)data[0].charAt(0);
      hexBuffer[36] = (byte)data[1].charAt(0);
      
      id = data[2];
      data_type = data[3];
//      hexBuffer[35] = (byte)'0';
//      hexBuffer[36] = (byte)'0';
      
      // �ð��� 12�� ������
      // �ð��� �����̾� 3030~3033 ex)DEC 500���� ������ 5Hz(5.00)
      // �ð��� �µ�       3034
      
      // 1�ܿ��� �µ�  3020~3025��
      // ���� �����̾� 3012 2�ܿ� �Ʒ�
      //          3013 2�ܿ� ����
      
      return hexBuffer;
    }
    
    // �µ��� �о�´�.
    public String getTempValue(String readStr) {
       String resultValue = "";
       String tempValueStr = "";
       try {
          int indexTP0 = readStr.indexOf("TP0");
          if (indexTP0 > 0) {
             tempValueStr = ""+Integer.valueOf(readStr.substring(indexTP0+3,indexTP0+7), 16).intValue();
              resultValue = tempValueStr.substring(0,2) + "." + tempValueStr.substring(2);
          } else {
             resultValue = "0";
          }
       } catch (Exception e) {
          resultValue = "-999";
       }
       return resultValue;
    }
    
    public static void measure(int arrNum) throws IOException {
      try {
    	  	System.out.println(arrNum);
	         OvenTemp = new OvenTemp();
	         
	         if(arrNum==0||arrNum==1||arrNum==2) {
	        	 ip = "192.168.1.11";	             
	         } else {	        	 
	        	 ip = "192.168.1.12";
	         }
	         sock = new Socket(ip, 2004);
	          sock.setSoTimeout(5000); 
	          in = new DataInputStream(new BufferedInputStream(sock.getInputStream()));
	          out = new DataOutputStream(new BufferedOutputStream(sock.getOutputStream()));
	          
	          
	          
	          
	          for(int i=0; i<ByteSet.arr.get(arrNum).length; i++) {
	        	  
	        	  sendPacket = OvenTemp.getHexPacket(ByteSet.arr.get(arrNum)[i]);
	              System.out.println("sendMsg= "+ModbusUtil.toHex(sendPacket));
	              out.write(sendPacket);
	              out.flush();
	              
	              rcvSize = in.read(rcvPacket);
	              
	              returnMsg = ModbusUtil.toHex(rcvPacket, 0, rcvSize);
	              System.out.println("rcvMsg= "+returnMsg);
	              
	              //16���� ��ȯ...
	              result = ModbusUtil.toHex(rcvPacket).split(" ");
	              JSONObject jArray = new JSONObject();
//	              jArray.put("censor_no", id);
//	              jArray.put("censor_data_type", data_type);
//	              jArray.put("censor_channel_no", 0);
//	              jArray.put("censor_value", Long.parseLong(result[33]+result[32],16)/10.0);
	              
	              
	              //DB ���� ....
	              //TableModel_insert = new DoyosaeTableModel("M707S010600E111", jArray);
		          
	              url = new URL("http://182.162.141.5:8080/Oven_Svr?censor_no="+id+"&censor_data_type="+data_type+"&censor_value="+Long.parseLong(result[33]+result[32],16)/10.0);
		          conn = (HttpURLConnection) url.openConnection();
		          conn.setRequestMethod("GET"); 
		          
		          // ���� Ÿ�Ӿƿ� ���� 
		          conn.setConnectTimeout(3000); // 3�� 
		          // �б� Ÿ�Ӿƿ� ���� 
		          conn.setReadTimeout(3000); // 3�� 
		          br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
		          br.close();
	          }
	          
	          
	          
	          sock.close();
	          System.out.println("========================================================================================================================");
	          System.out.println("========================================================================================================================");
          
      } catch (Exception e) {
         System.out.println("�ɸ�");
         sock.close();
    	  e.printStackTrace();
      }
    }
}