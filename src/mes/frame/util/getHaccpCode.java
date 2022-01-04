package mes.frame.util;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import mes.client.conf.Config;
import mes.frame.serviceinterface.LoggingWriter;

import java.io.BufferedReader;
import java.io.IOException;
public class getHaccpCode {
	static HttpURLConnection conn;
    static BufferedReader rd;
    static String  ServiceKey="LvsTDJA%2BSXmlYtNxfsGuUzimBg4b7hU5wOSU8UwtRP%2F1aXVKr3ETQgwQ5AUgdz70tVkLQk5tLo58j5j7by1c3Q%3D%3D";
    getHaccpCode(){    	
    }
	public static void main(String[] args) throws IOException{
		PrcssListService();
//		PrdLstListService();
//		IndutyListService();
//		PrdLstKndListService();
//		CertCompanyListService();
//		// TODO Auto-generated method stub
//		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B553748/CertCompanyListService/getCertCompanyListService"); /*URL*/
//        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=" + "LvsTDJA%2BSXmlYtNxfsGuUzimBg4b7hU5wOSU8UwtRP%2F1aXVKr3ETQgwQ5AUgdz70tVkLQk5tLo58j5j7by1c3Q%3D%3D"); /*怨듦났�뜲�씠�꽣�룷�꽭�뿉�꽌 諛쏆� �씤利앺궎*/
//        urlBuilder.append("&" + URLEncoder.encode("appointno","UTF-8") + "=" + URLEncoder.encode("2018-6-0116", "UTF-8")); /*HACCP�씤利앹뾽泥대퀎濡� 遺��뿬�맂 怨좎쑀踰덊샇*/
//        urlBuilder.append("&" + URLEncoder.encode("company","UTF-8") + "=" + URLEncoder.encode("沅뚮냽�옣", "UTF-8")); /*�뾽泥대챸*/
//        urlBuilder.append("&" + URLEncoder.encode("returnType","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*寃곌낵 �쓳�떟 �삎�떇*/
//        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*�럹�씠吏� 踰덊샇*/
//        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*�븳 �럹�씠吏� 寃곌낵 �닔*/
//        URL url = new URL(urlBuilder.toString());
//        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//        conn.setRequestMethod("GET");
//        conn.setRequestProperty("Content-type", "application/json");
//        System.out.println("Response code: " + conn.getResponseCode());
//        BufferedReader rd;
//        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
//            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//        } else {
//            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
//        }
//        StringBuilder sb = new StringBuilder();
//        String line;
//        while ((line = rd.readLine()) != null) {
//            sb.append(line);
//        }
//        rd.close();
//        conn.disconnect();
//        System.out.println(sb.toString());
//
	}
	
//	HACCP 怨듭젙肄붾뱶�젙蹂� �꽌鍮꾩뒪
	public static void PrcssListService() {
		// TODO Auto-generated method stub
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B553748/PrcssListService/getPrcssListService"); /*URL*/
        urlBuilder.append("?" + "ServiceKey" + "=" + ServiceKey); /*怨듦났�뜲�씠�꽣�룷�꽭�뿉�꽌 諛쏆� �씤利앺궎*/
        urlBuilder.append("&" + "pcd" + "=" + "BIZ046"); /*�긽�쐞肄붾뱶*/ 
        urlBuilder.append("&" + "returnType" + "=" + "json"); /*寃곌낵 �쓳�떟 �삎�떇*/
//        urlBuilder.append("&" + URLEncoder.encode("returnType","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*寃곌낵 �쓳�떟 �삎�떇*/
        try {
	        URL url = new URL(urlBuilder.toString());
	        System.out.println("URL code: " + url);
	        
	        conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        
	        System.out.println("Response code: " + conn.getResponseCode());
	        
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        //�뜲�씠�꽣瑜� �떎 諛쏆� �썑�뿉 jason媛앹껜瑜� 留뚮뱾�뼱
            //�씠遺�遺꾩뿉�꽌 DB�뿉 insert or update Function�쓣 Call�븳�떎.
	        System.out.println(sb.toString());
        }
        catch(Exception e) {
			e.printStackTrace();
        	
        } finally {
        	try {
				rd.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	if (conn != null) conn.disconnect();
	    	
	    }
	}

//	HACCP �뭹紐⑹퐫�뱶�젙蹂� �꽌鍮꾩뒪
	public static void PrdLstListService() {
		// TODO Auto-generated method stub
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B553748/PrdLstListService/getPrdLstListService"); /*URL*/
        urlBuilder.append("?" + "ServiceKey" + "=" + ServiceKey); /*怨듦났�뜲�씠�꽣�룷�꽭�뿉�꽌 諛쏆� �씤利앺궎*/
        urlBuilder.append("&" + "pcd" + "=" + "B001"); /*�긽�쐞肄붾뱶*/ 
        urlBuilder.append("&" + "returnType" + "=" + "json"); /*寃곌낵 �쓳�떟 �삎�떇*/
//        urlBuilder.append("&" + URLEncoder.encode("returnType","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*寃곌낵 �쓳�떟 �삎�떇*/
        try {
	        URL url = new URL(urlBuilder.toString());
	        System.out.println("URL code: " + url);
	        
	        conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        
	        System.out.println("Response code: " + conn.getResponseCode());
	        
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
        }
        catch(Exception e) {
			e.printStackTrace();
        	
        } finally {
        	try {
				rd.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	if (conn != null) conn.disconnect();
	    	
	    }
	}

//	HACCP �뾽醫낆퐫�뱶�젙蹂� 議고쉶
	public static void IndutyListService() {
		// TODO Auto-generated method stub
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B553748/IndutyListService/getIndutyListService"); /*URL*/
        urlBuilder.append("?" + "ServiceKey" + "=" + ServiceKey); /*怨듦났�뜲�씠�꽣�룷�꽭�뿉�꽌 諛쏆� �씤利앺궎*/
        urlBuilder.append("&" + "pcd" + "=" + "BIZ046"); /*�긽�쐞肄붾뱶*/ 
        urlBuilder.append("&" + "returnType" + "=" + "json"); /*寃곌낵 �쓳�떟 �삎�떇*/
//        urlBuilder.append("&" + URLEncoder.encode("returnType","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*寃곌낵 �쓳�떟 �삎�떇*/
        try {
	        URL url = new URL(urlBuilder.toString());
	        System.out.println("URL code: " + url);
	        
	        conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        
	        System.out.println("Response code: " + conn.getResponseCode());
	        
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        //�뜲�씠�꽣瑜� �떎 諛쏆� �썑�뿉 jason媛앹껜瑜� 留뚮뱾�뼱
            //�씠遺�遺꾩뿉�꽌 DB�뿉 insert or update Function�쓣 Call�븳�떎.
	        System.out.println(sb.toString());
        }
        catch(Exception e) {
			e.printStackTrace();
        	
        } finally {
        	try {
				rd.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	if (conn != null) conn.disconnect();
	    	
	    }
	}
	
//	HACCP �뭹紐⑹쑀�삎肄붾뱶�젙蹂� �꽌鍮꾩뒪
	public static void PrdLstKndListService() {
		// TODO Auto-generated method stub
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B553748/PrdLstKndListService/getPrdLstKndListService"); /*URL*/
        urlBuilder.append("?" + "ServiceKey" + "=" + ServiceKey); /*怨듦났�뜲�씠�꽣�룷�꽭�뿉�꽌 諛쏆� �씤利앺궎*/
        urlBuilder.append("&" + "pcd" + "=" + "005"); /*�긽�쐞肄붾뱶*/ 
        urlBuilder.append("&" + "returnType" + "=" + "json"); /*寃곌낵 �쓳�떟 �삎�떇*/
//        urlBuilder.append("&" + URLEncoder.encode("returnType","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*寃곌낵 �쓳�떟 �삎�떇*/
        try {
	        URL url = new URL(urlBuilder.toString());
	        System.out.println("URL code: " + url);
	        
	        conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        
	        System.out.println("Response code: " + conn.getResponseCode());
	        
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        //�뜲�씠�꽣瑜� �떎 諛쏆� �썑�뿉 jason媛앹껜瑜� 留뚮뱾�뼱
            //�씠遺�遺꾩뿉�꽌 DB�뿉 insert or update Function�쓣 Call�븳�떎.
	        System.out.println(sb.toString());
        }
        catch(Exception e) {
			e.printStackTrace();
        	
        } finally {
        	try {
				rd.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	if (conn != null) conn.disconnect();
	    	
	    }
	}


//	HACCP �씤利앹뾽泥댁젙蹂� �꽌鍮꾩뒪
	public static void CertCompanyListService() {
		// TODO Auto-generated method stub
        try {
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B553748/CertCompanyListService/getCertCompanyListService"); /*URL*/
        urlBuilder.append("?" + "ServiceKey" + "=" + ServiceKey);
        urlBuilder.append("&" + URLEncoder.encode("appointno","UTF-8") + "=" + URLEncoder.encode("2018-6-0116", "UTF-8")); /*HACCP�씤利앹뾽泥대퀎濡� 遺��뿬�맂 怨좎쑀踰덊샇*/
        urlBuilder.append("&" + URLEncoder.encode("company","UTF-8") + "=" + URLEncoder.encode("沅뚮냽�옣", "UTF-8")); /*�뾽泥대챸*/
        urlBuilder.append("&" + URLEncoder.encode("returnType","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*寃곌낵 �쓳�떟 �삎�떇*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*�럹�씠吏� 踰덊샇*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*�븳 �럹�씠吏� 寃곌낵 �닔*/
	        URL url = new URL(urlBuilder.toString());
	        System.out.println("URL code: " + url);
	        
	        conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        
	        System.out.println("Response code: " + conn.getResponseCode());
	        
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
        }
        catch(Exception e) {
			e.printStackTrace();
        	
        } finally {
        	try {
				rd.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	if (conn != null) conn.disconnect();
	    	
	    }
	}
}