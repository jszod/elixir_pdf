use extractous::Extractor;
use rustler::{Encoder, Env, NifResult, Term};

#[rustler::nif(schedule = "DirtyCpu")]
fn extract_pdf(path: String) -> NifResult<String> {
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
     Err(e) => Err(rustler::Error::Term(Box::new(format!("{}", e)))),
 }
}

rustler::init!("Elixir.ElixirPdf.RustReader", [extract_pdf]);
