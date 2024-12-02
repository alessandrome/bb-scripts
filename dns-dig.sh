#!/bin/bash

# Funzione per mostrare l'uso
usage() {
    echo "Uso: $0 dominio [-o output_file] [-s]"
    echo "  -o FILE    Salva i risultati in un file"
    echo "  -s         Divide i risultati per tipo di record"
    exit 1
}

# Controlla se ci sono argomenti
if [ "$#" -lt 1 ]; then
    usage
fi

# Parsing degli argomenti
OUTPUT_FILE=""
SPLIT_FILES=false
DOMAIN=$1
shift

while getopts ":o:s" opt; do
    case ${opt} in
        o )
            OUTPUT_FILE="$OPTARG"
            ;;
        s )
            SPLIT_FILES=true
            ;;
        \? )
            echo "Opzione non valida: -$OPTARG" >&2
            usage
            ;;
        : )
            echo "Opzione -$OPTARG richiede un argomento" >&2
            usage
            ;;
    esac
done

# Controllo che l'output file sia specificato se viene usata l'opzione -s
if $SPLIT_FILES && [ -z "$OUTPUT_FILE" ]; then
    echo "Errore: L'opzione -s richiede un file base con -o."
    exit 1
fi

# Lista dei record DNS da interrogare
RECORDS="A AAAA MX TXT NS CNAME SOA PTR SRV CAA NAPTR DNAME SPF DNSKEY DS TLSA LOC HINFO RP SSHFP URI ZONE"

# Esecuzione delle query DNS
for record in $RECORDS; do
    OUTPUT=$(dig $DOMAIN $record)
    
    if [ -n "$OUTPUT_FILE" ]; then
        if $SPLIT_FILES; then
            # Salva i risultati in file separati per tipo di record
            RECORD_FILE="${OUTPUT_FILE}.${record,,}" # Nome del file: output.a, output.txt, ecc.
            echo "=== $record ===" > "$RECORD_FILE"
            echo "$OUTPUT" >> "$RECORD_FILE"
        else
            # Salva i risultati in un unico file
            echo "=== $record ===" >> "$OUTPUT_FILE"
            echo "$OUTPUT" >> "$OUTPUT_FILE"
        fi
    else
        # Mostra i risultati nel terminale
        echo "=== $record ==="
        echo "$OUTPUT"
    fi
done

# Messaggi finali
if [ -n "$OUTPUT_FILE" ]; then
    if $SPLIT_FILES; then
        echo "Risultati salvati in file separati basati sul tipo di record."
    else
        echo "Risultati salvati in: $OUTPUT_FILE"
    fi
fi
