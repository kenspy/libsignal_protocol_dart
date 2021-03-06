import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import '../../InvalidKeyIdException.dart';
import '../SignedPreKeyRecord.dart';
import '../SignedPreKeyStore.dart';

class InMemorySignedPreKeyStore extends SignedPreKeyStore {
  final store = HashMap<int, Uint8List>();

  @override
  SignedPreKeyRecord loadSignedPreKey(int signedPreKeyId) {
    try {
      if (!store.containsKey(signedPreKeyId)) {
        throw InvalidKeyIdException(
            'No such signedprekeyrecord! $signedPreKeyId');
      }
      return SignedPreKeyRecord.fromSerialized(store[signedPreKeyId]);
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  List<SignedPreKeyRecord> loadSignedPreKeys() {
    try {
      var results = List<SignedPreKeyRecord>();
      for (var serialized in store.values) {
        results.add(SignedPreKeyRecord.fromSerialized(serialized));
      }
      return results;
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  void storeSignedPreKey(int signedPreKeyId, SignedPreKeyRecord record) {
    store[signedPreKeyId] = record.serialize();
  }

  @override
  bool containsSignedPreKey(int signedPreKeyId) {
    return store.containsKey(signedPreKeyId);
  }

  @override
  void removeSignedPreKey(int signedPreKeyId) {
    store.remove(signedPreKeyId);
  }
}
