library chess_board;

import 'dart:async';

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

typedef Null MoveCallback(String moveNotation);
typedef Null CheckMateCallback(String winColor);

class ChessBoard extends StatefulWidget {
  // Defines the length and width of the chess board.
  final size;

  // Defines the callback on move.
  final MoveCallback onMove;

  // Defines the callback on checkmate.
  final CheckMateCallback onCheckMate;

  // Defines the callback on draw.
  final VoidCallback onDraw;

  ChessBoard(
      {this.size = 200.0,
      @required this.onMove,
      @required this.onCheckMate,
      @required this.onDraw});

  @override
  _ChessBoardState createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  chess.Chess game = chess.Chess();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      child: Stack(
        // The base chessboard image
        children: <Widget>[
          Container(
            height: widget.size,
            width: widget.size,
            child: Image.asset("images/chess_board.png"),
          ),

          //Overlaying draggables/ dragTargets onto the squares
          Center(
            child: Container(
              height: widget.size * 0.89,
              width: widget.size * 0.89,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ChessBoardRank(
                    children: [
                      "a8",
                      "b8",
                      "c8",
                      "d8",
                      "e8",
                      "f8",
                      "g8",
                      "h8",
                    ],
                    game: game,
                    size: widget.size,
                    onMove: widget.onMove,
                    refreshBoard: refreshBoard,
                  ),
                  ChessBoardRank(
                    children: [
                      "a7",
                      "b7",
                      "c7",
                      "d7",
                      "e7",
                      "f7",
                      "g7",
                      "h7",
                    ],
                    game: game,
                    size: widget.size,
                    onMove: widget.onMove,
                    refreshBoard: refreshBoard,
                  ),
                  ChessBoardRank(
                    children: [
                      "a6",
                      "b6",
                      "c6",
                      "d6",
                      "e6",
                      "f6",
                      "g6",
                      "h6",
                    ],
                    game: game,
                    size: widget.size,
                    onMove: widget.onMove,
                    refreshBoard: refreshBoard,
                  ),
                  ChessBoardRank(
                    children: [
                      "a5",
                      "b5",
                      "c5",
                      "d5",
                      "e5",
                      "f5",
                      "g5",
                      "h5",
                    ],
                    game: game,
                    size: widget.size,
                    onMove: widget.onMove,
                    refreshBoard: refreshBoard,
                  ),
                  ChessBoardRank(
                    children: [
                      "a4",
                      "b4",
                      "c4",
                      "d4",
                      "e4",
                      "f4",
                      "g4",
                      "h4",
                    ],
                    game: game,
                    size: widget.size,
                    onMove: widget.onMove,
                    refreshBoard: refreshBoard,
                  ),
                  ChessBoardRank(
                    children: [
                      "a3",
                      "b3",
                      "c3",
                      "d3",
                      "e3",
                      "f3",
                      "g3",
                      "h3",
                    ],
                    game: game,
                    size: widget.size,
                    onMove: widget.onMove,
                    refreshBoard: refreshBoard,
                  ),
                  ChessBoardRank(
                    children: [
                      "a2",
                      "b2",
                      "c2",
                      "d2",
                      "e2",
                      "f2",
                      "g2",
                      "h2",
                    ],
                    game: game,
                    size: widget.size,
                    onMove: widget.onMove,
                    refreshBoard: refreshBoard,
                  ),
                  ChessBoardRank(
                    children: [
                      "a1",
                      "b1",
                      "c1",
                      "d1",
                      "e1",
                      "f1",
                      "g1",
                      "h1",
                    ],
                    game: game,
                    size: widget.size,
                    onMove: widget.onMove,
                    refreshBoard: refreshBoard,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void refreshBoard() {
    setState(() {});
    if (game.in_checkmate) {
      widget.onCheckMate(game.turn == chess.Color.WHITE ? "Black" : "White");
    } else if (game.in_draw || game.in_stalemate) {
      widget.onDraw();
    }
  }
}

// A "Rank" is a Row on the chessboard.
class ChessBoardRank extends StatelessWidget {
  // Children are the squares in the row.
  final List<String> children;
  final chess.Chess game;
  final double size;
  final MoveCallback onMove;
  final Function refreshBoard;

  ChessBoardRank(
      {this.children = const [],
      @required this.game,
      this.size,
      this.onMove,
      this.refreshBoard});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        children: children
            .map((squareName) =>
                BoardSquare(squareName, game, size, onMove, refreshBoard))
            .toList(),
      ),
    );
  }
}

// A single square on the chessboard.
// This is a dragTarget with an optional piece displayed.
class BoardSquare extends StatefulWidget {
  final String squareName;
  final chess.Chess game;
  final double size;
  final MoveCallback onMove;
  final Function refreshBoard;

  BoardSquare(
      this.squareName, this.game, this.size, this.onMove, this.refreshBoard);

  @override
  _BoardSquareState createState() => _BoardSquareState();
}

class _BoardSquareState extends State<BoardSquare> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: DragTarget(builder: (context, accepted, rejected) {
        return widget.game.get(widget.squareName) != null
            ? Draggable(
                child: _getImageToDisplay(size: 45.0 * (widget.size / 400.0)),
                feedback:
                    _getImageToDisplay(size: 55.0 * (widget.size / 400.0)),
                onDragCompleted: () {},
                data: [
                  widget.squareName,
                  widget.game.get(widget.squareName).type.toUpperCase(),
                  widget.game.get(widget.squareName).color,
                ],
              )
            : Container();
      }, onWillAccept: (willAccept) {
        return true;
      }, onAccept: (List moveInfo) {
        if (moveInfo[1] == "P" &&
            ((moveInfo[0][1] == "7" &&
                    widget.squareName[1] == "8" &&
                    moveInfo[2] == chess.Color.WHITE) ||
                (moveInfo[0][1] == "2" &&
                    widget.squareName[1] == "1" &&
                    moveInfo[2] == chess.Color.BLACK))) {
          _promotionDialog().then((value) {
            widget.game.move({
              "from": moveInfo[0],
              "to": widget.squareName,
              "promotion": value
            });
            widget.refreshBoard();
          });
        } else {
          widget.game.move({"from": moveInfo[0], "to": widget.squareName});
        }
        widget.onMove(moveInfo[1] == "P"
            ? widget.squareName
            : moveInfo[1] + widget.squareName);
        widget.refreshBoard();
      }),
    );
  }

  Widget _getImageToDisplay({double size}) {
    Widget imageToDisplay = Container();

    if (widget.game.get(widget.squareName) == null) {
      return Container();
    }

    String piece = widget.game
            .get(widget.squareName)
            .color
            .toString()
            .substring(0, 1)
            .toUpperCase() +
        widget.game.get(widget.squareName).type.toUpperCase();

    switch (piece) {
      case "WP":
        imageToDisplay = WhitePawn(size: size);
        break;
      case "WR":
        imageToDisplay = WhiteRook(size: size);
        break;
      case "WN":
        imageToDisplay = WhiteKnight(size: size);
        break;
      case "WB":
        imageToDisplay = WhiteBishop(size: size);
        break;
      case "WQ":
        imageToDisplay = WhiteQueen(size: size);
        break;
      case "WK":
        imageToDisplay = WhiteKing(size: size);
        break;
      case "BP":
        imageToDisplay = BlackPawn(size: size);
        break;
      case "BR":
        imageToDisplay = BlackRook(size: size);
        break;
      case "BN":
        imageToDisplay = BlackKnight(size: size);
        break;
      case "BB":
        imageToDisplay = BlackBishop(size: size);
        break;
      case "BQ":
        imageToDisplay = BlackQueen(size: size);
        break;
      case "BK":
        imageToDisplay = BlackKing(size: size);
        break;
      default:
        imageToDisplay = WhitePawn(size: size);
    }

    return imageToDisplay;
  }

  Future<String> _promotionDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
            title: new Text('Choose promotion'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  child: WhiteQueen(),
                  onTap: () {
                    Navigator.of(context).pop("q");
                  },
                ),
                InkWell(
                  child: WhiteRook(),
                  onTap: () {
                    Navigator.of(context).pop("r");
                  },
                ),
                InkWell(
                  child: WhiteBishop(),
                  onTap: () {
                    Navigator.of(context).pop("b");
                  },
                ),
                InkWell(
                  child: WhiteKnight(),
                  onTap: () {
                    Navigator.of(context).pop("n");
                  },
                ),
              ],
            ));
      },
    ).then((value) {
      return value;
    });
  }
}
