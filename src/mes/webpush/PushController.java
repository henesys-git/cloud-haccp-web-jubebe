package mes.webpush;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.apache.http.HttpEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.entity.StringEntity;

import mes.dao.SubscriptionDao;
import mes.dao.SubscriptionDaoImpl;
import mes.webpush.dto.Notification;
import mes.webpush.dto.PushMessage;
import mes.webpush.dto.Subscription;

//@RestController
public class PushController {

    private final ServerKeys serverKeys;

    private final CryptoService cryptoService;

    private String lastNumbersAPIFact = "";

    private final CloseableHttpClient httpClient;

    private final Algorithm jwtAlgorithm;

    private final ObjectMapper objectMapper;

    public PushController(ServerKeys serverKeys, CryptoService cryptoService,
                          ObjectMapper objectMapper) {
        this.serverKeys = serverKeys;
        this.cryptoService = cryptoService;
        this.objectMapper = objectMapper;
        this.httpClient = HttpClients.createDefault();
        
        this.jwtAlgorithm = Algorithm.ECDSA256(this.serverKeys.getPublicKey(),
                							   this.serverKeys.getPrivateKey());
    }

    //@GetMapping(path = "/publicSigningKey", produces = "application/octet-stream")
    public byte[] publicSigningKey() {
        return this.serverKeys.getPublicKeyUncompressed();
    }

    //@GetMapping(path = "/publicSigningKeyBase64")
    public String publicSigningKeyBase64() {
        return this.serverKeys.getPublicKeyBase64();
    }

    //@PostMapping("/subscribe")
    //@ResponseStatus(HttpStatus.CREATED)
    public void subscribe(Subscription subscription) {
    	SubscriptionDao subscriptions = new SubscriptionDaoImpl();
    	subscriptions.insertSubscription(subscription);
    }

    //@PostMapping("/unsubscribe")
    public void unsubscribe(String endpointJsonStr) {
    	
		try {
			JSONParser parser = new JSONParser();
			JSONObject endpointJsonObj;
			endpointJsonObj = (JSONObject) parser.parse(endpointJsonStr);
			String endpoint = endpointJsonObj.get("endpoint").toString();
			
			SubscriptionDao subscriptions = new SubscriptionDaoImpl();
			subscriptions.deleteSubscription(endpoint);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    }

    //@PostMapping("/isSubscribed")
    public boolean isSubscribed(String endpoint) {
    	SubscriptionDao subscriptions = new SubscriptionDaoImpl();
    	Set<Subscription> subscriberList = subscriptions.getAllSubscriptions();
    	
    	for (Subscription s : subscriberList) {
    		if(s.getEndpoint().equals(endpoint)) {
    			return true;
    		}
    	}
    	
        return false;
    }

    private void sendPushMessageToAllSubscribersWithoutPayload() throws UnsupportedEncodingException {
    	System.out.println("start : sendPushMessageToAllSubscribersWithoutPayload func");
    	
    	SubscriptionDao subscriptions = new SubscriptionDaoImpl();
    	System.out.println("1");
    	Set<Subscription> subscriberList = subscriptions.getAllSubscriptions();
    	System.out.println("2");
    	
        Set<Subscription> failedSubscriptions = new HashSet<>();
        System.out.println("3");
        
        for (Subscription subscriber : subscriberList) {
        	System.out.println("in for loop");
            boolean remove = sendPushMessage(subscriber, null);
            System.out.println("	after sending push msg");
            if (remove) {
            	failedSubscriptions.add(subscriber);
            }
        }
        System.out.println("after for loop");
        failedSubscriptions.forEach(subscriberList::remove);
        System.out.println("after remove");
    }

    private void sendPushMessageToAllSubscribers(Set<Subscription> subscriberList,
        Object message) throws JsonProcessingException, UnsupportedEncodingException {
    	System.out.println("start : sendPushMessageToAllSubscribers func");
    	
        Set<Subscription> failedSubscribers = new HashSet<>();

        for (Subscription subscriber : subscriberList) {
            try {
                byte[] result = this.cryptoService.encrypt(
                    this.objectMapper.writeValueAsString(message),
                    subscriber.getP256dh(), subscriber.getAuth(), 0);
                boolean remove = sendPushMessage(subscriber, result);
                if (remove) {
                	failedSubscribers.add(subscriber);
                }
            } catch (InvalidKeyException | NoSuchAlgorithmException
                | InvalidAlgorithmParameterException | IllegalStateException
                | InvalidKeySpecException | NoSuchPaddingException | IllegalBlockSizeException
                | BadPaddingException e) {
                System.out.println("send encrypted message error");
                System.out.println(e);
            }
        }

        failedSubscribers.forEach(subscriberList::remove);
    }

    /**
    * @return true if the subscription is no longer valid and can be removed, false if
    * everything is okay
     * @throws UnsupportedEncodingException 
    */
    private boolean sendPushMessage(Subscription subscription, byte[] body) 
    		throws UnsupportedEncodingException {
        String origin = "https://fcm.googleapis.com";

        Date today = new Date();
        Date expires = new Date(today.getTime() + 12 * 60 * 60 * 1000);

        String token = JWT.create().withAudience(origin).withExpiresAt(expires)
            .withSubject("mailto:example@example.com").sign(this.jwtAlgorithm);

        URI endpointURI = URI.create(subscription.getEndpoint());

        HttpPost post = new HttpPost(endpointURI);
        
        if(body != null) {
        	post.setHeader("Content-Type", "application/octet-stream");
        	post.addHeader("Content-Encoding", "aes128gcm");
        	post.setEntity(new ByteArrayEntity(body));
        } else {
        	post.setEntity(new StringEntity(""));
        	post.setHeader("Content-Length", "0");
        }
        
        post.addHeader("TTL", "180");
        post.addHeader("Authorization", "vapid t=" + token + ", k=" + this.serverKeys.getPublicKeyBase64());

        System.out.println("before try statement in sendPushMessage func");
        try(CloseableHttpClient httpClient = HttpClients.createDefault()) {
        	System.out.println("before executing post request");
        	CloseableHttpResponse response = httpClient.execute(post);
        	System.out.println("after executing post request");
        	
        	switch (response.getStatusLine().getStatusCode()) {
	            case 201:
	                System.out.println("Push message successfully sent: ");
	                System.out.println(subscription.getEndpoint());
	                break;
	            case 404:
	            case 410:
	                System.out.println("Subscription not found or gone: ");
	                System.out.println(subscription.getEndpoint());
	                // remove subscription from our collection of subscriptions
	                return true;
	            case 429:
	                System.out.println("Too many requests");
	                break;
	            case 400:
	                System.out.println("Invalid request");
	                break;
	            case 413:
	                System.out.println("Payload size too large");
	                break;
	            default:
	                System.out.println("Unhandled status code");
        	}
        } catch(Exception e) {
        	System.out.println(e);
        }

        return false;
    }
}