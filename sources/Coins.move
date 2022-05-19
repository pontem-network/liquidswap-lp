module Account::Coins {
    use Std::Signer;
    use Std::ASCII::string;

    use AptosFramework::Coin::{Self, MintCapability, BurnCapability};

    /// Represents test USDT coin.
    struct USDT has store {}

    /// Represents test BTC coin.
    struct BTC has store {}

    /// Stroing mint/burn capabilities for `USDT` and `BTC` on user account for mint purposes.
    struct Caps<phantom CoinType> has key {
        mint: MintCapability<CoinType>,
        burn: BurnCapability<CoinType>,
    }

    /// Initializes `BTC` and `USDT` coins.
    public(script) fun register_coins(token_admin: signer) {
        let (btc_m, btc_b) =
            Coin::initialize<BTC>(&token_admin,
                string(b"Bitcoin"), string(b"BTC"), 8, true);
        let (usdt_m, usdt_b) =
            Coin::initialize<USDT>(&token_admin,
                string(b"Tether"), string(b"USDT"), 6, true);
        move_to(&token_admin, Caps<BTC> { mint: btc_m, burn: btc_b });
        move_to(&token_admin, Caps<USDT> { mint: usdt_m, burn: usdt_b });
    }

    /// Mints new coin `CoinType` on account `acc_addr`.
    public(script) fun mint_coin<CoinType>(token_admin: &signer, acc_addr: address, amount: u64) acquires Caps {
        let token_admin_addr = Signer::address_of(token_admin);
        let caps = borrow_global<Caps<CoinType>>(token_admin_addr);
        let coins = Coin::mint<CoinType>(amount, &caps.mint);
        Coin::deposit(acc_addr, coins);
    }
}