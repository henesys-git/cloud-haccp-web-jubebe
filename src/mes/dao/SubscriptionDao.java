package mes.dao;

import java.util.Set;

import mes.webpush.dto.Subscription;

public interface SubscriptionDao {
	Set<Subscription> getAllSubscriptions();
	boolean insertSubscription(Subscription subscriber);
	boolean deleteSubscription(String endpoint);
}