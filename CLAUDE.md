# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Markdown-to-eBook conversion tool that generates EPUB and PDF files from Markdown source material. The system uses Docker with pandoc and Japanese font support to create publication-ready eBooks.

## Key Commands

### Environment Setup
```bash
# Build the Docker image with Japanese fonts and LaTeX packages
docker build -t gen-kindle-book .
```

### Book Conversion
```bash
# Generate EPUB (default)
./convert.sh books/book-name

# Generate PDF only
./convert.sh --pdf books/book-name

# Generate both EPUB and PDF
./convert.sh --both books/book-name
```

### Testing Changes
```bash
# Test with sample book
./convert.sh --both books/sample

# Test with zen book (contains Japanese text)
./convert.sh --both books/zen-book
```

## Architecture

### Core Components

**convert.sh**: Main conversion script that orchestrates the entire process
- Parses command-line arguments for output format selection
- Creates book-specific output directories under `output/`
- Runs pandoc inside Docker container with Japanese font support
- Handles both EPUB and PDF generation with separate pipelines

**Dockerfile**: Custom pandoc environment
- Based on `pandoc/latex:latest`
- Installs Japanese fonts (`font-noto-cjk`) and LaTeX packages (`xecjk`)
- Provides isolated conversion environment

### Book Structure Requirements

Each book must be in `books/book-name/` with:
- `book.md` (required): Complete book content in single Markdown file
- `metadata.yml` (recommended): Book metadata for proper EPUB/PDF generation
- `template.tex` (optional): Custom LaTeX template for PDF styling
- `cover.jpg` (optional): Cover image referenced in metadata
- `style.css` (optional): EPUB styling

### Output Organization

Generated files are organized as:
```
output/
└── book-name/
    ├── book-name.epub
    └── book-name.pdf
```

### Japanese Font Handling

The system is specifically designed for Japanese content:
- PDF generation uses XeLaTeX with Noto Sans CJK JP fonts
- EPUB generation preserves Japanese text encoding
- Custom LaTeX templates support CJK typography

## Important Implementation Details

### Docker Integration
The conversion process runs entirely within Docker to ensure consistent environments. The `convert.sh` script uses:
```bash
DOCKER_CMD="docker run --rm -v $(pwd):/data --workdir=/data --entrypoint /bin/sh gen-kindle-book -c"
```

### Format-Specific Processing
- **EPUB**: Uses pandoc's epub3 output with table of contents generation
- **PDF**: Uses XeLaTeX engine with Japanese font variables and optional custom templates

### Error Handling
The script validates:
- Book directory existence
- Presence of required `book.md` file
- Successful file generation before reporting completion

### Metadata Integration
The system automatically includes metadata files if present, enhancing the professional quality of generated eBooks with proper title, author, and publishing information.

When working with this codebase, always test changes with both sample books to ensure Japanese text handling and basic functionality remain intact.