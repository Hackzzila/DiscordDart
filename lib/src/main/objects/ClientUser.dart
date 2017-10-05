part of discord;

/// The client user.
class ClientUser extends User {
  /// The client user's email, null if the client user is a bot.
  String email;

  /// Weather or not the client user's account is verified.
  bool verified;

  /// Weather or not the client user has MFA enabled.
  bool mfa;

  ClientUser._new(Client client, Map<String, dynamic> data)
      : super._new(client, data) {
    this.email = raw['email'];
    this.verified = raw['verified'];
    this.mfa = raw['mfa_enabled'];
  }
}
