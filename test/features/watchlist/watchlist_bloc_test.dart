import 'package:bloc_test/bloc_test.dart';
import 'package:e_clothing/features/product/domain/entities/product.dart';
import 'package:e_clothing/features/watchlist/domain/usecases/add_to_watchlist_usecase.dart';
import 'package:e_clothing/features/watchlist/domain/usecases/clear_watchlist_usecase.dart';
import 'package:e_clothing/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:e_clothing/features/watchlist/domain/usecases/remove_from_watchlist_usecase.dart';
import 'package:e_clothing/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:e_clothing/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:e_clothing/features/watchlist/presentation/bloc/watchlist_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetWatchlistUseCase extends Mock
    implements GetWatchlistUseCase {}

class _MockAddToWatchlistUseCase extends Mock
    implements AddToWatchlistUseCase {}

class _MockRemoveFromWatchlistUseCase extends Mock
    implements RemoveFromWatchlistUseCase {}

class _MockClearWatchlistUseCase extends Mock
    implements ClearWatchlistUseCase {}

void main() {
  late _MockGetWatchlistUseCase getWatchlist;
  late _MockAddToWatchlistUseCase addToWatchlist;
  late _MockRemoveFromWatchlistUseCase removeFromWatchlist;
  late _MockClearWatchlistUseCase clearWatchlist;

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

  setUp(() {
    getWatchlist = _MockGetWatchlistUseCase();
    addToWatchlist = _MockAddToWatchlistUseCase();
    removeFromWatchlist = _MockRemoveFromWatchlistUseCase();
    clearWatchlist = _MockClearWatchlistUseCase();
  });

  WatchlistBloc buildBloc() => WatchlistBloc(
    getWatchlist: getWatchlist,
    addToWatchlist: addToWatchlist,
    removeFromWatchlist: removeFromWatchlist,
    clearWatchlist: clearWatchlist,
  );

  test('a product is marked as saved only when it is in the watchlist', () {
    const state = WatchlistLoaded([tee]);

    expect(state.isInWatchlist('p1'), isTrue);
    expect(state.isInWatchlist('p2'), isFalse);
  });

  blocTest<WatchlistBloc, WatchlistState>(
    'adding a product emits the updated watchlist',
    build: () {
      when(() => addToWatchlist(tee)).thenAnswer((_) async {});
      when(() => getWatchlist()).thenAnswer((_) async => [tee]);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AddToWatchlist(tee)),
    expect: () => [const WatchlistLoaded([tee])],
    verify: (_) => verify(() => addToWatchlist(tee)).called(1),
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'removing a product emits the remaining watchlist',
    build: () {
      when(() => removeFromWatchlist('p1')).thenAnswer((_) async {});
      when(() => getWatchlist()).thenAnswer((_) async => [jacket]);
      return buildBloc();
    },
    seed: () => const WatchlistLoaded([tee, jacket]),
    act: (bloc) => bloc.add(const RemoveFromWatchlist('p1')),
    expect: () => [const WatchlistLoaded([jacket])],
    verify: (_) => verify(() => removeFromWatchlist('p1')).called(1),
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'removing the last product emits the empty state',
    build: () {
      when(() => removeFromWatchlist('p1')).thenAnswer((_) async {});
      when(() => getWatchlist()).thenAnswer((_) async => <Product>[]);
      return buildBloc();
    },
    seed: () => const WatchlistLoaded([tee]),
    act: (bloc) => bloc.add(const RemoveFromWatchlist('p1')),
    expect: () => [const WatchlistEmpty()],
  );
}