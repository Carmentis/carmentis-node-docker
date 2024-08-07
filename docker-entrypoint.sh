#!/bin/bash

CMTHOME=/cometbft
set -e

if [ ! -d "$CMTHOME/config" ]; then
  echo "Welcome."
  mkdir "$CMTHOME/config"
fi

if [ ! -f "$CMTHOME/config/genesis.json" ]; then
  echo "Copying the themis genesis.json to the config directory."
  ls -la "/etc/carmentis/"
  cp "/etc/carmentis/chains/themis.json" "$CMTHOME/config/genesis.json"
fi

if [ ! -f "$CMTHOME/config/config.toml" ]; then
  echo "Running cometbft init to create configuration for carmentis run."
  cometbft init

  sed -i \
      -e "s/^proxy_app\s*=.*/proxy_app = \"abci\"/" \
      -e "s/^moniker\s*=.*/moniker = \"$MONIKER\"/" \
      -e 's/^addr_book_strict\s*=.*/addr_book_strict = false/' \
      -e 's/^timeout_commit\s*=.*/timeout_commit = "10s"/' \
      -e 's/^index_all_tags\s*=.*/index_all_tags = true/' \
      -e 's/^abci\s*=.*/abci = "grpc"/' \
      -e 's/^cors_allowed_origins\s*=.*/cors_allowed_origins = ["*"]/' \
      -e 's/^cors_allowed_methods\s*=.*/cors_allowed_methods = ["HEAD", "GET", "POST", ]/' \
      -e 's/^cors_allowed_headers\s*=.*/cors_allowed_headers = ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-HTTP-Method-Override", "Authorization"]/' \
      -e 's/^prometheus\s*=.*/prometheus = true/' \
      -e 's/^create_empty_blocks\s*=.*/create_empty_blocks = true/' \
      "$CMTHOME/config/config.toml"



	jq ".chain_id = \"$CHAIN_ID\" | .consensus_params.block.time_iota_ms = \"500\"" \
		"$CMTHOME/config/genesis.json" > "$CMTHOME/config/genesis.json.new"
	mv "$CMTHOME/config/genesis.json.new" "$CMTHOME/config/genesis.json"
fi

exec cometbft "$@"
