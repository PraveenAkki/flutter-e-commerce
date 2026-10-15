import 'package:e_clothing/features/product/domain/entities/product.dart';
import 'package:e_clothing/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WatchlistLocalDataSourceImpl dataSource;

  const tee = Product(
    id: 'p1',
    name: 'Tee',
    subtitle: 'Cotton',
    price: 799,
    imageUrl: 'img1',
    category: 'tops',
  );
  const jacket = Product(
    id: 'p2',
    name: 'Jacket',
    subtitle: 'Denim',
    price: 2999,
    imageUrl: 'img2',
    category: 'outerwear',
  );

  setUp(() => dataSource = WatchlistLocalDataSourceImpl());

  test('starts with an empty watchlist', () async {
    expect(await dataSource.getProducts(), isEmpty);
  });

  test('adds a product to the watchlist', () async {
    await dataSource.addProduct(tee);

    expect(await dataSource.getProducts(), [tee]);
  });

  test('does not add the same product twice', () async {
    await dataSource.addProduct(tee);
    await dataSource.addProduct(tee);

    expect(await dataSource.getProducts(), [tee]);
  });

  test('removes only the product with the given id', () async {
    await dataSource.addProduct(tee);
    await dataSource.addProduct(jacket);

    await dataSource.removeProduct('p1');

    expect(await dataSource.getProducts(), [jacket]);
  });

  test('removing a product that is not saved changes nothing', () async {
    await dataSource.addProduct(tee);

    await dataSource.removeProduct('p99');

    expect(await dataSource.getProducts(), [tee]);
  });

  test('clear removes every saved product', () async {
    await dataSource.addProduct(tee);
    await dataSource.addProduct(jacket);

    await dataSource.clearProducts();

    expect(await dataSource.getProducts(), isEmpty);
  });
}