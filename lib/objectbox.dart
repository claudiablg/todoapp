import 'dart:developer';

import 'package:get/get.dart' hide Rx;
import 'package:todo_app/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class Db {
  /// The Store of this app.
  late final Store store;

  Db._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<Db> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, 'octave-db'));
    return Db._create(store);
  }

  static Box<T> getBox<T>() {
    assert(T != dynamic, 'Type T must be specified');
    final store = Get.find<Store>();
    return store.box<T>();
  }

  static RxList<T> getObs<T>() {
    final box = Db.getBox<T>();
    final RxList<T> items = RxList();
    items.bindStream(
      box.query().watch(triggerImmediately: true).map((query) => query.find()),
    );
    return items;
  }

  static RxList<T> getMergedObs<A extends T, B extends T, T>() {
    final boxA = Db.getBox<A>();
    final boxB = Db.getBox<B>();

    final RxList<T> items = RxList();
    final combo = Rx.combineLatest2(
      boxA.query().watch(triggerImmediately: true).map((query) {
        log('I am fetched again 😬');
        return query.find();
      }),
      boxB.query().watch(triggerImmediately: true).map((query) => query.find()),
      (a, b) {
        return [...a, ...b];
      },
    );
    items.bindStream(combo);

    return items;
  }
}
