#!/bin/bash
OUTPUT="index.html"

cat <<EOF > "$OUTPUT"
<!DOCTYPE html>
<html lang="pl">
<head>
  <meta charset="UTF-8">
  <title>Lista plików PDF</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h1 { color: #333; }
    ol { padding-left: 20px; }
    li { margin: 5px 0; }
    a { text-decoration: none; color: #0066cc; }
    a:hover { text-decoration: underline; }
    .meta { color: #666; font-size: 0.9em; margin-left: 10px; }
  </style>
</head>
<body>
  <h1>Pliki PDF w katalogu</h1>
  <ol>
EOF

# Generowanie listy plików z datą i rozmiarem w czytelnych jednostkach
find . -maxdepth 1 -type f -name "*.pdf" | sort | while read -r file; do
    fname=$(basename "$file")
    size=$(stat -c %s "$file")                         # rozmiar w bajtach
    human_size=$(numfmt --to=iec --suffix=B "$size")   # np. 15K, 2.3M, 1.1G
    mtime=$(stat -c %y "$file" | cut -d' ' -f1)        # data modyfikacji (YYYY-MM-DD)
    echo "    <li><a href=\"$fname\">$fname</a><span class=\"meta\">($mtime, $human_size)</span></li>" >> "$OUTPUT"
done

cat <<EOF >> "$OUTPUT"
  </ol>
</body>
</html>
EOF

echo "Plik $OUTPUT został wygenerowany."
