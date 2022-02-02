// bitcoin
const List<Map<String, dynamic>> COINS_BITCOIN = [
  {
    'id': 'bitcoin',
    'name': 'Bitcoin',
    'symbol': 'BTC',
    'decimals': 8,
    'type': 'COIN',
    'contractAddress': '',
    'status': 'active',
    'blockchainId': 'bitcoin',
    'image':
        'https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579'
  },
];

// binance-smart-chain
const COINS_BINANCE_SMARTCHAIN = [
  {
    'id': 'binancecoin',
    'name': 'Binance Smart Chain',
    'symbol': 'BNB',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '',
    'type': 'COIN',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png?1547034615'
  },
  {
    'id': 'ethereum',
    'name': 'Binance-Peg Ethereum Token',
    'symbol': 'ETH',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x2170ed0880ac9a755fd29b2688956bd959f933f8',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880'
  },
  {
    'id': 'wbnb',
    'name': 'Wrapped BNB',
    'symbol': 'WBNB',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12591/large/binance-coin-logo.png?1600947313'
  },
  {
    'id': 'tether',
    'name': 'Binance-Peg BSC-USD',
    'symbol': 'BSC-USD',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x55d398326f99059ff775485246999027b3197955',
    'type': 'BEP20',
    'status': 'active',
    'image': 'https://bscscan.com/token/images/busdt_32.png'
  },
  {
    'id': 'binance-peg-cardano',
    'name': 'Binance-Peg Cardano Token',
    'symbol': 'ADA',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x3ee2200efb3400fabb9aacf31297cbdd1d435d47',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/15455/large/ZE8LxNBf_400x400.jpg?1620894681'
  },
  {
    'id': 'binance-peg-dogecoin',
    'name': 'Binance-Peg Dogecoin',
    'symbol': 'DOGE',
    'decimals': 8,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0xba2ae424d960c26247dd6c32edc70b295c744c43',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/15768/large/dogecoin.png?1621833687'
  },
  {
    'id': 'binance-peg-xrp',
    'name': 'Binance-Peg XRP Token',
    'symbol': 'XRP',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x1d2f0da169ceb9fc7b3144628db156f3f6c60dbe',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/15458/large/ryyrCapt_400x400.jpg?1620895978'
  },
  {
    'id': 'usd-coin',
    'name': 'Binance-Peg USD Coin',
    'symbol': 'USDC',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/6319/large/USD_Coin_icon.png?1547042389'
  },
  {
    'id': 'binance-peg-polkadot',
    'name': 'Binance-Peg Polkadot Token',
    'symbol': 'DOT',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x7083609fce4d1d8dc0c979aab8c869ea2c873402',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/15457/large/-Tj2WF_6_400x400.jpg?1620895613'
  },
  {
    'id': 'binance-peg-uniswap',
    'name': 'Binance-Peg Uniswap',
    'symbol': 'UNI',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0xbf5140a22578168fd562dccf235e5d43a02ce9b1',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/15459/large/wG2eTAfD_400x400.jpg?1620896413'
  },
  {
    'id': 'binance-usd',
    'name': 'Binance-Peg BUSD Token',
    'symbol': 'BUSD',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0xe9e7cea3dedca5984780bafc599bd69add087d56',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9576/large/BUSD.png?1568947766'
  },
  {
    'id': 'binance-peg-bitcoin-cash',
    'name': 'Binance-Peg Bitcoin Cash Token',
    'symbol': 'BCH',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x8ff795a6f4d97e7887c79bea79aba5cc76444adf',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/15774/large/bitcoin-cash-circle.png?1621834955'
  },
  {
    'id': 'binance-peg-litecoin',
    'name': 'Binance-Peg Litecoin Token',
    'symbol': 'LTC',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x4338665cbb7b2485a8855a139b75d5e34ab0db94',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/15456/large/LrysCc5Q_400x400.jpg?1620895206'
  },
  {
    'id': 'chainlink',
    'name': 'Binance-Peg ChainLink Token',
    'symbol': 'LINK',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0xf8a0bf9cf54bb92f17374d9e9a321e6a111a51bd',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/877/large/chainlink-new-logo.png?1547034700'
  },
  {
    'id': 'dai',
    'name': 'Binance-Peg Dai Token',
    'symbol': 'DAI',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9956/large/dai-multi-collateral-mcd.png?1574218774'
  },
  {
    'id': 'ethereum-classic',
    'name': 'Binance-Peg Ethereum Classic',
    'symbol': 'ETC',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x3d6545b08693dae087e957cb1180ee38b9e3c25e',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/453/large/ethereum-classic-logo.png?1547034169'
  },
  {
    'id': 'binance-peg-eos',
    'name': 'Binance-Peg EOS Token',
    'symbol': 'EOS',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x56b6fb708fc5732dec1afc8d8556423a2edccbd6',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/15771/large/eos-eos-logo.png?1621834238'
  },
  {
    'id': 'pancakeswap-token',
    'name': 'PancakeSwap Token',
    'symbol': 'CAKE',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12632/large/IMG_0440.PNG?1602654093'
  },
  {
    'id': 'binance-bitcoin',
    'name': 'Binance-Peg BTCB Token',
    'symbol': 'BTCB',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x7130d2a12b9bcbfae4f2634d864a1ee1ce3ead9c',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/14108/large/Binance-bitcoin.png?1617332330'
  },
  {
    'id': 'tezos',
    'name': 'Binance-Peg Tezos Token',
    'symbol': 'XTZ',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x16939ef78684453bfdfb47825f8a5f714f12623a',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/976/large/Tezos-logo.png?1547034862'
  },
  {
    'id': 'maker',
    'name': 'Binance-Peg Maker',
    'symbol': 'MKR',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x5f0da599bb2cccfcf6fdfd7d81743b6020864350',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/1364/large/Mark_Maker.png?1585191826'
  },
  {
    'id': 'cosmos',
    'name': 'Binance-Peg Cosmos Token',
    'symbol': 'ATOM',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x0eb3a705fc54725037cc9e008bdede697f62f335',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/1481/large/cosmos_hub.png?1555657960'
  },
  {
    'id': 'safemoon',
    'name': 'SafeMoon',
    'symbol': 'SAFEMOON',
    'decimals': 9,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x8076c74c5e3f5852037f31ff0093eeb8c8add8d3',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/14362/large/174x174-white.png?1617174846'
  },
  {
    'id': 'ltd',
    'name': 'LTD Token',
    'symbol': 'LTD',
    'decimals': 18,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x0f7cd24e31293b162dcf6211c6ac5bd8efcb81f4',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/4df651321b566bab4483d5f7613fec9553cb895d.png'
  },
  {
    'id': 'vndc',
    'name': 'Token VNDC',
    'symbol': 'VNDC',
    'decimals': 0,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0xdde5b33a56f3f1c22e5a6bd8429e6ad508bff24e',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9670/large/vndc-gold-coin.png?1571032826'
  },
  {
    'id': 'vidb',
    'name': 'VNDC International Digital Banking',
    'symbol': 'VIDB',
    'decimals': 8,
    'blockchainId': 'binance-smart-chain',
    'contractAddress': '0x90dc17d47d739ee84d61bd0ec828a24881e2a0b4',
    'type': 'BEP20',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/dca0334f63dc677d896e3b657bf95a519e47e3a8.png'
  },
];

// ethereum
const COINS_ETHEREUM = [
  {
    'id': 'ethereum',
    'name': 'Ethereum',
    'symbol': 'ETH',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '',
    'type': 'COIN',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880'
  },
  {
    'id': 'tether',
    'name': 'Tether',
    'symbol': 'USDT',
    'decimals': 6,
    'blockchainId': 'ethereum',
    'contractAddress': '0xdac17f958d2ee523a2206206994597c13d831ec7',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/325/large/Tether-logo.png?1598003707'
  },
  {
    'id': 'weth',
    'name': 'Wrapped Ether',
    'symbol': 'WETH',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/2518/large/weth.png?1547036627'
  },
  {
    'id': 'binancecoin',
    'name': 'Binance ERC20',
    'symbol': 'BNB',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xB8c77482e45F1F44dE1745F52C74426C631bDD52',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png?1547034615'
  },
  {
    'id': 'usd-coin',
    'name': 'USD Coin',
    'symbol': 'USDC',
    'decimals': 6,
    'blockchainId': 'ethereum',
    'contractAddress': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/6319/large/USD_Coin_icon.png?1547042389'
  },
  {
    'id': 'hex',
    'name': 'HEX',
    'symbol': 'HEX',
    'decimals': 8,
    'blockchainId': 'ethereum',
    'contractAddress': '0x2b591e99afe9f32eaa6214f7b7629768c40eeb39',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/10103/large/HEX-logo.png?1575942673'
  },
  {
    'id': 'uniswap',
    'name': 'Uniswap',
    'symbol': 'UNI',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12504/large/uniswap-uni.png?1600306604'
  },
  {
    'id': 'binance-usd',
    'name': 'Binance USD',
    'symbol': 'BUSD',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x4fabb145d64652a948d72533023f6e7a623c7c53',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9576/large/BUSD.png?1568947766'
  },
  {
    'id': 'chainlink',
    'name': 'ChainLink Token',
    'symbol': 'LINK',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x514910771af9ca656af840dff83e8264ecf986ca',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/877/large/chainlink-new-logo.png?1547034700'
  },
  {
    'id': 'theta-token',
    'name': 'Theta Token',
    'symbol': 'THETA',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x3883f5e181fccaf8410fa61e12b59bad963fb645',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/2538/large/theta-token-logo.png?1548387191'
  },
  {
    'id': 'wrapped-bitcoin',
    'name': 'Wrapped BTC',
    'symbol': 'WBTC',
    'decimals': 8,
    'blockchainId': 'ethereum',
    'contractAddress': '0x2260fac5e5542a773aa44fbcfedf7c193bc2c599',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/7598/large/wrapped_bitcoin_wbtc.png?1548822744'
  },
  {
    'id': 'vechain-old-erc20',
    'name': 'VeChain',
    'symbol': 'VEN',
    'decimals': 18,
    'contractAddress': '0xd850942ef8811f2a866692a623011bde52a462c1',
    'blockchainId': 'ethereum',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9959/large/VeChain-Logo-768x725.png?1574145145'
  },
  {
    'id': 'wrapped-filecoin',
    'name': 'Wrapped Filecoin',
    'symbol': 'WFIL',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x6e1A19F235bE7ED8E3369eF73b196C07257494DE',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/13238/large/WFIL.png?1623827165'
  },
  {
    'id': 'dai',
    'name': 'Dai Stablecoin',
    'symbol': 'DAI',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x6b175474e89094c44da98b954eedeac495271d0f',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9956/large/dai-multi-collateral-mcd.png?1574218774'
  },
  {
    'id': 'tron',
    'name': 'TRON',
    'symbol': 'TRX',
    'decimals': 6,
    'blockchainId': 'ethereum',
    'contractAddress': '0xe1be5d3f34e89de342ee97e6e90d405884da6c67',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/1094/large/tron-logo.png?1547035066'
  },
  {
    'id': 'amp-token',
    'name': 'Amp',
    'symbol': 'AMP',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xff20817765cb7f73d4bde2e66e067e58d11095c2',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12409/large/amp-200x200.png?1599625397'
  },
  {
    'id': 'okb',
    'name': 'OKB',
    'symbol': 'OKB',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x75231f58b43240c9718dd58b4967c5114342a86c',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/4463/large/okb_token.png?1548386209'
  },
  {
    'id': 'cdai',
    'name': 'Compound Dai',
    'symbol': 'cDAI',
    'decimals': 8,
    'blockchainId': 'ethereum',
    'contractAddress': '0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9281/large/cDAI.png?1576467585'
  },
  {
    'id': 'compound-usd-coin',
    'name': 'Compound USD Coin',
    'symbol': 'CUSDC',
    'decimals': 8,
    'blockchainId': 'ethereum',
    'contractAddress': '0x39aa39c021dfbae8fac545936693ac917d5e7563',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9442/large/Compound_USDC.png?1567581577'
  },
  {
    'id': 'crypto-com-chain',
    'name': 'Crypto.com Coin',
    'symbol': 'CRO',
    'decimals': 8,
    'blockchainId': 'ethereum',
    'contractAddress': '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/7310/large/cypto.png?1547043960'
  },
  {
    'id': 'celsius-degree-token',
    'name': 'Celsius',
    'symbol': 'CEL',
    'decimals': 4,
    'blockchainId': 'ethereum',
    'contractAddress': '0xaaaebe6fe48e54f431b0c390cfaf0b017d09d42d',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/3263/large/CEL_logo.png?1609598753'
  },
  {
    'id': 'compound-ether',
    'name': 'Compound Ether',
    'symbol': 'CETH',
    'decimals': 8,
    'blockchainId': 'ethereum',
    'contractAddress': '0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/10643/large/ceth2.JPG?1581389598'
  },
  {
    'id': 'leo-token',
    'name': 'Bitfinex LEO Token',
    'symbol': 'LEO',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x2af5d2ad76741191d15dfe7bf6ac92d4bd912ca3',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/1364/large/Mark_Maker.png?1585191826'
  },
  {
    'id': 'maker',
    'name': 'Maker',
    'symbol': 'MKR',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/1364/large/Mark_Maker.png?1585191826'
  },
  {
    'id': 'huobi-token',
    'name': 'HuobiToken',
    'symbol': 'HT',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x6f259637dcd74c767781e37bc6133cd6a68aa161',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/2822/large/huobi-token-logo.png?1547036992'
  },
  {
    'id': 'bittorrent-2',
    'name': 'BitTorrent',
    'symbol': 'BTT',
    'decimals': 6,
    'blockchainId': 'ethereum',
    'contractAddress': '0xe83cccfabd4ed148903bf36d4283ee7c8b3494d1',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/7595/large/BTT_Token_Graphic.png?1555066995'
  },
  {
    'id': 'terrausd',
    'name': 'Wrapped UST Token',
    'symbol': 'UST',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xa47c8bf37f92abed4a126bda807a7b7498661acd',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12681/large/UST.png?1601612407'
  },
  {
    'id': 'the-graph',
    'name': 'Graph Token',
    'symbol': 'GRT',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xc944e90c64b2c07662a292be6244bdf05cda44a7',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/6319/large/USD_Coin_icon.png?1547042389'
  },
  {
    'id': 'telcoin',
    'name': 'Telcoin',
    'symbol': 'TEL',
    'decimals': 2,
    'blockchainId': 'ethereum',
    'contractAddress': '0x467Bccd9d29f223BcE8043b84E8C8B282827790F',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/1899/large/tel.png?1547036203'
  },
  {
    'id': 'chiliz',
    'name': 'chiliZ',
    'symbol': 'CHZ',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x3506424f91fd33084466f402d5d97f05f8e3b4af',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/8834/large/Chiliz.png?1561970540'
  },
  {
    'id': 'compound-governance-token',
    'name': 'Compound',
    'symbol': 'COMP',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xc00e94cb662c3520282e6f5717214004a7f26888',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/10775/large/COMP.png?1592625425'
  },
  {
    'id': 'sushi',
    'name': 'SushiToken',
    'symbol': 'SHUSHI',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x6b3595068778dd592e39a122f4f5a5cf09c90fe2',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12271/large/512x512_Logo_no_chop.png?1606986688'
  },
  {
    'id': 'true-usd',
    'name': 'TrueUSD',
    'symbol': 'TUSD',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x0000000000085d4780B73119b644AE5ecd22b376',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/3449/large/tusd.png?1618395665'
  },
  {
    'id': 'huobi-btc',
    'name': 'Huobi BTC',
    'symbol': 'HBTC',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x0316EB71485b0Ab14103307bf65a021042c6d380',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12407/large/Unknown-5.png?1599624896'
  },
  {
    'id': 'havven',
    'name': 'Synthetix Network Token',
    'symbol': 'SNX',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xc011a73ee8576fb46f5e1c5751ca3b9fe0af2a6f',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/3406/large/SNX.png?1598631139'
  },
  {
    'id': 'holotoken',
    'name': 'HoloToken',
    'symbol': 'HOT',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x6c6ee5e31d828de241282b9606c8e98ea48526e2',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/3348/large/Holologo_Profile.png?1547037966'
  },
  {
    'id': 'yearn-finance',
    'name': 'yearn.finance',
    'symbol': 'YFI',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/11849/large/yfi-192x192.png?1598325330'
  },
  {
    'id': 'enjincoin',
    'name': 'EnjinCoin',
    'symbol': 'ENJ',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xf629cbd94d3791c9250152bd8dfbdf380e2a3b9c',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/1102/large/enjin-coin-logo.png?1547035078'
  },
  {
    'id': 'staked-ether',
    'name': 'stETH',
    'symbol': 'stETH',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xae7ab96520de3a18e5e111b5eaab095312d7fe84',
    'type': 'ERC20',
    'image':
        'https://assets.coingecko.com/coins/images/13442/large/steth_logo.png?1608607546'
  },
  {
    'id': 'zilliqa',
    'name': 'Zilliqa',
    'symbol': 'ZIL',
    'decimals': 12,
    'blockchainId': 'ethereum',
    'contractAddress': '0x05f4a42e251f2d52b8ed15e9fedaacfcef1fad27',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/2687/large/Zilliqa-logo.png?1547036894'
  },
  {
    'id': 'first-blood',
    'name': 'FirstBlood',
    'symbol': 'ST',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xaf30d2a7e90d7dc361c8c4585e9bb7d2f6f15bc7',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/522/large/bqJZ2qGQ_400x400.jpg?1569415098'
  },
  {
    'id': 'nexo',
    'name': 'Nexo',
    'symbol': 'NEXO',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xb62132e35a6c13ee1ee0f84dc5d40bad8d815206',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/3695/large/nexo.png?1548086057'
  },
  {
    'id': 'quant-network',
    'name': 'Quant',
    'symbol': 'QNT',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x4a220e6096b25eadb88358cb44068a3248254675',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/3370/large/5ZOu7brX_400x400.jpg?1612437252'
  },
  {
    'id': 'basic-attention-token',
    'name': 'BAT',
    'symbol': 'BAT',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x0d8775f648430679a709e98d2b0cb6250d2887ef',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/677/large/basic-attention-token.png?1547034427'
  },
  {
    'id': 'fantom',
    'name': 'Fantom Token',
    'symbol': 'FTM',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x4e15361fd6b4bb609fa63c81a2be19d873717870',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/4001/large/Fantom.png?1558015016'
  },
  {
    'id': 'paxos-standard',
    'name': 'Paxos Standard',
    'symbol': 'PAX',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x8e870d67f660d95d5be530380d0ec0bd388289e1',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/6013/large/paxos_standard.png?1548386291'
  },
  {
    'id': 'xdce-crowd-sale',
    'name': 'XinFin XDCE',
    'symbol': 'XDCE',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x41ab1b6fcbb2fa9dced81acbdec13ea6315f2bf2',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/6319/large/USD_Coin_icon.png?1547042389'
  },
  {
    'id': 'bancor',
    'name': 'Bancor',
    'symbol': 'BNT',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x1f573d6fb3f13d689ff844b4ce37794d79a7ff1c',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/736/large/bancor.png?1547034477'
  },
  {
    'id': 'harmony',
    'name': 'HarmonyOne',
    'symbol': 'ONE',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x799a4202c12ca952cb311598a024c80ed371a41e',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/4344/large/Y88JAze.png?1565065793'
  },
  {
    'id': '0x',
    'name': 'ZRX',
    'symbol': 'ZRX',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0xe41d2489571d322189246dafa5ebde1f4699f498',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/863/large/0x.png?1547034672'
  },
  {
    'id': 'uma',
    'name': 'UMA Voting Token v1',
    'symbol': 'UMA',
    'decimals': 18,
    'blockchainId': 'ethereum',
    'contractAddress': '0x04Fa0d235C4abf4BcF4787aF4CF447DE572eF828',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/10951/large/UMA.png?1586307916'
  },
  {
    'id': 'husd',
    'name': 'HUSD',
    'symbol': 'HUSD',
    'decimals': 8,
    'blockchainId': 'ethereum',
    'contractAddress': '0xdf574c24545e5ffecb9a659c229253d4111d87e1',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9567/large/HUSD.jpg?1568889385'
  },
  {
    'id': 'vndc',
    'name': 'Token VNDC',
    'symbol': 'VNDC',
    'decimals': 0,
    'blockchainId': 'ethereum',
    'contractAddress': '0x1f3f677ecc58f6a1f9e2cf410df4776a8546b5de',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9670/large/vndc-gold-coin.png?1571032826'
  },
  {
    'id': 'vidb',
    'name': 'VNDC International Digital Banking',
    'symbol': 'VIDB',
    'decimals': 8,
    'blockchainId': 'ethereum',
    'contractAddress': '0xbfce0c7d3ba3a7f7a039521fe371a87bf84baad4',
    'type': 'ERC20',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/dca0334f63dc677d896e3b657bf95a519e47e3a8.png'
  },
];

// kardiaChain
const List<Map<String, dynamic>> COINS_KARDIACHAIN = [
  {
    'id': 'kardiachain',
    'name': 'KardiaChain',
    'symbol': 'KAI',
    'decimals': 18,
    'type': 'COIN',
    'contractAddress': '',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/7942/large/KardiaChain.png?1591631223'
  },
  {
    'id': 'DefilyToken',
    'name': 'DefilyToken',
    'symbol': 'DFL',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0xD675fF2B0ff139E14F86D87b7a6049ca7C66d76e',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/D675fF2B0ff139E14F86D87b7a6049ca7C66d76e.png'
  },
  {
    'id': 'BecoSwap Token',
    'name': 'BecoSwap Token',
    'symbol': 'BECO',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0x2Eddba8b949048861d2272068A94792275A51658',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/2Eddba8b949048861d2272068A94792275A51658.png'
  },
  {
    'id': 'Token KUSD-T',
    'name': 'Token KUSD-T',
    'symbol': 'KUSD-T',
    'decimals': 6,
    'type': 'KRC20',
    'contractAddress': '0x92364Ec610eFa050D296f1EEB131f2139FB8810e',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/cc6f1ef0dd2233dc4014c5a56e50dc938a9f9a74.png'
  },
  {
    'id': 'WrappedKAI',
    'name': 'Wrapped KAI',
    'symbol': 'WKAI',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0xAF984E23EAA3E7967F3C5E007fbe397D8566D23d',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/AF984E23EAA3E7967F3C5E007fbe397D8566D23d.png'
  },
  {
    'id': 'my-defi-pet',
    'name': 'My DeFi Pet Token',
    'symbol': 'DPET',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0xfb62AE373acA027177D1c18Ee0862817f9080d08',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/edc8284279cb6efa3953a9a0806653d7b3717d52.png'
  },
  {
    'id': 'DRAGON',
    'name': 'DRAGON',
    'symbol': 'DRAGON',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0x18f4f7A1fa6F2c93d40d4Fd83c67E93B88d3a0b1',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/6f26989c87ebcbaaec5ca25faaa3cfc6ca45a570.png'
  },
  {
    'id': 'sleepearn.finance',
    'name': 'sleepearn.finance',
    'symbol': 'SEN',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0xb697231730C004110A86f51BfF4B8DD085c0CB28',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/b697231730C004110A86f51BfF4B8DD085c0CB28.png'
  },
  {
    'id': 'BossDoge',
    'name': 'BossDoge',
    'symbol': 'BossDoge',
    'decimals': 9,
    'type': 'KRC20',
    'contractAddress': '0x5995F16246DfA676A44B8bD7E751C1226093dcd7',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/65076cfb9adce82d96a7e95fa549b99bb245a4b8.png'
  },
  {
    'id': 'Kephi Token',
    'name': 'Kephi Token',
    'symbol': 'KPHI',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0x6CD689DefCA80f9F2CBED9D0C6f3B2Cf4abc4598',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/d9aa394a71ca66bdd61061b54630f82619dbb950.png'
  },
  {
    'id': '100MAN',
    'name': '100MAN',
    'symbol': 'MAN',
    'decimals': 8,
    'type': 'KRC20',
    'contractAddress': '0x0acfaa0d0ccA295672E09ad906240C03D54F286a',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/861925fee53a3c8fa3a49bcc2a286c54560a2c8f.png'
  },
  {
    'id': 'Trustpay Token',
    'name': 'Trustpay Token',
    'symbol': 'TPH',
    'decimals': 8,
    'type': 'KRC20',
    'contractAddress': '0xc1c319434bd861A335752b4b6993C13f139B26fa',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/2cb25dd27b1f7733d4f33e855c281634e0174a98.png'
  },
  {
    'id': 'Vietnam Gold Token',
    'name': 'Vietnam Gold Token',
    'symbol': 'CHI',
    'decimals': 3,
    'type': 'KRC20',
    'contractAddress': '0xf8bB30c912a46f57F2B499111cb536dB13A044c3',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/f8bB30c912a46f57F2B499111cb536dB13A044c3.png'
  },
  {
    'id': 'FAM Token',
    'name': 'FAM Token',
    'symbol': 'FAM',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0xA137f7e4189492D8480dE03c71e3F2B0b545Eb64',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/935d6e6e897dbf1e0276667cc3f53a4b807fff00.png'
  },
  {
    'id': 'LGBT Token',
    'name': 'LGBT Token',
    'symbol': 'LGBT',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0x28bA261e7AbD7E00937f7b5862c7097378eb9369',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/219fa73102e05f6cb8a2dfe110062a0c8d9738e3.png'
  },
  {
    'id': 'MOONKA Token',
    'name': 'MOONKA Token',
    'symbol': 'MKA',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0xbFb1398F4755E861620d25A1Df6Bb8ff25252377',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/c6d8f449b89c5a54a79898c54ad1d33f7928016b.png'
  },
  {
    'id': 'Bami Token',
    'name': 'Bami Token',
    'symbol': 'BAMI',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0xb3b39589Cf5ECf173e5191cdef3563f7677E3703',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/8ba06e038355348ea0f453f75d0552cfdaa752ea.png'
  },
  {
    'id': 'Token GO24',
    'name': 'Token GO24',
    'symbol': 'GO24',
    'decimals': 8,
    'type': 'KRC20',
    'contractAddress': '0xbE8752b4141bBA97A1659D7f27FF9f8b8B492692',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/d570e228e0af1d3c8d3196496e14845d93ee9a48.png'
  },
  {
    'id': 'Token SHC',
    'name': 'Token SHC',
    'symbol': 'SHC',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0x7c3c1eb131f0d0051c46D035F42900905752238C',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/0485c5b03ec228603b604c57d2203fe69500cf26.webp'
  },
  {
    'id': 'Big Digital Shares',
    'name': 'Big Digital Shares',
    'symbol': 'BDS',
    'decimals': 8,
    'type': 'KRC20',
    'contractAddress': '0x72b7181bd4a0B67Ca7dF2c7778D8f70455DC735b',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/7bb06c6ef5a2737dc4fd7dfb60ea71bf97096bdb.png'
  },
  {
    'id': 'ltd',
    'name': 'LTD Token',
    'symbol': 'LTD',
    'decimals': 18,
    'type': 'KRC20',
    'contractAddress': '0xf631BdC21A77AFAc69B9B3e966E85d7fBcf00b1f',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/4df651321b566bab4483d5f7613fec9553cb895d.png'
  },
  {
    'id': 'vndc',
    'name': 'Token VNDC',
    'symbol': 'VNDC',
    'decimals': 0,
    'type': 'KRC20',
    'contractAddress': '0xeFF34B63f55200a9D635B8ABBBFCC719b4977864',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9670/large/vndc-gold-coin.png?1571032826'
  },
  {
    'id': 'vidb',
    'name': 'VNDC International Digital Banking',
    'symbol': 'VIDB',
    'decimals': 8,
    'type': 'KRC20',
    'contractAddress': '0x75b9d2A0007A6866e32Ac0A976FeF60ccA151f87',
    'blockchainId': 'kardiachain',
    'status': 'active',
    'image':
        'https://kardiachain-explorer.s3-ap-southeast-1.amazonaws.com/explorer.kardiachain.io/logo/dca0334f63dc677d896e3b657bf95a519e47e3a8.png'
  },
];

// stellar
const List<Map<String, dynamic>> COINS_STELLAR = [
  {
    'id': 'stellar',
    'name': 'Stellar',
    'symbol': 'XLM',
    'decimals': 7,
    'type': 'COIN',
    'contractAddress': '',
    'blockchainId': 'stellar',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/100/large/Stellar_symbol_black_RGB.png?1552356157'
  },
];

// pi testnet
const List<Map<String, dynamic>> COINS_PI = [
  {
    'id': 'pi',
    'name': 'Pi',
    'symbol': 'PI',
    'decimals': 7,
    'type': 'COIN',
    'contractAddress': '',
    'blockchainId': 'pitestnet',
    'status': 'active',
    'image': 'https://developers.minepi.com/static/media/logo.77e93b0b.png'
  },
];

// pi tron
const List<Map<String, dynamic>> COINS_TRON = [
  {
    'id': 'tron',
    'name': 'TRON',
    'symbol': 'TRX',
    'decimals': 6,
    'type': 'COIN',
    'contractAddress': '',
    'blockchainId': 'tron',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/1094/large/tron-logo.png?1547035066'
  },
  {
    'id': 'tether',
    'name': 'Tether USD',
    'symbol': 'USDT',
    'decimals': 6,
    'blockchainId': 'tron',
    'contractAddress': 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t',
    'type': 'TRC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/325/large/Tether-logo.png?1598003707'
  },
  {
    'id': 'usd-coin',
    'name': 'USD Coin',
    'symbol': 'USDC',
    'decimals': 6,
    'blockchainId': 'tron',
    'contractAddress': 'TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8',
    'type': 'TRC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/6319/large/USD_Coin_icon.png?1547042389'
  },
  {
    'id': 'justbet',
    'name': 'WINkLink',
    'symbol': 'WIN',
    'decimals': 6,
    'blockchainId': 'tron',
    'contractAddress': 'TLa2f6VPqDgRE67v1736s7bJ8Ray5wYjU7',
    'type': 'TRC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12886/large/WINR.png?1603270935'
  },
  {
    'id': 'just-stablecoin',
    'name': 'JUST Stablecoin',
    'symbol': 'USDJ',
    'decimals': 18,
    'blockchainId': 'tron',
    'contractAddress': 'TMwFHYXLJaRUPeW6421aqXL4ZEzPRFGkGT',
    'type': 'TRC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/10998/large/usdj.png?1587026569'
  },
  {
    'id': 'true-usd',
    'name': 'TrueUSD',
    'symbol': 'TUSD',
    'decimals': 18,
    'blockchainId': 'tron',
    'contractAddress': 'TUpMhErZL2fhh4sVNULAbNKLokS4GjC1F4',
    'type': 'TRC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/3449/large/tusd.png?1618395665'
  },
  {
    'id': 'just',
    'name': 'JUST',
    'symbol': 'JST',
    'decimals': 18,
    'blockchainId': 'tron',
    'contractAddress': 'TCFLL5dx5ZJdKnWuesXxi1VPwjLVmWZZy9',
    'type': 'TRC20',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/11095/large/JUST.jpg?1588175394'
  },
];

// pi polygon
const List<Map<String, dynamic>> COINS_POLYGON = [
  {
    'id': 'matic-network',
    'name': 'MATIC',
    'symbol': 'MATIC',
    'decimals': 18,
    'type': 'COIN',
    'contractAddress': '',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png?1624446912'
  },
  {
    'id': 'tether',
    'name': 'Tether USD',
    'symbol': 'USDT',
    'decimals': 6,
    'type': 'POLYGON ERC20',
    'contractAddress': '0xc2132d05d31c914a87c6611c10748aeb04b58e8f',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/325/large/Tether-logo.png?1598003707'
  },
  {
    'id': 'binancecoin',
    'name': 'BNB',
    'symbol': 'BNB',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0x3BA4c387f786bFEE076A58914F5Bd38d668B42c3',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png?1547034615'
  },
  {
    'id': 'usd-coin',
    'name': 'USD Coin',
    'symbol': 'USDT',
    'decimals': 6,
    'type': 'POLYGON ERC20',
    'contractAddress': '0x2791bca1f2de4661ed88a30c99a7a9449aa84174',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/6319/large/USD_Coin_icon.png?1547042389'
  },
  {
    'id': 'binance-usd',
    'name': 'Binance USD',
    'symbol': 'BUSD',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0xdab529f40e671a1d4bf91361c21bf9f0c9712ab7',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9576/large/BUSD.png?1568947766'
  },
  {
    'id': 'uniswap',
    'name': 'Uniswap',
    'symbol': 'UNI',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0xb33eaad8d922b1083446dc23f610c2567fb5180f',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12504/large/uniswap-uni.png?1600306604'
  },
  {
    'id': 'chainlink',
    'name': 'ChainLink Token',
    'symbol': 'LINK',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0x53e0bca35ec356bd5dddfebbd1fc0fd03fabad39',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/877/large/chainlink-new-logo.png?1547034700'
  },
  {
    'id': 'wrapped-bitcoin',
    'name': 'Wrapped BTC',
    'symbol': 'WBTC',
    'decimals': 8,
    'type': 'POLYGON ERC20',
    'contractAddress': '0x1bfd67037b42cf73acf2047067bd4f2c47d9bfd6',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/7598/large/wrapped_bitcoin_wbtc.png?1548822744'
  },
  {
    'id': 'theta-token',
    'name': 'Theta Token',
    'symbol': 'THETA',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0xb46e0ae620efd98516f49bb00263317096c114b2',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/2538/large/theta-token-logo.png?1548387191'
  },
  {
    'id': 'dai',
    'name': 'Dai Stablecoin',
    'symbol': 'DAI',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0x8f3cf7ad23cd3cadbd9735aff958023239c6a063',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/9956/large/dai-multi-collateral-mcd.png?1574218774'
  },
  {
    'id': 'aave',
    'name': 'Aave',
    'symbol': 'AAVE',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0xd6df932a45c0f255f85145f286ea0b292b21c90b',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/12645/large/AAVE.png?1601374110'
  },
  {
    'id': 'wmatic',
    'name': 'Wrapped Matic',
    'symbol': 'WMATIC',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0x0d500b1d8e8ef31e21c99d1db9a6444d3adf1270',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/14073/large/matic.jpg?1614155404'
  },
  {
    'id': 'quick',
    'name': 'Quickswap',
    'symbol': 'QUICK',
    'decimals': 18,
    'type': 'POLYGON ERC20',
    'contractAddress': '0x831753dd7087cac61ab5644b308642cc1c33dc13',
    'blockchainId': 'polygon-pos',
    'status': 'active',
    'image':
        'https://assets.coingecko.com/coins/images/13970/large/1_pOU6pBMEmiL-ZJVb0CYRjQ.png?1613386659'
  },
];
