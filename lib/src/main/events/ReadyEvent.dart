part of discord;

/// Sent when the client is ready.
class ReadyEvent {
  ReadyEvent._new(Client client) {
    client.ready = true;
    client._events.onReady.add(this);
  }
}
