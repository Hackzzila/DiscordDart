part of discord;

/// The client's OAuth2 app, if the client is a bot.
class ClientOAuth2Application extends OAuth2Application {
  /// The app's flags.
  int flags;

  /// The app's owner.
  User owner;

  ClientOAuth2Application._new(Client client, Map<String, dynamic> data)
      : super._new(client, data) {
    this.flags = raw['flags'];
    this.owner = new User._new(client, raw['owner'] as Map<String, dynamic>);
  }

  /// Creates an OAuth2 URL with the specified permissions.
  String makeOAuth2Url([int permissions = 0]) {
    return "https://discordapp.com/oauth2/authorize?client_id=$id&scope=bot&permissions=$permissions";
  }
}
