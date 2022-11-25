defmodule UnterEats.ImageUploader do
  use Waffle.Definition

  @versions [
    :original,
    :thumb,
    :thumb_retina,
    :thumb_mobile,
    :thumb_mobile_retina,
    :cart_thumb,
    :cart_thumb_retina
  ]

  @base_headers [cache_control: "max-age=31536000,public"]

  def s3_object_headers(:original, {file, _}) do
    [content_type: MIME.from_path(file.file_name)] ++ @base_headers
  end

  def s3_object_headers(_, _) do
    [content_type: "image/webp"] ++ @base_headers
  end

  def download_url({file, scope}, :original), do: url({file, scope}, :original)

  def download_url({file, scope}, version) do
    url = url({file, scope}, version)
    extension = Path.extname(url)
    String.replace_trailing(url, extension, ".webp")
  end

  def download_urls({file, scope}) do
    @versions
    |> Enum.map(fn version -> %{variant: version, url: download_url({file, scope}, version)} end)
  end

  def versions, do: @versions

  # Whitelist file extensions:
  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(~w(.jpg .jpeg .png .webp), file_extension) do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def transform(:original, _), do: :noaction

  def transform(size, _scope) when size in @versions do
    dimensions = dimensions(size)

    {:convert,
     fn input, output ->
       "#{input} -quality 50 -filter lanczos -thumbnail #{dimensions}^ -gravity center +profile \"*\" -extent #{dimensions} -define webp:method=6 -define webp:lossless=true webp:#{output}"
     end, :webp}
  end

  defp dimensions(:cart_thumb), do: "90x90"
  defp dimensions(:cart_thumb_retina), do: "180x180"
  defp dimensions(:thumb), do: "275x275"
  defp dimensions(:thumb_retina), do: "550x550"
  defp dimensions(:thumb_mobile), do: "170x170"
  defp dimensions(:thumb_mobile_retina), do: "340x340"

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  def storage_dir(_version, {_file, %{id: id}}) do
    prefix = String.slice(id, 0, 2)
    "images/#{prefix}/#{id}"
  end
end
