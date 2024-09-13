// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page1_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Page1Store on _Page1Store, Store {
  late final _$devicesAtom =
      Atom(name: '_Page1Store.devices', context: context);

  @override
  ObservableList<DeviceModel> get devices {
    _$devicesAtom.reportRead();
    return super.devices;
  }

  @override
  set devices(ObservableList<DeviceModel> value) {
    _$devicesAtom.reportWrite(value, super.devices, () {
      super.devices = value;
    });
  }

  late final _$fetchDevicesAsyncAction =
      AsyncAction('_Page1Store.fetchDevices', context: context);

  @override
  Future<void> fetchDevices() {
    return _$fetchDevicesAsyncAction.run(() => super.fetchDevices());
  }

  @override
  String toString() {
    return '''
devices: ${devices}
    ''';
  }
}
