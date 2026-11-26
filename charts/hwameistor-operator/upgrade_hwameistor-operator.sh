## This script is only used for upgrade hwameistor-operator version
## hwameistor-operator repo: https://github.com/hwameistor/hwameistor-operator

# /bin/bash
set -x
releaseVersion=$1

[ "$releaseVersion" == "" ] && \
echo "release version must be specified!(example: bash upgrade_hwameistor-operator.sh v0.10.2)" && \
exit 1

echo "Step1: download specified version charts"

# delete old version files
rootProgram="$(dirname $PWD)/.."
rm -rf hwameistor-operator

# update config file
oldVersion=$(ss=$(grep "VERSION" config) && echo ${ss#*=})
echo "oldVersion: $oldVersion"
OS=$(uname)
if [ "$OS" == "Darwin" ]; then
    sed -i '' "s/$oldVersion/$releaseVersion/g" config
elif [ "$OS" == "Linux" ]; then
    sed -i "s/$oldVersion/$releaseVersion/g" config
else
    echo "Unsupported OS: $OS. Please use either 'Darwin' or 'Linux'." && exit 1
fi

# download specified version chart
cd "$rootProgram" && make -e PROJECT=hwameistor-operator &>/dev/null
cd -
[ ! -e "./hwameistor-operator/" ] && echo "failed to download hwameistor-operator chart!" && exit 1

echo "Step2: do custom actions"

# custom actions, switch to Daocloud registry
oldValue1="hwameistorImageRegistry: ghcr.io"
newValue1="hwameistorImageRegistry: ghcr.m.daocloud.io"
oldValue2="k8sImageRegistry: registry.k8s.io"
newValue2="k8sImageRegistry: k8s.m.daocloud.io"

target_file="hwameistor-operator/values.yaml"

if [ "$OS" == "Darwin" ];then
	sed -i '' "s#$oldValue1#$newValue1#g" "$target_file"
	sed -i '' "s#$oldValue2#$newValue2#g" "$target_file"
else
  sed -i "s#$oldValue1#$newValue1#g" "$target_file"
  sed -i "s#$oldValue2#$newValue2#g" "$target_file"
fi

echo "
Update hwameistor-operator:$releaseVersion success!

Changed files:
"

git status -s

# Step3: check charts correctly by `helm template`

