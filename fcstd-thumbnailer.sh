#!/bin/bash

echo 'Проверка зависимостей.
'
sudo apt-get install -y file unzip shared-mime-info

echo '
Создание файла /usr/local/bin/fcstd-thumbnailer'
sudo tee /usr/local/bin/fcstd-thumbnailer > /dev/null << 'EOF'
#!/bin/bash

INPUT="$1"
OUTPUT="$2"

# проверка наличия thumbnail внутри архива
if unzip -l "$INPUT" thumbnails/Thumbnail.png >/dev/null 2>&1; then
    unzip -p "$INPUT" thumbnails/Thumbnail.png > "$OUTPUT"
    exit 0
else
    # важно: не создавать OUTPUT
    exit 1
fi
EOF

sudo chmod +x /usr/local/bin/fcstd-thumbnailer

echo '
Создание файла /usr/share/thumbnailers/fcstd.thumbnailer'
sudo tee /usr/share/thumbnailers/fcstd.thumbnailer > /dev/null << 'EOF'
[Thumbnailer Entry]
TryExec=/usr/local/bin/fcstd-thumbnailer
Exec=/usr/local/bin/fcstd-thumbnailer %i %o %s
MimeType=application/x-extension-fcstd;application/vnd.freecad.fcstd;
EOF

echo '
Очистка кэша'
rm -rf ~/.cache/thumbnails/*
nautilus -q
#nautilus &

echo '
Готово.'

