import 'dart:async';
import 'dart:convert';
import '../../discord.dart';
import 'package:http/http.dart' as http;

/// A guild.
class Guild {
  /// The client.
  Client client;

  /// A map of all of the properties.
  Map<String, dynamic> map = <String, dynamic>{};

  /// The guild's name.
  String name;

  /// The guild's ID.
  String id;

  /// The guild's icon hash.
  String icon;

  /// The guild's icon URL.
  String iconURL;

  /// The guild's afk channel ID, null if not set.
  String afkChannelID;

  /// The guild's voice region.
  String region;

  /// The channel ID for the guild's widget if enabled.
  String embedChannelID;

  /// The guild's default channel.
  GuildChannel defaultChannel;

  /// The guild's AFK timeout.
  int afkTimeout;

  /// The guild's member count.
  int memberCount;

  /// The guild's verification level.
  int verificationLevel;

  /// The guild's notification level.
  int notificationLevel;

  /// The guild's MFA level.
  int mfaLevel;

  /// A timestamp for when the guild was created.
  DateTime createdAt;

  /// If the guild's widget is enabled.
  bool embedEnabled;

  /// Whether or not the guild is available.
  bool available = true;

  /// The guild owner's ID
  String ownerID;

  /// The guild's members.
  Collection members;

  /// The guild's channels.
  Collection channels;

  /// Constructs a new [Guild].
  Guild(this.client, Map<String, dynamic> data,
      [this.available, bool guildCreate = false]) {
    if (this.available) {
      this.name = this.map['name'] = data['name'];
      this.id = this.map['id'] = data['id'];
      this.icon = this.map['icon'] = data['icon'];
      this.iconURL = this.map['iconURL'] =
          "https://discordapp.com/api/v6/guilds/${this.id}/icons/${this.icon}.jpg";
      this.afkChannelID = this.map['afkChannelID'] = data['afk_channel_id'];
      this.region = this.map['region'] = data['region'];
      this.embedChannelID =
          this.map['embedChannelID'] = data['embed_channel_id'];
      this.afkTimeout = this.map['afkTimeout'] = data['afk_timeout'];
      this.memberCount = this.map['memberCount'] = data['member_count'];
      this.verificationLevel =
          this.map['verificationLevel'] = data['verification_level'];
      this.notificationLevel =
          this.map['notificationLevel'] = data['default_message_notifications'];
      this.mfaLevel = this.map['mfaLevel'] = data['mfa_level'];
      this.embedEnabled = this.map['embedEnabled'] = data['embed_enabled'];
      this.ownerID = this.map['ownerID'] = data['owner_id'];
      this.createdAt = this.map['createdAt'] = getDate(this.id);

      if (guildCreate) {
        this.members = new Collection();
        this.channels = new Collection();

        //this.roles = JSON.decode(data['roles']);
        data['members'].forEach((Map<String, dynamic> o) {
          this.members.add(new Member(client, o, this));
        });
        this.map['members'] = this.members;

        data['channels'].forEach((Map<String, dynamic> o) {
          this.channels.add(new GuildChannel(client, o, this));
        });
        this.map['channels'] = this.channels;

        this.defaultChannel = this.channels.get(this.id);
        this.map['defaultChannel'] = this.defaultChannel;
      }
    }
  }

  /// Returns a string representation of this object.
  @override
  String toString() {
    return this.name;
  }

  /// Gets a [Member] object. Adds it to `Client.guilds["guild id"].members` if
  /// not already there.
  ///
  /// Throws an [Exception] if the HTTP request errored.
  ///     Guild.getMember("user id");
  Future<Member> getMember(dynamic member) async {
    if (this.client.ready) {
      final String id = this.client.resolve('member', member);

      if (this.members.get(member) != null) {
        return this.members.get(member);
      } else {
        final http.Response r =
            await this.client.http.get('guilds/${this.id}/members/$id');
        final Map<String, dynamic> res = JSON.decode(r.body);

        if (r.statusCode == 200) {
          final Member m = new Member(client, res, this);
          this.members.add(m);
          this.map['members'] = this.members;
          return m;
        } else {
          throw new Exception("${res['code']}:${res['message']}");
        }
      }
    } else {
      throw new Exception("the client isn't ready");
    }
  }

  /// Invites a bot to a guild. Only usable by user accounts.
  ///
  /// Throws an [Exception] if the HTTP request errored or if the client user
  /// is a bot.
  ///     Guild.oauth2Authorize("app id");
  Future<bool> oauth2Authorize(dynamic app, [int permissions = 0]) async {
    if (this.client.ready) {
      if (!this.client.user.bot) {
        final String id = this.client.resolve('app', app);

        final http.Response r = await this.client.http.post(
            'oauth2/authorize?client_id=$id&scope=bot', <String, dynamic>{
          "guild_id": this.id,
          "permissions": permissions,
          "authorize": true
        });
        final Map<String, dynamic> res = JSON.decode(r.body);

        if (r.statusCode == 200) {
          return true;
        } else {
          throw new Exception("${res['code']}:${res['message']}");
        }
      } else {
        throw new Exception(
            "'oauth2Authorize' is only usable by user accounts.");
      }
    } else {
      throw new Exception("the client isn't ready");
    }
  }
}
