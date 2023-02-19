#!/bin/bash
aftman install
wally install
rojo sourcemap > ./sourcemap.json
wally-package-types --sourcemap sourcemap.json Packages/