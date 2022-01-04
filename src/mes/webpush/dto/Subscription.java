package mes.webpush.dto;

//import com.fasterxml.jackson.annotation.JsonCreator;
//import com.fasterxml.jackson.annotation.JsonProperty;

public class Subscription {
    private String endpoint;
    private String p256dh;
    private String auth;
    
    public Subscription() {
    	
    }
    
    public Subscription(String endpoint, String p256dh, String auth) {
	    this.endpoint = endpoint;
	    this.p256dh = p256dh;
	    this.auth = auth;
    }
    
    public String getEndpoint() {
        return this.endpoint;
    }

    public String getP256dh() {
        return this.p256dh;
    }

    public String getAuth() {
    	return this.auth;
    }
    
    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }

    public void setP256dh(String p256dh) {
        this.p256dh = p256dh;
    }

    public void setAuth(String auth) {
    	this.auth = auth;
    }
    
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + (this.endpoint == null ? 0 : this.endpoint.hashCode());
        result = prime * result + (this.p256dh == null ? 0 : this.p256dh.hashCode());
        result = prime * result + (this.auth == null ? 0 : this.auth.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        
        if (obj == null) {
            return false;
        }
        
        if (getClass() != obj.getClass()) {
            return false;
        }
        
        Subscription other = (Subscription) obj;
        
        if (this.endpoint == null) {
            if (other.endpoint != null) {
                return false;
            }
        } else if (!this.endpoint.equals(other.endpoint)) {
            return false;
        }
        
        if (this.p256dh == null) {
            if (other.p256dh != null) {
                return false;
            }
        } else if (!this.p256dh.equals(other.p256dh)) {
            return false;
        }
        
        if (this.auth == null) {
            if (other.auth != null) {
                return false;
            }
        } else if (!this.auth.equals(other.auth)) {
            return false;
        }
        
        return true;
    }

    @Override
    public String toString() {
        return "Subscription [endpoint=" + this.endpoint +
        				   ", p256dh=" + this.p256dh +
        				   ", auth=" + this.auth + "]";
    }
}