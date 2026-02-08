#!/usr/bin/env bash
set -euo pipefail

echo "Reproducing URF Verifier"
cd ../urf-verifier
./replay/replay.sh schema/urf-sg.schema.json tests/certificate.valid.json

echo "Reproducing URF Counterexamples"
cd ../urf-counterexamples
./replay-all.sh

echo "REPRODUCTION COMPLETE"
