part of discord;

/// Sent when the client is ratelimited, either by the ratelimit handler itself,
/// or when a 429 is received.
class RatelimitEvent {
  /// true if ratelimit handler stopped the request preventatively
  ///
  /// false if the client received a 429
  bool handled;

  /// The request that was ratelimited.
  HttpRequest request;

  /// The response received if the ratelimit handler did not stop
  /// the request (rare)
  HttpResponse response;

  RatelimitEvent._new(Client client, this.request, this.handled,
      [this.response]) {
    client._events.onRatelimited.add(this);
  }
}
