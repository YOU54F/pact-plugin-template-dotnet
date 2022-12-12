#!/usr/bin/env bash

# Using https://github.com/ktr0731/evans for quick testing of gRPC

# Reads config from `.evans.toml`

# Init Plugin Request

echo '{ "implementation": "pact-rust", "version":"1.2.3" }' | evans cli call InitPlugin  --port 5117

# {
#   "catalogue": [
#     {
#       "key": "dotnet-template",
#       "type": "TRANSPORT",
#       "values": {
#         "content-types": "application/matt"
#       }
#     }
#   ]
# }