// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page1_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Page1Store on _Page1StoreBase, Store {
  late final _$barChartTitleAtom =
      Atom(name: '_Page1StoreBase.barChartTitle', context: context);

  @override
  String get barChartTitle {
    _$barChartTitleAtom.reportRead();
    return super.barChartTitle;
  }

  @override
  set barChartTitle(String value) {
    _$barChartTitleAtom.reportWrite(value, super.barChartTitle, () {
      super.barChartTitle = value;
    });
  }

  late final _$pieChartTitleAtom =
      Atom(name: '_Page1StoreBase.pieChartTitle', context: context);

  @override
  String get pieChartTitle {
    _$pieChartTitleAtom.reportRead();
    return super.pieChartTitle;
  }

  @override
  set pieChartTitle(String value) {
    _$pieChartTitleAtom.reportWrite(value, super.pieChartTitle, () {
      super.pieChartTitle = value;
    });
  }

  late final _$dailySummaryAtom =
      Atom(name: '_Page1StoreBase.dailySummary', context: context);

  @override
  String get dailySummary {
    _$dailySummaryAtom.reportRead();
    return super.dailySummary;
  }

  @override
  set dailySummary(String value) {
    _$dailySummaryAtom.reportWrite(value, super.dailySummary, () {
      super.dailySummary = value;
    });
  }

  late final _$_Page1StoreBaseActionController =
      ActionController(name: '_Page1StoreBase', context: context);

  @override
  void updateBarChartTitle(String newTitle) {
    final _$actionInfo = _$_Page1StoreBaseActionController.startAction(
        name: '_Page1StoreBase.updateBarChartTitle');
    try {
      return super.updateBarChartTitle(newTitle);
    } finally {
      _$_Page1StoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePieChartTitle(String newTitle) {
    final _$actionInfo = _$_Page1StoreBaseActionController.startAction(
        name: '_Page1StoreBase.updatePieChartTitle');
    try {
      return super.updatePieChartTitle(newTitle);
    } finally {
      _$_Page1StoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDailySummary(String newSummary) {
    final _$actionInfo = _$_Page1StoreBaseActionController.startAction(
        name: '_Page1StoreBase.updateDailySummary');
    try {
      return super.updateDailySummary(newSummary);
    } finally {
      _$_Page1StoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
barChartTitle: ${barChartTitle},
pieChartTitle: ${pieChartTitle},
dailySummary: ${dailySummary}
    ''';
  }
}
