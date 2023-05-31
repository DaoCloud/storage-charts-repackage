## This script is only used for upgrade hwameistor version 
## according to version released in official charts rep(https://hwameistor.io)

# /bin/bash

releaseVersion=$1

[ "$releaseVersion" == "" ] && \
echo "release version must be specified!(example: bash upgrade_hwameistor.sh v0.9.3)" && \
exit 1

rootProgram="$(dirname "$PWD")/.."
# Step1: download specified version charts

echo "Step1: download specified version charts"

pushd . &>/dev/null

[ -e "hwameistor" ] && rm -rf hwameistor/ 

oldVersion=$(ss=$(grep "VERSION" config) && echo ${ss#*=})
echo "oldVersion: $oldVersion"
OS=$(uname)
if [ "$OS" == "Darwin" ];then 
	sed -i '' "s/$oldVersion/$releaseVersion/g" config
elif [ "$OS" == "Linux" ] 
  sed -i "s/$oldVersion/$releaseVersion/g" config
then 
  echo "Unsupported OS $OS" && exit 1
fi

cd "$rootProgram" && make -e PROJECT=hwameistor &>/dev/null

popd &>/dev/null

[ ! -e "./hwameistor/" ] && echo "failed to update hwameistor charts!" && exit 1

# Step2: copy custom files from hwameistor/parent

echo "Step2: copy custom files from hwameistor/parent"

cp parent/* ./hwameistor

[ -e "./hwameistor/crds/module.go" ] && rm -rf hwameistor/crds/module.go

! grep 'keywords' ./hwameistor/Charts.yaml &>/dev/null && \
echo "keywords:
  - storage
  - local
  - block" >> ./hwameistor/Chart.yaml

echo "
Update hwameistor $releaseVersion success!

Changed files:
"

git status -s

# Step3: check charts correctly by `helm template`
