part of discord;

/// Sent when a channel is updated.
class ChannelUpdateEvent {
  /// The channel prior to the update.
  GuildChannel oldChannel;

  /// The channel after the update.
  GuildChannel newChannel;

  ChannelUpdateEvent._new(Client client, Map<String, dynamic> json) {
    if (client.ready) {
      final Guild guild = client.guilds[json['d']['guild_id']];
      this.oldChannel = client.channels[json['d']['id']];
      if (json['d']['type'] == 0) {
        this.newChannel = new TextChannel._new(
            client, json['d'] as Map<String, dynamic>, guild);
      } else {
        this.newChannel = new VoiceChannel._new(
            client, json['d'] as Map<String, dynamic>, guild);
      }
      client._events.onChannelUpdate.add(this);
    }
  }
}
