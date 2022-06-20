/// Basic liquidity coin, can be pre-deployed for any account.
module Account::LP {
    /// Represents `LP` coin with `X` and `Y` coin types.
    struct LP<phantom X, phantom Y> {}
}