#!/usr/bin/env bash

set -e
set -x
mkdir -p /root/.cache/unity3d
mkdir -p /root/.local/share/unity3d/Unity/
set +x

unity_license_destination=/root/.local/share/unity3d/Unity/Unity_lic.ulf
android_keystore_destination=keystore.keystore

upper_case_build_target=${BUILD_TARGET^^};

if [ "$upper_case_build_target" = "ANDROID" ]
then
    if [ -n $ANDROID_KEYSTORE_BASE64 ]
    then
        echo "'\$ANDROID_KEYSTORE_BASE64' found, decoding content into ${android_keystore_destination}"
        echo $ANDROID_KEYSTORE_BASE64 | base64 --decode > ${android_keystore_destination}
    else
        echo '$ANDROID_KEYSTORE_BASE64'" env var not found, building with Unity's default debug keystore"
    fi
fi

if [ -n "$UNITY_LICENSE_BASE64" ]
then
    echo "Found an encoded unity license as '\$UNITY_LICENSE_BASE64'"
    echo "Decoding & writing '\$UNITY_LICENSE_BASE64' to license file ${unity_license_destination}"
    echo "${UNITY_LICENSE_BASE64}" | base64 -d | tr -d '\r' > ${unity_license_destination}
elif [ -n "$UNITY_LICENSE" ]
then
    echo "Found unity license as '\$UNITY_LICENSE'"
    echo "Writing '\$UNITY_LICENSE' to license file ${unity_license_destination}"
    echo "${UNITY_LICENSE}" | tr -d '\r' > ${unity_license_destination}
else
    echo "'\$UNITY_LICENSE_BASE64' or '\$UNITY_LICENSE' env var not found"
fi
