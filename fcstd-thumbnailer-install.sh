#!/bin/bash

echo 'Проверка зависимостей.
'
sudo apt-get install -y file unzip shared-mime-info

echo 'Удаление старых файлов'
sudo rm -f /usr/local/bin/fcstd-thumbnailer
sudo rm -f /usr/share/thumbnailers/fcstd.thumbnailer
echo '
Создание файла /usr/local/bin/freecad-thumbnailer'
sudo tee /usr/local/bin/freecad-thumbnailer > /dev/null << 'EOF'
#!/bin/bash

INPUT="$3"
OUTPUT="$4"

# проверка наличия thumbnail внутри архива
if unzip -l "$INPUT" thumbnails/Thumbnail.png >/dev/null 2>&1; then
    unzip -p "$INPUT" thumbnails/Thumbnail.png > "$OUTPUT"
    exit 0
else
    # важно: не создавать OUTPUT
    exit 1
fi
EOF

sudo chmod +x /usr/local/bin/freecad-thumbnailer

echo '
Создание файла /usr/share/thumbnailers/FreeCAD1.thumbnailer'
sudo tee /usr/share/thumbnailers/FreeCAD1.thumbnailer > /dev/null << 'EOF'
[Thumbnailer Entry]
TryExec=freecad-thumbnailer
Exec=freecad-thumbnailer -s %s %i %o
MimeType=application/x-extension-fcstd;
EOF

echo '
Очистка кэша'
rm -rf ~/.cache/thumbnails/*
nautilus -q
#nautilus &

echo '
Готово.'

