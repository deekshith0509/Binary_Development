echo "CLEANing CACHE"
rm -rf /storage/emulated/0/Android/data/*/cache/*
rm -rf /data/data/*/cache/*
rm -rf /data/dalvik-cache/arm/*
rm -rf /data/dalvik-cache/arm64/*
rm -rf /cache/magisk.log
touch /cache/magisk.log
chmod 644 /cache/magisk.log
echo "DONE"
