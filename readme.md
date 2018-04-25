pdf-extract-pg
===========

A tool and library that can extract various areas of text from a PDF, especially a
scholarly article PDF. It performs structural analysis to determine column bounds, 
headers, footers, sections, titles and so on. It can analyse and categorise sections 
into reference and non-reference sections and can split reference sections into 
individual references.

The latest version is *0.1.1*. Earlier versions are far less reliable.

pdf-extract-pg requires Ruby 1.9.1 or above.

## Quick start

Install the latest version with:

    $ gem install pdf-extract-pg

## Quick examples

Extract references from a PDF:

    $ pdf-extract-pg extract --references myfile.pdf

Extract references and a title from a PDF:

    $ pdf-extract-pg extract --references --titles myfile.pdf

Mark the locations of headers, footers and columns in a new PDF:

    $ pdf-extract-pg mark --columns --headers --footers myfile.pdf

Extract regions of text from a PDF, preserving line information (offsets from region
origin):

    $ pdf-extract-pg extract --regions myfile.pdf

Extract regions of text from a PDF without line information (prettier and easier to read):

    $ pdf-extract-pg extract --regions --no-lines myfile.pdf
    
Resolve references to DOIs and output related metadata as BibTeX:

    $ pdf-extract-pg extract-bib --resolved_references myfile.pdf

## Problems

### pdf-extract-pg mistakes normal text for references when attempting to extract references.

pdf-extract-pg attempts to identify reference sections by comparing section features to
an idealised model of a reference section. Sometimes this can go wrong. If pdf-extract-pg
is producing reference output that clearly includes something that is not a reference, try
reducing the `reference_flex` slightly:

    $ pdf-extract-pg extract --references --set reference_flex:0.18 myfile.pdf

The default for `reference_flex` is 0.2. Make small decrements.

### pdf-extract-pg extracts no references.

As above, but try to increase the reference_flex a bit a time:

    $ pdf-extract-pg extract --references --set reference_flex:0.25 myfile.pdf

Keep trying with small increments to reference_flex. Note that a reference_flex of
1 means pdf-extract-pg will identify *all* sections as reference sections.

### pdf-extract-pg is still producing weird output after fiddling with reference_flex.

Have a look at pdf-extract-pg's settings:

    $ pdf-extract-pg settings

This command will produce a list of settings along with descriptions of what they affect.
They can be set by passing a `--set key:value` argument to pdf-extract-pg.

