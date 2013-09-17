pushd jni
/opt/android-ndk/ndk-build
popd
cp libs/armeabi/libwebp_extension.so android/libAndroid.so
rm -rf libs
