// const list = [
//   {
//     "id": "bitcoin",
//     "name": "Bitcoin",
//     "coinId": 0,
//     "symbol": "BTC",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/84'/0'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 0,
//     "p2shPrefix": 5,
//     "hrp": "bc",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "zpub",
//     "xprv": "zprv"
//   },
//   {
//     "id": "litecoin",
//     "name": "Litecoin",
//     "coinId": 2,
//     "symbol": "LTC",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/84'/2'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 48,
//     "p2shPrefix": 50,
//     "hrp": "ltc",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "zpub",
//     "xprv": "zprv",
//     "explorer": {
//       "url": "https://blockchair.com",
//       "txPath": "/litecoin/transaction/",
//       "accountPath": "/litecoin/address/"
//     },
//     "info": {
//       "url": "https://litecoin.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "doge",
//     "name": "Dogecoin",
//     "coinId": 3,
//     "symbol": "DOGE",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/3'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 30,
//     "p2shPrefix": 22,
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "dgub",
//     "xprv": "dgpv",
//     "explorer": {
//       "url": "https://blockchair.com",
//       "txPath": "/dogecoin/transaction/",
//       "accountPath": "/dogecoin/address/"
//     },
//     "info": {
//       "url": "https://dogecoin.com",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "dash",
//     "name": "Dash",
//     "coinId": 5,
//     "symbol": "DASH",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/5'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 76,
//     "p2shPrefix": 16,
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "xpub",
//     "xprv": "xprv",
//     "explorer": {
//       "url": "https://blockchair.com",
//       "txPath": "/dash/transaction/",
//       "accountPath": "/dash/address/"
//     },
//     "info": {
//       "url": "https://dash.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "viacoin",
//     "name": "Viacoin",
//     "coinId": 14,
//     "symbol": "VIA",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/84'/14'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 71,
//     "p2shPrefix": 33,
//     "hrp": "via",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "zpub",
//     "xprv": "zprv",
//     "explorer": {
//       "url": "https://explorer.viacoin.org",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://viacoin.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "groestlcoin",
//     "name": "Groestlcoin",
//     "coinId": 17,
//     "symbol": "GRS",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/84'/17'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 36,
//     "p2shPrefix": 5,
//     "hrp": "grs",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "groestl512d",
//     "xpub": "zpub",
//     "xprv": "zprv",
//     "explorer": {
//       "url": "https://blockchair.com",
//       "txPath": "/groestlcoin/transaction/",
//       "accountPath": "/groestlcoin/address/"
//     },
//     "info": {
//       "url": "https://www.groestlcoin.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "digibyte",
//     "name": "DigiByte",
//     "coinId": 20,
//     "symbol": "DGB",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/84'/20'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 30,
//     "p2shPrefix": 63,
//     "hrp": "dgb",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "zpub",
//     "xprv": "zprv",
//     "explorer": {
//       "url": "https://digiexplorer.info",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://www.digibyte.io",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "monacoin",
//     "name": "Monacoin",
//     "coinId": 22,
//     "symbol": "MONA",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/22'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 50,
//     "p2shPrefix": 55,
//     "hrp": "mona",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "xpub",
//     "xprv": "xprv",
//     "explorer": {
//       "url": "https://blockbook.electrum-mona.org",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://monacoin.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "decred",
//     "name": "Decred",
//     "coinId": 42,
//     "symbol": "DCR",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/42'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "staticPrefix": 7,
//     "p2pkhPrefix": 63,
//     "p2shPrefix": 26,
//     "publicKeyHasher": "blake256ripemd",
//     "base58Hasher": "blake256d",
//     "xpub": "dpub",
//     "xprv": "dprv",
//     "explorer": {
//       "url": "https://dcrdata.decred.org",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://decred.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "ethereum",
//     "name": "Ethereum",
//     "coinId": 60,
//     "symbol": "ETH",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/60'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://etherscan.io",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "0x9edaf0f7d9c6629c31bbf0471fc07d696c73b566b93783f7e25d8d5d2b62fa4f",
//       "sampleAccount": "0x5bb497e8d9fe26e92dd1be01e32076c8e024d167"
//     },
//     "info": {
//       "url": "https://ethereum.org",
//       "client": "https://github.com/ethereum/go-ethereum",
//       "clientPublic": "https://mainnet.infura.io",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "classic",
//     "name": "Ethereum Classic",
//     "coinId": 61,
//     "symbol": "ETC",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/61'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://blockscout.com/etc/mainnet",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://ethereumclassic.org",
//       "client": "https://github.com/ethereumclassic/go-ethereum",
//       "clientPublic": "https://www.ethercluster.com/etc",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "icon",
//     "name": "ICON",
//     "coinId": 74,
//     "symbol": "ICX",
//     "decimals": 18,
//     "blockchain": "Icon",
//     "derivationPath": "m/44'/74'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://tracker.icon.foundation",
//       "txPath": "/transaction/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://icon.foundation",
//       "client": "https://github.com/icon-project/icon-rpc-server",
//       "clientPublic": "http://ctz.icxstation.com:9000/api/v3",
//       "clientDocs": "https://www.icondev.io/docs/icon-json-rpc-v3"
//     }
//   },
//   {
//     "id": "cosmos",
//     "name": "Cosmos",
//     "coinId": 118,
//     "symbol": "ATOM",
//     "decimals": 6,
//     "blockchain": "Cosmos",
//     "derivationPath": "m/44'/118'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "hrp": "cosmos",
//     "explorer": {
//       "url": "https://www.mintscan.io",
//       "txPath": "/txs/",
//       "accountPath": "/account/"
//     },
//     "info": {
//       "url": "https://cosmos.network",
//       "client": "https://github.com/cosmos/cosmos-sdk",
//       "clientPublic": "https://stargate.cosmos.network",
//       "clientDocs": "https://cosmos.network/rpc"
//     }
//   },
//   {
//     "id": "zcash",
//     "name": "Zcash",
//     "coinId": 133,
//     "symbol": "ZEC",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/133'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "staticPrefix": 28,
//     "p2pkhPrefix": 184,
//     "p2shPrefix": 189,
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "xpub",
//     "xprv": "xprv",
//     "explorer": {
//       "url": "https://blockchair.com/zcash",
//       "txPath": "/transaction/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://z.cash",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "zcoin",
//     "name": "Zcoin",
//     "displayName": "Firo",
//     "coinId": 136,
//     "symbol": "FIRO",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/136'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 82,
//     "p2shPrefix": 7,
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "xpub",
//     "xprv": "xprv",
//     "explorer": {
//       "url": "https://explorer.firo.org",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://firo.org/",
//       "client": "https://github.com/firoorg/firo",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "ripple",
//     "name": "XRP",
//     "coinId": 144,
//     "symbol": "XRP",
//     "decimals": 6,
//     "blockchain": "Ripple",
//     "derivationPath": "m/44'/144'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "explorer": {
//       "url": "https://bithomp.com",
//       "txPath": "/explorer/",
//       "accountPath": "/explorer/",
//       "sampleTx":
//           "E26AB8F3372D2FC02DEC1FD5674ADAB762D684BFFDBBDF5D674E9D7CF4A47054",
//       "sampleAccount": "rfkH7EuS1XcSkB9pocy1R6T8F4CsNYixYU"
//     },
//     "info": {
//       "url": "https://ripple.com/xrp",
//       "client": "https://github.com/ripple/rippled",
//       "clientPublic": "https://s2.ripple.com:51234",
//       "clientDocs": "https://xrpl.org/rippled-api.html"
//     }
//   },
//   {
//     "id": "bitcoincash",
//     "name": "Bitcoin Cash",
//     "coinId": 145,
//     "symbol": "BCH",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/145'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 0,
//     "p2shPrefix": 5,
//     "hrp": "bitcoincash",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "xpub",
//     "xprv": "xprv",
//     "explorer": {
//       "url": "https://blockchair.com",
//       "txPath": "/bitcoin-cash/transaction/",
//       "accountPath": "/bitcoin-cash/address/"
//     },
//     "info": {
//       "url": "https://bitcoincash.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "stellar",
//     "name": "Stellar",
//     "coinId": 148,
//     "symbol": "XLM",
//     "decimals": 7,
//     "blockchain": "Stellar",
//     "derivationPath": "m/44'/148'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://blockchair.com/stellar",
//       "txPath": "/transaction/",
//       "accountPath": "/account/"
//     },
//     "info": {
//       "url": "https://stellar.org",
//       "client": "https://github.com/stellar/go",
//       "clientPublic": "https://horizon.stellar.org",
//       "clientDocs": "https://www.stellar.org/developers/horizon/reference"
//     }
//   },
//   {
//     "id": "bitcoingold",
//     "name": "Bitcoin Gold",
//     "coinId": 156,
//     "symbol": "BTG",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/84'/156'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 38,
//     "p2shPrefix": 23,
//     "hrp": "btg",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "zpub",
//     "xprv": "zprv",
//     "explorer": {
//       "url": "https://explorer.bitcoingold.org/insight",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://bitcoingold.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "nano",
//     "name": "Nano",
//     "coinId": 165,
//     "symbol": "NANO",
//     "decimals": 30,
//     "blockchain": "Nano",
//     "derivationPath": "m/44'/165'/0'",
//     "curve": "ed25519Blake2bNano",
//     "publicKeyType": "ed25519Blake2b",
//     "url": "https://nano.org",
//     "explorer": {
//       "url": "https://nanocrawler.cc",
//       "txPath": "/explorer/block/",
//       "accountPath": "/explorer/account/",
//       "sampleTx":
//           "C264DB7BF40738F0CEFF19B606746CB925B713E4B8699A055699E0DC8ABBC70F",
//       "sampleAccount":
//           "nano_1wpj616kwhe1y38y1mspd8aub8i334cwybqco511iyuxm55zx8d67ptf1tsf"
//     },
//     "info": {
//       "url": "https://nano.org",
//       "client": "https://github.com/nanocurrency/nano-node",
//       "clientPublic": "",
//       "clientDocs": "https://docs.nano.org/commands/rpc-protocol/"
//     }
//   },
//   {
//     "id": "ravencoin",
//     "name": "Ravencoin",
//     "coinId": 175,
//     "symbol": "RVN",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/175'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 60,
//     "p2shPrefix": 122,
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "xpub",
//     "xprv": "xprv",
//     "explorer": {
//       "url": "https://ravencoin.network",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://ravencoin.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "poa",
//     "name": "POA Network",
//     "coinId": 178,
//     "symbol": "POA",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/178'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://blockscout.com",
//       "txPath": "/poa/core/tx/",
//       "accountPath": "/poa/core/address/"
//     },
//     "info": {
//       "url": "https://poa.network",
//       "client": "https://github.com/poanetwork/parity-ethereum",
//       "clientPublic": "https://core.poa.network",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "eos",
//     "name": "EOS",
//     "coinId": 194,
//     "symbol": "EOS",
//     "decimals": 4,
//     "blockchain": "EOS",
//     "derivationPath": "m/44'/194'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "explorer": {
//       "url": "https://bloks.io",
//       "txPath": "/transaction/",
//       "accountPath": "/account/"
//     },
//     "info": {
//       "url": "http://eos.io",
//       "client": "https://github.com/eosio/eos",
//       "clientPublic": "",
//       "clientDocs": "https://developers.eos.io/eosio-nodeos/reference"
//     }
//   },
//   {
//     "id": "tron",
//     "name": "Tron",
//     "coinId": 195,
//     "symbol": "TRX",
//     "decimals": 6,
//     "blockchain": "Tron",
//     "derivationPath": "m/44'/195'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://tronscan.org",
//       "txPath": "/#/transaction/",
//       "accountPath": "/#/address/"
//     },
//     "info": {
//       "url": "https://tron.network",
//       "client": "https://github.com/tronprotocol/java-tron",
//       "clientPublic": "https://api.trongrid.io",
//       "clientDocs": "https://developers.tron.network/docs/tron-wallet-rpc-api"
//     }
//   },
//   {
//     "id": "fio",
//     "name": "FIO",
//     "coinId": 235,
//     "symbol": "FIO",
//     "decimals": 9,
//     "blockchain": "FIO",
//     "derivationPath": "m/44'/235'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "url": "https://fioprotocol.io/",
//     "explorer": {
//       "url": "https://explorer.fioprotocol.io",
//       "txPath": "/transaction/",
//       "accountPath": "/account/"
//     },
//     "info": {
//       "url": "https://fioprotocol.io",
//       "client": "https://github.com/fioprotocol/fio",
//       "clientPublic": "https://mainnet.fioprotocol.io",
//       "clientDocs": "https://developers.fioprotocol.io"
//     }
//   },
//   {
//     "id": "nimiq",
//     "name": "Nimiq",
//     "coinId": 242,
//     "symbol": "NIM",
//     "decimals": 5,
//     "blockchain": "Nimiq",
//     "derivationPath": "m/44'/242'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://nimiq.watch",
//       "txPath": "/#",
//       "accountPath": "/#"
//     },
//     "info": {
//       "url": "https://nimiq.com",
//       "client": "https://github.com/nimiq/core-rs",
//       "clientPublic": "",
//       "clientDocs": "https://github.com/nimiq/core-js/wiki/JSON-RPC-API"
//     }
//   },
//   {
//     "id": "algorand",
//     "name": "Algorand",
//     "coinId": 283,
//     "symbol": "ALGO",
//     "decimals": 6,
//     "blockchain": "Algorand",
//     "derivationPath": "m/44'/283'/0'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://algoexplorer.io",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx": "CR7POXFTYDLC7TV3IXHA7AZKWABUJC52BACLHJQNXAKZJGRPQY3A",
//       "sampleAccount":
//           "J4AEINCSSLDA7LNBNWM4ZXFCTLTOZT5LG3F5BLMFPJYGFWVCMU37EZI2AM"
//     },
//     "info": {
//       "url": "https://www.algorand.com/",
//       "client": "https://github.com/algorand/go-algorand",
//       "clientPublic": "https://indexer.algorand.network",
//       "clientDocs": "https://developer.algorand.org/docs/algod-rest-paths"
//     }
//   },
//   {
//     "id": "iotex",
//     "name": "IoTeX",
//     "coinId": 304,
//     "symbol": "IOTX",
//     "decimals": 18,
//     "blockchain": "IoTeX",
//     "derivationPath": "m/44'/304'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "hrp": "io",
//     "explorer": {
//       "url": "https://iotexscan.io",
//       "txPath": "/action/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://iotex.io",
//       "client": "https://github.com/iotexproject/iotex-core",
//       "clientPublic": "",
//       "clientDocs": "https://docs.iotex.io/#api"
//     }
//   },
//   {
//     "id": "zilliqa",
//     "name": "Zilliqa",
//     "coinId": 313,
//     "symbol": "ZIL",
//     "decimals": 12,
//     "blockchain": "Zilliqa",
//     "derivationPath": "m/44'/313'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "hrp": "zil",
//     "explorer": {
//       "url": "https://viewblock.io",
//       "txPath": "/zilliqa/tx/",
//       "accountPath": "/zilliqa/address/"
//     },
//     "info": {
//       "url": "https://zilliqa.com",
//       "client": "https://github.com/Zilliqa/Zilliqa",
//       "clientPublic": "https://api.zilliqa.com",
//       "clientDocs": "https://apidocs.zilliqa.com"
//     }
//   },
//   {
//     "id": "terra",
//     "name": "Terra",
//     "coinId": 330,
//     "symbol": "LUNA",
//     "decimals": 6,
//     "blockchain": "Cosmos",
//     "derivationPath": "m/44'/330'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "hrp": "terra",
//     "explorer": {
//       "url": "https://terra.stake.id",
//       "txPath": "/#/tx/",
//       "accountPath": "/#/address/"
//     },
//     "info": {
//       "url": "https://terra.money",
//       "client": "https://github.com/terra-project/core",
//       "clientPublic": "https://rpc.terra.dev",
//       "clientDocs": "https://docs.terra.money"
//     }
//   },
//   {
//     "id": "polkadot",
//     "name": "Polkadot",
//     "coinId": 354,
//     "symbol": "DOT",
//     "decimals": 10,
//     "blockchain": "Polkadot",
//     "derivationPath": "m/44'/354'/0'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://polkadot.subscan.io",
//       "txPath": "/extrinsic/",
//       "accountPath": "/account/"
//     },
//     "info": {
//       "url": "https://polkadot.network/",
//       "client": "https://github.com/paritytech/polkadot",
//       "clientPublic": "",
//       "clientDocs": "https://polkadot.js.org/api/substrate/rpc.html"
//     }
//   },
//   {
//     "id": "ton",
//     "name": "TON",
//     "coinId": 396,
//     "symbol": "GRAM",
//     "decimals": 9,
//     "blockchain": "TON",
//     "derivationPath": "m/44'/396'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://test.ton.org",
//       "txPath": "/testnet/transaction?hash=",
//       "accountPath": "/testnet/account?account="
//     },
//     "info": {
//       "url": "https://test.ton.org",
//       "client": "https://github.com/ton-blockchain/ton",
//       "clientPublic": "",
//       "clientDocs": "https://test.ton.org/"
//     }
//   },
//   {
//     "id": "near",
//     "name": "NEAR",
//     "coinId": 397,
//     "symbol": "NEAR",
//     "decimals": 24,
//     "blockchain": "NEAR",
//     "derivationPath": "m/44'/397'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://explorer.near.org",
//       "txPath": "/transactions/",
//       "accountPath": "/accounts/"
//     },
//     "info": {
//       "url": "https://nearprotocol.com",
//       "client": "https://github.com/nearprotocol/nearcore",
//       "clientPublic": "https://rpc.nearprotocol.com",
//       "clientDocs": "https://docs.nearprotocol.com"
//     }
//   },
//   {
//     "id": "aion",
//     "name": "Aion",
//     "coinId": 425,
//     "symbol": "AION",
//     "decimals": 18,
//     "blockchain": "Aion",
//     "derivationPath": "m/44'/425'/0'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://mainnet.aion.network",
//       "txPath": "/#/transaction/",
//       "accountPath": "/#/account/"
//     },
//     "info": {
//       "url": "https://aion.network",
//       "client": "https://github.com/aionnetwork/aion",
//       "clientPublic": "",
//       "clientDocs": "https://github.com/aionnetwork/aion/wiki/JSON-RPC-API-Docs"
//     }
//   },
//   {
//     "id": "kusama",
//     "name": "Kusama",
//     "coinId": 434,
//     "symbol": "KSM",
//     "decimals": 12,
//     "blockchain": "Polkadot",
//     "derivationPath": "m/44'/434'/0'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://kusama.subscan.io",
//       "txPath": "/extrinsic/",
//       "accountPath": "/account/",
//       "sampleTx":
//           "0xcbe0c2e2851c1245bedaae4d52f06eaa6b4784b786bea2f0bff11af7715973dd",
//       "sampleAccount": "DbCNECPna3k6MXFWWNZa5jGsuWycqEE6zcUxZYkxhVofrFk"
//     },
//     "info": {
//       "url": "https://kusama.network",
//       "client": "https://github.com/paritytech/polkadot",
//       "clientPublic": "wss://kusama-rpc.polkadot.io/",
//       "clientDocs": "https://polkadot.js.org/api/substrate/rpc.html"
//     }
//   },
//   {
//     "id": "aeternity",
//     "name": "Aeternity",
//     "coinId": 457,
//     "symbol": "AE",
//     "decimals": 18,
//     "blockchain": "Aeternity",
//     "derivationPath": "m/44'/457'/0'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://explorer.aepps.com",
//       "txPath": "/transactions/",
//       "accountPath": "/account/transactions/"
//     },
//     "info": {
//       "url": "https://aeternity.com",
//       "client": "https://github.com/aeternity/aeternity",
//       "clientPublic": "https://sdk-mainnet.aepps.com",
//       "clientDocs": "http://aeternity.com/api-docs/"
//     }
//   },
//   {
//     "id": "kava",
//     "name": "Kava",
//     "coinId": 459,
//     "symbol": "KAVA",
//     "decimals": 6,
//     "blockchain": "Cosmos",
//     "derivationPath": "m/44'/459'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "hrp": "kava",
//     "explorer": {
//       "url": "https://kava.mintscan.io",
//       "txPath": "/txs/",
//       "accountPath": "/account/",
//       "sampleTx":
//           "2988DF83FCBFAA38179D583A96734CBD071541D6768221BB23111BC8136D5E6A",
//       "sampleAccount": "kava1jf9aaj9myrzsnmpdr7twecnaftzmku2mdpy2a7"
//     },
//     "info": {
//       "url": "https://kava.io",
//       "client": "https://github.com/kava-labs/kava",
//       "clientPublic": "https://data.kava.io",
//       "clientDocs": "https://rpc.kava.io"
//     }
//   },
//   {
//     "id": "filecoin",
//     "name": "Filecoin",
//     "coinId": 461,
//     "symbol": "FIL",
//     "decimals": 18,
//     "blockchain": "Filecoin",
//     "derivationPath": "m/44'/461'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://filfox.info/en",
//       "txPath": "/message/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "bafy2bzacedsgjcd6xfhrrymmfrqubb44otlyhvgqkgsh533d5j5hwniiqespm",
//       "sampleAccount": "f1abjxfbp274xpdqcpuaykwkfb43omjotacm2p3za"
//     },
//     "info": {
//       "url": "https://filecoin.io/",
//       "client": "https://github.com/filecoin-project/lotus",
//       "clientPublic": "",
//       "clientDocs": "https://docs.lotu.sh"
//     }
//   },
//   {
//     "id": "band",
//     "name": "BandChain",
//     "symbol": "BAND",
//     "coinId": 494,
//     "decimals": 6,
//     "blockchain": "Cosmos",
//     "derivationPath": "m/44'/494'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "hrp": "band",
//     "explorer": {
//       "url": "https://scan-wenchang-testnet2.bandchain.org/",
//       "txPath": "/tx/",
//       "accountPath": "/account/",
//       "sampleTx":
//           "473264551D3063A9EC64EC251C61BE92DDDFCF6CC46D026D1E574D83D5447173",
//       "sampleAccount": "band12nmsm9khdsv0tywge43q3zwj8kkj3hvup9rltp"
//     },
//     "info": {
//       "url": "https://bandprotocol.com/",
//       "client": "https://github.com/bandprotocol/bandchain",
//       "clientPublic": "https://api-wt2-lb.bandchain.org",
//       "clientDocs": "https://docs.bandchain.org/"
//     }
//   },
//   {
//     "id": "theta",
//     "name": "Theta",
//     "coinId": 500,
//     "symbol": "THETA",
//     "decimals": 18,
//     "blockchain": "Theta",
//     "derivationPath": "m/44'/500'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://explorer.thetatoken.org",
//       "txPath": "/txs/",
//       "accountPath": "/account/"
//     },
//     "info": {
//       "url": "https://www.thetatoken.org",
//       "client": "https://github.com/thetatoken/theta-protocol-ledger",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/thetatoken/theta-mainnet-integration-guide/blob/master/docs/api.md#api-reference"
//     }
//   },
//   {
//     "id": "solana",
//     "name": "Solana",
//     "coinId": 501,
//     "symbol": "SOL",
//     "decimals": 9,
//     "blockchain": "Solana",
//     "derivationPath": "m/44'/501'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://explorer.solana.com",
//       "txPath": "/transactions/",
//       "accountPath": "/accounts/"
//     },
//     "info": {
//       "url": "https://solana.com",
//       "client": "https://github.com/solana-labs/solana",
//       "clientPublic": "https://api.mainnet-beta.solana.com",
//       "clientDocs": "https://docs.solana.com"
//     }
//   },
//   {
//     "id": "elrond",
//     "name": "Elrond",
//     "coinId": 508,
//     "symbol": "eGLD",
//     "decimals": 18,
//     "blockchain": "ElrondNetwork",
//     "derivationPath": "m/44'/508'/0'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "hrp": "erd",
//     "explorer": {
//       "url": "https://explorer.elrond.com",
//       "txPath": "/transactions/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://elrond.com/",
//       "client": "https://github.com/ElrondNetwork/elrond-go",
//       "clientPublic": "https://api.elrond.com",
//       "clientDocs": "https://docs.elrond.com"
//     }
//   },
//   {
//     "id": "binance",
//     "name": "Binance",
//     "displayName": "BNB",
//     "coinId": 714,
//     "symbol": "BNB",
//     "decimals": 8,
//     "blockchain": "Binance",
//     "derivationPath": "m/44'/714'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "hrp": "bnb",
//     "explorer": {
//       "url": "https://explorer.binance.org",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "A93625C9F9ABEA1A8E31585B30BBB16C34FAE0D172EB5B6B2F834AF077BF06BB",
//       "sampleAccount": "bnb1u7jm0cll5h3224y0tapwn6gf6pr49ytewx4gsz"
//     },
//     "info": {
//       "url": "https://binance.org",
//       "client": "https://github.com/binance-chain/node-binary",
//       "clientPublic": "https://dex.binance.org",
//       "clientDocs": "https://docs.binance.org/api-reference/dex-api/paths.html"
//     }
//   },
//   {
//     "id": "vechain",
//     "name": "VeChain",
//     "coinId": 818,
//     "symbol": "VET",
//     "decimals": 18,
//     "blockchain": "Vechain",
//     "derivationPath": "m/44'/818'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://explore.vechain.org",
//       "txPath": "/transactions/",
//       "accountPath": "/accounts/"
//     },
//     "info": {
//       "url": "https://vechain.org",
//       "client": "https://github.com/vechain/thor",
//       "clientPublic": "",
//       "clientDocs": "https://doc.vechainworld.io/docs"
//     }
//   },
//   {
//     "id": "callisto",
//     "name": "Callisto",
//     "coinId": 820,
//     "symbol": "CLO",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/820'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://explorer2.callisto.network",
//       "txPath": "/tx/",
//       "accountPath": "/addr/"
//     },
//     "info": {
//       "url": "https://callisto.network",
//       "client": "https://github.com/EthereumCommonwealth/go-callisto",
//       "clientPublic": "https://clo-geth.0xinfra.com",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "neo",
//     "name": "NEO",
//     "coinId": 888,
//     "symbol": "NEO",
//     "decimals": 8,
//     "blockchain": "NEO",
//     "derivationPath": "m/44'/888'/0'/0/0",
//     "curve": "nist256p1",
//     "publicKeyType": "nist256p1",
//     "explorer": {
//       "url": "https://neoscan.io",
//       "txPath": "/transaction/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "e0ddf7c81c732df26180aca0c36d5868ad009fdbbe6e7a56ebafc14bba41cd53",
//       "sampleAccount": "AcxuqWhTureEQGeJgbmtSWNAtssjMLU7pb"
//     },
//     "info": {
//       "url": "https://neo.org",
//       "client": "https://github.com/neo-project/neo",
//       "clientPublic": "http://seed1.ngd.network:10332",
//       "clientDocs": "https://neo.org/eco"
//     }
//   },
//   {
//     "id": "tomochain",
//     "name": "TomoChain",
//     "coinId": 889,
//     "symbol": "TOMO",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/889'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://scan.tomochain.com",
//       "txPath": "/txs/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://tomochain.com",
//       "client": "https://github.com/tomochain/tomochain",
//       "clientPublic": "https://rpc.tomochain.com",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "thundertoken",
//     "name": "Thunder Token",
//     "coinId": 1001,
//     "symbol": "TT",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/1001'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://scan.thundercore.com",
//       "txPath": "/transactions/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://thundercore.com",
//       "client": "https://github.com/thundercore/pala",
//       "clientPublic": "https://mainnet-rpc.thundercore.com",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "harmony",
//     "name": "Harmony",
//     "coinId": 1023,
//     "symbol": "ONE",
//     "decimals": 18,
//     "blockchain": "Harmony",
//     "derivationPath": "m/44'/1023'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "hrp": "one",
//     "explorer": {
//       "url": "https://explorer.harmony.one",
//       "txPath": "/#/tx/",
//       "accountPath": "/#/address/"
//     },
//     "info": {
//       "url": "https://harmony.one",
//       "client": "https://github.com/harmony-one/go-sdk",
//       "clientPublic": "",
//       "clientDocs":
//           "https://docs.harmony.one/home/harmony-networks/harmony-network-overview/mainnet"
//     }
//   },
//   {
//     "id": "oasis",
//     "name": "Oasis",
//     "coinId": 474,
//     "symbol": "ROSE",
//     "decimals": 9,
//     "blockchain": "OasisNetwork",
//     "derivationPath": "m/44'/474'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "hrp": "oasis",
//     "explorer": {
//       "url": "https://oasisscan.com",
//       "txPath": "/transactions/",
//       "accountPath": "/accounts/detail/",
//       "sampleTx":
//           "0b9bd4983f1c88a1c71bf33562b6ba02b3064e01697d15a0de4bfe1922ec74b8",
//       "sampleAccount": "oasis1qrx376dmwuckmruzn9vq64n49clw72lywctvxdf4"
//     },
//     "info": {
//       "url": "https://oasisprotocol.org/",
//       "client": "https://github.com/oasisprotocol/oasis-core",
//       "clientPublic": "https://rosetta.oasis.dev/api/v1",
//       "clientDocs": "https://docs.oasis.dev/oasis-core/"
//     }
//   },
//   {
//     "id": "ontology",
//     "name": "Ontology",
//     "coinId": 1024,
//     "symbol": "ONT",
//     "decimals": 0,
//     "blockchain": "Ontology",
//     "derivationPath": "m/44'/1024'/0'/0/0",
//     "curve": "nist256p1",
//     "publicKeyType": "nist256p1",
//     "explorer": {
//       "url": "https://explorer.ont.io",
//       "txPath": "/transaction/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://ont.io",
//       "client": "https://github.com/ontio/ontology",
//       "clientPublic": "http://dappnode1.ont.io:20336",
//       "clientDocs":
//           "https://github.com/ontio/ontology/blob/master/docs/specifications/rpc_api.md"
//     }
//   },
//   {
//     "id": "tezos",
//     "name": "Tezos",
//     "coinId": 1729,
//     "symbol": "XTZ",
//     "decimals": 6,
//     "blockchain": "Tezos",
//     "derivationPath": "m/44'/1729'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://tzstats.com",
//       "txPath": "/",
//       "accountPath": "/"
//     },
//     "info": {
//       "url": "https://tezos.com",
//       "client": "https://gitlab.com/tezos/tezos",
//       "clientPublic": "https://rpc.tulip.tools/mainnet",
//       "clientDocs": "https://tezos.gitlab.io/tezos/api/rpc.html"
//     }
//   },
//   {
//     "id": "cardano",
//     "name": "Cardano",
//     "coinId": 1815,
//     "symbol": "ADA",
//     "decimals": 6,
//     "blockchain": "Cardano",
//     "derivationPath": "m/1852'/1815'/0'/0/0",
//     "curve": "ed25519Extended",
//     "publicKeyType": "ed25519Extended",
//     "hrp": "addr",
//     "explorer": {
//       "url": "https://shelleyexplorer.cardano.org",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "b7a6c5cadab0f64bdc89c77ee4a351463aba5c33f2cef6bbd6542a74a90a3af3",
//       "sampleAccount":
//           "addr1s3xuxwfetyfe7q9u3rfn6je9stlvcgmj8rezd87qjjegdtxm3y3f2mgtn87mrny9r77gm09h6ecslh3gmarrvrp9n4yzmdnecfxyu59jz29g8j"
//     },
//     "info": {
//       "url": "https://www.cardano.org",
//       "client": "https://github.com/input-output-hk/cardano-sl",
//       "clientPublic": "",
//       "clientDocs": "https://cardanodocs.com/introduction/"
//     }
//   },
//   {
//     "id": "kin",
//     "name": "Kin",
//     "coinId": 2017,
//     "symbol": "KIN",
//     "decimals": 5,
//     "blockchain": "Stellar",
//     "derivationPath": "m/44'/2017'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "ed25519",
//     "explorer": {
//       "url": "https://www.kin.org",
//       "txPath": "/blockchainInfoPage/?&dataType=public&header=Transaction&id=",
//       "accountPath": "/blockchainAccount/?&dataType=public&header=accountID&id="
//     },
//     "info": {
//       "url": "https://www.kin.org",
//       "client": "https://github.com/kinecosystem/go",
//       "clientPublic": "https://horizon.kinfederation.com",
//       "clientDocs": "https://www.stellar.org/developers/horizon/reference"
//     },
//     "deprecated": true
//   },
//   {
//     "id": "qtum",
//     "name": "Qtum",
//     "coinId": 2301,
//     "symbol": "QTUM",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/2301'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "p2pkhPrefix": 58,
//     "p2shPrefix": 50,
//     "hrp": "qc",
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "xpub",
//     "xprv": "xprv",
//     "explorer": {
//       "url": "https://qtum.info",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://qtum.org",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "nebulas",
//     "name": "Nebulas",
//     "coinId": 2718,
//     "symbol": "NAS",
//     "decimals": 18,
//     "blockchain": "Nebulas",
//     "derivationPath": "m/44'/2718'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://explorer.nebulas.io",
//       "txPath": "/#/tx/",
//       "accountPath": "/#/address/"
//     },
//     "info": {
//       "url": "https://nebulas.io",
//       "client": "https://github.com/nebulasio/go-nebulas",
//       "clientPublic": "https://mainnet.nebulas.io",
//       "clientDocs":
//           "https://wiki.nebulas.io/en/latest/dapp-development/rpc/rpc.html"
//     }
//   },
//   {
//     "id": "gochain",
//     "name": "GoChain",
//     "coinId": 6060,
//     "symbol": "GO",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/6060'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://explorer.gochain.io",
//       "txPath": "/tx/",
//       "accountPath": "/addr/"
//     },
//     "info": {
//       "url": "https://gochain.io",
//       "client": "https://github.com/gochain-io/gochain",
//       "clientPublic": "https://rpc.gochain.io",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "nuls",
//     "name": "NULS",
//     "coinId": 8964,
//     "symbol": "NULS",
//     "decimals": 8,
//     "blockchain": "NULS",
//     "derivationPath": "m/44'/8964'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "explorer": {
//       "url": "https://nulscan.io",
//       "txPath": "/transaction/info?hash=",
//       "accountPath": "/address/info?address="
//     },
//     "info": {
//       "url": "https://nuls.io",
//       "client": "https://github.com/nuls-io/nuls-v2",
//       "clientPublic": "https://public1.nuls.io/",
//       "clientDocs": "https://docs.nuls.io/"
//     }
//   },
//   {
//     "id": "zelcash",
//     "name": "Zelcash",
//     "displayName": "Flux",
//     "coinId": 19167,
//     "symbol": "FLUX",
//     "decimals": 8,
//     "blockchain": "Bitcoin",
//     "derivationPath": "m/44'/19167'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "staticPrefix": 28,
//     "p2pkhPrefix": 184,
//     "p2shPrefix": 189,
//     "publicKeyHasher": "sha256ripemd",
//     "base58Hasher": "sha256d",
//     "xpub": "xpub",
//     "xprv": "xprv",
//     "explorer": {
//       "url": "https://explorer.runonflux.io",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://runonflux.io",
//       "client": "https://github.com/trezor/blockbook",
//       "clientPublic": "https://blockbook.runonflux.io",
//       "clientDocs":
//           "https://github.com/trezor/blockbook/blob/master/docs/api.md"
//     }
//   },
//   {
//     "id": "wanchain",
//     "name": "Wanchain",
//     "coinId": 5718350,
//     "symbol": "WAN",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/5718350'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://www.wanscan.org",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "0x180ea96a3218b82b9b35d796823266d8a425c182507adfe5eeffc96e6a14d856",
//       "sampleAccount": "0xc6D3DBf8dF90BA3f957A9634677805eee0e43bBe"
//     },
//     "info": {
//       "url": "https://wanchain.org",
//       "client": "https://github.com/wanchain/go-wanchain",
//       "clientPublic": "",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "waves",
//     "name": "Waves",
//     "coinId": 5741564,
//     "symbol": "WAVES",
//     "decimals": 8,
//     "blockchain": "Waves",
//     "derivationPath": "m/44'/5741564'/0'/0'/0'",
//     "curve": "ed25519",
//     "publicKeyType": "curve25519",
//     "explorer": {
//       "url": "https://wavesexplorer.com",
//       "txPath": "/tx/",
//       "accountPath": "/address/"
//     },
//     "info": {
//       "url": "https://wavesplatform.com",
//       "client": "https://github.com/wavesplatform/Waves",
//       "clientPublic": "https://nodes.wavesnodes.com",
//       "clientDocs": "https://nodes.wavesnodes.com/api-docs/index.html"
//     }
//   },
//   {
//     "id": "bsc",
//     "name": "Smart Chain Legacy",
//     "coinId": 10000714,
//     "slip44": 714,
//     "symbol": "BNB",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/714'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://bscscan.com",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "0xb9ae2e808fe8e57171f303ad8f6e3fd17d949b0bfc7b4db6e8e30a71cc517d7e",
//       "sampleAccount": "0x35552c16704d214347f29Fa77f77DA6d75d7C752"
//     },
//     "info": {
//       "url": "https://www.binance.org/en/smartChain",
//       "client": "https://github.com/binance-chain/bsc",
//       "clientPublic": "https://data-seed-prebsc-1-s1.binance.org:8545",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     },
//     "deprecated": true
//   },
//   {
//     "id": "smartchain",
//     "name": "Smart Chain",
//     "coinId": 20000714,
//     "slip44": 714,
//     "symbol": "BNB",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/60'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://bscscan.com",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "0xb9ae2e808fe8e57171f303ad8f6e3fd17d949b0bfc7b4db6e8e30a71cc517d7e",
//       "sampleAccount": "0x35552c16704d214347f29Fa77f77DA6d75d7C752"
//     },
//     "info": {
//       "url": "https://www.binance.org/en/smartChain",
//       "client": "https://github.com/binance-chain/bsc",
//       "clientPublic": "https://bsc-dataseed1.binance.org",
//       "clientDocs": "https://eth.wiki/json-rpc/API"
//     }
//   },
//   {
//     "id": "polygon",
//     "name": "Polygon",
//     "coinId": 966,
//     "symbol": "MATIC",
//     "decimals": 18,
//     "blockchain": "Ethereum",
//     "derivationPath": "m/44'/60'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1Extended",
//     "explorer": {
//       "url": "https://explorer.matic.network/",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "0xe26ed1470d5bf99a53d687843e7acdf7e4ba6620af93b4d672e714de90476e8e",
//       "sampleAccount": "0x720E1fa107A1Df39Db4E78A3633121ac36Bec132"
//     },
//     "info": {
//       "url": "https://polygon.technology",
//       "client": "https://github.com/maticnetwork/contracts",
//       "clientPublic": "https://rpc-mainnet.matic.network",
//       "clientDocs": "https://github.com/ethereum/wiki/wiki/JSON-RPC"
//     }
//   },
//   {
//     "id": "thorchain",
//     "name": "THORChain",
//     "coinId": 931,
//     "symbol": "RUNE",
//     "decimals": 8,
//     "blockchain": "Cosmos",
//     "derivationPath": "m/44'/931'/0'/0/0",
//     "curve": "secp256k1",
//     "publicKeyType": "secp256k1",
//     "hrp": "thor",
//     "explorer": {
//       "url": "https://viewblock.io/thorchain",
//       "txPath": "/tx/",
//       "accountPath": "/address/",
//       "sampleTx":
//           "ADF0899E58C177E2391F22D04E9C5E1C35BB0F75B42B363A0761687907FD9476",
//       "sampleAccount": "bnb1czhptncu9uhhlrlrk9q0rmy459gae2ua79mapn"
//     },
//     "info": {
//       "url": "https://thorchain.org",
//       "client": "https://gitlab.com/thorchain/thornode",
//       "clientPublic": "https://seed.thorchain.info",
//       "clientDocs": ""
//     }
//   }
// ];

// class Blockchain {
//   final String name;
//   final String derivationPath;
//   final bool isHaveToken;

//   const Blockchain({
//     required this.name,
//     required this.derivationPath,
//     required this.isHaveToken,
//   });

//   String get network => name + 'Net work';

//   List<Blockchain> get supports => [
//         bitcoin,
//         ethereum,
//         binanceSmartChain,
//       ];

//   static const bitcoin = Blockchain(
//     name: 'Bitcoin',
//     derivationPath: "m/84'/0'/0'/0/",
//     isHaveToken: false,
//   );

//   static const ethereum = Blockchain(
//     name: 'Ethereum',
//     derivationPath: "m/44'/60'/0'/0/",
//     isHaveToken: false,
//   );

//   static const binanceSmartChain = Blockchain(
//     name: 'Binance Smart Chain',
//     derivationPath: "m/44'/60'/0'/0/",
//     isHaveToken: false,
//   );

//   // static String network(int network) {
//   //   switch (network) {
//   //     case bitcoin:
//   //       return 'Bitcoin Network';
//   //     case ethereum:
//   //       return 'Ethereum Network';
//   //     case smartChain:
//   //       return 'Binance Smart Chain Network';
//   //     default:
//   //       return 'Network not support';
//   //   }
//   // }
//   // String getDerivationPath({
//   //   required int network,
//   //   required int index,
//   // }) {
//   //   switch (network) {
//   //     case bitcoin:
//   //       return "m/84'/0'/0'/0/${index}";
//   //     case ethereum:
//   //       return "m/44'/60'/0'/0/${index}";
//   //     case smartChain:
//   //       return "m/44'/60'/0'/0/${index}";
//   //     default:
//   //       return "m/84'/0'/0'/0/${index}";
//   //   }
//   // }
// }
