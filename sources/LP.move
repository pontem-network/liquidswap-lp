/// Basic liquidity coin, can be pre-deployed for any account.
module Account::LP {
    use Std::Errors;
    use Std::ASCII::string;
    use AptosFramework::Coin;
    use AptosSwap::LiquidityPool;
    use AptosSwap::CoinHelper;

    /// When `X` and `Y` aren't sorted.
    const ERR_NOT_SORTED: u64 = 100;

    /// Represents `LP` coin with `X` and `Y` coin types.
    struct LP<phantom X, phantom Y> has store {}

    /// Creates `LP` coin and registers new liquidity pool.
    public(script) fun register_liquidity_pool<X: store, Y: store>(account: &signer) {
        assert!(CoinHelper::is_sorted<X, Y>(), Errors::invalid_argument(ERR_NOT_SORTED));

        let (mint_cap, burn_cap) = Coin::initialize<LP<X, Y>>(
            account,
            string(b"LP"),
            string(b"LP"),
            8,
            true
        );

        LiquidityPool::register<X, Y, LP<X, Y>>(
            account,
            mint_cap,
            burn_cap
        );
    }
}