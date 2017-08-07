# Kraken Swift


### IMPORTANT

Please thoroughly vet everything in the code for yourself before using this lib to buy, sell, or move any of your assets.

PLEASE submit an issue or pull request if you notice any bugs, security holes, or potential improvements. Any help is appreciated!


### Description

This library is a wrapper for the [Kraken Digital Asset Trading Platform](https://www.kraken.com) API. Official documentation from Kraken can be found [here](https://www.kraken.com/help/api).

The current version  can be used to query public/private data and make trades. Private data queries and trading functionality require use of your Kraken account API keys.

Kraken Swift was built by [Antonio Casero](@acaserop) 


## Installation

Using cocoapods

pod krakenClient

or using swft package manager



## Usage

Create a Kraken client using your credentials

```swift

let credentials = Kraken.Credentials(key: "0Q/eOVRtyfg+WbIuLjKJ.....",
                                     secret: "EVFTYSinNiC89V.....")
let kraken = Kraken(credentials: credentials)

kraken.serverTime(completion: { let _ = $0.map{ print($0) } } #=> 1393056191

```

### Public Data Methods

#### Server Time

This functionality is provided by Kraken to to aid in approximating the skew time between the server and client.

```swift

 kraken.serverTime { result in
    switch result {
         case .success(let serverTime):
                serverTime["unixtime"] #=> 1393056191
                serverTime["rfc1123"] #=> "Sat, 22 Feb 2014 08:28:04 GMT"
         case .failure(let error): print(error)
        }
 }

```

#### Asset Info

Returns the assets that can be traded on the exchange. This method can be passed ```info```, ```aclass``` (asset class), and ```asset``` options. An example below is given for each:

```swift
kraken.assets(completion: { let _ = $0.map{ print($0) } })

```

#### Asset Pairs

```swift
kraken.assetsPairs(completion: { let _ = $0.map{ print($0) } })
```

#### Ticker Information

```swift
  kraken.ticker(pairs: ["BCHEUR", "BCHUSD"], completion: { let _ = $0.map{ print($0) }  })
```

#### Order Book

Get market depth information for given asset pairs

```swift

depth_data = kraken.order_book('LTCXRP')
```

#### Trades

Get recent trades

```swift
trades = kraken.trades('LTCXRP')
```

#### Spread

Get spread data for a given asset pair

```swift
spread = kraken.spread('LTCXRP')
```

### Private Data Methods

#### Balance

Get account balance for each asset
Note: Rates used for the floating valuation is the midpoint of the best bid and ask prices

```swift
kraken.balance(completion: { ... })
```

#### Trade Balance

Get account trade balance

```swift
kraken.tradeBalance(completion: { ... })
```

#### Open Orders

```swift
kraken.openOrders(completion: { ... })
```

#### Closed Orders

```swift
kraken.closedOrders(completion: { ... })
```

#### Query Orders

See all orders

```swift
kraken.queryOrders(completion: { ... })
```

#### Trades History

Get array of all trades

```swift
kraken.tradeHistory(completion: { ... })
```

#### Query Trades

**Input:** Array of transaction (tx) ids

```swift
kraken.queryTrades(txids:arrayIds completion: { ... })
```

#### Open Positions

**Input:** Array of transaction (tx) ids

```swift
kraken.openPositions(txids:arrayIds completion: { ... })
```

#### Ledgers Info

```swift
kraken.ledgersInfo(completion: { ... })
```

#### Ledgers Info

**Input:** Array of ledger ids

```swift
kraken.queryTrades(ids: ledgerIds completion: { ... })
```

#### Trade Volume

```swift
let assetPairs = ["XLTCXXDG", "ZEURXXDG"]
kraken.queryTrades(ids: assetPairs completion: { ... })
```

### Adding and Cancelling Orders

#### Add Order

There are 4 required parameters for buying an order. The example below illustrates the most basic order. Please see the [Kraken documentation](https://www.kraken.com/help/api#add-standard-order) for the parameters required for more advanced order types.
```swift
# buying 0.01 XBT (bitcoin) for XRP (ripple) at market price
opts = {
  "pair": "XBTXRP",
  "type": "buy",
  "ordertype": "market",
  "volume": "0.01"
}

kraken.addOrder(options:opts completion: { ... })

```

#### Cancel Order

```swift
kraken.cancelOrder(ids:["UKIYSP-9VN27-AJWWYC"] completion: { ... })
```

