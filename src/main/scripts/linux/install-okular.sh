#!/bin/bash

# Aktualisieren der Paketliste
sudo apt-get update

# Okular installieren
echo "Installiere Okular..."
sudo apt-get install -y okular

echo "Okular wurde erfolgreich installiert."

echo "Soll die erweiterte Formatunterstützung installiert werden? ([Y]/n)"
read -r INSTALL_EXTRA

# Standardwert setzen, falls keine Eingabe erfolgt
INSTALL_EXTRA=${INSTALL_EXTRA:-Y}

if [[ "${INSTALL_EXTRA^^}" == "Y" ]]; then
    # Installieren der zusätzlichen Backends
    echo "Installiere Unterstützung für EPUB, TIFF und DjVu..."
    sudo apt-get install -y okular-extra-backends

    echo "Installiere Unterstützung für OpenDocument Presentation (ODP), PowerPoint und PPTX..."
    sudo apt-get install -y okular-backend-odp

    echo "Installiere Unterstützung für OpenDocument Text (ODT), DOC, DOCX, RTF und WPD..."
    sudo apt-get install -y okular-backend-odt

    echo "Installiere Unterstützung für mobile Formate (FictionBook, Plucker, CHM, XML Document Format)..."
    sudo apt-get install -y okular-mobile

    echo "Erweiterte Formatunterstützung wurde erfolgreich installiert."
else
    echo "Erweiterte Formatunterstützung wird nicht installiert."
fi

echo "Installation abgeschlossen."
