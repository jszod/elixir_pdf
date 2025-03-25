defmodule ElixirPdfWeb.HomeLiveTest do
  #  alias ElixirPdfWeb.HomeLive
  use ElixirPdfWeb.ConnCase, async: true

  # import Phoenix.LiveViewTest
  # import Mock

  @fixture_pdf_path "test/fixtures/pdf/test.pdf"

  setup do
    # Make sure the uploads directory exists
    File.mkdir_p!(Path.join(["priv", "uploads"]))
    :ok
  end

  test "renders file upload form", %{conn: conn} do
    conn
    |> visit("/")
    |> assert_has("#upload-form")
    |> assert_has("#file-upload")
    |> assert_has("input[type=file][name=pdf][accept='.pdf']")
    |> assert_has("[phx-drop-target]")
    |> refute_has("entry-name")
  end

  test "validate file upload", %{conn: conn} do
    conn
    |> visit("/")
    |> upload("browse", @fixture_pdf_path)
    |> refute_has("[phx-feedback-for]", test: "not a valid PDF")

    # |> refute_has("[phx-feedback-for]", test: "not a valid PDF")
  end

  test "validates file upload and sh", %{conn: conn} do
    conn
    |> visit("/")
    |> upload("browse", @fixture_pdf_path)
    |> assert_has("#submit-button")
    |> click_button("#submit-button", "Upload")

    assert File.exists?(Path.join(["priv", "uploads", "test.pdf"]))
  end
end
