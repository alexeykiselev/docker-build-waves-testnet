#!/bin/bash
SCOREX_BRANCH="$1"
WAVES_BRANCH="$2"

if [ -z "$1" ]; then
	echo "No Scorex branch name supplied, using master"
	SCOREX_BRANCH="master"
fi

if [ -z "$2" ]; then
	echo "No Waves branch name supplied, using master"
	WAVES_BRANCH="master"
fi

cd /build/Scorex
git pull
git checkout ${SCOREX_BRANCH}

echo ""
echo "********************************************************************************"
SCOREX_VERSION="$(git describe --tags --always)"
echo "Building Scorex version ${SCOREX_VERSION} on branch ${SCOREX_BRANCH}"
echo "********************************************************************************"
echo ""

/build/sbt/bin/sbt clean publishLocal 

cd /build/Waves
git pull
git checkout ${WAVES_BRANCH}

echo ""
echo "********************************************************************************"
WAVES_VERSION="$(git describe --tags --always)"
echo "Building Waves version ${WAVES_VERSION} on branch ${WAVES_BRANCH}"
echo "********************************************************************************"
echo ""

rm -rfv /root/.ivy2/cache/com.wavesplatform/

/build/sbt/bin/sbt clean update stage
cp -R target/universal/stage/* /waves
chmod +x /waves/bin/waves

echo ""
echo "********************************************************************************"
echo "Preparing test net configuration file..."
echo "********************************************************************************"
echo ""

if [ ! -f /waves/waves-testnet.json ]; then
	echo "Configuration file not found. Initializing..."

	mkdir /waves/data /waves/wallet

	cd /build
	source ./bitcoin-bash-tools/bitcoin.sh
	export NEWSEED=`newBitcoinKey | grep address | cut -c 27- | head -1`
	echo "New seed: $NEWSEED"

	sed "s/\"walletSeed\": \"\",/\"walletSeed\": \"$NEWSEED\",/g;s+/tmp/scorex++g;s/127.0.0.1/0.0.0.0/g" /build/Waves/waves-testnet.json > /waves/waves-testnet.json

	cat /waves/waves-testnet.json
fi

cd /waves

echo ""
echo "********************************************************************************"
echo "Starting Waves..."
echo "********************************************************************************"
echo ""
bin/waves waves-testnet.json
