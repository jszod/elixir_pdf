defmodule ElixirPdfWeb.HomeLive do
  use ElixirPdfWeb, :live_view

  alias ElixirPdf.RustReader

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> assign(:pdf_document, nil)
     |> allow_upload(:pdf,
       accept: ~w(.pdf),
       max_entries: 1,
       max_file_size: 10_000_000,
       chunk_size: 64_000
     )}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :pdf, fn %{path: path}, entry ->
        #        dest = Path.join(["priv", "uploads", Path.basename(path)])
        dest = Path.join(["priv", "uploads", entry.client_name])
        File.cp!(path, dest)
        {:ok, dest}
      end)

    pdf_document =
      uploaded_files
      |> hd()
      |> RustReader.extract_pdf()

    IO.inspect(pdf_document)

    {:noreply,
     socket
     |> assign(:pdf_document, pdf_document)
     |> update(:uploaded_files, &(&1 ++ uploaded_files))}
  end
end
