import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:reply/settings_bottom_sheet.dart';

import 'email_model.dart';

const _avatarsLocation = 'reply/avatars';

class EmailStore with ChangeNotifier {
  final _categories = <String, Set<Email>>{
    'Inbox': _mainInbox,
    'Starred': _starredInbox,
    'Sent': _outbox,
    'Trash': _trash,
    'Spam': _spam,
    'Drafts': _drafts,
  };

  static final _mainInbox = <Email>{
    const Email(
      sender: 'Tokyo, Japan',
      subject: 'The Ritz-Carlton, Tokyo ',
      message: 'Located in the heart of Tokyo, Japan, this luxury hotel offers stunning views of the city and impeccable service.',

      containsPictures: true,
    ),
    const Email(
      sender: 'New York City, USA',
      subject: 'The Plaza Hotel ',
      message:
          'I\'ll be in your neighborhood doing errands and was hoping to catch you for a coffee this Saturday. If you don\'t have anything scheduled, it would be great to see you! It feels like its been forever.\n\n'
          'If we do get a chance to get together, remind me to tell you about Kim. She stopped over at the house to say hey to the kids and told me all about her trip to Mexico.\n\n'
          'Talk to you soon,\n\n'
          'Ali',
      containsPictures: true,
    ),
    const Email(
      sender: 'Bangkok, Thailand',
      subject: 'Mandarin Oriental, Bangkok',
      message: 'Here are some great shots from my trip...',
      containsPictures: true,
    ),
    const Email(
      sender: 'Rome, Italy',
      subject: 'Hotel de Russie ',
      message:
          'Thought we might be able to go over some details about our upcoming vacation.\n\n'
          'I\'ve been doing a bit of research and have come across a few paces in Northern Brazil that I think we should check out. '
          'One, the north has some of the most predictable wind on the planet. '
          'I\'d love to get out on the ocean and kitesurf for a couple of days if we\'re going to be anywhere near or around Taiba. '
          'I hear it\'s beautiful there and if you\'re up for it, I\'d love to go. Other than that, I haven\'t spent too much time looking into places along our road trip route. '
          'I\'m assuming we can find places to stay and things to do as we drive and find places we think look interesting. But... I know you\'re more of a planner, so if you have ideas or places in mind, lets jot some ideas down!\n\n'
          'Maybe we can jump on the phone later today if you have a second.',
      containsPictures: true,
    ),
    const Email(
      sender: 'Sydney, Australia',
      subject: 'The Langham, Sydney',
      message: '',
      containsPictures: true,
    ),
    const Email(
      sender: 'Dubai',
      subject: 'The Ritz-Carlton, Dubai',
      message: 'Your shoes should be waiting for you at home!',
      containsPictures: true,
    ),
  };

  static final _starredInbox = <Email>{};

  static final _outbox = <Email>{
    const Email(
      sender: 'Kim Alen',
      subject: 'High school reunion?',
      message:
          'Hi friends,\n\nI was at the grocery store on Sunday night.. when I ran into Genie Williams! I almost didn\'t recognize her afer 20 years!\n\n'
          'Anyway, it turns out she is on the organizing committee for the high school reunion this fall. I don\'t know if you were planning on going or not, but she could definitely use our help in trying to track down lots of missing alums. '
          'If you can make it, we\'re doing a little phone-tree party at her place next Saturday, hoping that if we can find one person, thee more will...',
      containsPictures: false,
    ),
    const Email(
      sender: 'Sandra Adams',

      subject: 'Recipe to try',
      message:
          'Raspberry Pie: We should make this pie recipe tonight! The filling is '
          'very quick to put together.',
      containsPictures: false,
    ),
  };

  static final _trash = <Email>{
    const Email(
      sender: 'Frank Hawkins',
      subject: 'Your update on the Google Play Store is live!',
      message:
          'Your update is now live on the Play Store and available for your alpha users to start testing.\n\n'
          'Your alpha testers will be automatically notified. If you\'d rather send them a link directly, go to your Google Play Console and follow the instructions for obtaining an open alpha testing link.',
      containsPictures: false,
    ),
    const Email(
      sender: 'Allison Trabucco',
      subject: 'Try a free TrailGo account',
      message:
          'Looking for the best hiking trails in your area? TrailGo gets you on the path to the outdoors faster than you can pack a sandwich.\n\n'
          'Whether you\'re an experienced hiker or just looking to get outside for the afternoon, there\'s a segment that suits you.',
      containsPictures: false,
    ),
  };

  static final _spam = <Email>{
    const Email(
      sender: 'Allison Trabucco',
      subject: 'Free money',
      message:
          'You\'ve been selected as a winner in our latest raffle! To claim your prize, click on the link.',
      containsPictures: false,
    ),
  };

  static final _drafts = <Email>{
    const Email(
      sender: 'Sandra Adams',
      subject: '(No subject)',
      message: 'Hey,\n\n'
          'Wanted to email and see what you thought of',
      containsPictures: false,
    ),
  };

  int _currentlySelectedEmailId = -1;
  String _currentlySelectedInbox = 'Inbox';
  bool _onCompose = false;
  bool _bottomDrawerVisible = false;
  ThemeMode _currentTheme = ThemeMode.system;
  SlowMotionSpeedSetting _currentSlowMotionSpeed =
      SlowMotionSpeedSetting.normal;

  Map<String, Set<Email>> get emails =>
      Map<String, Set<Email>>.unmodifiable(_categories);

  void deleteEmail(String category, int id) {
    final email = _categories[category]!.elementAt(id);

    _categories.forEach(
      (key, value) {
        if (value.contains(email)) {
          value.remove(email);
        }
      },
    );

    notifyListeners();
  }

  void starEmail(String category, int id) {
    final email = _categories[category]!.elementAt(id);
    var alreadyStarred = isEmailStarred(email);

    if (alreadyStarred) {
      _categories['Starred']!.remove(email);
    } else {
      _categories['Starred']!.add(email);
    }

    notifyListeners();
  }

  bool get bottomDrawerVisible => _bottomDrawerVisible;
  int get currentlySelectedEmailId => _currentlySelectedEmailId;
  String get currentlySelectedInbox => _currentlySelectedInbox;
  bool get onMailView => _currentlySelectedEmailId > -1;
  bool get onCompose => _onCompose;
  ThemeMode get themeMode => _currentTheme;
  SlowMotionSpeedSetting get slowMotionSpeed => _currentSlowMotionSpeed;

  bool isEmailStarred(Email email) {
    return _categories['Starred']!.contains(email);
  }

  set bottomDrawerVisible(bool value) {
    _bottomDrawerVisible = value;
    notifyListeners();
  }

  set currentlySelectedEmailId(int value) {
    _currentlySelectedEmailId = value;
    notifyListeners();
  }

  set currentlySelectedInbox(String inbox) {
    _currentlySelectedInbox = inbox;
    notifyListeners();
  }

  set themeMode(ThemeMode theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  set slowMotionSpeed(SlowMotionSpeedSetting speed) {
    _currentSlowMotionSpeed = speed;
    timeDilation = slowMotionSpeed.value;
  }

  set onCompose(bool value) {
    _onCompose = value;
    notifyListeners();
  }
}
