# Sardine NFT Auction

## Overview

Code challenge to create a web service for an NFT auction.

## Tests

Run automated specs with Rake or RSpec.

```bash
rake

# or use the binstub
bin/rspec
```

### Spec Documentation

```rspec
Randomized with seed 16266

SecretService
  GET /bids/current
    #generate_secret
      encrpyts data
    #decode_secret
      decrypts data
      when new instance of MessageEncryptor
        decrpyts data

Registrations
  POST /registrations
    returns a secret key
    registers a user
    with an invalid username
      responds with a :unprocessable_entity

Registration
  A valid Registration
    has a unique username
  #as_json
    does not include timestamps
    serializes the username and address
  #current_bid
    it returns the registration's latest bid
  #to_json
    returns a JSON string

Bid
  A valid Bid
    is a number
    is positive
    must be greater than the previous bid
  #to_json
    returns a JSON string
  #as_json
    does not include timestamps
    serializes the amount and owner
  #highest
    returns the current highest bid

Bids
  POST /bids
    includes owner flag
    creates a new bid
    with consecutive bids from two different users
      when amounts are the same
        responds with :unprocessable_entity
        matches an error message /previous bid/
    with consecutive bids from the same user
      responds with :unprocessable_entity
      matches an error message /already have current highest bid/
    when not authorized
      responds with unauthorized
  GET /bids/current
    responds with status :ok
    when multiple bids
      returns the current highest bid
    when authorized
      tells the user if the current highest bid is their own
      includes the user's latest bid

Finished in 1.09 seconds (files took 0.63755 seconds to load)
29 examples, 0 failures

Randomized with seed 16266
```

## Curl Output

Alice tries to submit a bid without being registered and gets rejected.

```bash
curl -i -X POST http://localhost:3000/bids \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d '{"amount": 1.25}'

HTTP/1.1 401 Unauthorized
Content-Type: application/json
```

So she registers as a new user and gets her secret token.

```bash
curl -i -X POST http://localhost:3000/registrations \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d '{"username": "aliceNFT"}'
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8

{"secret":"05e64b1393ed60f5ca4ddcbeb0f59b23fce9511a37bb2ce904af5bc794291dad$$tBG6t78plrdINBCTI6rpTZGG--I97MBv1aV72vNr8a--gug0fIdKGz52ofSO3/ayeA=="}
```

She retires submitting a bid, this time making sure to include her secret token.

```bash
curl -i -X POST http://localhost:3000/bids \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H 'secret: 05e64b1393ed60f5ca4ddcbeb0f59b23fce9511a37bb2ce904af5bc794291dad$$tBG6t78plrdINBCTI6rpTZGG--I97MBv1aV72vNr8a--gug0fIdKGz52ofSO3/ayeA==' \
-d '{"amount": 1.25}'
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8

{"amount":1.25,"owner":true}
```

Bob wants to check on the current highest bid.

```bash
curl -i -X GET http://localhost:3000/bids/current \
-H "Accept: application/json" \
-H "Content-Type: application/json"
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"highest_bid":{"amount":1.25,"owner":false}}
```

Alice checks to see if her bid is still the highest, and it is.

```bash
curl -i -X GET http://localhost:3000/bids/current \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H 'secret: 05e64b1393ed60f5ca4ddcbeb0f59b23fce9511a37bb2ce904af5bc794291dad$$tBG6t78plrdINBCTI6rpTZGG--I97MBv1aV72vNr8a--gug0fIdKGz52ofSO3/ayeA=='
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"current_bid":{"amount":1.25},"highest_bid":{"amount":1.25,"owner":true}}
```

Bob decides to register so he can start bidding.

```bash
curl -i -X POST http://localhost:3000/registrations \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d '{"username": "theREALBeeple"}'
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8

{"secret":"2dd94093c098931f014600ef0cf366f666f829d67fa432de4bb53a74e787587b$$1od9sp6H2IBNKLXguyn+WukaFHbldAk=--tzZl3QJhj7qrFVSN--FXm+xTci1W7c6bbtVA6+GQ=="}
```

Bob makes his first bid for 1.5

```bash
curl -i -X POST http://localhost:3000/bids \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H 'secret: 2dd94093c098931f014600ef0cf366f666f829d67fa432de4bb53a74e787587b$$1od9sp6H2IBNKLXguyn+WukaFHbldAk=--tzZl3QJhj7qrFVSN--FXm+xTci1W7c6bbtVA6+GQ==' \
-d '{"amount": 1.5}'
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8

{"amount":1.5,"owner":true}
```

Bob checks to make sure his bid is the new high bid, which it is.

```bash
curl -i -X GET http://localhost:3000/bids/current \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H 'secret: 2dd94093c098931f014600ef0cf366f666f829d67fa432de4bb53a74e787587b$$1od9sp6H2IBNKLXguyn+WukaFHbldAk=--tzZl3QJhj7qrFVSN--FXm+xTci1W7c6bbtVA6+GQ=='
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"current_bid":{"amount":1.5},"highest_bid":{"amount":1.5,"owner":true}}
```

Bob wants to pump up the price of the item for some strange reason so he tries
to bid a little more. But gets rejected since he already has the highest bid.

```bash
curl -i -X POST http://localhost:3000/bids \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H 'secret: 2dd94093c098931f014600ef0cf366f666f829d67fa432de4bb53a74e787587b$$1od9sp6H2IBNKLXguyn+WukaFHbldAk=--tzZl3QJhj7qrFVSN--FXm+xTci1W7c6bbtVA6+GQ==' \
-d '{"amount": 1.8}'
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json; charset=utf-8

{"error":"You already have the current highest bid"}
```

Hoping to trick the server into giving her the high bid, Alice posts a bid with
an amount equal to the current highest bid.

```bash
curl -i -X POST http://localhost:3000/bids \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H 'secret: 05e64b1393ed60f5ca4ddcbeb0f59b23fce9511a37bb2ce904af5bc794291dad$$tBG6t78plrdINBCTI6rpTZGG--I97MBv1aV72vNr8a--gug0fIdKGz52ofSO3/ayeA==' \
-d '{"amount": 1.5}'
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json; charset=utf-8

{"error":["Amount Amount must be greater than previous bid"]
```

Since that didn't work, Alice submits a new high bid but has a typo in her
amount.

```bash
curl -i -X POST http://localhost:3000/bids \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H 'secret: 05e64b1393ed60f5ca4ddcbeb0f59b23fce9511a37bb2ce904af5bc794291dad$$tBG6t78plrdINBCTI6rpTZGG--I97MBv1aV72vNr8a--gug0fIdKGz52ofSO3/ayeA==' \
-d '{"amount": "$1.6"}'
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json; charset=utf-8

{"error":["Amount is not a number","Amount Amount must be greater than previous
bid"]}
```

She corrects the typo and submits a correct new high bid to win the auction.

```bash
curl -i -X POST http://localhost:3000/bids \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H 'secret: 05e64b1393ed60f5ca4ddcbeb0f59b23fce9511a37bb2ce904af5bc794291dad$$tBG6t78plrdINBCTI6rpTZGG--I97MBv1aV72vNr8a--gug0fIdKGz52ofSO3/ayeA==' \
-d '{"amount": 1.6}'
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8

{"amount":1.6,"owner":true}
```
