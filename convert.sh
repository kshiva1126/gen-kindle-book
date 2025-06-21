#!/bin/bash

set -e

FORMAT="epub"

while [[ $# -gt 0 ]]; do
    case $1 in
        --format)
            FORMAT="$2"
            shift 2
            ;;
        --pdf)
            FORMAT="pdf"
            shift
            ;;
        --epub)
            FORMAT="epub"
            shift
            ;;
        --both)
            FORMAT="both"
            shift
            ;;
        -*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            BOOK_DIR="$1"
            shift
            ;;
    esac
done

if [ -z "$BOOK_DIR" ]; then
    echo "Usage: $0 [options] <book_directory>"
    echo "Options:"
    echo "  --epub     Generate EPUB (default)"
    echo "  --pdf      Generate PDF"
    echo "  --both     Generate both EPUB and PDF"
    echo "Example: $0 --pdf books/sample"
    exit 1
fi

BOOK_NAME=$(basename "$BOOK_DIR")
OUTPUT_DIR="output"
METADATA_FILE="$BOOK_DIR/metadata.yml"

if [ ! -d "$BOOK_DIR" ]; then
    echo "Error: Directory $BOOK_DIR does not exist"
    exit 1
fi

echo "Converting book: $BOOK_NAME (format: $FORMAT)"

BOOK_OUTPUT_DIR="$OUTPUT_DIR/$BOOK_NAME"
mkdir -p "$BOOK_OUTPUT_DIR"

DOCKER_CMD="docker run --rm -v $(pwd):/data --workdir=/data --entrypoint /bin/sh gen-kindle-book -c"

MD_FILE="$BOOK_DIR/book.md"

if [ ! -f "$MD_FILE" ]; then
    echo "Error: book.md not found in $BOOK_DIR"
    exit 1
fi

# Function to generate EPUB
generate_epub() {
    echo "Generating EPUB..."
    PANDOC_ARGS="--from=markdown --to=epub3"
    PANDOC_ARGS="$PANDOC_ARGS --toc --toc-depth=2"
    
    if [ -f "$BOOK_DIR/cover.jpg" ]; then
        PANDOC_ARGS="$PANDOC_ARGS --epub-cover-image=$BOOK_DIR/cover.jpg"
    fi
    
    if [ -f "$METADATA_FILE" ]; then
        PANDOC_ARGS="$PANDOC_ARGS --metadata-file=$METADATA_FILE"
    fi
    
    if [ -f "$BOOK_DIR/style.css" ]; then
        PANDOC_ARGS="$PANDOC_ARGS --css=$BOOK_DIR/style.css"
    fi
    
    OUTPUT_FILE="$BOOK_OUTPUT_DIR/${BOOK_NAME}.epub"
    
    $DOCKER_CMD "pandoc $PANDOC_ARGS -o $OUTPUT_FILE $MD_FILE"
    
    if [ -f "$OUTPUT_FILE" ]; then
        echo "Success! EPUB file created: $OUTPUT_FILE"
        echo "File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
    else
        echo "Error: Failed to create EPUB file"
        return 1
    fi
}

# Function to generate PDF
generate_pdf() {
    echo "Generating PDF..."
    PANDOC_ARGS="--from=markdown --to=pdf"
    PANDOC_ARGS="$PANDOC_ARGS --toc --toc-depth=2"
    PANDOC_ARGS="$PANDOC_ARGS --pdf-engine=xelatex"
    PANDOC_ARGS="$PANDOC_ARGS --variable=CJKmainfont:'Noto Sans CJK JP'"
    PANDOC_ARGS="$PANDOC_ARGS --variable=geometry:margin=2cm"
    PANDOC_ARGS="$PANDOC_ARGS --variable=fontsize:12pt"
    PANDOC_ARGS="$PANDOC_ARGS --variable=linestretch:1.5"
    
    if [ -f "$METADATA_FILE" ]; then
        PANDOC_ARGS="$PANDOC_ARGS --metadata-file=$METADATA_FILE"
    fi
    
# LaTeXテンプレートをスキップしてシンプルなPDF生成を行う
    # if [ -f "$BOOK_DIR/template.tex" ]; then
    #     PANDOC_ARGS="$PANDOC_ARGS --template=$BOOK_DIR/template.tex"
    # fi
    
    OUTPUT_FILE="$BOOK_OUTPUT_DIR/${BOOK_NAME}.pdf"
    
    $DOCKER_CMD "pandoc $PANDOC_ARGS -o $OUTPUT_FILE $MD_FILE"
    
    if [ -f "$OUTPUT_FILE" ]; then
        echo "Success! PDF file created: $OUTPUT_FILE"
        echo "File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
    else
        echo "Error: Failed to create PDF file"
        return 1
    fi
}

# Execute based on format
case $FORMAT in
    "epub")
        generate_epub
        ;;
    "pdf")
        generate_pdf
        ;;
    "both")
        generate_epub
        generate_pdf
        ;;
    *)
        echo "Error: Unsupported format: $FORMAT"
        exit 1
        ;;
esac