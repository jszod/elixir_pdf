use extractous::Extractor;
use rustler::NifResult;

mod reader_nifs {
    // Bring needed items into scope
    use super::Extractor;
    use super::NifResult;
    use rustler::Error;

    #[rustler::nif(schedule = "DirtyCpu")]
    pub fn extract_pdf(path: String) -> NifResult<String> {
        let extractor = Extractor::new();

    // Extract the text from the PDF file
    match extractor.extract_file_to_string(&path) {
        Ok((content, _metadata)) => {
            if content.is_empty() {
                Ok("Empty content extracted".to_string())
            } else {
                Ok(content)
            }
        },
        Err(e) => Err(Error::Term(Box::new(format!("{}", e)))),
        }
    }
}

// Required to make the module loadable
fn load(_env: rustler::Env, _load_info: rustler::Term) -> bool {
    eprintln!("RustReader NIF loaded");
    true
}

// rustler::init!("Elixir.ElixirPdf.RustReader", [extract_pdf]);
// Module-based init with load
rustler::init!("Elixir.ElixirPdf.RustReader", 
    module = reader_nifs, 
    load = load);