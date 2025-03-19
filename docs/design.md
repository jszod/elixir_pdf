Use a Rust NIF to extract text from PDF files. The Rust code is in [rustreader](https://github.com/robinhirsch/rustreader). It's a simple wrapper around the [pdfium](https://github.com/brechtsanders/pdfium) library, which is a C++ implementation of the PDF specification.


# TODO: add more info about how to use this package

## Dependencies

### Rust
Make sure Rust is installed. I use asdf for managing my Rust versions.
Install asdf and then run the following commands in your terminal:

Add the Rust plugin:
`asdf plugin-add rust`

Install the latest version of Rust:
`asdf install rust latest`

Set the global Rust version to the latest one installed by asdf:
`asdf global rust latest`

### Extractous

Extractous is a Rust library that can be used to extract text from PDF files. It's a simple wrapper around the [pdfium](https://github.com/brechtsanders/pdfium) library, which is a C++ implementation of the PDF specification.

https://github.com/yobix-ai/extractous

### enscript
Utility to convert text to PDF for creating test files.
I use brew as my package mangager on Mac
`brew install enscript`