defmodule ElixirPdfWeb.HomeLiveTest do
  #  alias ElixirPdfWeb.HomeLive
  use ElixirPdfWeb.ConnCase, async: true

  import Mock

  @fixture_pdf_path "test/fixtures/pdf/test.pdf"
  @expected_text "This is a test PDF file"

  setup do
    # Make sure the uploads directory exists
    File.mkdir_p!(Path.join(["priv", "uploads"]))
    :ok
  end

  describe "upload form" do
    test "renders file upload form", %{conn: conn} do
      conn
      |> visit("/")
      |> assert_has("#upload-form")
      |> assert_has("#file-upload")
      |> assert_has("input[type=file][name=pdf][accept='.pdf']")
      |> assert_has("[phx-drop-target]")
      |> refute_has("entry-name")
      |> refute_has("#submit-button")
    end
  end

  describe "file upload process" do
    setup %{conn: conn} do
      view =
        conn
        |> visit("/")
        |> upload("browse", @fixture_pdf_path)

      {:ok, view: view}
    end

    test "shows details after file upload", %{view: view} do
      view
      |> assert_has("#entry-name")
      |> assert_has("#submit-button")
    end

    test "saves file when submitted", %{view: view} do
      view
      |> click_button("#submit-button", "Upload")

      assert File.exists?(Path.join(["priv", "uploads", "test.pdf"]))
    end
  end

  describe "text extraction" do
    test "displays extracted text after upload", %{conn: conn} do
      with_mock ElixirPdf.RustReader, extract_pdf: fn _path -> @expected_text end do
        conn
        |> visit("/")
        |> upload("browse", @fixture_pdf_path)
        |> click_button("#submit-button", "Upload")
        |> assert_has("h2", text: "Extracted PDF Text")
        |> assert_has("pre", text: @expected_text)
      end
    end
  end

  # test "validate file upload", %{conn: conn} do
  #   conn
  #   |> visit("/")
  #   |> upload("browse", @fixture_pdf_path)
  #   |> refute_has("[phx-feedback-for]", test: "not a valid PDF")

  #   # |> refute_has("[phx-feedback-for]", test: "not a valid PDF")
  # end

  # test "validates file upload and save", %{conn: conn} do
  #   conn
  #   |> visit("/")
  #   |> upload("browse", @fixture_pdf_path)
  #   |> assert_has("#submit-button")
  #   |> click_button("#submit-button", "Upload")

  #   assert File.exists?(Path.join(["priv", "uploads", "test.pdf"]))
  # end

  # test "displays extracted text", %{conn: conn} do
  #   conn
  #   |> visit("/")
  #   |> upload("browse", @fixture_pdf_path)
  #   |> assert_has("#submit-button")
  #   |> click_button("#submit-button", "Upload")
  #   |> assert_has("h2", text: "Extracted PDF Text")
  #   |> assert_has("pre", text: @expected_text)
  # end
end
