const List<Map<String, dynamic>> BLOCKCHAIN_SUPPORT = [
  {
    'id': 'bitcoin',
    'coinType': 0,
    'name': 'Bitcoin',
    'coin': 'bitcoin',
    'derivationPath': "m/84'/0'/0'/0/0",
    'nodeHttp': 'https://blockstream.info/api',
    'nodeWss': '',
    'api': 'https://api.blockcypher.com/v1/btc/main',
    'image':
        'https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579'
  },
  {
    'id': 'ethereum',
    'coinType': 60,
    'name': 'Ethereum',
    'coin': 'ethereum',
    'derivationPath': "m/44'/60'/0'/0/0",
    'nodeHttp': 'https://mainnet.infura.io/v3/f65c68ec7a2a4660aec71b82727181f6',
    'nodeWss': 'https://mainnet.infura.io/v3/f65c68ec7a2a4660aec71b82727181f6',
    'api': 'https://api.etherscan.io/api',
    'image':
        'https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880'
  },
  {
    'id': 'binance-smart-chain',
    'coinType': 20000714,
    'name': 'Binance Smart Chain',
    'coin': 'binancecoin',
    'derivationPath': "m/44'/60'/0'/0/0",
    'nodeHttp': 'https://bsc-dataseed.binance.org/',
    'nodeWss': 'wss://bsc-ws-node.nariox.org:443',
    'api': 'https://api.bscscan.com/api',
    'image':
        'https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png?1547034615'
  },
  {
    'id': 'tron',
    'coinType': 195,
    'name': 'Tron',
    'coin': 'tron',
    'derivationPath': "m/44'/195'/0'/0/0",
    'nodeHttp': 'https://api.trongrid.io',
    'nodeWss': 'https://api.trongrid.io',
    'api': 'https://api.trongrid.io',
    'image':
        'https://assets.coingecko.com/coins/images/1094/large/tron-logo.png?1547035066'
  },
  {
    'id': 'kardiachain',
    'coinType': 60,
    'name': 'KardiaChain',
    'coin': 'kardiachain',
    'derivationPath': "m/44'/60'/0'/0/0",
    'nodeHttp': 'https://rpc.kardiachain.io',
    'nodeWss': 'wss://ws.kardiachain.io',
    'api': '',
    'image':
        'https://assets.coingecko.com/coins/images/7942/large/KardiaChain.png?1591631223'
  },
  {
    'id': 'stellar',
    'coinType': 148,
    'name': 'Stellar',
    'coin': 'stellar',
    'derivationPath': "m/44'/148'/0'",
    'nodeHttp': 'https://horizon.stellar.org',
    'nodeWss': 'https://horizon.stellar.org',
    'api': '',
    'image':
        'https://assets.coingecko.com/coins/images/100/large/Stellar_symbol_black_RGB.png?1552356157'
  },
  {
    'id': 'pitestnet',
    'coinType': 148,
    'name': 'Pi Testnet',
    'coin': 'pi',
    'derivationPath': "m/44'/314159'/0'",
    'nodeHttp': 'https://api.testnet.minepi.com',
    'nodeWss': 'https://api.testnet.minepi.com',
    'api': '',
    'image': 'https://developers.minepi.com/static/media/logo.77e93b0b.png'
  },
  {
    'id': 'polygon-pos',
    'coinType': 966,
    'name': 'Polygon',
    'coin': 'matic-network',
    'derivationPath': "m/44'/60'/0'/0/0",
    'nodeHttp': 'https://rpc-mainnet.maticvigil.com',
    'nodeWss': 'wss://rpc-mainnet.maticvigil.com/ws',
    'api': 'https://api.polygonscan.com/api',
    'image':
        'https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png?1624446912'
  },
];
