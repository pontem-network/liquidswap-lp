/// Extended standard test coins with additional ones.
module Account::CoinsExtended {
    use Std::Signer;
    use Std::ASCII::string;

    use AptosFramework::Coin::{Self, MintCapability, BurnCapability};

    /// Represents test USDC coin.
    struct USDC {}

    /// Represents test ETH coin.
    struct ETH {}

    /// Represents DAI coin.
    struct DAI {}

    /// Storing mint/burn capabilities for `USDT` and `BTC` coins under user account.
    struct Caps<phantom CoinType> has key {
        mint: MintCapability<CoinType>,
        burn: BurnCapability<CoinType>,
    }

    /// Initializes `BTC` and `USDT` coins.
    public(script) fun register_coins(token_admin: signer) {
        let (eth_m, eth_b) =
            Coin::initialize<ETH>(&token_admin,
                string(b"ETH"), string(b"ETH"), 8, true);
        let (usdc_m, usdc_b) =
            Coin::initialize<USDC>(&token_admin,
                string(b"USDC"), string(b"USDC"), 6, true);
        let (dai_m, dai_b) =
            Coin::initialize<DAI>(&token_admin,
                string(b"DAI"), string(b"DAI"), 6, true);

        move_to(&token_admin, Caps<ETH> { mint: eth_m, burn: eth_b });
        move_to(&token_admin, Caps<USDC> { mint: usdc_m, burn: usdc_b });
        move_to(&token_admin, Caps<DAI> { mint: dai_m, burn: dai_b });
    }

    /// Mints new coin `CoinType` on account `acc_addr`.
    public(script) fun mint_coin<CoinType>(token_admin: &signer, acc_addr: address, amount: u64) acquires Caps {
        let token_admin_addr = Signer::address_of(token_admin);
        let caps = borrow_global<Caps<CoinType>>(token_admin_addr);
        let coins = Coin::mint<CoinType>(amount, &caps.mint);
        Coin::deposit(acc_addr, coins);
    }
}