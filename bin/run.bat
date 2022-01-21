ren homestudy.apk homestudy.aab
del homestudy.apks
java -jar "bundletool-all-1.8.2.jar" build-apks --bundle="homestudy.aab" --output="homestudy.apks"
java -jar "bundletool-all-1.8.2.jar" install-apks --apks="homestudy.apks"
pause