import 'package:aceup/pages/challenges/challenge-questions.dart';
import 'package:aceup/pages/json-classes/challenge.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/util/avatar.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:flutter/material.dart';

class StartChallenge extends StatefulWidget {
  final Challenge challenge;
  StartChallenge({this.challenge});

  @override
  _StartChallengeState createState() => _StartChallengeState();
}

class _StartChallengeState extends State<StartChallenge> {
  Challenge _challenge;
  bool userCompletedChallenge;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;
    _loading = false;
    userCompletedChallenge =
        _challenge.scores.complete ? true : checkUserChallengeCompletion();
    if (userCompletedChallenge) {
      submitAndMarkChallenge();
    }
  }


  bool checkUserChallengeCompletion() {
    bool complete = true;

    _challenge.questions.forEach((question) => _challenge.userIsChallenger
        ? question.challengerAttempt != null
            ? complete = true
            : complete = false
        : question.opponentAttempt != null
            ? complete = true
            : complete = false);

    return complete;
  }

  bool userWon() {
    return _challenge.userIsChallenger ? _challenge.scores.challenger > _challenge.scores.opponent : _challenge.scores.challenger < _challenge.scores.opponent;
  }
  // If user completed challenge, check if opponent score has also been gotten and if challenge has been marked complete from BE, if not submit and get Score.
  void submitAndMarkChallenge() async {
    Challenge challenge;
    if (!_challenge.scores.complete) {
      setState(() {
        _loading = true;
      });
      challenge = await _challenge.submit();
    }

    setState(() {
      _challenge = challenge != null ? challenge : _challenge;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageHolder(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: _loading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Avatars.avatarFromId(_challenge.challenger.avatarId,
                                username: _challenge.challenger.username),
                            Text(
                              _challenge.challenger.username,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        Text(
                          _challenge.scores.challenger.toString(),
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "VS",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          _challenge.scores.opponent.toString(),
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Column(
                          children: <Widget>[
                            Avatars.avatarFromId(_challenge.opponent.avatarId,
                                username: _challenge.opponent.username),
                            Text(
                              _challenge.opponent.username,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Wrap(
                      children: <Widget>[
                        Text(
                          _challenge.scores.complete ? _challenge.scores.challenger == _challenge.scores.opponent ? "Draw! " : userWon() ? "You win! " : (_challenge.userIsChallenger ? _challenge.opponent.username : _challenge.challenger.username) + " Wins " : "Winner Gets ",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          (_challenge.scores.complete && _challenge.scores.challenger == _challenge.scores.opponent) ? "" : (_challenge.scores.complete && !userWon() ? "- " : "+ ") + (_challenge.scores.complete && !userWon() ? (_challenge.scores.stakePoints / 2).round().toString() : _challenge.scores.stakePoints.toString()) + " Points",
                          style: TextStyle(
                              color: _challenge.scores.complete && !userWon() ? Colors.red : Theme.of(context).primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: BlockButton(
                            child: !checkUserChallengeCompletion() ? Text("Start Challenge") : _challenge.scores.complete ? Text("View Details") : Text("Waiting for Opponent", style: TextStyle(color: Colors.white70),),
                            color: Theme.of(context).primaryColor,
                            onPressed: checkUserChallengeCompletion() && !_challenge.scores.complete ? null : () {
                              Navigator.of(context).push(
                                new MaterialPageRoute(builder: (context) {
                                  return ChallengeWidget(
                                    challenge: _challenge,
                                    completeCallback: () async {
                                      await submitAndMarkChallenge();
                                      }
                                  );
                                }),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
