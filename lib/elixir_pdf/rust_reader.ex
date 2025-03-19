defmodule ElixirPdf.RustReader do
  use Rustler, otp_app: :elixir_pdf, crate: "rustreader"

  @moduledoc """
  Elixir interface for the RustReader NIF.
  """

  # Extracts text from a PDF file at the given path.
  # This function will be overridden by the native Rust implementation when the NIF is loaded.
  def extract_pdf(_path), do: :erlang.nif_error(:nif_not_loaded)
end
