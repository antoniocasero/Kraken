# Kraken Swift


### IMPORTANT

Please thoroughly vet everything in the code for yourself before using this lib to buy, sell, or move any of your assets.

PLEASE submit an issue or pull request if you notice any bugs, security holes, or potential improvements. Any help is appreciated!


### Description

This library is a wrapper for the [Kraken Digital Asset Trading Platform](https://www.kraken.com) API. Official documentation from Kraken can be found [here](https://www.kraken.com/help/api).

The current version  can be used to query public/private data and make trades. Private data queries and trading functionality require use of your Kraken account API keys.

Kraken Swift was built by [Antonio Casero](@acaserop) 


## Installation


### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Kraken into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "antoniocasero/Kraken" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `Kraken.framework` into your Xcode project.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate Kraken into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add Kraken as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/antoniocasero/Kraken.git
  ```

- Open the new `Kraken` folder, and drag the `Kraken.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Kraken.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Select the top `Kraken.framework` 
- And that's it!

  > The `Kraken.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

---

## Usage

Create a Kraken client using your credentials

```swift

let credentials = Kraken.Credentials(key: "0Q/eOVRtyfg+WbIuLjKJ.....",
                                     secret: "EVFTYSinNiC89V.....")

let kraken = Kraken(credentials: credentials)

kraken.serverTime(completion: { let _ = $0.map{ print($0) } } // 1393056191

```

### Public Data Methods

#### Server Time

This functionality is provided by Kraken to to aid in approximating the skew time between the server and client.

```swift

 kraken.serverTime { result in
    switch result {
         case .success(let serverTime):
                serverTime["unixtime"] // 1393056191
                serverTime["rfc1123"] // "Sat, 22 Feb 2014 08:28:04 GMT"
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

depth_data = kraken.order_book('LTCXRP', completion: { ... })
```

#### Trades

Get recent trades

```swift
trades = kraken.trades('LTCXRP', completion: { ... })
```

#### Spread

Get spread data for a given asset pair

```swift
spread = kraken.spread('LTCXRP', completion: { ... })
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
// buying 0.01 XBT (bitcoin) for XRP (ripple) at market price
let opts = [
  "pair": "XBTXRP",
  "type": "buy",
  "ordertype": "market",
  "volume": "0.01"
]

kraken.addOrder(options:opts completion: { ... })

```

#### Cancel Order

```swift
kraken.cancelOrder(ids:["UKIYSP-9VN27-AJWWYC"] completion: { ... })
```

