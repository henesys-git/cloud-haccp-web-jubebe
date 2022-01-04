self.addEventListener('activate', event => event.waitUntil(clients.claim()));

self.addEventListener('push', event => event.waitUntil(handlePushEvent(event)));

self.addEventListener('notificationclick', event => event.waitUntil(handleNotificationClick(event)));

self.addEventListener('notificationclose', event => console.info('notificationclose event fired'));

async function handlePushEvent(event) {
  console.info('push event emitted');

  const needToShow = await needToShowNotification();
  const dataCache = await caches.open('data');
  
  console.info("need to show push notification? " + needToShow);
	
  if (!event.data) {
    console.info('number fact received');

    if (needToShow) {
      self.registration.showNotification('Numbers API', {
        body: 'A new fact has arrived',
        tag: 'numberfact',
        icon: 'numbers.png'
      });
    }

    const response = await fetch('lastNumbersAPIFact');
    const fact = await response.text();

    await dataCache.put('fact', new Response(fact));
  } else {
    const msg = event.data.json();

    if (needToShow) {
      self.registration.showNotification(msg.title, {
        body: msg.body,
        icon: 'chuck.png'
      });
    }

    await dataCache.put('joke', new Response(msg.body));
  }

  const allClients = await clients.matchAll({ includeUncontrolled: true });
  for (const client of allClients) {
    client.postMessage('data-updated');
  }
}

const urlToOpen1 = new URL('/index.html', self.location.origin).href;
const urlToOpen2 = new URL('/', self.location.origin).href;

async function handleNotificationClick(event) {

  let openClient = null;
  const allClients = await clients.matchAll({ includeUncontrolled: true, type: 'window' });
  for (const client of allClients) {
    if (client.url === urlToOpen1 || client.url === urlToOpen2) {
      openClient = client;
      break;
    }
  }

  if (openClient) {
    await openClient.focus();
  } else {
    await clients.openWindow(urlToOpen1);
  }

  event.notification.close();
}

async function needToShowNotification() {
  console.info("checking if need to show notification");
  const allClients = await clients.matchAll({ includeUncontrolled: true });
  console.info("any clients?");
  console.info(allClients);

  for (const client of allClients) {
    if (client.visibilityState === 'visible') {
      return false;
    }
  }
  return true;
}
