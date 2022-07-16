import 'chess_coord.dart';

enum CastleSide {
  whiteKingSide,
  whiteQueenSide,
  blackKingSide,
  blackQueenSide,
}

extension Ext on CastleSide {
  ChessCoord get kingCoord {
    return _cs2king[this]!;
  }

  ChessCoord get rookCoord {
    return _cs2rook[this]!;
  }

  ChessCoord get rookAfterCastlingCoord {
    return _cs2rookAfterCastling[this]!;
  }
}

CastleSide stringToCastleSide(String castleSide) {
  final cs = _str2cs[castleSide];
  if (cs != null) return cs;
  throw ArgumentError("Invalid castle side: $castleSide");
}

String castleSideToString(CastleSide castleSide) {
  final cs = _cs2str[castleSide];
  if (cs != null) return cs;
  throw ArgumentError("Invalid castle side: $castleSide");
}

Map<String, CastleSide> _str2cs = {
  "K": CastleSide.whiteKingSide,
  "Q": CastleSide.whiteQueenSide,
  "k": CastleSide.blackKingSide,
  "q": CastleSide.blackQueenSide,
};

Map<CastleSide, String> _cs2str = {
  CastleSide.whiteKingSide: "K",
  CastleSide.whiteQueenSide: "Q",
  CastleSide.blackKingSide: "k",
  CastleSide.blackQueenSide: "q",
};

Map<CastleSide, ChessCoord> _cs2king = {
  CastleSide.whiteKingSide: const ChessCoord(row: 7, column: 6),
  CastleSide.whiteQueenSide: const ChessCoord(row: 7, column: 2),
  CastleSide.blackKingSide: const ChessCoord(row: 0, column: 6),
  CastleSide.blackQueenSide: const ChessCoord(row: 0, column: 2),
};

Map<CastleSide, ChessCoord> _cs2rook = {
  CastleSide.whiteKingSide: const ChessCoord(row: 7, column: 7),
  CastleSide.whiteQueenSide: const ChessCoord(row: 7, column: 0),
  CastleSide.blackKingSide: const ChessCoord(row: 0, column: 7),
  CastleSide.blackQueenSide: const ChessCoord(row: 0, column: 0),
};

Map<CastleSide, ChessCoord> _cs2rookAfterCastling = {
  CastleSide.whiteKingSide: const ChessCoord(row: 7, column: 5),
  CastleSide.whiteQueenSide: const ChessCoord(row: 7, column: 3),
  CastleSide.blackKingSide: const ChessCoord(row: 0, column: 5),
  CastleSide.blackQueenSide: const ChessCoord(row: 0, column: 3),
};
