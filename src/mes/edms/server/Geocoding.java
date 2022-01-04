package mes.edms.server;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

class GpsToAddress {
	double latitude;
	double longitude;
	String regionAddress;

	public GpsToAddress(double latitude, double longitude) throws Exception {
		this.latitude = latitude;
		this.longitude = longitude;
		this.regionAddress = getRegionAddress(getJSONData(getApiAddress()));
	}

	public String getApiAddress() {
		String apiURL = "https://maps.googleapis.com/maps/api/geocode/json?latlng="
				+ latitude + "," + longitude + "&language=ko&key=AIzaSyDlkYGqn-4YiwwH9R5Us7G2nx3Rtd0dJQ4";
		return apiURL;
	}

	public String getJSONData(String apiURL) throws Exception {
		String jsonString = new String();
		String buf;
		URL url = new URL(apiURL);
		URLConnection conn = url.openConnection();
		BufferedReader br = new BufferedReader(new InputStreamReader(
				conn.getInputStream(), "UTF-8"));
		while ((buf = br.readLine()) != null) {
			jsonString += buf;
		}
		return jsonString;
	}

	public String getRegionAddress(String jsonString) {
		JSONObject jObj = (JSONObject) JSONValue.parse(jsonString);
		JSONArray jArray = (JSONArray) jObj.get("results");
		jObj = (JSONObject) jArray.get(0);
		return (String) jObj.get("formatted_address");
	}

	public String getAddress() {
		return regionAddress;
	}
}
public class Geocoding {
	String location="";
	GpsToAddress gps;
	public static void main(String[] args) throws Exception {
		double latitude = 36.317507;
		double longitude = 127.383851;

		GpsToAddress gps = new GpsToAddress(latitude, longitude);
		System.out.println(gps.getAddress());
	}
	
	public String location(double latitude, double longitude) {
		try {
			gps = new GpsToAddress(latitude, longitude);
			location = gps.getAddress();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return location;
	}
	
	
}