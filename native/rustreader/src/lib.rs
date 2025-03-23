use extractous::Extractor;
use rustler::NifResult;
use std::path::Path;

#[rustler::nif(schedule = "DirtyCpu")]
fn extract_pdf(path: String) -> NifResult<String> {
    let extractor = Extractor::new();
    let file_path = Path::new(&path);
    match extractor.extract_file_to_string(file_path) {
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
