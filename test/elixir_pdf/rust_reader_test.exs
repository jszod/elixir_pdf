defmodule ElixirPdf.RustReaderTest do
  use ExUnit.Case
  doctest ElixirPdf.RustReader

  test "extract_pdf/1 returns the correct text content" do
    expected_text = "\nThis is a test PDF file.\nIt contains some simple text.\n\n\n"
    assert ElixirPdf.RustReader.extract_pdf("test/data/test.pdf") == expected_text
  end
end
