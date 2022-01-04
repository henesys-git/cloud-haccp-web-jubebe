package mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashSet;
import java.util.Set;

import mes.frame.database.JDBCConnectionPool;
import mes.webpush.dto.Subscription;

public class SubscriptionDaoImpl implements SubscriptionDao {
	
	@Override
	public Set getAllSubscriptions() {
		Connection con = JDBCConnectionPool.getConnection();
		
		try {
			Statement stmt = con.createStatement();
			String sql = "SELECT * FROM pushnotification_subscription";
			ResultSet rs = stmt.executeQuery(sql);
			
			Set<Subscription> subscriberList = new HashSet<Subscription>();
			
			if(rs.next()) {
				Subscription subscriber = extractSubscriberFromResultSet(rs);
				subscriberList.add(subscriber);
			}
			
			return subscriberList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	}
	
	@Override
	public boolean insertSubscription(Subscription subscriber) {
		Connection con = JDBCConnectionPool.getConnection();

	    try {
	        PreparedStatement ps = con.prepareStatement(
	        		"INSERT INTO pushnotification_subscription VALUES (?, ?, ?)");
	        ps.setString(1, subscriber.getEndpoint());
	        ps.setString(2, subscriber.getP256dh());
	        ps.setString(3, subscriber.getAuth());
	        int i = ps.executeUpdate();

	      if(i == 1) {
	        return true;
	      }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean deleteSubscription(String endpoint) {
		Connection con = JDBCConnectionPool.getConnection();
		
		System.out.println("delete sql:");
		System.out.println(endpoint);
		
	    try {
	        Statement stmt = con.createStatement();
	        String sql = "DELETE FROM pushnotification_subscription " +
	        			 "WHERE endpoint ='" + endpoint + "'";
		        	
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	private Subscription extractSubscriberFromResultSet(ResultSet rs) throws SQLException {
	    Subscription subscriber = new Subscription();

	    subscriber.setEndpoint( rs.getString("endpoint") );
	    subscriber.setP256dh( rs.getString("p256dh") );
	    subscriber.setAuth( rs.getString("auth") );

	    return subscriber;
	}
	
}
