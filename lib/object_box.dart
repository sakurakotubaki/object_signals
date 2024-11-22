import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

// BoxStore（Java）またはStore（Dart）は、
// ObjectBoxを使用するためのエントリーポイントです。
// データベースへの直接のインターフェイスであり、Box を管理します。
// 通常、Store は 1 つだけ（1 つのデータベース）にして、アプリの実行中に開いておきたいものです。
class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // ビルドクエリなど、追加の設定コードを追加します.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }
}