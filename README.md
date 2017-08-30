# pandoc-bbcode: Write Critique Circle stories and forum posts in Markdown (or anything else)

## Overview

This is a simple [Pandoc](https://pandoc.org/) writer for converting Markdown, Word Docs, etc. to Critique Circle's flavor of BBCode. An example of this conversion can be seen in the `samples/` folder where `sample.md` is the input and `sample.ccbbcode` is the output.

## Usage

You can convert a file from any Pandoc-recognized format to Critique Circle format with the syntax below.

```
pandoc INPUTFILE.md -S -t panbbcodecritiquecircle.lua -o OUTPUTFILE.ccbbcode
```

Pandoc will be able to figure out the type of your input file by the file extension. The `-S` tells it to convert things like "---" and "'" to em-dash and curly/smart quote, respectively. For a much more in-depth explanation of Pandoc usage and features, check out [the Pandoc website](https://pandoc.org/).